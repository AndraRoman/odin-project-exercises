class Board < Array

# 2-square border for easy bounds checking
  def self.empty_board
    board = Board.new([Array.new(12, 0)] * 2 + Array.new(8) { [0, 0] + [nil] * 8 + [0, 0] } + [Array.new(12, 0)] * 2)
    board[0].flatten!
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
    result = []
    self.each { |i| result.push(i.clone) }
    result
  end

  # pawn => 1, knight => 2, bishop => 3, rook => 4, queen => 5, king => 6
  def populate
    # white
    self[2][2...10] = [4, 2, 3, 5, 6, 3, 2, 4]
    self[3].each_with_index do |i, index|
      self[3][index] = 1 if i.nil?
    end
    # black
    self[8] = self[3].reverse.map { |i| i * -1 }
    self[9] = self[2].reverse.map { |i| i * -1 }
    self
  end

  def display(output = $stdout)
    output.print("     " + "\u23bd" * 24)
    self[2...10].reverse.each_with_index do |row, i|
      output.print("\n #{8 - i}  \u23b9")
      row[2...10].each_with_index do |sq, j|
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

