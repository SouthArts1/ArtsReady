class TemplateView < Mustache
  attr_accessor :model

  def initialize(model)
    self.model = model
  end

  def self.new_for_preview
    new(model_for_preview)
  end
end