class Ability  
  include CanCan::Ability  
  
  def initialize(user)
     
     user ||= User.new # Guest user 

     # common permissions
     can(:read, Article)

     if user.admin?
       can :manage, :all  
     elsif user.role == (:manager)
     elsif user.role == (:executive)
     elsif user.role == (:editor)
     elsif user.role == (:reader)
     else
       # unknown role
       Rails.logger.debug("User is in role that we don't recognize: #{user.inspect}")
     end

  end
 
end