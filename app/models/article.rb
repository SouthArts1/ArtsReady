class Article < ActiveRecord::Base

  acts_as_taggable
  mount_uploader :document, DocumentUploader

  belongs_to :organization
  belongs_to :user
  belongs_to :todo
  has_one :todo_note

  has_many :comments, :dependent => :destroy
  
#  attr_accessible :title, :body, :tags, :link, :user, :visibility
# Article.all.group_by(&:critical_function).each { |fn, x| puts "#{fn} #{x}"}
  delegate :name, :to => :user, :allow_nil => true, :prefix => true

  validates_presence_of :title
  validates_presence_of :description
  validates_presence_of :critical_function
  validates_presence_of :buddy_list, :if => :shared?

  default_scope where(:disabled => false)
  
  scope :on_critical_list, where(:on_critical_list => true)
  scope :only_public, where("visibility = 'public' AND disabled = false AND featured = false")
  scope :for_public, where("visibility = 'public' AND disabled = false")
  scope :featured, where(:featured => true)
  scope :only_private, where(:visibility => 'private')
  scope :recent, order("created_at DESC")
  scope :matching, lambda { |term| includes(:tags).where("articles.title LIKE ? OR articles.body LIKE ? OR tags.name LIKE ?","%#{term}%","%#{term}%","%#{term}%") }  
  scope :executive, where(:visibility => 'executive')
  scope :visible_to_organization, lambda { |organization|
    where("
          articles.organization_id = :organization
          OR articles.visibility = 'public'
          OR (articles.visibility = 'buddies'
              AND (SELECT id FROM battle_buddy_requests
                   WHERE battle_buddy_requests.organization_id = articles.organization_id
                     AND battle_buddy_requests.battle_buddy_id = :organization
                     AND battle_buddy_requests.accepted
                   LIMIT 1))
          OR (articles.visibility = 'shared'
              AND POSITION(',:id,' IN CONCAT(',', buddy_list, ',')))
          ", 
          :organization => organization,
          :id => organization.id)
  }
  scope :disabled, where(:disabled => true)
  scope :with_critical_function, lambda { |cf| where(:critical_function => cf)}
  after_save :notify_admin, :if => "is_public?"
  after_save :create_todo_note, :if => :todo

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
      return true
    elsif visibility == 'buddies' && organization.battle_buddy_list.include?(user.organization_id)
      return true
    elsif visibility == 'shared' && buddy_list.split(',').include?(user.organization_id.to_s)
      return true
    elsif visibility == 'executive' && user.is_executive? && organization.users.include?(user)
      return true
    elsif ['private','buddies','shared'].include?(visibility) && organization.users.include?(user)
      return true
    else
      return false
    end
  end

  def shared?
    visibility == 'shared'
  end

  def deleteable_by(user)
    self.user == user
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

  def create_todo_note
    todo.todo_notes.create(:article => self)
  end
end

