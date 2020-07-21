# frozen_string_literal: true

require 'bundler/setup'
require 'byebug'
require 'acts_as_lockable_by'

ActsAsLockableBy.configure do |config|
  config.redis = Redis.new(url: ENV['REDIS_URL'])
  config.ttl = 30.seconds
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

# Include helpers
Dir[
  File.join(File.dirname(__FILE__), 'helpers', '**', '*.rb')
].sort.each { |f| require f }

# Include shared examples
Dir[
  File.join(File.dirname(__FILE__), 'shared_examples', '**', '*.rb')
].sort.each { |f| require f }
