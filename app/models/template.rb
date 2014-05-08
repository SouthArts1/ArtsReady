class Template < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :subject, :body, on: :update
  validates_uniqueness_of :name

  TEMPLATE_NAMES = [
    'renewal receipt'
  ]

  scope :usable, -> {
    where("subject IS NOT NULL AND subject <> ''").
      where("body IS NOT NULL AND subject <> ''")
  }

  def self.find_usable(name)
    usable.find_by_name(name)
  end

  def render(model)
    template_view_class.new(body, model).render
  end

  def preview
    template_view_class.new_for_preview(body).render
  end

  def template_view_class
    "#{name.parameterize.underscore.classify}TemplateView".constantize
  end

  def self.create_required_templates
    TEMPLATE_NAMES.each do |name|
      find_or_create_by_name(name)
    end
  end
end
