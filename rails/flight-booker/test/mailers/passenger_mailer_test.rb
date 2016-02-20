require 'test_helper'

class PassengerMailerTest < ActionMailer::TestCase

  include Rails.application.routes.url_helpers
  include ActionView::Helpers::UrlHelper

  # allow to compare dynamic data in email using erb
  def read_fixture(action)
    x = super
    template = ERB.new(x.join)
    template.result(binding) # cargo culting
  end

  def test_thank_you
    email = PassengerMailer.thank_you_email(passengers(:a_user)).deliver_now

    refute ActionMailer::Base.deliveries.empty?

    assert_equal ['a_user@example.com'], email.to
    assert_equal ['flight-picker@example.com'], email.from
    assert_equal 'Thank you for flying with us!', email.subject

    assert_equal read_fixture('thank_you.txt.erb'), email.text_part.body.to_s
  end

end
