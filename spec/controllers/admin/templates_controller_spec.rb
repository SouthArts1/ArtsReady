require 'spec_helper'

describe Admin::TemplatesController do
  before do
    controller.stub(:authenticate_admin!)
  end

  describe 'update' do
    let(:template) { double('template', id: 1) }
    let(:template_params) { {subject: 'no subject'} }

    before do
      Template.stub(:find).and_return(template)
      template.stub(:update_attributes).and_return(true)
      template.stub(:attributes=).and_return(true)

      put 'update', id: template.id,
        template: template_params,
        commit: commit_button
    end

    context 'via the Save button' do
      let(:commit_button) { 'Save' }

      it 'saves the form' do
        expect(template).to have_received(:update_attributes)
      end

      it { should redirect_to admin_templates_path }
    end

    context 'via the Preview button' do
      let(:commit_button) { 'Preview' }

      it 'does not save the form' do
        expect(template).not_to have_received(:update_attributes)
        expect(template).to have_received(:attributes=)
      end

      it { should render_template 'preview' }
    end

    context 'via the Edit button' do
      let(:commit_button) { 'Edit' }

      it 'does not save the form' do
        expect(template).not_to have_received(:update_attributes)
        expect(template).to have_received(:attributes=)
      end

      it { should render_template 'edit' }
    end
  end
end