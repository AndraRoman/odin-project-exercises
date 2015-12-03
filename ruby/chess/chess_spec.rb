require 'minitest/autorun'
require './chess'

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

  def test_place_pieces
    @board.place_pieces({["d", 2] => -1, ["a", 8] => 3})
    assert_equal(-1, @board[3][5])
    assert_equal(3, @board[9][2])
  end

end

class TestMoveValidations < Minitest::Test

  def setup
    @board = empty_board
  end

  class TestWhitePawnMoveValidation < TestMoveValidations

    def setup
      @white_board = empty_board
      white_pawns = {["a", 2] => 1, ["b", 2] => 1, ["c", 3] => 1, ["e", 5] => 1}
      black_pawn = {["d", 5] => -1}
      black_knight = {["b", 3] => -2}
      @white_board.place_pieces(white_pawns.merge(black_pawn).merge(black_knight))
      @black_board = @white_board.reverse.map { |row| row.reverse.map { |val| val ? -1 * val : nil } }
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

    def test_cannot_jump_over_a_piece
      start = alg_to_cartesian(["b", 2])
      finish = alg_to_cartesian(["b", 5])
      refute(validate_pawn_move(start, finish, @white_board))
      refute(validate_pawn_move(flip_coords(start), flip_coords(finish), @black_board))
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

    def setup
      super
    end

    def test_knight_move_validation
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
