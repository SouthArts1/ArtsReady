require 'spec_helper'

describe Template do
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
