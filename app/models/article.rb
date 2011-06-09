class Article < ActiveRecord::Base
  
  mount_uploader :document, DocumentUploader
  
  belongs_to :organization
  belongs_to :user
  
  attr_accessible :title, :content, :tags, :link, :user
  
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