class Resource < ActiveRecord::Base
  belongs_to :organization

  validates_presence_of :name
  validates_presence_of :details

end