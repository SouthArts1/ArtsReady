require 'spec_helper'

describe TodosController do
  before { sign_in_as user }

  describe 'index' do
    let(:params) { {} }
    before { get :index, params }

    context '(authorized)' do
      let(:user) { 
        FactoryGirl.create(:reader)
      }
      let!(:todos) {
        FactoryGirl.create_list(:todo, 1,
          :user => user, :organization => user.organization)
      }

      context '(CSV)' do
        let(:params) { {:format => :csv} }

        it 'assigns to todos' do
          expect(assigns[:todos]).to be_present
        end

        it 'responds with a csv' do
          expect(response.content_type).to eq('text/csv')
        end
      end
    end
  end
end
