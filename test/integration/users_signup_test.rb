require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test "user not created when invalid data is input" do
    get signup_path

    assert_no_difference 'User.count' do
      post users_path, params: { user: {
        name: "", email: "user@invalid", password: "foo",
        password_confirmation: "bar"
      } }
    end
    assert_template 'users/new'
    assert_select '.alert-danger'
    assert_select '.field_with_errors'
  end

  test "user created with account validation when valid data is input" do
    get signup_path

    assert_difference 'User.count', 1 do
      post users_path, params: { user: {
        name: "Example User", email: "user@example.com", password: "password",
        password_confirmation: "password"
      } }
    end

    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?

    # Try to log in before activation.
    log_in_as(user)
    assert_not is_logged_in?

    # Invalid activation token
    get edit_account_activation_path("invalid token", email: user.email)
    assert_not is_logged_in?

    # Valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "wrong")
    assert_not is_logged_in?

    # Valid activation token
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?

    follow_redirect!
    assert_template 'users/show'
    assert_select ".alert-success"
    assert is_logged_in?
  end
end
