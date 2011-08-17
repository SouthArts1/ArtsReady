class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  
  validates_presence_of(:comment)
  
  after_create :notify_admins
  
  private
  
  def notify_admins
    User.admins.each do |admin|
      AdminMailer.review_comment(self,admin).deliver
    end
  end
  
end
