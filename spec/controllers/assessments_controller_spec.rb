require 'spec_helper'

describe AssessmentsController do
  before { sign_in_as user }

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

