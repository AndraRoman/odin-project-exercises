require 'test_helper'

class DestroyKittenTest < ActionDispatch::IntegrationTest

  def test_destroy_kitten
    kitten = kittens(:persian)
    get kittens_path(kitten)
    assert_difference 'Kitten.count', -1 do
      delete_via_redirect kitten_path(kitten)
    end
    assert_template 'kittens/index'
  end

end
