require 'spec_helper'

describe "archived_assessments/index" do
  let(:current_org) { Factory.create(:organization) }
  let(:first_assessment) { Factory.create(:assessment, :organization => current_org) }
  let(:second_assessment) { Factory.create(:assessment, :organization => current_org) }
  
  before do
    view.stub(:current_org) { current_org }
    view.stub(:assessments) { [first_assessment, second_assessment] }
  end

  it 'links to each assessment' do
    rendered.should have_selector(
      "a[href='#{archived_assessment_path(first_assessment)}']")
    rendered.should have_selector(
      "a[href='#{archived_assessment_path(second_assessment)}']")
  end
end
