module AuthenticationSpecHelper
  def sign_in_as(user)
    controller.stub(:current_user).and_return(user)
  end
end

