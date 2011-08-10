class Admin::PagesController < Admin::AdminController

  def index
    @pages = Page.all
  end

  def edit
    @page = Page.find(params[:id])
  end
  
  def update
    @page = Page.find(params[:id])

    if @page.update_attributes(params[:page])
      redirect_to admin_pages_path, :notice => "Page updated"
    else
      redirect_to admin_pages_path, :notice => "Problem updating page"
    end
  end
  
end
