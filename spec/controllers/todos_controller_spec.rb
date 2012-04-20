require 'spec_helper'

describe TodosController do
  before { sign_in_as user }

  describe 'index' do
    let(:params) { {} }
    before { get :index, params }

    context '(authorized)' do
      let(:user) { 
        Factory.create(:reader)
      }
      let!(:todos) {
        FactoryGirl.create_list(:todo, 1,
          :user => user, :organization => user.organization)
      }

      context '(CSV)' do
        let(:params) { {:format => :csv} }

        it { should assign_to :todos }
        it { should respond_with_content_type(:csv) }
      end
    end
  end
end
