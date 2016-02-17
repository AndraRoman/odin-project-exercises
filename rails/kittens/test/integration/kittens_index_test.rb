require 'test_helper'

class KittensIndexTest < ActionDispatch::IntegrationTest

  def test_index_shows_all_kittens
    get root_path
    assert_template 'kittens/index'
    assert_select '.kitten', count: 2
  end

end
