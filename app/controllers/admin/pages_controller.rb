class Admin::PagesController < Admin::AdminController

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(page_params)

    if @page.save
      redirect_to admin_pages_path, notice: 'Page created'
    else
      render 'new'
    end
  end

  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(page_params)
      redirect_to admin_pages_path, :notice => "Page updated"
    else
      render 'edit'
    end
  end

  def destroy
    @page = Page.find(params[:id])

    if @page.destroy
      redirect_to admin_pages_path, notice: 'Page deleted'
    else
      render 'edit'
    end
  end

  private

  def page_params
    params.require(:page).permit(
      :slug, :title, :body
    )
  end
end
