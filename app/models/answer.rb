class Answer < ActiveRecord::Base
  belongs_to :assessment
  belongs_to :question
end
