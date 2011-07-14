class Crisis < ActiveRecord::Base
  belongs_to :organization
  
  def resolve_crisis!
    puts "resolving crisis!"
    self.resolved_on= Time.now
    self.save
  end
end
