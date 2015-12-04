require 'minitest/autorun'
require './chess'

module Minitest::Assertions

  def assert_subarrays_equivalent(expected, actual)
    assert(subarrays_equivalent(expected, actual), "Expected #{expected} and #{actual} to have equal elements.")
  end

  def refute_subarrays_equivalent(expected, actual)
    refute(subarrays_equivalent(expected, actual), "Expected #{expected} and #{actual} not to have equal elements.")
  end

  private
  def subarrays_equivalent(expected, actual)
    expected.length == actual.length && [0..expected.length].all? { |i| actual[i] == expected[i] }
  end

end

class TestBoardSetup < Minitest::Test

  def setup
    @board = empty_board
  end

  def test_empty_board
    assert_equal(12, @board.length) 
    assert_equal([0] * 12, @board[0])
    assert_equal([0, 0] + [nil] * 8 + [0, 0], @board[8])
  end

  def test_populated_board
    @board = populate_board(@board)
    assert_equal(12, @board.length) 
    assert_equal([0] * 12, @board[0])
    assert_equal([0, 0] + [-1] * 8 + [0, 0], @board[8])
    assert_equal([0, 0, -4, -2, -3, -6, -5, -3, -2, -4, 0, 0], @board[9])
  end

  def test_set_by_alg_coords
    @board.set_by_alg_coords(["c", 4], 5)
    assert_equal(5, @board[5][4])
  end

  def test_flip_coords
    assert_equal([11, 2], flip_coords([0, 9]))
  end

  def test_alg_to_cartesian
    assert_equal([2, 2], alg_to_cartesian(["a", 1]))
  end

  def test_delta_gives_difference_between_coordinates
    assert_equal([3, -5], delta([1, 7], [4, 2]))
  end

  def test_place_pieces
    @board.place_pieces({["d", 2] => -1, ["a", 8] => 3})
    assert_equal(-1, @board[3][5])
    assert_equal(3, @board[9][2])
  end

  def test_path_vertical
    start = [1, 4]
    finish = [1, 1]
    assert_subarrays_equivalent([[1, 3], [1, 2]], path(start, finish))
    assert_subarrays_equivalent([[1, 2], [1, 3]], path(finish, start))
  end

  def test_path_horizontal
    start = [4, 1]
    finish = [1, 1]
    assert_subarrays_equivalent([[3, 1], [2, 1]], path(start, finish))
    assert_subarrays_equivalent([[2, 1], [3, 1]], path(finish, start))
  end

  def test_path_pos_diagonal
    start = [2, 1]
    finish = [5, 4]
    assert_subarrays_equivalent([[3, 2], [4, 3]], path(start, finish))
    assert_subarrays_equivalent([[4, 3], [3, 2]], path(finish, start))
  end

  def test_path_neg_diagonal
    start = [5, 1]
    finish = [2, 4]
    assert_subarrays_equivalent([[4, 2], [3, 3]], path(start, finish))
    assert_subarrays_equivalent([[3, 3], [4, 2]], path(finish, start))
  end

  def test_path_knight
    start = [1, 1]
    finish = [2, 3]
    assert_equal([], path(start, finish))
    assert_equal([], path(finish, start))
  end

  def test_path_stationary
    start = [1, 1]
    finish = [1, 1]
    assert_equal([], path(start, finish))
    assert_equal([], path(finish, start))
  end

  def test_path_open_true_on_clear_path
    start = [2, 2]
    finish = [2, 10]
    assert(@board.path_open?(path(start, finish)))
    assert(@board.path_open?(path(finish, start)))
  end

  def test_path_open_false_on_blocked_path
    start = [2, 2]
    finish = [2, 10]
    @board.place_pieces(["a", 5] => 1)
    refute(@board.path_open?(path(start, finish)))
    refute(@board.path_open?(path(finish, start)))
  end

end

