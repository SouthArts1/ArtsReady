require 'spec_helper'

describe AssessmentsController do
  before { sign_in_as user }

  describe 'new' do
    before do
      assessment # make sure it's created first
      get :new
    end
    
    context '(authorized)' do
      let(:organization) { Factory.create(:organization) }
      let(:user) { Factory.create(:editor, :organization => organization) }
      
      context '(no existing assessment)' do
        let(:assessment) { nil }

        it 'assigns to assessment' do
          expect(assigns[:assessment]).to be_present
        end

        it { should render_template :new }
      end
      
      context '(assessment in progress)' do
        let(:assessment) {
          Factory.create(:assessment,
            :organization => user.organization)

        }
        
        it { should redirect_to assessment_path }
      end
      
      context '(assessment complete)' do
        let(:assessment) {
          Factory.create(:completed_assessment,
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
      let(:assessment) { Factory.create(:assessment) }
      let(:user) { 
        Factory.create(:reader, :organization => assessment.organization)
      }

      context '(CSV)' do
        let(:show_params) { {:format => :csv} }

        it 'assigns to answers' do
          expect(assigns(:answers)).not_to be_nil
        end

        it 'responds with a csv' do
          expect(response.content_type).to eq('text/csv')
        end

        it { should_not render_with_layout }
      end
    end

    context '(no assessment yet)' do
      let(:user) { Factory.create(:reader) }

      it { should redirect_to new_assessment_path }
    end
  end
end

