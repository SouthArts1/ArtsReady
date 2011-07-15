class Update < ActiveRecord::Base
  belongs_to :crisis
  belongs_to :user
  belongs_to :organization

  def organization_name
    organization.name rescue 'Organization Name'
  end

  def user_name
    user.name rescue 'User Name'
  end
end
