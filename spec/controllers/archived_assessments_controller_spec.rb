require 'spec_helper'

describe ArchivedAssessmentsController do
  before { sign_in_as user }

  describe 'index' do
    before { get :index }
    
    context '(authorized)' do
      let(:user) { Factory.create(:reader) }
      
      it 'assigns to assessments' do
        expect(assigns(:assessments)).not_to be_nil
      end

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

        it 'assigns to answers' do
          expect(assigns(:answers)).not_to be_nil
        end

        it 'responds with a csv' do
          expect(response.content_type).to eq('text/csv')
        end

        it { should_not render_with_layout }
      end
    end
  end
end
