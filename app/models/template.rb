class Template < ActiveRecord::Base
  include ActiveModel::ForbiddenAttributesProtection

  validates_presence_of :subject, :body, on: :update
  validates_uniqueness_of :name

  TEMPLATE_NAMES = [
    'renewal reminder',
    'credit card expiration'
  ]

  scope :usable, -> {
    where("subject IS NOT NULL AND subject <> ''").
      where("body IS NOT NULL AND subject <> ''")
  }

  def self.find_usable(name)
    usable.find_by_name(name)
  end

  def render_preview
    TemplateRendering.new(template_view_class.new_for_preview, self)
  end

  def render(model)
    TemplateRendering.new(template_view_class.new(model), self)
  end

  def template_view_class
    "#{name.parameterize.underscore.classify}TemplateView".constantize
  end

  def self.create_required_templates
    TEMPLATE_NAMES.each do |name|
      find_or_create_by(name: name)
    end
  end
end
