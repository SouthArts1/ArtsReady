class TodoNote < ActiveRecord::Base
  belongs_to :todo, :touch => true
  belongs_to :user
  belongs_to :article

  delegate :name, :to => :user, :allow_nil => true, :prefix => true

  before_validation :initialize_from_article, :if => :article

  def initialize_from_article
    self.message = article.title
    self.user = article.user
  end
end
