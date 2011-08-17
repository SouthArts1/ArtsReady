class Comment < ActiveRecord::Base
  belongs_to :article
  belongs_to :user
  
  validates_presence_of(:comment)
  
end
