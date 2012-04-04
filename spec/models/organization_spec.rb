require 'spec_helper'

describe Organization do

  subject { Organization.new }
  
  it { should have_many(:articles) }
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
  it { should validate_presence_of(:operating_budget)}
  
  it {subject.assessment_is_complete?.should be_false} 
  it {subject.assessment_percentage_complete.should be_nil}
  it {subject.todo_completion.should be_zero} 
  it {subject.declared_crisis?.should be_false}
  it {subject.active?.should be_false}
  it {subject.is_approved?.should be_false}
  
  context "geocoding address" do
    it "should geocode address when created" do
      @organization = Factory.build(:organization)
      @organization.should_receive(:geocode)
      @organization.valid?
    end

    context "on changed address fields" do
      let(:organization) { Factory.create(:organization) }
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
        organization = Factory.create(:organization)
        organization.should_not_receive(:geocode)
        organization.update_attribute(:address, 'New Address')
      end
    end
  end

  describe '#last_activity' do
    it 'is the activity of the last-logged-in user, or never' do
      subject = Factory.create(:organization)
      subject.last_activity.should == 'Never'

      time = Time.zone.parse('Mon, 02 Apr 2012 04:24:14 UTC +00:00')
      subject.users = [
        Factory.create(:member,
          :organization => subject,
          :last_login_at => time)
      ]
      subject.last_activity.should == time
    end
  end
end
