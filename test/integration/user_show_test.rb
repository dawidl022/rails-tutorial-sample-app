require "test_helper"

class UserShowTest < ActionDispatch::IntegrationTest
  def setup
    @activated_user = users(:michael)
    @not_activated_user = users(:david)
  end

  test "user is shown when activated" do
    get user_path(@activated_user)
    assert_response :success
    assert_template "users/show"
    assert_match @activated_user.name, response.body
  end

  test "should redirect when user not activated" do
    get user_path(@not_activated_user)
    assert_response :redirect
    assert_redirected_to root_url
  end
end
