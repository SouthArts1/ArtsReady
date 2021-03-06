require 'spec_helper'

describe "archived_assessments/index" do
  let(:current_org) { FactoryGirl.create(:organization) }
  let(:first_assessment) { FactoryGirl.create(:completed_assessment, :organization => current_org) }
  let(:second_assessment) { FactoryGirl.create(:completed_assessment, :organization => current_org) }
  
  before do
    stub_template 'shared/_settings_navbar.html.erb' => ''
    assign :assessments, [first_assessment, second_assessment]

    render
  end

  it 'links to each assessment' do
    rendered.should have_selector(
      "a[href='#{archived_assessment_path(first_assessment, :format => :csv)}']")
    rendered.should have_selector(
      "a[href='#{archived_assessment_path(second_assessment, :format => :csv)}']")
  end
end
