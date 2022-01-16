require "test_helper"

class UsersSignupTest < ActionDispatch::IntegrationTest
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
end
