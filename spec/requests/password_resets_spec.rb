require 'spec_helper'

describe "PasswordResets" do
  it "emails user when requesting password reset" do
    user = FactoryGirl.create(:user)
    reset_email

    post password_resets_path, email: user.email
    expect(response).to redirect_to root_path

    follow_redirect!
    expect(response.body).to include 'Email sent'
    expect(last_email.to).to include user.email
  end

  it "does not email invalid user when requesting password reset" do
    post password_resets_path, email: 'nobody@example.com'
    expect(response).to redirect_to root_path

    follow_redirect!
    expect(response.body). to include 'Email sent'
    expect(last_email).to be_nil
  end

  it "updates the user password when confirmation matches" do
    user = FactoryGirl.create(:user, :password_reset_token => "something", :password_reset_sent_at => 1.hour.ago)

    put password_reset_path(user.password_reset_token,
      user: {
        password: 'foobar',
        password_confirmation: ''
      }
    )
    expect(response.body).to include("match Password")

    put password_reset_path(user.password_reset_token,
      user: {
        password: 'foobar',
        password_confirmation: 'foobar'
      }
    )
    expect(response).to redirect_to root_path
    follow_redirect!
    expect(response.body).to include("Password has been reset")
  end

  it "reports when password token has expired" do
    user = FactoryGirl.create(:user, :password_reset_token => "something", :password_reset_sent_at => 5.days.ago)
    put password_reset_path(user.password_reset_token,
      user: {
        password: 'foobar',
        password_confirmation: ''
      }
    )
    expect(response).to redirect_to new_password_reset_path
    follow_redirect!
    expect(response.body).to include("Password reset has expired")
  end

  it "raises record not found when password token is invalid" do
    lambda {
      get edit_password_reset_path("invalid")
    }.should raise_exception(ActiveRecord::RecordNotFound)
  end
end
