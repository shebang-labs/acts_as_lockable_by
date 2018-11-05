# frozen_string_literal: true

class DummyClass
  include ActsAsLockable::Lockable
  acts_as_lockable :id, ttl: 60

  def id
    'SOME_OBJECT_IDENTIFIER'
  end
end
