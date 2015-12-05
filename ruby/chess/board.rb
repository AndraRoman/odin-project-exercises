
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
    output.print("   " + "\u23bd" * 24)
    self[2...10].reverse.each_with_index do |row, i|
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

end
