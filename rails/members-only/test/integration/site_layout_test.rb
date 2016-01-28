require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

  def test_header_links
    get login_url
    assert_template 'sessions/new'
    assert_select "a[href=?]", login_path
    assert_select "a[href=?]", logout_path, count: 1
  end

end
