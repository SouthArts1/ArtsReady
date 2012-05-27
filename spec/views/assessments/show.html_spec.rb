require 'spec_helper'

describe "assessments/show" do
  let(:current_org) { Factory.create(:organization) }
  
  before do
    view.stubs(:current_org).returns(current_org)
      
    assign :answers, FactoryGirl.create_list(:answer, 1)
    assign :critical_function, 'productions'
  end
  
  context 'given a complete assessment' do
    before do
      current_org.stubs(:complete?) { true }
      
      render
    end
    
    it 'offers a re-assess button' do
      rendered.should have_selector("a[href='#{new_assessment_path}']")
    end
  end
  
  context 'given an incomplete assessment' do
    before do
      current_org.stubs(:complete?) { false }
      
      render
    end
    
    it 'does not offer a re-assess button' do
      rendered.should_not have_selector("a[href='#{new_assessment_path}']")
    end
  end
end
