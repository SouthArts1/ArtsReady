require 'spec_helper'

describe User do

  subject { Factory(:user) }
  
  it { should have_many(:articles) }
  it { should have_many(:todo_notes) }
  it { should belong_to(:organization) }
  it { should validate_presence_of(:first_name)}
  it { should validate_presence_of(:last_name)}
  it { should validate_presence_of(:email)}

  it { should validate_uniqueness_of(:email)}

  specify {subject.role.should == 'reader'}
  specify {subject.admin.should be_false}
  specify {subject.is_admin?.should be_false}
  
  context "first user for an organization should be a manager" do
    let(:organization) {Factory(:new_organization)}
    
    it "should set the first user for an organization to a manager" do
      u=organization.users.create(:first_name => 'First', :last_name => 'Last', :email => 'first_user@test.host')
      u.should be_valid
      u.role.should eq('manager')
    end
    
  end
  
  context "#can_set_battlebuddy_permission_for_article?" do
    it "should be false for user" do
      @member = Factory(:user)
      @member.can_set_battlebuddy_permission_for_article?.should be_false
    end
    it "should be false for reader" do
      @member = Factory(:reader)
      @member.can_set_battlebuddy_permission_for_article?.should be_false
    end
    it "should be true for editor" do
      @member = Factory(:editor)
      @member.can_set_battlebuddy_permission_for_article?.should be_true
    end
    it "should be true for executive" do
      @member = Factory(:executive)
      @member.can_set_battlebuddy_permission_for_article?.should be_true
    end
    it "should be true for manager" do
      @member = Factory(:manager)
      @member.can_set_battlebuddy_permission_for_article?.should be_true
    end
  end
  
  context "#can_set_executive_permission_for_article?" do
    it "should be false for user" do
      @member = Factory(:user)
      @member.can_set_executive_permission_for_article?.should be_false
    end
    it "should be false for reader" do
      @member = Factory(:reader)
      @member.can_set_executive_permission_for_article?.should be_false
    end
    it "should be false for editor" do
      @member = Factory(:editor)
      @member.can_set_executive_permission_for_article?.should be_false
    end
    it "should be true for executive" do
      @member = Factory(:executive)
      @member.can_set_executive_permission_for_article?.should be_true
    end
    it "should be true for manager" do
      @member = Factory(:manager)
      @member.can_set_executive_permission_for_article?.should be_true
    end
  end
  
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
    
  context "#name" do

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

  context "#admin?" do
    let(:member) {Factory(:user, :email => 'member@test.host', :password => 'secret')}
    let(:admin) {Factory(:user, :email => 'admin@test.host', :password => 'secret', :admin => true)}

    it "should not be an admin by default" do
      member.admin?.should be_false
    end

    it "should be an admin if set" do
      admin.admin?.should be_true
    end

    it "should be an admin if set" do
      admin.is_admin?.should be_true
    end

    it "should not have member in the .admins scope" do
      User.admins.should_not include(@ember)
    end

    it "should have an admin in the .admins scope" do
      User.admins.should include(admin)
    end

  end
  
  context "#send_password_reset" do
    let(:user) { Factory(:user) }

    it "generates a unique password_reset_token each time" do
      user.send_password_reset
      last_token = user.password_reset_token
      user.send_password_reset
      user.password_reset_token.should_not eq(last_token)
    end

    it "saves the time the password reset was sent" do
      user.send_password_reset
      user.reload.password_reset_sent_at.should be_present
    end
    
    it "sends an password reset email" do
      # TODO This sends the intro email on the create and then the reset. Probably a better way to do
      expect {user.send_password_reset}.to change{ActionMailer::Base.deliveries.count}
      last_email.subject.should eq("ArtsReady Password Reset")
      last_email.to.should eq([user.email])
    end
  end
end