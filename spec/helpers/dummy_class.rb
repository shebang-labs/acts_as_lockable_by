# frozen_string_literal: true

class DummyClass
  include ActsAsLockableBy::Lockable
  acts_as_lockable_by :id, ttl: 60

  def id
    'SOME_OBJECT_IDENTIFIER'
  end
end
