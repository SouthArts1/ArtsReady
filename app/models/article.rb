class Article < ActiveRecord::Base

  acts_as_taggable
  mount_uploader :document, DocumentUploader

  belongs_to :organization
  belongs_to :user
  belongs_to :todo

#  attr_accessible :title, :body, :tags, :link, :user, :visibility
  delegate :name, :to => :user, :allow_nil => true, :prefix => true

  validates_presence_of :title
  validates_presence_of :description

  scope :on_critical_list, where(:on_critical_list => true)
  scope :for_public, where(:visibility => 'public')
  scope :featured, where(:featured => true)
  scope :recent, order("created_at DESC")

  def self.search_public(phrase)
    term = "%#{phrase}%"
    Article.for_public.where("title LIKE ? OR body LIKE ?",term,term) + Article.for_public.tagged_with(term)
  end

  def self.search(phrase)
    term = "%#{phrase}%"
    Article.where("title LIKE ? OR body LIKE ?",term,term) + Article.tagged_with(term)
  end
  
  def is_public?
    visibility == 'public'
  end

  def is_featured?
    featured
  end

  def is_disabled?
    disabled
  end

  def published_on
    created_at.to_date rescue nil
  end

  def to_html
    RedCloth.new(body).to_html.html_safe
  end
  
end