require 'spec_helper'

describe Template do
  describe '#render' do
    let(:template) { FactoryGirl.build(:template, name: 'renewal receipt') }
    let(:template_view) { double('template view', render: 'rendered body') }
    let(:redcloth) { double('redcloth', to_html: 'rendered html body') }
    let(:model) { double('model') }

    before do
      RedCloth.stub(:new).and_return(redcloth)
      RenewalReceiptTemplateView.stub(:new).and_return(template_view)
    end

    it 'creates a TemplateView and calls render on it' do
      expect(template.render(model)).to eq('rendered html body')
    end

    it 'uses RedCloth to convert the rendered template into HTML' do
      template.render(model)

      expect(RedCloth).to have_received(:new).with('rendered body')
    end
  end

  describe 'TEMPLATE_NAMES' do
    specify 'all have corresponding TemplateView classes' do
      Template::TEMPLATE_NAMES.each do |name|
        expect {
          Template.new(name: name).template_view_class
        }.not_to raise_error
      end
    end
  end

  describe '.create_required_templates' do
    it 'creates missing templates' do
      Template.create_required_templates

      expect(Template.pluck(:name)).to include 'renewal receipt'
    end

    it 'does not recreate existing templates' do
      Template.create_required_templates

      expect {
        Template.create_required_templates
      }.not_to change { Template.count }
    end
  end
end
