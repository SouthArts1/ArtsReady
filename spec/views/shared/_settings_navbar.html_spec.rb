require 'spec_helper'

describe "shared/_settings_navbar" do
  let(:current_org) { Factory.create(:organization) }
  
  before do
    view.stubs(:current_org).returns(current_org)
    view.stubs(:current_settings_tab).returns(:our_team)
  end

  context 'given archived assessments' do
    before do
      2.times { Factory.create(:assessment, :organization => current_org) }
      
      render
    end
    
    it 'links to them' do
      rendered.should have_selector("a[href='#{archived_assessments_path}']")
    end
  end
end
