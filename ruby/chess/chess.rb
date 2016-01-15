require './move_validations'
require './board'

include MoveValidations # does this help?

# passes on exception for invalid move
def move(start, finish, player_sign, board, graveyard, history)
  piece = board.get_by_coords(start)
  move_valid = MoveValidations::validate_move(start, finish, board, player_sign, history)
  board.set_by_coords(finish, piece)
  board.set_by_coords(start, nil)
  if move_valid.class == Array # ie if move makes a capture
    captured_piece = board.get_by_coords(move_valid)
    graveyard.push(captured_piece)
    board.set_by_coords(move_valid, piece)
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

def play(player_sign, board)
  color = (player_sign == 1) ? "White" : "Black"
  begin
    start = get_coordinates("#{color}, enter the coordinates of the piece you would like to move.")
    finish = get_coordinates("Enter the coordinates of the square you would like to move to.")
    move(start, finish, player_sign, board, [], [])
  rescue InvalidMove => e
    puts "#{e}. Try again."
    retry
  end
end

def run
  board = Board.empty_board.populate
  board.display
  while true
    play(1, board)
    board.display
    play(-1, board)
    board.display
  end
end

if __FILE__ == $0
  run
end
