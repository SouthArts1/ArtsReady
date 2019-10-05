require 'spec_helper'

shared_examples_for 'a subscription' do
  context 'when created' do
    before { subscription.save! }

    it { should be_active }
  end

  context 'when cancelled' do
    let(:cancellation_date) { 6.months.from_now }
    let(:result) { subscription.cancel }

    before do
      subscription.organization.
        stub(:create_subscription_event).and_return(double)

      subscription.save!

      Timecop.freeze(cancellation_date) do
        result
      end
    end

    it 'should return true' do
      expect(result).to be_truthy
    end

    it { should_not be_active }

    it 'sets the end date to today' do
      expect(subscription.end_date).to eq cancellation_date
    end

    context 'given an explanation' do
      let(:canceler) { double(email: 'admin@example.com') }

      it 'records an event' do
        expect(subscription.organization).
          to receive(:create_subscription_event).
          with(notes: "Cancelled by admin (admin@example.com)")

        subscription.cancel(role: :admin, canceler: canceler)
      end
    end

    context 'given no explanation' do
      it 'does not record an event' do
        expect(subscription.organization).not_to receive(:create_subscription_event)

        subscription.cancel
      end
    end
  end

  it { should respond_to :payment_method_expires_before? }
end