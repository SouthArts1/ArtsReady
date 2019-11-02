require 'spec_helper'

describe AnswersController do
  describe 'update' do
    let(:answer) { FactoryGirl.create(:answer) }
    let(:answer_params) { {preparedness: 'unknown', priority: 'critical'} }
    before do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(answer.assessment.organization)

      xhr :put, :update, :id => answer, :answer => answer_params
    end

    it { 
      should render_template('update')
    }
  end
end
