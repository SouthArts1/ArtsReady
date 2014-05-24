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
      subscription.save!

      Timecop.freeze(cancellation_date) do
        result
      end
    end

    it 'should return true' do
      expect(result).to be_true
    end

    it { should_not be_active }

    it 'sets the end date to today' do
      expect(subscription.end_date).to eq cancellation_date
    end
  end
end