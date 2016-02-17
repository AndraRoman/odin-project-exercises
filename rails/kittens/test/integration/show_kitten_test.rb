require 'test_helper'

class ShowKittenTest < ActionDispatch::IntegrationTest

  def setup
    @kitten = kittens(:siamese)
  end

  def test_shows_kitten
    get "/kittens/#{@kitten.id}"
    assert_template 'kittens/show'
    assert_match @kitten.name, response.body
  end

  def test_responds_to_json_request
    get "/kittens/#{@kitten.id}.json"
    assert_response :success
    assert_equal(response.body, @kitten.to_json)
  end

end
