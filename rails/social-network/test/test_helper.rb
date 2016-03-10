ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest'
require 'minitest/rails/capybara'
require 'hashie'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  # sign_in is a Devise helper method, not available in integration tests
  # password isn't part of table so can't pull from user fixture
  def my_sign_in(user)
    password = user.password || "password"
    post_via_redirect user_session_path, user: {email: user.email, password: password}
  end

  def my_sign_out # likewise with sign_out
    delete_via_redirect destroy_user_session_path
  end

  def my_current_user_id
    key = session.fetch("warden.user.user.key", [])
    key[0][0] if key[0]
  end

  def is_logged_in?
    !my_current_user_id.nil?
  end

  class MyPseudoHash < Hash
    include Hashie::Extensions::MethodAccess
  end

end
