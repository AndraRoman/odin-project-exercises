require './move_validations'
require './board'

include MoveValidations # does this help?

# TODO castling
# TODO TEST FOR CAPTURING incl en passant
# TODO test
# passes on exception with message for invalid move
def move(start, finish, board, graveyard, history)
  piece = board.get_by_coords(start)
  move_valid = MoveValidations::validate_move(start, finish, board, piece / piece.abs, history)
  board.set_by_coords(finish, piece)
  board.set_by_coords(start, nil)
  if move_valid.class == Array
    captured_piece = board.get_by_coords(move_valid)
    graveyard.push(captured_piece)
    board.set_by_coords(move_valid)
  end
end

# interactive stuff
def get_coordinates(message, io = {:input => $stdin, :output => $stdout})
  coords = []
  letters = ("a"..."i").to_a
  io[:output].puts message
  loop do
    c = io[:input].gets.chomp
    if c.length == 2 && letters.include?(c[0]) && (1...9).include?(c[1].to_i)
      coords = [c[0], c[1].to_i]
      break
    else
      io[:output].puts "Input '#{c}' is not a valid square. Try again and make sure to use algebraic notation (eg 'b5')."
    end
  end
  alg_to_cartesian(coords)
end

# TODO later pass on other needed info
# TODO test
# TODO print nicer error msg
def play(player, board)
  color = (player == 1) ? "White" : "Black"
  begin
    start_coords = get_coordinates("#{color}, enter the coordinates of the piece you would like to move.")
    end_coords = get_coordinates("Enter the coordinates of the square you would like to move to.")
    move(start_coords, end_coords, board, [], [])
  rescue InvalidMove => e
    puts "#{e}. Try again."
    retry
  end
end

# TODO test
def run
  board = Board.empty_board.populate
  board.display
  play(1, board)
  board.display
  play(-1, board)
  board.display
end

if __FILE__ == $0
  run
end
