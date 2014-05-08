require 'spec_helper'

describe Template do
  describe '#render' do
    let(:template) { FactoryGirl.build(:template, name: 'renewal receipt') }
    let(:template_view) { double('template view', render: 'rendered body') }
    let(:model) { double('model') }

    before do
      RenewalReceiptTemplateView.stub(:new).and_return(template_view)
    end

    it 'creates a TemplateView and calls render on it' do
      expect(template.render(model)).to eq('rendered body')
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
