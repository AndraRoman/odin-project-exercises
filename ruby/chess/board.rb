class Board < Array

# 2-square border for easy bounds checking
  def self.empty_board
    board = Board.new(Array.new(8) { [nil] * 8 })
    board
  end

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

  def copy
    result = Board.new
    self.each { |i| result.push(i.clone) }
    result
  end

  # pawn => 1, knight => 2, bishop => 3, rook => 4, queen => 5, king => 6
  def populate
    # white
    self[0] = [4, 2, 3, 5, 6, 3, 2, 4]
    self[1] = [1] * 8
    # black
    self[6] = self[1].map { |i| i * -1 }
    self[7] = self[0].map { |i| i * -1 }
    self
  end

  def display(output = $stdout)
    output.print("     " + "\u23bd" * 24)
    self.reverse.each_with_index do |row, i|
      output.print("\n #{8 - i}  \u23b9")
      row.each_with_index do |sq, j|
        piece = " " + num_to_piece(sq) + " "
        piece = piece.reverse_color if i % 2 == j % 2
        output.print(piece)
      end
      output.print("\u23b8")
    end
    output.print("\n     " + "\u23ba" * 24 + "\n")
    letters = ""
    ("a"..."i").each do |i|
      letters += " #{i} "
    end
    output.print("     #{letters}\n" )
  end

end

# COORDINATES

# rotates 180 degrees
def flip_coords(coords)
  coords.map { |i| 7 - i }
end

def alg_to_cartesian(coords)
  letters = ("a"..."i").to_a
  [letters.index(coords[0]), coords[1] - 1]
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

class String
  def reverse_color
    "\e[7m#{self}\e[27m"
  end
end

def num_to_piece(n)
  char = "\u2654".ord
  if (1...7).include? n 
    char += (6 - n)
    char.chr("UTF-8")
  elsif (-6...0).include? n
    char += (12 + n)
    char.chr("UTF-8")
  else
    " "
  end
end

def get_sign(square, board)
  piece = board.get_by_coords(square)
  piece && piece != 0 ? piece / piece.abs : 0
end

def in_bounds(coords)
  coords.all? { |i| (0...8).include? i }
end
