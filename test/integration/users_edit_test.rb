require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  def update_user_assertions
    name = "Foo Bar"
    email = "foo@bar.com"

    patch user_path(@user), params: { user: {
      name: name, email: email, password: "", password_confirmation: ""
    } }

    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test "unsuccessful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: {
      name: "", email: "foo_at_invalid", password: "foo",
      password_confirmation: "bar"
    } }
    assert_template 'users/edit'
    assert_select "div.alert", /4/
  end

  test "successful edit" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    update_user_assertions
  end

  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    update_user_assertions
  end

  test "friendly forwarding only redirects once" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    log_in_as(@user)
    assert_redirected_to user_url(@user)
  end
end
