ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # not using user object as arg, just a string
  def log_in_as(user)
    if integration_test?
      post login_path, session: { name: user.name }
    else
      session[:user_id] = user.id
    end
  end

  def is_logged_in?
    !session[:user_id].nil?
  end

  def integration_test?
    defined?(post_via_redirect)
  end

end
