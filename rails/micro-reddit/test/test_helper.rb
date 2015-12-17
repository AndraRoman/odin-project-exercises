ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
    def assert_raise_with_partial_message exception_class, message
    assert_raise exception_class do
      begin
        yield
      rescue Exception => e
        assert_match(message, e.message)
        raise e
      end
    end
  end

end
