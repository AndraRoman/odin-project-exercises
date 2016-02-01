ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
include SessionsHelper

class ActiveSupport::TestCase
  # Set up all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def integration_test?
    defined?(post_via_redirect)
  end

  def log_in_as(user)
    if integration_test?
      post_via_redirect login_path, session: {name: user.name, password: user.password || "password"}
    else
      log_in(user)
    end
  end

  # taken from hartl
  def is_logged_in?
    !session[:user_id].nil?
  end

end
