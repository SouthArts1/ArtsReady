require 'spec_helper'

describe "archived_assessments/index" do
  let(:current_org) { Factory.create(:organization) }
  let(:first_assessment) { Factory.create(:completed_assessment, :organization => current_org) }
  let(:second_assessment) { Factory.create(:completed_assessment, :organization => current_org) }
  
  before do
    view.stub(:current_org) { current_org }
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
