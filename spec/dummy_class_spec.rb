# frozen_string_literal: true

require 'spec_helper'

RSpec.describe DummyClass do
  it_behaves_like ActsAsLockable::Lockable
  subject { described_class.new }
end
