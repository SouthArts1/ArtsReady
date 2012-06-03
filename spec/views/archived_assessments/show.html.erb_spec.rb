require 'spec_helper'

describe "archived_assessments/show" do
  let(:assessment) { Factory.create(:assessment) }
  
  before do
    2.times { Factory.create(:question) }
    view.stub(:answers) { assessment.answers }
    render
  end

  it 'displays each answer' do
    rendered.should have_selector(".answers tbody tr", :count => 2)
  end
end