class TestMoveValidations < Minitest::Test

  def setup
    @board = empty_board
  end

  class TestOverallMoveValidation < TestMoveValidations

    def setup
      super
      @board.place_pieces({["a", 2] => 5})
      @start = alg_to_cartesian(["a", 2]) 
    end

    def test_true_for_valid_move
      finish = alg_to_cartesian(["a", 4])
      assert(validate_move(@start, finish, @board, 1, []))
    end

    def test_false_for_missing_piece
      start = alg_to_cartesian(["b", 2])
      finish = alg_to_cartesian(["b", 3])
      refute(validate_move(start, finish, @board, 1, []))
    end

    def test_false_for_wrong_piece_color
      finish = alg_to_cartesian(["a", 4])
      refute(validate_move(@start, finish, @board, -1, []))
    end

    # piece validation doesn't fail yet, not implemented for queen
    def test_false_when_piece_validation_fails
      finish = alg_to_cartesian(["b", 5])
      refute(validate_move(@start, finish, @board, 1, []))
    end

    def test_false_when_out_of_bounds
      finish = alg_to_cartesian(["a", -1])
      refute(validate_move(@start, finish, @board, 1, []))
    end

    def test_false_when_path_blocked
      @board.place_pieces({["a", 4] => 1})
      finish = alg_to_cartesian(["a", 5])
      refute(validate_move(@start, finish, @board, 1, []))
    end

    def test_false_when_own_piece_is_on_finish
      @board.place_pieces({["a", 4] => 1})
      finish = alg_to_cartesian(["a", 4])
      refute(validate_move(@start, finish, @board, 1, []))
    end

    def test_true_for_valid_capture
      @board.place_pieces({["a", 4] => -1})
      finish = alg_to_cartesian(["a", 4])
      assert(validate_move(@start, finish, @board, 1, []))
    end

    def test_false_when_ends_in_check
      # TODO
    end

    def test_false_when_castling_from_check
      # TODO
    end

    def test_false_when_castling_through_check
      # TODO
    end

    def test_false_when_history_validation_fails
      # TODO
    end

  end

  class TestWhitePawnMoveValidation < TestMoveValidations

    def setup
      @white_board = empty_board
      white_pawns = {["a", 2] => 1, ["b", 2] => 1, ["c", 3] => 1, ["e", 5] => 1}
      black_pawn = {["d", 5] => -1}
      black_knight = {["b", 3] => -2}
      @white_board.place_pieces(white_pawns.merge(black_pawn).merge(black_knight))
      @black_board = Board.new(@white_board.reverse.map { |row| row.reverse.map { |val| val ? -1 * val : nil } })
      @black_board[0].flatten!
    end

    def test_single_move_forward
      start = alg_to_cartesian(["a", 2])
      finish = alg_to_cartesian(["a", 3])
      assert(validate_pawn_move(start, finish, @white_board))
      assert(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_cannot_move_backward
      start = alg_to_cartesian(["a", 2])
      finish = alg_to_cartesian(["a", 1])
      refute(validate_pawn_move(start, finish, @white_board))
      refute(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_cannot_move_sideways
      start = alg_to_cartesian(["b", 2])
      finish = alg_to_cartesian(["c", 2])
      refute(validate_pawn_move(start, finish, @white_board))
      refute(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_cannot_capture_forward
      start = alg_to_cartesian(["b", 2])
      finish = alg_to_cartesian(["b", 3])
      refute(validate_pawn_move(start, finish, @white_board))
      refute(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_double_move_forward
      start = alg_to_cartesian(["a", 2])
      finish = alg_to_cartesian(["a", 4])
      assert(validate_pawn_move(start, finish, @white_board))
      assert(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_diagonal_capture
      start = alg_to_cartesian(["a", 2])
      finish = alg_to_cartesian(["b", 3])
      assert(validate_pawn_move(start, finish, @white_board))
      assert(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_cannot_move_diagonally_without_capture
      start = alg_to_cartesian(["c", 3])
      finish = alg_to_cartesian(["d", 4])
      refute(validate_pawn_move(start, finish, @white_board))
      refute(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_en_passant
      start = alg_to_cartesian(["e", 5])
      finish = alg_to_cartesian(["d", 6])
      assert(validate_pawn_move(start, finish, @white_board))
      assert(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_en_passant_only_captures_pawns
      start = alg_to_cartesian(["c", 3])
      finish = alg_to_cartesian(["b", 4])
      refute(validate_pawn_move(start, finish, @white_board))
      refute(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

  end

  class TestKnightMoveValidation < TestMoveValidations

    def test_valid_knight_moves
      start = alg_to_cartesian(["d", 3])
      finish = alg_to_cartesian(["e", 5])
      assert(validate_knight_move(start, finish))
      assert(validate_knight_move(finish, start))
    end

    def test_invalid_knight_move_1_1
      start = alg_to_cartesian(["d", 3])
      finish = alg_to_cartesian(["e", 4])
      refute(validate_knight_move(start, finish))
      refute(validate_knight_move(finish, start))
    end

    def test_invalid_knight_move_2_2
      start = alg_to_cartesian(["d", 3])
      finish = alg_to_cartesian(["f", 5])
      refute(validate_knight_move(start, finish))
      refute(validate_knight_move(finish, start))
    end

  end

  class TestBishopMoveValidation < TestMoveValidations

    def setup
      super
    end

    def test_pos_diagonal
    end

    def test_neg_diagonal
    end

  end

  class TestRookMoveValidation < TestMoveValidations

    def setup
      super
    end

    def test_horizontal
    end

    def test_vertical
    end

  end

  class TestQueenMoveValidation < TestMoveValidations

    def setup
      super
    end

    def test_horizontal
    end

    def test_vertical
    end

    def test_pos_diagonal
    end

    def test_neg_diagonal
    end

  end

  class TestKingMoveValidation < TestMoveValidations

    def setup
      super
    end

    def test_castling
    end

    def test_diagonal
    end

    def test_horizontal
    end

    def test_vertical
    end
  end

end

class TestUIMethods < Minitest::Test
  
  def setup
    @input = StringIO.new("i0\nc0\na1")
    @output = StringIO.new
  end

  def test_display_board
    board = populate_board(empty_board)
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

  def test_get_alg_coordinates
    coords = get_coordinates({:input => @input, :output => @output})
    assert_equal(["a", 1], coords)
  end

end
