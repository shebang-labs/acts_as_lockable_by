# frozen_string_literal: true

module ActsAsLockableBy
  module Lockable
    extend ActiveSupport::Concern

    UnLockError = Class.new(StandardError)
    LockError = Class.new(StandardError)

    included do
      class_attribute :lock_id, :ttl
    end

    class_methods do
      def acts_as_lockable_by(
        lock_id,
        ttl: ActsAsLockableBy.configuration.ttl.to_i
      )
        self.lock_id = lock_id
        self.ttl = ttl
        extend ActsAsLockableBy::Lockable::SingletonMethods
        include ActsAsLockableBy::Lockable::InstanceMethods
      end
    end

    module SingletonMethods
      def lockable?
        true
      end

      # rubocop:disable Naming/PredicateName
      def is_lockable?
        tagger?
      end
      # rubocop:enable Naming/PredicateName
    end

    module InstanceMethods
      def lock(locked_by_id)
        # Set if not exist
        redis.set(lock_key, locked_by_id, ex: ttl, nx: true)
      end

      def lock!(locked_by_id)
        lock(locked_by_id) || raise(LockError)
      end

      def locked_by_id
        redis.get(lock_key)
      end

      def locked?
        locked_by_id.present?
      end

      def unlock(locked_by_id)
        redis.eval(
          unlock_atomic_script,
          keys: [lock_key],
          argv: [locked_by_id]
        ) == 1
      end

      def unlock!(locked_by_id)
        unlock(locked_by_id) || raise(UnLockError)
      end

      def renew_lock(locked_by_id)
        # Set if only exist
        redis.eval(
          renew_lock_atomic_script,
          keys: [lock_key],
          argv: [locked_by_id, 'EX', ttl, 'XX']
        ) == 'OK'
      end

      private

      def redis
        ActsAsLockableBy.configuration.redis
      end

      def lock_key
        "ActsAsLockableBy:#{self.class.name}:#{lock_id_value}"
      end

      def lock_id_value
        send(lock_id)
      end

      def unlock_atomic_script
        <<LUA_SCRIPT
        if redis.call("get",KEYS[1]) == ARGV[1]
        then
          return redis.call("del",KEYS[1])
        else
          return 0
        end
LUA_SCRIPT
      end

      def renew_lock_atomic_script
        <<LUA_SCRIPT
        redis.log(redis.LOG_WARNING, ARGV[2])
        if redis.call("get",KEYS[1]) == ARGV[1]
        then
          return redis.call("set", KEYS[1], ARGV[1], ARGV[2], ARGV[3], ARGV[4])
        else
          return 0
        end
LUA_SCRIPT
      end
    end
  end
end
