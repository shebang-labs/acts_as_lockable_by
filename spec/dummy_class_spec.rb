# frozen_string_literal: true

RSpec.describe DummyClass do
  it_behaves_like ActsAsLockable::Lockable
  subject { described_class.new }
end
