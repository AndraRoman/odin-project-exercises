require 'test_helper'

class CreateKittenTest < ActionDispatch::IntegrationTest

  def test_create_valid_kitten
    get '/kittens/new'
    assert_template 'kittens/new'
    assert_select 'input[type=submit]', count: 1

    assert_difference 'Kitten.count', 1 do
      post_via_redirect kittens_path, kitten: { name: "Catkin", age: 3, cuteness: 7, softness: 10 }
    end

    assert_match 'Catkin', response.body
    assert_template 'kittens/show'
  end

  def test_cannot_create_invalid_kitten
    get '/kittens/new'
    assert flash.empty?

    assert_no_difference 'Kitten.count' do
      post_via_redirect kittens_path, kitten: { age: 3, cuteness: 7, softness: 10 }
    end

    assert_template 'kittens/new'
    refute flash.empty?
  end

end
