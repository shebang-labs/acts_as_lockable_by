# frozen_string_literal: true

RSpec.shared_examples_for ActsAsLockableBy::Lockable do
  let(:id) { 'SOME_IDENTIFIER' }

  around(:each) do |example|
    ActsAsLockableBy.configuration.redis.flushall
    begin
      example.run
    ensure
      ActsAsLockableBy.configuration.redis.flushall
    end
  end

  context 'with locked resource' do
    before(:each) { subject.lock(id) }
    describe '#lock' do
      it 'does not lock the resource' do
        expect(subject.lock(id)).to be_falsy
      end
    end

    describe '#lock!' do
      it 'throws a LockError' do
        expect { subject.lock!(id) }.to(
          raise_error(described_class::LockError)
        )
      end
    end

    describe '#locked_by_id' do
      it 'returns the id of who locked the resource' do
        expect(subject.locked_by_id).to eq(id.to_s)
      end
    end

    describe '#locked?' do
      it 'returns true' do
        expect(subject.locked?).to be_truthy
      end
    end

    describe '#unlock' do
      it 'removes the resource lock' do
        expect(subject.unlock(id)).to be_truthy
        expect(subject.locked?).to be_falsy
      end
    end

    describe '#unlock!' do
      it 'removes the resource lock' do
        expect(subject.unlock!(id)).to be_truthy
        expect(subject.locked?).to be_falsy
      end
    end

    describe '#renew_lock' do
      it 'renews the existing lock' do
        expect(subject.renew_lock(id)).to be_truthy
        expect(subject.locked?).to be_truthy
      end
    end
  end

  context 'with unlocked resource' do
    describe '#lock' do
      it 'locks the resource' do
        subject.lock(id)
        expect(subject.locked?).to be_truthy
      end

      it 'locks the resource by a user' do
        expect do
          subject.lock(id)
        end.to change { subject.locked_by_id }.from(nil).to(id.to_s)
      end
    end

    describe '#lock!' do
      it 'locks the resource' do
        subject.lock!(id)
        expect(subject.locked?).to be_truthy
      end

      it 'locks the resource by a user' do
        expect do
          subject.lock!(id)
        end.to change { subject.locked_by_id }.from(nil).to(id.to_s)
      end
    end

    describe '#locked_by_id' do
      it 'returns nil' do
        expect(subject.locked_by_id).to be_nil
      end
    end

    describe '#locked?' do
      it 'returns false' do
        expect(subject.locked?).to be_falsy
      end
    end

    describe '#unlock' do
      it 'returns false' do
        expect(subject.unlock(id)).to be_falsy
      end
    end

    describe '#unlock!' do
      it 'throws an UnLockError' do
        expect { subject.unlock!(id) }.to(
          raise_error described_class::UnLockError
        )
      end
    end

    describe '#renew_lock' do
      it 'returns false' do
        expect(subject.renew_lock(id)).to be_falsy
        expect(subject.locked?).to be_falsy
      end
    end
  end
end
