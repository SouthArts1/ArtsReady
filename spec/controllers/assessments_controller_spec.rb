require 'spec_helper'

describe AssessmentsController do
  before { sign_in_as user }

  describe 'new' do
    before do
      assessment.stub(:complete?, :assessment_complete) if assessment
      get :new
    end
    
    context '(authorized)' do
      let(:user) { Factory.create(:editor) }
      
      context '(no existing assessment)' do
        let(:assessment) { nil }
        
        it { should assign_to :assessment }
        it { should render_template :new }
      end
      
      context '(assessment in progress)' do
        let(:assessment) {
          user.organization.create_assessment
        }
        let(:assessment_complete) { false }
        
        it { should redirect_to assessment }
      end
      
      context '(assessment complete)' do
        let(:assessment) {
          user.organization.create_assessment(:has_exhibits => true)
        }
        let(:assessment_complete) { true }

        it 'builds a new assessment' do
          assigns[:assessment].should be_present
          assigns[:assessment].should_not == assessment
          assigns[:assessment].should have_exhibits
        end
        
        it { should render_template :new }
      end
    end
  end
  
  describe 'show' do
    let(:show_params) { {} }
    before { get :show, show_params }

    context '(authorized)' do
      let(:assessment) { Factory.create(:assessment) }
      let(:user) { 
        Factory.create(:reader, :organization => assessment.organization)
      }

      context '(CSV)' do
        let(:show_params) { {:format => :csv} }

        it { should assign_to :answers }
        it { should respond_with_content_type(:csv) }
        it { should_not render_with_layout }
      end
    end
  end
end

