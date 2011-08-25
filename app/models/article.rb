class Article < ActiveRecord::Base

  acts_as_taggable
  mount_uploader :document, DocumentUploader

  belongs_to :organization
  belongs_to :user
  belongs_to :todo

  has_many :comments
  
#  attr_accessible :title, :body, :tags, :link, :user, :visibility
# Article.all.group_by(&:critical_function).each { |fn, x| puts "#{fn} #{x}"}
  delegate :name, :to => :user, :allow_nil => true, :prefix => true

  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :critical_function

  scope :on_critical_list, where(:on_critical_list => true)
  scope :only_public, where("visibility = 'public' AND disabled = false AND featured = false")
  scope :for_public, where("visibility = 'public' AND disabled = false")
  scope :featured, where(:featured => true)
  scope :only_private, where(:visibility => 'private')
  scope :recent, order("created_at DESC")
  scope :matching, lambda { |term| includes(:tags).where("articles.title LIKE ? OR articles.body LIKE ? OR tags.name LIKE ?","%#{term}%","%#{term}%","%#{term}%") }  
  scope :executive, where(:visibility => 'executive')
  scope :disabled, where(:disabled => true)
  
  after_save :notify_admin, :if => "is_public?"

  def self.search_public(phrase)
    term = "%#{phrase}%"
    Article.for_public.where("title LIKE '%?%' OR body LIKE %?%",term,term)# + Article.for_public.tagged_with(term)
  end

  def self.search_other_public(org,phrase)
    term = "%#{phrase}%"
    Article.where('organization_id !=?',org).for_public.where("title LIKE ? OR body LIKE ?",term,term)# + Article.where('organization_id !=?',org).for_public.tagged_with(term)
  end

  def self.search(phrase)
    term = "%#{phrase}%"
    Article.where("title LIKE ? OR body LIKE ?",term,term)# + Article.tagged_with(term)
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

  # Declarative security, but not very sexy. 
  # TODO would be great to refactor this into multiple *types* of documents -- article is not best modelling for behavior
  def can_be_accessed_by?(user)
    if visibility == 'public'
      logger.debug('allowed by public')
      return true
    elsif visibility == 'buddies' && organization.battle_buddy_list.include?(user.organization_id)
      logger.debug('allowed by buddy network')
      return true
    elsif visibility == 'shared' && buddy_list.split(',').include?(user.organization_id)
      logger.debug('allowed by shared')
      return true
    elsif visibility == 'executive' && user.is_executive? && organization.users.include?(user)
      logger.debug('allowed by executive')
      return true
    elsif ['private','buddies','shared'].include?(visibility) && organization.users.include?(user)
      logger.debug('allowed by private')
      return true
    else
      logger.debug("access denied to #{user.inspect} to #{self.inspect}")
      return false
    end
  end

  def published_on
    created_at.to_date rescue nil
  end

  def to_html
    RedCloth.new(body).to_html.html_safe
  end
  
  def notify_admin
    User.admins.each do |admin|
      AdminMailer.review_public(self,admin).deliver
    end    
  end
  
end