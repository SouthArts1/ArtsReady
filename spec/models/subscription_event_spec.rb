require 'spec_helper'

describe SubscriptionEvent do
  subject(:event) { FactoryGirl.build(:subscription_event) }

  let(:datetime) { Time.zone.parse('March 20, 2024 03:13:13 PM') }

  describe 'happened_at_date' do
    it 'returns the date component of happened_at' do
      event = SubscriptionEvent.new(happened_at: datetime)
      expect(event.happened_at_date).to eq '2024-03-20'
    end

    it 'returns nil if happened_at is unset' do
      expect(SubscriptionEvent.new.happened_at_date).to be_nil
    end
  end

  describe 'happened_at_time' do
    it 'returns the date component of happened_at' do
      event = SubscriptionEvent.new(happened_at: datetime)
      expect(event.happened_at_time).to eq '3:13 PM'
    end

    it 'returns nil if happened_at is unset' do
      expect(SubscriptionEvent.new.happened_at_date).to be_nil
    end
  end

  describe 'happened_at_date=' do
    it 'changes the date of happened_at if it exists' do
      event = SubscriptionEvent.new(happened_at: datetime)
      event.happened_at_date = '2024-03-21'
      expect(event.happened_at).to eq(datetime + 1.day)
    end

    it 'sets happened_at to midnight if not previously set' do
      event = SubscriptionEvent.new
      event.happened_at_date = '2024-03-20'
      expect(event.happened_at).to eq(datetime.beginning_of_day)
    end

    it 'has no effect if the value is blank' do
      event = SubscriptionEvent.new(happened_at: datetime)
      event.happened_at_date = ''
      expect(event.happened_at).to eq(datetime)
    end
  end

  describe 'happened_at_time=' do
    it 'changes the time of happened_at if it exists' do
      event = SubscriptionEvent.new(happened_at: datetime)
      event.happened_at_time = '3:14 PM'
      expect(event.happened_at).to eq(datetime + 47.seconds)
    end

    it 'sets happened_at to today if not previously set' do
      Timecop.freeze(datetime) do
        event = SubscriptionEvent.new
        event.happened_at_time = '3:13:13 PM'
        expect(event.happened_at).to eq(datetime)
      end
    end

    it 'has no effect if the value is blank' do
      event = SubscriptionEvent.new(happened_at: datetime)
      event.happened_at_time = ''
      expect(event.happened_at).to eq(datetime)
    end
  end
end
