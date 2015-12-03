require 'minitest/autorun'
require './chess'

class TestGameplay < Minitest::Unit::TestCase

  def setup
    @board = set_up_board
  end

  def test_set_up_board
    assert_equal(12, @board.length) 
    assert_equal([0] * 12, @board[0])
    assert_equal([0, 0] + [-1] * 8 + [0, 0], @board[8])
    assert_equal([0, 0, -4, -2, -3, -6, -5, -3, -2, -4, 0, 0], @board[9])
  end

end

class TestUIMethods < Minitest::Unit::TestCase
  
  def setup
    @input = StringIO.new("i0\nc0\na1")
    @output = StringIO.new
  end

  def test_display_board
    board = set_up_board
    display_board(board, @output)
    expected = "   ⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽
  ⎹\e[7m ♜ \e[27m ♞ \e[7m ♝ \e[27m ♚ \e[7m ♛ \e[27m ♝ \e[7m ♞ \e[27m ♜ ⎸
  ⎹ ♟ \e[7m ♟ \e[27m ♟ \e[7m ♟ \e[27m ♟ \e[7m ♟ \e[27m ♟ \e[7m ♟ \e[27m⎸
  ⎹\e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   ⎸
  ⎹   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m⎸
  ⎹\e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   ⎸
  ⎹   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m⎸
  ⎹\e[7m ♙ \e[27m ♙ \e[7m ♙ \e[27m ♙ \e[7m ♙ \e[27m ♙ \e[7m ♙ \e[27m ♙ ⎸
  ⎹ ♖ \e[7m ♘ \e[27m ♗ \e[7m ♕ \e[27m ♔ \e[7m ♗ \e[27m ♘ \e[7m ♖ \e[27m⎸
   ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
"
    assert_equal(expected, @output.string)
  end

  def test_get_coordinates
    coords = get_coordinates({:input => @input, :output => @output})
    assert_equal([0, 0], coords)
  end

end
