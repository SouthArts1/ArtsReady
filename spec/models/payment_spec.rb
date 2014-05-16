require 'spec_helper'

describe Payment do
  let(:datetime) { Time.zone.parse('March 20, 2024 03:13:13 PM') }

  subject(:payment) { FactoryGirl.build(:payment) }

  it 'has a valid factory' do
    expect(payment).to be_valid
  end

  context 'when saved' do
    let(:payment_date) { Date.today }
    let(:organization) { FactoryGirl.build(:organization) }
    subject(:payment) {
      FactoryGirl.build(:payment,
        paid_at: payment_date,
        organization: organization
      )
    }

    context 'if derived from a notification' do
      before do
        payment.notification = PaymentNotification.new
        organization.stub(:extend_subscription!)
      end

      it "sets the organization's next billing date" do
        organization.should_receive(:extend_subscription!).with(
          payment_date + 365
        )

        payment.save

        expect(payment).to be_persisted
      end
    end

    context 'if entered manually' do
      before { payment.notification = nil }

      context do
        it "does not set the organization's next billing date" do
          organization.should_not_receive(:extend_subscription!)

          payment.save

          expect(payment).to be_persisted
        end
      end

      context 'and extend_subscription is set' do
        before { payment.extend_subscription = true }

        it "sets the organization's next billing date" do
          organization.should_receive(:extend_subscription!).with()

          payment.save

          expect(payment).to be_persisted
        end
      end

    end
  end

  describe 'paid_at_date' do
    it 'returns the date component of paid_at' do
      payment = Payment.new(paid_at: datetime)
      expect(payment.paid_at_date).to eq '2024-03-20'
    end

    it 'returns nil if paid_at is unset' do
      expect(Payment.new.paid_at_date).to be_nil
    end
  end

  describe 'paid_at_time' do
    it 'returns the date component of paid_at' do
      payment = Payment.new(paid_at: datetime)
      expect(payment.paid_at_time).to eq '3:13 PM'
    end

    it 'returns nil if paid_at is unset' do
      expect(Payment.new.paid_at_date).to be_nil
    end
  end

  describe 'paid_at_date=' do
    it 'changes the date of paid_at if it exists' do
      payment = Payment.new(paid_at: datetime)
      payment.paid_at_date = '2024-03-21'
      expect(payment.paid_at).to eq(datetime + 1.day)
    end

    it 'sets paid_at to midnight if not previously set' do
      payment = Payment.new
      payment.paid_at_date = '2024-03-20'
      expect(payment.paid_at).to eq(datetime.beginning_of_day)
    end

    it 'has no effect if the value is blank' do
      payment = Payment.new(paid_at: datetime)
      payment.paid_at_date = ''
      expect(payment.paid_at).to eq(datetime)
    end
  end

  describe 'paid_at_time=' do
    it 'changes the time of paid_at if it exists' do
      payment = Payment.new(paid_at: datetime)
      payment.paid_at_time = '3:14 PM'
      expect(payment.paid_at).to eq(datetime + 47.seconds)
    end

    it 'sets paid_at to today if not previously set' do
      Timecop.freeze(datetime) do
        payment = Payment.new
        payment.paid_at_time = '3:13:13 PM'
        expect(payment.paid_at).to eq(datetime)
      end
    end

    it 'has no effect if the value is blank' do
      payment = Payment.new(paid_at: datetime)
      payment.paid_at_time = ''
      expect(payment.paid_at).to eq(datetime)
    end
  end

  describe 'amount=' do
    it 'handles nil' do
      expect(Payment.new(amount: nil).amount).to be_nil
    end

    it 'handles numbers' do
      expect(Payment.new(amount: 50.24).amount).to eq 50.24
    end

    it 'handles numeric strings' do
      expect(Payment.new(amount: '500.50').amount).to eq 500.50
    end

    it 'handles currency strings' do
      expect(Payment.new(amount: '$75').amount).to eq 75
    end
  end
end
  
