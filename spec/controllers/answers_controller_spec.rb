require 'spec_helper'

describe AnswersController do
  describe 'update' do
    let(:answer) { Factory.create(:answer) }
    let(:answer_params) { {} }
    before do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(answer.assessment.organization)

      xhr :put, :update, :id => answer, :answer => answer_params
    end

    it { 
      should render_template(:partial => 'assessments/_assessment_question')
    }
  end
end
