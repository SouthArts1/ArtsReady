require 'spec_helper'

describe Organization do
  subject(:org) { Organization.new }
  
  it { should have_many(:articles) }
  it { should have_many(:assessments) }
  it { should have_many(:battle_buddy_requests) }
  it { should have_many(:crises) }
  it { should have_many(:resources) }
  it { should have_many(:todos) }
  
  it { should validate_presence_of(:name)} 
  it { should validate_presence_of(:address)} 
  it { should validate_presence_of(:city)} 
  it { should validate_presence_of(:state)} 
  it { should validate_presence_of(:zipcode)}
  it { should validate_presence_of(:organizational_status)}
  
  it {subject.assessment_complete?.should be_falsey}
  it {subject.assessment_percentage_complete.should be_nil}
  it {subject.declared_crisis?.should be_falsey}
  it {subject.active?.should be_falsey}

  describe '#account_status' do
    subject { org.account_status }

    context 'for an active organization' do
      before { org.active = true }

      it { should eq 'active' }
    end

    context 'for an inactive organization' do
      before { org.active = false }

      context 'that has never paid' do
        before { org.subscriptions.stub(:last) { nil } }

        it { should eq 'needs approval' }
      end

      context 'that has previously been active' do
        before { org.subscriptions.stub(:last) { double } }

        it { should eq 'inactive' }
      end
    end
  end

  describe 'contact_name' do
    it 'can be broken into first and last names' do
      org.contact_name = 'Thomas J. Flory, Esq.'

      expect(org.contact_first_name).to eq 'Thomas J.'
      expect(org.contact_last_name).to eq 'Flory'

      org.contact_name = 'Rothrock'
      expect(org.contact_first_name).to eq nil
      expect(org.contact_last_name).to eq 'Rothrock'

      org.contact_name = nil
      expect(org.contact_first_name).to eq nil
      expect(org.contact_last_name).to eq nil
    end
  end

  context 'given multiple assessments' do
    let(:organization) { FactoryGirl.create(:organization) }
    let!(:first_assessment) {
      FactoryGirl.create(:assessment, :organization => organization,
        :created_at => 1.year.ago)
    }
    let!(:second_assessment) {
      FactoryGirl.create(:assessment, :organization => organization)
    }

    describe '.assessment' do
      it 'is the latest assessment' do
        organization.assessment.should == second_assessment
      end
    end
  end
  
  context "geocoding address", pending: 'disabled as app approaches EOL' do
    it "should geocode address when created" do
      @organization = FactoryGirl.build(:organization)
      @organization.should_receive(:geocode)
      @organization.valid?
    end

    context "on changed address fields" do
      let(:organization) { FactoryGirl.create(:organization) }
      before {organization.should_receive(:geocode)}
      it "should geocode address if address is changed" do
        organization.address = 'New Address'
        organization.save
      end
      it "should geocode address if city is changed" do
        organization.city = 'New City'
        organization.save
      end
      it "should geocode address if state is changed" do
        organization.state = 'AB'
        organization.save
      end
      it "should geocode address if zipcode is changed" do
        organization.zipcode = '12345'
        organization.save
      end
    end
    
    context "on other changes" do
      it "should not geocode address if name is changed" do
        skip

        organization = FactoryGirl.create(:organization)
        organization.should_not_receive(:geocode)
        organization.update_attribute(:address, 'New Address')
      end
    end
  end

  describe '#last_activity' do
    it 'is the activity of the last-logged-in user, or never' do
      subject = FactoryGirl.create(:organization)
      subject.last_activity.should == nil

      time = Time.zone.parse('Mon, 02 Apr 2012 04:24:14 UTC +00:00')
      subject.users = [
        FactoryGirl.create(:member,
          :organization => subject,
          :last_login_at => time)
      ]
      subject.last_activity.should == time
    end
  end

  describe '#destroy' do
    let(:organization) { FactoryGirl.create(:organization) }
    let!(:public_article) {
      FactoryGirl.create(:article, :organization => organization,
        :visibility => 'public')
    }
    let!(:executive_article) {
      FactoryGirl.create(:article, :organization => organization,
        :visibility => 'executive')
    }

    before { Organization.find(organization.id).destroy }

    it 'destroys private articles but not public ones' do
      Article.find_by_id(executive_article.id).should be_nil
      Article.find_by_id(public_article.id).organization_id.should be_nil
    end
  end

  describe 'days_left_until_rebill' do
    context 'given a next billing date' do
      before { org.next_billing_date = Date.tomorrow }

      it 'should count the days until then' do
        expect(org.days_left_until_rebill).to eq(1)
      end
    end

    context 'given no next billing date' do
      before { org.next_billing_date = nil }

      it 'should return nil' do
        expect(org.days_left_until_rebill).to be_nil
      end
    end
  end

  describe '#extend_next_billing_date!' do
    let(:organization) { FactoryGirl.create(:organization) }
    let(:today) { Time.zone.today }

    around do |example|
      Timecop.freeze(Time.zone.now) { example.run }
    end

    context 'if a next billing date has previously been set' do
      before { organization.next_billing_date = today - 1 }

      it 'extends the next billing date by 365 days' do
        organization.extend_next_billing_date!
        expect(organization.next_billing_date).to eq(today + 364)
        expect(organization).not_to be_changed
      end
    end

    context 'if no next billing date has been set' do
      before { organization.next_billing_date = nil }

      it 'sets the next billing date to 365 days from today' do
        organization.extend_next_billing_date!
        expect(organization.next_billing_date).to eq(today + 365)
        expect(organization).not_to be_changed
      end
    end
  end

  describe '.billing_next_month' do
    it 'returns organizations whose next billing date is next month' do
      Timecop.freeze(Time.zone.now) do
        before = FactoryGirl.create(
          :organization, next_billing_date: Time.zone.now)
        during = FactoryGirl.create(
          :organization, next_billing_date: 1.month.from_now)
        after = FactoryGirl.create(
          :organization, next_billing_date: 2.months.from_now)

        expect(Organization.billing_next_month).to eq([during])
      end
    end
  end

  describe '.renewing_in(days)' do
    it 'finds organizations whose next billing date is that many days away' do
      Timecop.freeze(Time.zone.parse('February 21, 2015')) do
        right = FactoryGirl.create(:organization,
          next_billing_date: Time.zone.parse('March 23, 2015'))
        wrong = FactoryGirl.create(:organization,
          next_billing_date: Time.zone.parse('March 24, 2015'))
        inactive = FactoryGirl.create(:organization,
          active: false,
          next_billing_date: Time.zone.parse('March 23, 2015'))

        expect(Organization.renewing_in(30)).to include right
        expect(Organization.renewing_in(30)).not_to include wrong
        expect(Organization.renewing_in(30)).not_to include inactive
      end
    end
  end
end
