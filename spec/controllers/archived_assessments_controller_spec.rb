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
    before { get :show, show_params }
    
    context '(authorized)' do
      let(:user) {
        Factory.create(:reader, :organization => assessment.organization)
      }

      context '(CSV)' do
        let(:show_params) { {:format => :csv, :id => assessment.id} }

        it { should assign_to :answers }
        it { should respond_with_content_type(:csv) }
        it { should_not render_with_layout }
      end
    end
  end
end
