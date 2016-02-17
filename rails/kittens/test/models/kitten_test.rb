require 'test_helper'

class KittenTest < ActiveSupport::TestCase

  def setup
    @kitten = Kitten.new(name: "Kitty!", age: 2, cuteness: 8, softness: 3)
  end

  def tests_accepts_valid_kitten
    assert @kitten.valid?
  end

  def tests_kitten_must_have_name
    @kitten.name = ""
    refute @kitten.valid?
  end

end
