class Admin::PagesController < Admin::AdminController

  def index
    @pages = Page.all
  end

  def new
    @page = Page.new
  end

  def create
    @page = Page.new(params[:page])

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

    if @page.update_attributes(params[:page])
      redirect_to admin_pages_path, :notice => "Page updated"
    else
      render 'edit'
    end
  end
  
end
