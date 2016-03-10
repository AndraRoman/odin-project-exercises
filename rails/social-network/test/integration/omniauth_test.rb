require 'test_helper'

class OmniauthTest < ActionDispatch::IntegrationTest

  def setup
    OmniAuth.config.test_mode = true
    @valid_new_auth_hash = MyPseudoHash[:provider, "facebook", :uid, "000000", :info, MyPseudoHash[:email, "valid_fb_user@example.com", :name, "Another User"]]

    @user = users(:facebook_user)
    @existing_user_auth_hash = MyPseudoHash[:provider, "facebook", :uid, @user.uid, :info, MyPseudoHash[:email, @user.email, :name, @user.name]]
  end

  # don't need to test case of invalid fb credentials because user just doesn't get to our site through that route

  def test_successful_user_creation_with_omniauth
    OmniAuth.config.mock_auth[:facebook] = @valid_new_auth_hash

    assert_difference 'User.count', 1 do
      host! 'localhost:3000' # otherwise expects redirect to go to example.com
      get user_omniauth_authorize_path(:facebook)
      assert_redirected_to user_omniauth_callback_path(:facebook)
      follow_redirect!
      assert_redirected_to root_path
    end

    assert is_logged_in?

    get posts_path
    assert_template 'posts/index'

    delete destroy_user_session_path
    refute is_logged_in?
  end

  def test_sign_in_existing_user_with_omniauth
    OmniAuth.config.mock_auth[:facebook] = @existing_user_auth_hash

    assert_no_difference 'User.count' do
      host! 'localhost:3000'
      get user_omniauth_authorize_path(:facebook)
      assert_redirected_to user_omniauth_callback_path(:facebook)
      follow_redirect!
      assert_redirected_to root_path
    end
 
    assert is_logged_in?

    get posts_path
    assert_template 'posts/index'

    delete destroy_user_session_path
    refute is_logged_in?
  end

  def test_informative_message_when_fb_sign_in_matches_email_of_an_existing_user
    @conflicting_user_auth_hash = MyPseudoHash[:provider, "facebook", :uid, "000111", :info, MyPseudoHash[:email, @user.email, :name, @user.name]]
    OmniAuth.config.mock_auth[:facebook] = @conflicting_user_auth_hash

    assert_no_difference 'User.count' do
      host! 'localhost:3000'
      get user_omniauth_authorize_path(:facebook)
      assert_redirected_to user_omniauth_callback_path(:facebook)
      follow_redirect!
      assert_redirected_to new_user_registration_path
    end
 
    refute is_logged_in?
    assert_match "already taken", flash[:danger]
  end

  # user gave fb phone # instead of email, user hasn't confirmed email yet, or other possibilities
  # TODO ideally would prompt user for email once, then create account successfully and allow fb login thenceforth
  def test_informative_message_when_auth_hash_lacks_email
    @no_email_new_auth_hash = MyPseudoHash[:provider, "facebook", :uid, "000000", :info, MyPseudoHash[:email, nil, :name, "Another User"]]
    OmniAuth.config.mock_auth[:facebook] = @no_email_new_auth_hash

    assert_no_difference 'User.count' do
      host! 'localhost:3000'
      get user_omniauth_authorize_path(:facebook)
      assert_redirected_to user_omniauth_callback_path(:facebook)
      follow_redirect!
      assert_redirected_to new_user_registration_path
    end
 
    refute is_logged_in?
    assert_match "email address is missing", flash[:danger]
  end

  def teardown
    OmniAuth.config.test_mode = false
  end

end
