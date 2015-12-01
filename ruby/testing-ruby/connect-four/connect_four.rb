class InvalidMove < Exception; end

class Board

  attr_accessor :columns

  def initialize(output_stream = $stdout)
    @columns = Array.new(7) { [] }
    @output_stream = output_stream
  end

  def play(column, color)
    if !(0...7).include?(column)
      raise InvalidMove.new("Column #{column} does not exist.")
    elsif columns[column].length >= 6
      raise InvalidMove.new("Column #{column} is already full.")
    else
      columns[column].push(color)
    end
  end

  def display
    all_rows.reverse.each do |i|
      @output_stream.puts("#{i.map { |j| (j ? j.to_s[0] : "").ljust(3) }}")
    end
  end

  def all_rows
    rows = Array.new(6) { [] }
    rows.each_with_index do |row, index|
      columns.each do |column|
        row.push(column[index])
      end
    end
    rows
  end

  def all_diagonals
    positions = []
    (-2...4).each do |x|
      diag_positions = [] # left to right, bottom to top
      (0...6).each do |y|
        if (0...7).include?(x + y)
          diag_positions.push([x + y, y])
        else
          diag_positions.push(nil)
        end
      end
      positions.push(diag_positions)
    end

    diagonals = []
    positions.each do |diag_positions|
      left_right = []
      right_left = []
      diag_positions.each do |pos|
        if pos.nil?
          left_right.push(nil)
          right_left.push(nil)
        else
          x, y = pos
          left_right.push(columns[x][y] || nil)
          right_left.push(columns[6 - x][y] || nil)
        end
      end
      diagonals.push(left_right)
      diagonals.push(right_left)
    end

    diagonals
  end

  def array_has_connect_four(array)
    last_player = nil
    count = 0
    array.each do |i|
      if i.nil?
        count = nil
      elsif i == last_player
        count += 1
        return i if count > 3
      else
        count = 1
      end
      last_player = i
    end
    false
  end

  def game_over?
    result = (columns + all_diagonals + all_rows).inject(false) { |r, col| r || array_has_connect_four(col) }
    if columns.all? { |c| c.length >= 6 }
      result = :nobody
    end
    result
  end

end

class Player

  attr_reader :color

  def initialize(color, streams = {})
    @color = color
    @input_stream = streams[:input] || $stdin
    @output_stream = streams[:output] || $stdout
  end

  def play(board)
    @output_stream.puts "Player #{color}, which column will you play in?"
    begin
      input = @input_stream.gets
      column = input.chomp.to_i
      board.play(column, color)
    rescue InvalidMove
      @output_stream.puts "You can't play there! Try again."
      retry
    end
  end

end

def game(board, p1, p2, output_stream = $stdout)
  while !board.game_over?
    [p1, p2].each do |player|
      player.play(board)
      board.display
      if board.game_over?
        break
      end
    end
  end
  output_stream.puts "Game over! Winner is #{board.game_over?}."
end

if __FILE__ == $0
  board = Board.new
  p1 = Player.new(:red)
  p2 = Player.new(:yellow)

  game(board, p1, p2)
end
