require 'spec_helper'

describe User do

  it { should validate_presence_of(:first_name)}
  it { should validate_presence_of(:last_name)}
  it { should validate_presence_of(:email)}

  it { should validate_uniqueness_of(:email)}

#  it { should_not allow_mass_assignment_of(:password) }

  context "authentication" do
    before do
      @member = Factory(:user, :email => 'member@test.host', :password => 'secret')
    end
    
    it "should authenticate successfully when the password hash matches the encrypted password" do
      User.authenticate('member@test.host', 'secret').should be_true
    end

    it "should not authenticate when the password hash does not match the encrypted password" do
      User.authenticate('member@test.host', 'badpassword').should_not be_true
    end
    # 
    # it "should not authenticate if the password is blank" do
    # end
    
  end
end
