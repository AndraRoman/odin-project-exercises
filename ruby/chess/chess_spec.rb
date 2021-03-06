gem 'minitest'
require 'minitest/autorun'
require 'minitest/reporters'
require './chess'
Minitest::Reporters.use!

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
    @board = Board.empty_board
  end

  def test_empty_board
    assert_equal(8, @board.length) 
    @board.each do |row|
      assert_equal([nil] * 8, row)
    end
  end

  def test_copy_board
    copied = @board.copy
    assert_subarrays_equivalent(copied, @board)
    @board.place_pieces({["a", 2] => 1})
    refute_subarrays_equivalent(copied, @board)
  end

  def test_populated_board
    @board = @board.populate
    assert_equal([-1] * 8, @board[6])
    assert_equal([-4, -2, -3, -5, -6, -3, -2, -4], @board[7])
  end

  def test_set_by_alg_coords
    @board.set_by_alg_coords(["c", 4], 5)
    assert_equal(5, @board[3][2])
  end

  def test_flip_coords
    assert_equal([7, 2], flip_coords([0, 5]))
  end

  def test_alg_to_cartesian
    assert_equal([2, 3], alg_to_cartesian(["c", 4]))
  end

  def test_get_sign
    @board.place_pieces({["d", 6] => -3})
    assert_equal(-1, get_sign(alg_to_cartesian(["d", 6]), @board))
  end

  def test_delta_gives_difference_between_coordinates
    assert_equal([3, -5], delta([1, 7], [4, 2]))
  end

  def test_place_pieces
    @board.place_pieces({["d", 2] => -1, ["a", 8] => 3})
    assert_equal(-1, @board[1][3])
    assert_equal(3, @board[7][0])
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
    start = [0, 0]
    finish = [0, 7]
    assert(@board.path_open?(path(start, finish)))
    assert(@board.path_open?(path(finish, start)))
  end

  def test_path_open_false_on_blocked_path
    start = [0, 0]
    finish = [0, 7]
    @board.place_pieces(["a", 5] => 1)
    refute(@board.path_open?(path(start, finish)))
    refute(@board.path_open?(path(finish, start)))
  end

end

