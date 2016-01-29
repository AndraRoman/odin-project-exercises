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

  # TODO
  def log_in_as(user, options = {})
    if integration_test?
      # TODO log in by posting to sessions path
    else
      # TODO log in using the session
    end
  end

  # taken from hartl
  def is_logged_in?
    !session[:user_id].nil?
  end

end
