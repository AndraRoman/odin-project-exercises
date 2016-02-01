require 'test_helper'

class PostIndexTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:jrmole)
  end

  def test_name_displayed_if_logged_in
    get login_path
    log_in_as(@user)
    get posts_path
    assert_select "li", text: "J R Mole",     count: 1
    assert_select "li", text: "C E Douglass", count: 1
    assert_select "li", text: "Anonymous",    count: 0
  end

  def test_name_hidden_if_not_logged_in
    get posts_path
    assert_select "li", text: "J R Mole",     count: 0
    assert_select "li", text: "C E Douglass", count: 0
    assert_select "li", text: "Anonymous",    count: 2
  end

end
