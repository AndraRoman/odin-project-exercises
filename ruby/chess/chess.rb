require './move_validations'
require './board'

# COORDINATES

# for testing convenience
def flip_coords(coords)
  coords.map { |i| 11 - i }
end

def alg_to_cartesian(coords)
  letters = ("a"..."i").to_a
  [letters.index(coords[0]) + 2, coords[1] + 1]
end

def delta(start, finish)
  [finish[0] - start[0], finish[1] - start[1]]
end

def path(start, finish)
  list = []
  difference = delta(start, finish)
  if difference[0].abs == difference[1].abs || difference.include?(0)
    unit = difference.map { |i| i <=> 0 }
    current = start
    while current != finish
      list.push(current) unless current == start
      current = [current[0] + unit[0], current[1] + unit[1]]
    end
  end
  list
end

# TODO castling
# TODO TEST FOR CAPTURING incl en passant
# TODO test
def move(start, finish, board, graveyard, history)
  piece = board.get_by_coords(start)
  move_valid = MoveValidations::validate_move(start, finish, board, piece / piece.abs, history)
  return false unless move_valid
  board.set_by_coords(finish, piece)
  board.set_by_coords(start, nil)
  if move_valid.class == Array
    captured_piece = board.get_by_coords(move_valid)
    graveyard.push(captured_piece)
    board.set_by_coords(move_valid)
  end
end

# UI STUFF MAINLY

class String
  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end

def num_to_piece(n)
  case(n)
  when 6 then "\u2654"
  when 5 then "\u2655"
  when 4 then "\u2656"
  when 3 then "\u2657"
  when 2 then "\u2658"
  when 1 then "\u2659"
  when -6 then "\u265a"
  when -5 then "\u265b"
  when -4 then "\u265c"
  when -3 then "\u265d"
  when -2 then "\u265e"
  when -1 then "\u265f"
  else(" ")
  end
end

# interactive stuff
def get_coordinates(io = {:input => $stdin, :output => $stdout})
  coords = []
  letters = ("a"..."i").to_a
  io[:output].puts "Enter the coordinates of the square where you would like to play, using algebraic notation (eg 'b5')."
  loop do
    c = io[:input].gets.chomp
    if c.length == 2 && letters.include?(c[0]) && (1...9).include?(c[1].to_i)
      coords = [c[0], c[1].to_i]
      break
    else
      io[:output].puts "Input #{c} is not a valid square. Please try again."
    end
  end
  coords
end

if __FILE__ == $0
end
