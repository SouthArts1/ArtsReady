class Template < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :subject, :body, on: :update
  validates_uniqueness_of :name

  TEMPLATE_NAMES = [
    'renewal receipt'
  ]

  def self.create_required_templates
    TEMPLATE_NAMES.each do |name|
      find_or_create_by_name(name)
    end
  end
end
