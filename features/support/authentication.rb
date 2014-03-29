module AuthenticationStepHelpers
  def sign_in_credentials
    @sign_in_credentials
  end

  def remember_sign_in_credentials(email, password)
    @sign_in_credentials = [email, password]
  end

  def login_again
    login *sign_in_credentials
  end

  def login(email, password = 'password')
    visit(sign_in_path)
    fill_in 'email', with: email
    fill_in 'password', with: password
    click_on 'Sign In'

    remember_sign_in_credentials email, password
  end
end
World(AuthenticationStepHelpers)
