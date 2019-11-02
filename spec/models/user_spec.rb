require 'spec_helper'

describe User do

  subject { FactoryGirl.create(:user) }
  
  it { should have_many(:articles) }
  it { should have_many(:todo_notes) }
  it { should belong_to(:organization) }
  it { should validate_presence_of(:first_name)}
  it { should validate_presence_of(:last_name)}
  it { should validate_presence_of(:email)}

  it { should validate_uniqueness_of(:email)}

  specify {subject.role.should == 'reader'}
  specify {subject.admin.should be_falsey}
  specify {subject.is_admin?.should be_falsey}

  describe 'admin_emails' do
    it "is a list of admins' email addresses" do
      admin = FactoryGirl.create(:sysadmin, email: 'myemail@admin.example.org')
      FactoryGirl.create(:executive)

      expect(User.admin_emails).to eq(['myemail@admin.example.org'])
    end
  end

  context "roles should only be chosen from the list in the Artsready domain" do
    it { should allow_value('reader').for(:role)}
    it { should allow_value('editor').for(:role)}
    it { should allow_value('executive').for(:role)}
    it { should allow_value('manager').for(:role)}

    it { should_not allow_value('Reader').for(:role)}
    it { should_not allow_value('Editor').for(:role)}
    it { should_not allow_value('Executive').for(:role)}
    it { should_not allow_value('Manager').for(:role)}

    it { should_not allow_value('').for(:role)}  
    it { should_not allow_value('admin').for(:role)}  
    it { should_not allow_value('bOb').for(:role)}  
  end
  
  
  context "first user for an organization should be a manager" do
    let(:organization) { FactoryGirl.create(:new_organization) }
    
    it "should set the first user for an organization to a manager" do
      u=organization.users.create(:first_name => 'First', :last_name => 'Last', :email => 'first_user@test.host')
      u.role.should eq('manager')
    end
    
  end
  
  context "#can_set_battlebuddy_permission_for_article?" do
    it "should be false for user" do
      @member = FactoryGirl.create(:user)
      @member.can_set_battlebuddy_permission_for_article?.should be_falsey
    end
    it "should be false for reader" do
      @member = FactoryGirl.create(:reader)
      @member.can_set_battlebuddy_permission_for_article?.should be_falsey
    end
    it "should be true for editor" do
      @member = FactoryGirl.create(:editor)
      @member.can_set_battlebuddy_permission_for_article?.should be_truthy
    end
    it "should be true for executive" do
      @member = FactoryGirl.create(:executive)
      @member.can_set_battlebuddy_permission_for_article?.should be_truthy
    end
    it "should be true for manager" do
      @member = FactoryGirl.create(:manager)
      @member.can_set_battlebuddy_permission_for_article?.should be_truthy
    end
  end
  
  context "#can_set_executive_permission_for_article?" do
    it "should be false for user" do
      @member = FactoryGirl.create(:user)
      @member.can_set_executive_permission_for_article?.should be_falsey
    end
    it "should be false for reader" do
      @member = FactoryGirl.create(:reader)
      @member.can_set_executive_permission_for_article?.should be_falsey
    end
    it "should be false for editor" do
      @member = FactoryGirl.create(:editor)
      @member.can_set_executive_permission_for_article?.should be_falsey
    end
    it "should be true for executive" do
      @member = FactoryGirl.create(:executive)
      @member.can_set_executive_permission_for_article?.should be_truthy
    end
    it "should be true for manager" do
      @member = FactoryGirl.create(:manager)
      @member.can_set_executive_permission_for_article?.should be_truthy
    end
  end
  
  context "#authenticate" do
    before do
      @member = FactoryGirl.create(:user, :email => 'member@test.host', :password => 'secret')
    end
    
    it "should authenticate successfully when the password hash matches the encrypted password" do
      User.authenticate('member@test.host', 'secret').should be_truthy
    end

    it "should not authenticate when the password hash does not match the encrypted password" do
      User.authenticate('member@test.host', 'badpassword').should_not be_truthy
    end
    
    it "should not authenticate if the password is blank"
    
  end
    
  context "#name" do

    it "should be composed of first_name and last_name" do
      member=FactoryGirl.build(:user, :first_name => 'First', :last_name => 'Last')
      member.name.should eq("First Last")
    end

    it "should handle a missing or blank first name" do
      
      member=FactoryGirl.build(:user, :first_name => nil, :last_name => 'Last')
      member.name.should eq("Last")
    end

    it "should be composed of first_name and last_name" do
      member=FactoryGirl.build(:user, :first_name => 'First', :last_name => nil)
      member.name.should eq("First")
    end
  end

  context "#admin?" do
    let(:member) { FactoryGirl.create(:user, :email => 'member@test.host', :password => 'secret') }
    let(:admin) { FactoryGirl.create(:user, :email => 'admin@test.host', :password => 'secret', :admin => true) }

    it "should not be an admin by default" do
      member.admin?.should be_falsey
    end

    it "should be an admin if set" do
      admin.admin?.should be_truthy
    end

    it "should be an admin if set" do
      admin.is_admin?.should be_truthy
    end

    it "should not have member in the .admins scope" do
      User.admins.should_not include(@ember)
    end

    it "should have an admin in the .admins scope" do
      User.admins.should include(admin)
    end

  end
  
  context "#send_password_reset" do
    let(:user) { FactoryGirl.create(:user) }

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
      last_email.subject.should eq("Important Information about your ArtsReady Account")
      last_email.to.should eq([user.email])
    end
  end

  describe '.send_email_to_address?' do
    it 'allows non-disabled users of active orgs' do
      user = FactoryGirl.create(:user)

      expect(User.send_email_to_address?(user.email)).to be_truthy
    end

    it 'rejects disabled users' do
      user = FactoryGirl.create(:user, :disabled => true)

      expect(User.send_email_to_address?(user.email)).to be_falsey
    end

    it 'rejects users from inactive orgs' do
      org = FactoryGirl.create(:organization, :active => false)
      user = FactoryGirl.create(:user, :organization => org)

      expect(User.send_email_to_address?(user.email)).to be_falsey
    end

    it 'allows addresses with no associated user' do
      email = 'admin@bossland.com'

      expect(User.send_email_to_address?(email)).to be_truthy
    end
  end
end
