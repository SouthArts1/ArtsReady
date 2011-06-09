class Article < ActiveRecord::Base
  
  mount_uploader :document, DocumentUploader
  
  attr_accessible :title, :content
  
  validates_presence_of :title
  validates_presence_of :content

  def self.featured
    [Article.first]
  end

  def self.recent
    Article.all - self.featured
  end
  
  def published_on
    created_at.to_date rescue nil
  end
end