class Admin::TemplatesController < Admin::AdminController
  before_filter :find_template, except: :index

  def index
    Template.create_required_templates

    @templates = Template.all
  end

  def edit
  end

  def update
    if @template.update_attributes(template_params)
      redirect_to admin_templates_path, :notice => "Template updated"
    else
      render 'edit'
    end
  end

  private

  def find_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:subject, :body)
  end
end