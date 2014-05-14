class TemplateRendering
  attr_accessor :view, :template

  def initialize(view, template)
    self.view = view
    self.template = template
  end

  def subject
    view.template = template.subject

    view.render
  end

  def body
    view.template = template.body

    htmlify(view.render)
  end

  private

  def htmlify(string)
    RedCloth.new(string).to_html
  end
end