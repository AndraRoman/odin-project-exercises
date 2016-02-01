require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jrmole)
  end

  def test_header_links_when_logged_out
    get login_url
    assert_template 'sessions/new'
    assert_select "a[href=?]", login_path,    count: 1
    assert_select "a[href=?]", logout_path,   count: 0
    assert_select "a[href=?]", new_post_path, count: 0
  end

  def test_header_links_when_logged_in
    get login_url
    log_in_as(@user)
    assert_select "a[href=?]", login_path,    count: 0
    assert_select "a[href=?]", logout_path,   count: 1
    assert_select "a[href=?]", new_post_path, count: 1
  end

end
