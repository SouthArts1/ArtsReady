require 'spec_helper'

describe "assessments/show" do
  let!(:questions) { 2.times { FactoryGirl.create(:question) } }
  let(:assessment) { FactoryGirl.create(:assessment) }

  before do
    view.stubs(:current_org).returns(assessment.organization)

    assign :assessment, assessment
    assign :answers, assessment.answers
    assign :critical_function, assessment.answers.first.critical_function
  end
  
  context 'given a complete assessment' do
    before do
      assessment.stubs(:complete?).returns(true)
      render
    end
    
    it 'offers a re-assess button' do
      rendered.should have_selector("a[href='#{new_assessment_path}']")
    end
  end
  
  context 'given an incomplete assessment' do
    before do
      assessment.stubs(:complete?).returns(false)
      
      render
    end
    
    it 'does not offer a re-assess button' do
      rendered.should_not have_selector("a[href='#{new_assessment_path}']")
    end
  end
end
