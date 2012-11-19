require 'spec_helper'

describe Crisis do
  it { should belong_to(:organization) }
  it { should belong_to(:user) }
  it { should have_many(:updates) }
  it { should have_many(:needs) }

  it { should validate_presence_of(:organization_id) }
  it { should validate_presence_of(:user_id) }

  describe 'contacts' do
    let(:crisis) { FactoryGirl.create(:crisis) }
    let(:org) { crisis.organization }
    let(:buddy) { FactoryGirl.create(:organization, :battle_buddies => [org]) }
    let!(:buddy_executive) { FactoryGirl.create(:executive, :organization => buddy) }
    let!(:stranger_executive) { FactoryGirl.create(:executive) }
    let!(:buddy_drone) {FactoryGirl.create(:user, :organization => buddy) }

    before { buddy.battle_buddy_requests.first.accept! }

    describe 'for declaration' do
      context '(buddies)' do
        before { crisis.update_attributes(:visibility => 'buddies') }

        it 'are executives of buddy organizations' do
          crisis.contacts_for_declaration.should == [buddy_executive]
        end
      end
      context '(public)' do
        before { crisis.update_attributes(:visibility => 'public') }

        it 'are all executives' do
          crisis.contacts_for_declaration.should == [buddy_executive, stranger_executive]
        end
      end
    end

    describe 'for updates' do
      context '(buddies)' do
        before { crisis.update_attributes(:visibility => 'buddies') }

        it 'are executives of buddy organizations' do
          crisis.contacts_for_update.should == [buddy_executive]
        end
      end
      context '(public)' do
        before { crisis.update_attributes(:visibility => 'buddies') }

        it 'are executives of buddy organizations' do
          crisis.contacts_for_update.should == [buddy_executive]
        end
      end
    end
  end
end
