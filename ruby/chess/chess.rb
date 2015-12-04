# 2-square border for easy bounds checking
def empty_board
  board = Board.new([Array.new(12, 0)] * 2 + Array.new(8) { [0, 0] + [nil] * 8 + [0, 0] } + [Array.new(12, 0)] * 2)
  board[0].flatten!
  board
end

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

class Board < Array

  def get_by_coords(coords)
    x, y = coords
    self[y][x]
  end

  def set_by_coords(coords, val)
    x, y = coords
    self[y][x] = val
  end

  def path_open?(path)
    path.none? { |coords| get_by_coords(coords) }
  end

# for test readability
  def set_by_alg_coords(coords, val)
    x, y = alg_to_cartesian(coords)
    self[y][x] = val
  end

  def place_pieces(pieces_hash)
    pieces_hash.each do |coords, piece|
      self.set_by_alg_coords(coords, piece)
    end
  end
end

# pawn => 1, knight => 2, bishop => 3, rook => 4, queen => 5, king => 6
def populate_board(board)
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

def move(start, finish, board, player_sign, history)
  # TODO
end

def validate_move(start, finish, board, player_sign, history)
  piece = board.get_by_coords(start)
  target_piece = board.get_by_coords(finish)
  return false unless (!piece.nil? && piece * player_sign > 0) # starting point has a piece of the correct color
  return false if target_piece == 0 # out of bounds

  path = path(start, finish)
  return false unless board.path_open?(path)

  return false if !target_piece.nil? && piece * target_piece > 0 # can't capture own piece

  piece_validation = case piece.abs
                     when 1 then validate_pawn_move(start, finish, board)
                     when 2 then validate_knight_move(start, finish)
                     when 3 then validate_bishop_move(start, finish)
                     when 4 then validate_rook_move(start, finish)
                     when 5 then validate_queen_move(start, finish)
                     when 6 then validate_king_move(start, finish, board)
                     end

  piece_validation && history_validation(start, finish, board, player_sign, history)
end

def history_validation(start, finish, board, player_sign, history)
  true
end

def validate_pawn_move(start, finish, board)
  difference = delta(start, finish)
  piece = board.get_by_coords(start)
  other_piece = board.get_by_coords(finish)
  if other_piece.nil?
    if difference == [0, piece]
      true
    elsif difference == [0, 2 * piece]
      [3, 8].include? start[1] # must be in rank 2 or 7 to move two squares
    else
      other_piece = board.get_by_coords([finish[0], finish[1] - piece])
      other_piece == -1 * piece && (difference[0]).abs == 1 && piece * other_piece < 0
    end
  elsif piece * other_piece > 0
    false
  else
    (difference[0]).abs == 1 && difference[1] == piece
  end
end

def validate_knight_move(start, finish)
  difference = delta(start, finish)
  (difference[0] * difference[1]).abs == 2
end

def validate_bishop_move(start, finish)
  difference = delta(start, finish)
  difference[0].abs == difference[1].abs
end

def validate_rook_move(start, finish)
  difference = delta(start, finish)
  difference.include?(0)
end

def validate_queen_move(start, finish)
  validate_rook_move(start, finish) || validate_bishop_move(start, finish)
end

# king/rook position validation is done in calling fn, using history
def validate_king_move(start, finish, board)
  difference = delta(start, finish)
  piece = board.get_by_coords(start)
  squares_passed_through = path(start, finish)
  squares_passed_through.each do |square|
    return false if threatened?(square, piece / piece.abs, board, [])
  end
  if validate_direct_king_move(start, finish, board)
    true
  else
    if check?(piece / piece.abs, board)
      false
    elsif difference == [2, 0]
      board.path_open?(path(start, [10, start[1]]))
    elsif difference == [-2, 0]
      board.path_open?(path(start, [2, start[1]]))
    else
      false
    end
  end
end

def validate_direct_king_move(start, finish, board)
  difference = delta(start, finish)
  difference.none? { |i| i.abs > 1 } && difference.any? { |i| i != 0 }
end

# history only needed for en passant
def threatened?(square, sign, board, history)
  board.each_with_index do |row, y|
    row.each_with_index do |piece, x|
      if !piece.nil? && piece * sign < 0
         if piece.abs == 6 # special case to prevent infinite loop between kings
           return true if validate_direct_king_move([x, y], square, board)
         else
           return true if validate_move([x, y], square, board, sign * -1, history)
         end
      end
    end
  end
  false
end

# passes empty history to threatened? since it won't affect the outcome
def check?(sign, board)
  square = [0, 0]
  board.each_with_index do |row, y|
    row.each_with_index do |piece, x|
      if piece == 6 * sign
        square = [x, y]
        break
      end
    end
  end
  threatened?(square, sign, board, [])
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
