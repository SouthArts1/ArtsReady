class PagesController < ApplicationController
  
  skip_before_filter :authenticate!
  
  def show
    @page = Page.find_by_slug(params[:slug])
    redirect_to root_url, :notice => "Page #{params[:slug]} does not exist" if @page.nil?
  end

end
