require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:douglass)
  end

  def test_404_if_user_not_found
    bad_user_id = 2453215
    refute User.find_by(id: bad_user_id) # silly
    get "/users/#{bad_user_id}"
    assert_match '404', response.body
    assert_response(:missing)
  end

  def test_user_page_profiles_user
    get "/users/#{@user.id}"
    assert_match "#{@user.name}\n's Profile", response.body # how to match apostrophe
  end

  def test_user_page_shows_created_events
    get "/users/#{@user.id}"
    assert_select ".created-events", count: 1 do
      assert_select 'h3', text: 'breakfast', count: 1
      assert_select 'h3', text: 'dinner', count: 0
    end
  end

  def test_user_page_shows_invited_events
    get "/users/#{@user.id}"
    assert_select ".invited-events", count: 1 do
      assert_select ".upcoming-events", count: 1 do
        assert_select 'h3', text: 'breakfast', count: 0
        assert_select 'h3', text: 'lunch', count: 0
        assert_select 'h3', text: 'dinner', count: 1
      end
      assert_select ".past-events", count: 1 do
        assert_select 'h3', text: 'breakfast', count: 0
        assert_select 'h3', text: 'lunch', count: 1
        assert_select 'h3', text: 'dinner', count: 0
      end
    end
  end

end
