require 'spec_helper'

describe ArchivedAssessmentsController do
  before { sign_in_as user }

  describe 'index' do
    before { get :index }
    
    context '(authorized)' do
      let(:user) { Factory.create(:reader) }
      
      it { should assign_to(:assessments) }
      it { should render_template :index }
    end
  end
  
  describe 'show' do
    let(:assessment) { Factory.create(:completed_assessment) }
    before { get :show, :id => assessment.id }
    
    context '(authorized)' do
      let(:user) {
        Factory.create(:reader, :organization => assessment.organization)
      }

      it { should assign_to(:assessment).with(assessment) }
      it { should render_template :show }
    end
  end
end
