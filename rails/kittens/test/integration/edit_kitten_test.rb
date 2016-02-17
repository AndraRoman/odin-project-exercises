require 'test_helper'

class EditKittenTest < ActionDispatch::IntegrationTest

  def setup
    @kitten = kittens(:siamese)
  end

  def test_can_update_kitten
    get "/kittens/#{@kitten.id}/edit"
    assert_template 'kittens/edit'
    refute_equal(":3", @kitten.name) # avoid vacuous passing
    refute_equal(10, @kitten.softness)

    patch_via_redirect "/kittens/#{@kitten.id}", kitten: { name: ":3", softness: 10 }

    @kitten.reload
    assert_equal(":3", @kitten.name)
    assert_equal(10, @kitten.softness)
    assert_template 'kittens/show'
  end

  def test_rerenders_edit_in_case_of_invalid_edit
    get "/kittens/#{@kitten.id}/edit"
    patch_via_redirect "/kittens/#{@kitten.id}", kitten: { name: "" }
    @kitten.reload
    assert_template 'kittens/edit'
    refute @kitten.name.blank?
  end

end
