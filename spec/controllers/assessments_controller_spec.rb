require 'spec_helper'

describe AssessmentsController do
  before { sign_in_as user }

  describe 'new' do
    before do
      assessment # make sure it's created first
      get :new
    end
    
    context '(authorized)' do
      let(:organization) { FactoryGirl.create(:organization) }
      let(:user) { FactoryGirl.create(:editor, :organization => organization) }
      
      context '(no existing assessment)' do
        let(:assessment) { nil }

        it { should assign_to :assessment }
        it { should render_template :new }
      end
      
      context '(assessment in progress)' do
        let(:assessment) {
          FactoryGirl.create(:assessment,
            :organization => user.organization)

        }
        
        it { should redirect_to assessment_path }
      end
      
      context '(assessment complete)' do
        let(:assessment) {
          FactoryGirl.create(:completed_assessment,
            :organization => user.organization,
            :has_exhibits => true)
        }

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
      let(:assessment) { FactoryGirl.create(:assessment) }
      let(:user) { 
        FactoryGirl.create(:reader, :organization => assessment.organization)
      }

      context '(CSV)' do
        let(:show_params) { {:format => :csv} }

        it { should assign_to :answers }
        it { should respond_with_content_type(:csv) }
        it { should_not render_with_layout }
      end
    end

    context '(no assessment yet)' do
      let(:user) { FactoryGirl.create(:reader) }

      it { should redirect_to new_assessment_path }
    end
  end
end

