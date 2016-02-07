require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def test_login_page
    get login_path
    assert_template 'sessions/new'
    assert_select 'h1', text: 'Private Events'
    assert_select 'p', text: 'Welcome', count: 0
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", signup_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
  end

  def test_signup_page
    get signup_path
    assert_template 'users/new'
    assert_select 'h1', text: 'Private Events'
    assert_select 'p', text: 'Welcome', count: 0
    assert_select "a[href=?]", login_path, count: 1
    assert_select "a[href=?]", signup_path, count: 1
    assert_select "a[href=?]", logout_path, count: 0
  end

  def test_header_when_logged_in
    name = "C E Douglass"
    get login_path
    post_via_redirect login_path, session: { name: name }
    assert_select 'h1', text: 'Private Events'
    assert_select 'p', text: "Welcome, #{name}!", count: 1
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", signup_path, count: 0
    assert_select "a[href=?]", logout_path, count: 1
  end

end
