# 2-square border for easy bounds checking
def set_up_board
  # empty board
  board = [Array.new(12, 0)] * 2 + Array.new(8) { [0, 0] + [nil] * 8 + [0, 0] } + [Array.new(12, 0)] * 2
  # white
  board[2][2...10] = [4, 2, 3, 5, 6, 3, 2, 4]
  board[3].each_with_index do |i, index|
    board[3][index] = 1 if i.nil?
  end
  # black
  board[8] = board[3].reverse.map { |i| i * -1 }
  board[9] = board[2].reverse.map { |i| i * -1 }
  board
end

def validate_pawn_move(start, finish, board)

end

def validate_knight_move(start, finish, board)

end

def validate_bishop_move(start, finish, board)

end

def validate_rook_move(start, finish, board)

end

def validate_queen_move(start, finish, board)

end

def validate_king_move(start, finish, board)

end

# UI methods

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

def display_board(board, output = $stdout)
  output.print("   " + "\u23bd" * 24)
  board[2...10].reverse.each_with_index do |row, i|
    output.print("\n  \u23b9")
    row[2...10].each_with_index do |sq, j|
      piece = " " + num_to_piece(sq) + " "
      piece = piece.reverse_color if i % 2 == j % 2
      output.print(piece)
    end
    output.print("\u23b8")
  end
  output.print("\n   " + "\u23ba" * 24 + "\n")
end

def get_coordinates(io = {:input => $stdin, :output => $stdout})
  coords = []
  letters = ("a"..."i").to_a
  io[:output].puts "Enter the coordinates of the square where you would like to play, using algebraic notation (eg 'b5')."
  loop do
    c = io[:input].gets.chomp
    if c.length == 2 && letters.include?(c[0]) && (1...9).include?(c[1].to_i)
      coords = [letters.index(c[0]), c[1].to_i - 1]
      break
    else
      io[:output].puts "Input #{c} is not a valid square. Please try again."
    end
  end
  coords
end

board = set_up_board
graveyard = []
display_board(board)
