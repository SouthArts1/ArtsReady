class TodoNote < ActiveRecord::Base
  belongs_to :todo
  belongs_to :user

end