require 'spec_helper'

describe AnswersController do
  describe 'index' do
    let(:answers) { [Factory.create(:answer)] }
    let(:answer) { answers.first }

    before do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(answer.assessment.organization)

      xhr :get, :index, :format => :json # TODO: specify critical function
    end

    it { should assign_to(:answers) }
    it { should respond_with_content_type(:json) }
  end

  describe 'update' do
    let(:answer) { Factory.create(:answer) }
    let(:answer_params) { {} }
    before do
      controller.stubs :authenticate!
      controller.stub(:current_org).and_return(answer.assessment.organization)
      Answer.any_instance.stub(:save).and_return(valid?)

      xhr :put, :update, :id => answer, :answer => answer_params
    end

    context '(with valid params)' do
      let(:valid?) { true }

      it { 
        should render_template(:partial => 'assessments/_assessment_question')
      }
    end

    context '(with invalid params)' do
      let(:valid?) { false }

      it { should respond_with(:unprocessable_entity) }
    end
  end
end