class TestMoveValidations < Minitest::Test
    
  include MoveValidations

  def setup
    @board = Board.empty_board
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
      assert_raises(BasicValidationFailed) { validate_move(start, finish, @board, 1, []) }
    end

    def test_false_for_wrong_piece_color
      finish = alg_to_cartesian(["a", 4])
      assert_raises(BasicValidationFailed) { validate_move(@start, finish, @board, -1, []) }
    end

    def test_false_when_piece_validation_fails
      finish = alg_to_cartesian(["b", 5])
      assert_raises(PieceValidationFailed) { validate_move(@start, finish, @board, 1, []) }
    end

    def test_false_when_out_of_bounds
      finish = alg_to_cartesian(["a", -1])
      assert_raises(BasicValidationFailed) { validate_move(@start, finish, @board, 1, []) }
    end

    def test_false_when_path_blocked
      @board.place_pieces({["a", 4] => 1})
      finish = alg_to_cartesian(["a", 5])
      assert_raises(BasicValidationFailed) { validate_move(@start, finish, @board, 1, []) }
    end

    def test_false_when_own_piece_is_on_finish
      @board.place_pieces({["a", 4] => 1})
      finish = alg_to_cartesian(["a", 4])
      assert_raises(BasicValidationFailed) { validate_move(@start, finish, @board, 1, []) }
    end

    def test_returns_captured_piece_coords_for_valid_capture
      @board.place_pieces({["a", 4] => -1})
      finish = alg_to_cartesian(["a", 4])
      assert_equal(finish, validate_move(@start, finish, @board, 1, []))
    end

    def test_false_for_null_move
      assert_raises(BasicValidationFailed) { validate_move(@start, @start, @board, 1, []) }
    end

    def test_false_when_ends_in_check
      @board.place_pieces({["b", 7] => -6})
      start = alg_to_cartesian(["b", 7])
      finish = alg_to_cartesian(["a", 7])
      assert_raises(PlayerLeftInCheck) { validate_move(start, finish, @board, -1, []) }
    end

    # TODO use a flag
    def test_false_when_history_prevents_en_passant
      # TODO
    end

    # TODO use a flag
    def test_cannot_castle_if_king_has_moved
      # TODO
    end

    # TODO use a flag
    def test_cannot_castle_if_rook_has_moved
      # TODO
    end

    class TestThreatDetection < TestOverallMoveValidation
    
      def setup
        super # white queen on a2
      end

      def test_threatened_true_when_opponent_can_reach_square
        assert(threatened?(alg_to_cartesian(["g", 8]), -1, @board, []))
      end

      def test_threatened_false_when_opponent_cannot_reach_square
        @board.place_pieces({["c", 4] => 2})
        refute(threatened?(alg_to_cartesian(["g", 8]), -1, @board, []))
      end

      def test_check_true_when_king_is_threatened
        @board.place_pieces({["a", 8] => -6})
        assert(check?(-1, @board))
      end

      def test_check_false_when_king_is_not_threatened
        @board.place_pieces({["a", 7] => -1})
        refute(check?(-1, @board))
      end

      def test_king_can_threaten
        @board.place_pieces({["c", 8] => -6})
        assert(threatened?(alg_to_cartesian(["d", 8]), 1, @board, []))
      end

    end

  end

  class TestWhitePawnMoveValidation < TestMoveValidations

    def setup
      @white_board = Board.empty_board
      white_pawns = {["a", 2] => 1, ["b", 2] => 1, ["c", 3] => 1, ["e", 5] => 1}
      black_pawn = {["d", 5] => -1}
      black_knight = {["b", 3] => -2}
      @white_board.place_pieces(white_pawns.merge(black_pawn).merge(black_knight))
      @black_board = Board.new(@white_board.reverse.map { |row| row.reverse.map { |val| val ? -1 * val : nil } })
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

    def test_cannot_move_two_squares_except_from_starting_rank
      start = alg_to_cartesian(["c", 3])
      finish = alg_to_cartesian(["c", 5])
      refute(validate_pawn_move(start, finish, @white_board))
      refute(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
    end

    def test_diagonal_capture
      start = alg_to_cartesian(["a", 2])
      finish = alg_to_cartesian(["b", 3])
      assert_equal(finish, validate_pawn_move(start, finish, @white_board))
      assert_equal(flip_coords(finish), validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
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
      assert_equal([finish[0], finish[1] - 1], validate_pawn_move(start, finish, @white_board))
      assert_equal(flip_coords([finish[0], finish[1] - 1]), validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
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
      @board.place_pieces({["c", 4] => 3})
      @start = alg_to_cartesian(["c", 4]) 
    end

    def test_can_move_on_pos_diagonal
      finish = alg_to_cartesian(["f", 7])
      assert(validate_bishop_move(@start, finish))
    end

    def test_can_move_on_neg_diagonal
      finish = alg_to_cartesian(["f", 1])
      assert(validate_bishop_move(@start, finish))
    end

    def test_cannot_move_horizontally
      finish = alg_to_cartesian(["h", 4])
      refute(validate_bishop_move(@start, finish))
    end

    def test_cannot_move_vertically
      finish = alg_to_cartesian(["c", 8])
      refute(validate_bishop_move(@start, finish))
    end

  end

  class TestRookMoveValidation < TestMoveValidations

    def setup
      super
      @board.place_pieces({["c", 4] => 4})
      @start = alg_to_cartesian(["c", 4]) 
    end

    def test_can_move_horizontally
      finish = alg_to_cartesian(["h", 4])
      assert(validate_rook_move(@start, finish))
    end

    def test_can_move_vertically
      finish = alg_to_cartesian(["c", 8])
      assert(validate_rook_move(@start, finish))
    end

    def test_cannot_move_diagonally
      finish = alg_to_cartesian(["f", 7])
      refute(validate_rook_move(@start, finish))
    end

  end

  class TestQueenMoveValidation < TestMoveValidations

    def setup
      super
      @board.place_pieces({["c", 4] => 5})
      @start = alg_to_cartesian(["c", 4]) 
    end

    def test_can_move_on_pos_diagonal
      finish = alg_to_cartesian(["f", 7])
      assert(validate_queen_move(@start, finish))
    end

    def test_can_move_on_neg_diagonal
      finish = alg_to_cartesian(["f", 1])
      assert(validate_queen_move(@start, finish))
    end

    def test_can_move_horizontally
      finish = alg_to_cartesian(["h", 4])
      assert(validate_queen_move(@start, finish))
    end

    def test_can_move_vertically
      finish = alg_to_cartesian(["c", 8])
      assert(validate_queen_move(@start, finish))
    end

    def test_cannot_move_as_knight
      finish = alg_to_cartesian(["d", 6])
      refute(validate_queen_move(@start, finish))
    end

  end

  class TestKingMoveValidation < TestMoveValidations

    def setup
      super
      @board.place_pieces({["e", 1] => 6})
      @board.place_pieces({["d", 8] => -6})
      @start = alg_to_cartesian(["e", 1]) 
    end

    def test_direct_king_move_validation_positive
      finish = alg_to_cartesian(["d", 2])
      assert(validate_direct_king_move(@start, finish, @board))
    end

    def test_direct_king_move_validation_negative
      finish = alg_to_cartesian(["g", 1])
      refute(validate_direct_king_move(@start, finish, @board))
    end

    def test_white_can_castle_kingside
      finish = alg_to_cartesian(["g", 1])
      assert(validate_king_move(@start, finish, @board))
    end

    def test_black_can_castle_kingside
      start = alg_to_cartesian(["d", 8])
      finish = alg_to_cartesian(["b", 8])
      assert(validate_king_move(start, finish, @board))
    end

    def test_white_can_castle_queenside
      finish = alg_to_cartesian(["c", 1])
      assert(validate_king_move(@start, finish, @board))
    end

    def test_black_can_castle_queenside
      start = alg_to_cartesian(["d", 8])
      finish = alg_to_cartesian(["f", 8])
      assert(validate_king_move(start, finish, @board))
    end

    def test_cannot_castle_kingside_when_path_to_rook_is_blocked
      @board.place_pieces({["f", 1] => 2})
      finish = alg_to_cartesian(["g", 1])
      refute(validate_king_move(@start, finish, @board))
    end

    def test_cannot_castle_queenside_when_path_to_rook_is_blocked
      @board.place_pieces({["b", 1] => 2})
      finish = alg_to_cartesian(["c", 1])
      refute(validate_king_move(@start, finish, @board))
    end

    def test_cannot_castle_through_check
      @board.place_pieces({["d", 8] => -4})
      finish = alg_to_cartesian(["c", 1])
      refute(validate_king_move(@start, finish, @board))
    end

    def test_cannot_castle_out_of_check
      @board.place_pieces({["e", 8] => -4})
      finish = alg_to_cartesian(["c", 1])
      refute(validate_king_move(@start, finish, @board))
    end

    def test_can_move_diagonally
      finish = alg_to_cartesian(["d", 2])
      assert(validate_king_move(@start, finish, @board))
    end

    def test_can_move_horizontally
      finish = alg_to_cartesian(["d", 1])
      assert(validate_king_move(@start, finish, @board))
    end

    def test_can_move_vertically
      finish = alg_to_cartesian(["e", 2])
      assert(validate_king_move(@start, finish, @board))
    end

    def test_cannot_move_more_than_one_space_diagonally
      finish = alg_to_cartesian(["c", 3])
      refute(validate_king_move(@start, finish, @board))
    end

    def test_cannot_move_more_than_one_space_horizontally_except_to_castle
      finish = alg_to_cartesian(["b", 1])
      refute(validate_king_move(@start, finish, @board))
    end

    def test_cannot_move_more_than_one_space_vertically
      finish = alg_to_cartesian(["e", 3])
      refute(validate_king_move(@start, finish, @board))
    end

  end

end

class TestUIMethods < Minitest::Test
  
  def setup
    @input = StringIO.new("0x\na4") # invalid followed by valid
    @output = StringIO.new
  end

  def test_get_coordinates
    coords = get_coordinates("Test message", {:input => @input, :output => @output})
    assert_equal("Test message\nInput '0x' is not a valid square. Try again and make sure to use algebraic notation (eg 'b5').\n", @output.string)
    assert_equal([0, 3], coords)
  end

  def test_display_board
    board = Board.empty_board.populate
    board.display(@output)
    expected = "     ⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽⎽
 8  ⎹\e[7m ♜ \e[27m ♞ \e[7m ♝ \e[27m ♛ \e[7m ♚ \e[27m ♝ \e[7m ♞ \e[27m ♜ ⎸
 7  ⎹ ♟ \e[7m ♟ \e[27m ♟ \e[7m ♟ \e[27m ♟ \e[7m ♟ \e[27m ♟ \e[7m ♟ \e[27m⎸
 6  ⎹\e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   ⎸
 5  ⎹   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m⎸
 4  ⎹\e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   ⎸
 3  ⎹   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m   \e[7m   \e[27m⎸
 2  ⎹\e[7m ♙ \e[27m ♙ \e[7m ♙ \e[27m ♙ \e[7m ♙ \e[27m ♙ \e[7m ♙ \e[27m ♙ ⎸
 1  ⎹ ♖ \e[7m ♘ \e[27m ♗ \e[7m ♕ \e[27m ♔ \e[7m ♗ \e[27m ♘ \e[7m ♖ \e[27m⎸
     ⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺
      a  b  c  d  e  f  g  h 
"
    assert_equal(expected, @output.string)
  end

end

class TestMiscHelpers < Minitest::Test

  def test_num_to_piece
    assert_equal("\u2655", num_to_piece(5))
    assert_equal("\u265b", num_to_piece(-5))
  end

end

