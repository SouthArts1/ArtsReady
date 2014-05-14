class TemplateView < Mustache
  attr_accessor :model

  def initialize(body, model)
    self.template = body
    self.model = model
  end

  def self.new_for_preview(body)
    new(body, model_for_preview)
  end
end