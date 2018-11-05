# frozen_string_literal: true

require 'active_support/all'
require 'acts_as_lockable/version'
require 'redis'

module ActsAsLockable
  extend ActiveSupport::Autoload
  autoload :Lockable

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :redis, :ttl

    def initialize
      @redit = Redis.new
      @ttl = 30.seconds
    end
  end
end

ActiveSupport.on_load(:active_record) do
  include ActsAsLockable::Lockable
end
