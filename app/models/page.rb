class Page < ActiveRecord::Base
  
  validates_presence_of :title
  validates_presence_of :body
  
  def to_html
    RedCloth.new(body).to_html.html_safe
  end
  
end
