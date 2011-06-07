class Organization < ActiveRecord::Base
  
  has_many :users
  
  validates_presence_of :name, :address, :city, :state, :zipcode
  
end
