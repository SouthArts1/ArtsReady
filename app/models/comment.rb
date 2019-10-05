class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  
  validates_presence_of :article_id
  validates_presence_of :user_id
  validates_presence_of :comment
  
  after_create :notify_admins

  scope :recent, -> { limit(3).order("created_at DESC") }
  scope :approved, -> { where(:disabled => false) }
  scope :for_public, -> { joins(:article).where("articles.visibility = 'public' AND articles.disabled = false") }

  delegate :title, :to => :article, :prefix => true
  
  private
  
  def notify_admins
    User.admins.each do |admin|
      AdminMailer.review_comment(self,admin).deliver
    end
  end
  
end
