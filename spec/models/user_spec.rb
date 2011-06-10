require 'spec_helper'

describe User do

  subject { Factory(:user) }
  
  it { should have_many(:articles) }
  
  it { should belong_to(:organization) }
  it { should validate_presence_of(:first_name)}
  it { should validate_presence_of(:last_name)}
  it { should validate_presence_of(:email)}

  it { should validate_uniqueness_of(:email)}

#  it { should_not allow_mass_assignment_of(:password) }

  context "#authenticate" do
    before do
      @member = Factory(:user, :email => 'member@test.host', :password => 'secret')
    end
    
    it "should authenticate successfully when the password hash matches the encrypted password" do
      User.authenticate('member@test.host', 'secret').should be_true
    end

    it "should not authenticate when the password hash does not match the encrypted password" do
      User.authenticate('member@test.host', 'badpassword').should_not be_true
    end
    
    it "should not authenticate if the password is blank"
    
  end
  
  
  context ".name" do

    it "should be composed of first_name and last_name" do
      member=Factory.build(:user, :first_name => 'First', :last_name => 'Last')
      member.name.should eq("First Last")
    end

    it "should handle a missing or blank first name" do
      
      member=Factory.build(:user, :first_name => nil, :last_name => 'Last')
      member.name.should eq("Last")
    end

    it "should be composed of first_name and last_name" do
      member=Factory.build(:user, :first_name => 'First', :last_name => nil)
      member.name.should eq("First")
    end
  end

  context ".admin?" do
    it "should not be an admin by default" do
      @member = Factory(:user, :email => 'member@test.host', :password => 'secret')
      @member.admin?.should be_false
    end
    it "should be an admin if set" do
      @member = Factory(:user, :email => 'member@test.host', :password => 'secret', :admin => true)
      @member.admin?.should be_true
    end
  end
end
