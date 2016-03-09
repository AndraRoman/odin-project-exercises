require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:active)
  end

  def test_login_page
    get new_user_session_path
    assert_template 'sessions/new'
    assert_select "a[href=?]", new_user_registration_path, count: 2
    assert_select "a[href=?]", new_user_session_path, count: 1
    assert_select "a[href=?]", user_omniauth_authorize_path(:facebook), count: 2
    assert_select "a[href=?]", edit_user_registration_path, count: 0
    assert_select "a[href=?]", destroy_user_session_path, count: 0
  end

  def test_signup_page_and_header_when_not_logged_in
    get new_user_registration_path
    assert_template 'registrations/new'
    assert_select "a[href=?]", new_user_registration_path, count: 1
    assert_select "a[href=?]", new_user_session_path, count: 2
    assert_select "a[href=?]", user_omniauth_authorize_path(:facebook), count: 2
    assert_select "a[href=?]", edit_user_registration_path, count: 0
    assert_select "a[href=?]", destroy_user_session_path, count: 0
    assert_select "a[href=?]", new_post_path, count: 0
    assert_match "see more", response.body
  end

  def test_header_when_logged_in
    my_sign_in @user

    assert_template 'users/index'

    assert_select "a[href=?]", new_user_registration_path, count: 0
    assert_select "a[href=?]", new_user_session_path, count: 0
    assert_select "a[href=?]", user_omniauth_authorize_path(:facebook), count: 0

    assert_select "a[href=?]", edit_user_registration_path, count: 1
    assert_select "a[href=?]", destroy_user_session_path, count: 1

    assert_select "a[href=?]", new_post_path, count: 1
    assert_select "a[href=?]", posts_path, count: 1
    assert_select "a[href=?]", users_path, count: 1
  end

end
