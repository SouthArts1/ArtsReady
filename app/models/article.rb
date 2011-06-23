class Article < ActiveRecord::Base
  
  mount_uploader :document, DocumentUploader
  
  belongs_to :organization
  belongs_to :user
  
  before_create :set_organization
  
  attr_accessible :title, :content, :tags, :link, :user
  
  validates_presence_of :title
  validates_presence_of :content

  scope :on_critical_list, where(:on_critical_list => true)
  scope :for_public, where(:visibility => 'public')

  def self.featured
    Article.limit(1)
  end

  def self.recent
    Article.all
  end

  def is_public?
    visibility == 'public'
  end
  
  def published_on
    created_at.to_date rescue nil
  end
  
  def set_organization
    self.organization = user.organization
  end
end