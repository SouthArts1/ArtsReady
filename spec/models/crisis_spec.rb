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
    let!(:manager) { FactoryGirl.create(:manager, :organization => org) }
    let!(:good_buddy) { FactoryGirl.create(:organization, :battle_buddies => [org]) }
    let!(:good_buddy_executive) { FactoryGirl.create(:executive, :organization => good_buddy) }
    let!(:buddy) { FactoryGirl.create(:organization, :battle_buddies => [org]) }
    let!(:buddy_executive) { FactoryGirl.create(:executive, :organization => buddy) }
    let!(:stranger_executive) { FactoryGirl.create(:executive) }
    let!(:buddy_drone) {FactoryGirl.create(:user, :organization => buddy) }
    let!(:disabled_manager) {FactoryGirl.create(:manager, :disabled => true) }

    before do
      buddy.battle_buddy_requests.first.accept!
      good_buddy.battle_buddy_requests.first.accept!
    end

    describe 'for declaration' do
      context '(buddies)' do
        before { crisis.update_attributes(:visibility => 'buddies') }

        it 'are executives of buddy organizations and declaring organization' do
          crisis.contacts_for_declaration.to_set.should ==
            [buddy_executive, good_buddy_executive, manager].to_set
        end
      end
      context '(public)' do
        before { crisis.update_attributes(:visibility => 'public') }

        it 'are all valid executives' do
          crisis.contacts_for_declaration.to_set.should ==
            [buddy_executive,  good_buddy_executive, stranger_executive,
             manager].to_set
        end
      end
      context '(private)' do
        before do
          crisis.update_attributes!(
            :visibility => 'private', :buddy_list => good_buddy.id.to_s)
        end

        it 'are only executives from selected buddies and the declaring org' do
          crisis.contacts_for_declaration.to_set.should ==
            [good_buddy_executive, manager].to_set
        end
      end
    end

    describe 'for updates' do
      context '(buddies)' do
        before { crisis.update_attributes(:visibility => 'buddies') }

        it 'are active executives of approved buddy organizations
          and declaring organization' do
          crisis.contacts_for_update.to_set.should ==
            [buddy_executive, good_buddy_executive, manager].to_set
        end
      end
      context '(public)' do
        before { crisis.update_attributes(:visibility => 'public') }

        it 'are active executives of approved buddy organizations 
          and declaring organization' do
          crisis.contacts_for_update.to_set.should ==
            [buddy_executive,  good_buddy_executive, manager].to_set
        end
      end
      context '(private)' do
        before do
          crisis.update_attributes(:visibility => 'private', 
                                   :buddy_list => good_buddy.id.to_s)
        end

        it 'are only executives from selected buddies and the declaring org' do
          crisis.contacts_for_update.to_set.should ==
            [good_buddy_executive, manager].to_set
        end
      end
    end
  end

  describe 'of_active_org' do
    let(:active_org) { FactoryGirl.create(:organization) }
    let!(:active_org_crisis) {
      FactoryGirl.create(:crisis, :organization => active_org) }
    let(:deactive_org) { FactoryGirl.create(:deactivated_org) }
    let!(:deactive_org_crisis) {
      FactoryGirl.create(:crisis, :organization => deactive_org) }

    it 'accepts crises of active orgs' do
      expect(Crisis.of_active_org).to eq([active_org_crisis])
    end
  end
end
