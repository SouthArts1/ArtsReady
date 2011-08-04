class Article < ActiveRecord::Base

  acts_as_taggable
  mount_uploader :document, DocumentUploader

  belongs_to :organization
  belongs_to :user
  belongs_to :todo

  #before_create :set_organization

#  attr_accessible :title, :body, :tags, :link, :user, :visibility
  delegate :name, :to => :user, :allow_nil => true, :prefix => true

  validates_presence_of :title
  validates_presence_of :description

  scope :on_critical_list, where(:on_critical_list => true)
  scope :for_public, where(:visibility => 'public')

  def self.search_public(phrase)
    term = "%#{phrase}%"
    Article.for_public.where("title LIKE ? OR body LIKE ?",term,term) + Article.for_public.tagged_with(term)
  end

  def self.search(phrase)
    term = "%#{phrase}%"
    Article.where("title LIKE ? OR body LIKE ?",term,term) + Article.tagged_with(term)
  end
  
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

  def to_html
    RedCloth.new(body).to_html.html_safe
  end

  def set_organization
    self.organization = user.organization
  end
  
end