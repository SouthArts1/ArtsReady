class Admin::TemplatesController < Admin::AdminController
  before_filter :find_template, except: :index
  before_filter :divert_update, only: :update

  def index
    Template.create_required_templates

    @templates = Template.all
  end

  def edit
    # set attributes if we're returning from the preview page
    @template.attributes = template_params

    # render explicitly, because we may be called from the `update` action
    # (via the `divert_update` filter)
    render 'edit'
  end

  def update
    if @template.update_attributes(template_params)
      redirect_to admin_templates_path, :notice => "Template updated"
    else
      render 'edit'
    end
  end

  def preview
    @template.attributes = template_params

    render 'preview'
  end

  private

  def find_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.fetch(:template, {}).permit(:subject, :body)
  end

  def divert_update
    case params[:commit]
    when 'Save'
      true
    when 'Preview'
      preview
      false
    when 'Edit'
      edit
      false
    else
      render text: 'Unknown button', status: :bad_request
      false
    end
  end
end
