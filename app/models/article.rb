class Article < ActiveRecord::Base
  
  mount_uploader :document, DocumentUploader
  
  belongs_to :organization
  belongs_to :user
  
  before_create :set_organization
  
  attr_accessible :title, :content, :tags, :link, :user
  
  validates_presence_of :title
  validates_presence_of :content

  def self.featured
    Article.limit(1)
  end

  def self.recent
    Article.all
  end

  def self.for_public
    where(:is_public => true)
  end
  
  def published_on
    created_at.to_date rescue nil
  end
  
  def set_organization
    self.organization = user.organization
  end
end