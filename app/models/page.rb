class Page < ActiveRecord::Base
  
  validates_presence_of :title, :body, :slug
  validates_uniqueness_of :slug

  def to_html
    RedCloth.new(body).to_html.html_safe
  end
  
end
