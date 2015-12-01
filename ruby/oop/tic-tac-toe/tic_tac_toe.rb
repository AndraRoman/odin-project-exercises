class InvalidBoardSize < Exception; end
class InvalidBoardContents < Exception; end
class InvalidSymbol < Exception; end
class InvalidMove < Exception; end
class InvalidInput < Exception; end

class Board

  attr_reader :board, :size

  def initialize(n, params = {})
    unless n.is_a?(Integer) && n.odd? && n > 0
      raise InvalidBoardSize
    end
    params[:vals] ||= Array.new(n, nil)
    raise InvalidBoardContents unless params[:vals].length == n
    @size = n
    @board = []
    @output_stream = params[:output] || $stdout
    (0...n).each {|i| @board.push(Row.new(n, {:vals => params[:vals][i], :output => @output_stream})) }
  end

  def display
    @board.each_with_index do |row, index|
      row.display
      if index < @size - 1
        @output_stream.puts "-" * (4 * @size - 1)
      end
    end
  end

  # returns an array of fake rows
  def columns
    cols = []
    (0...size).each do |i|
      vals = []
      (0...size).each do |j|
        vals.push(get_square({:column => i, :row => j}))
      end
      cols.push(Row.new(size, {:vals => vals}))
    end
    cols
  end

  # returns an array of fake rows
  def diagonals
    vals = [[], []]
    (0...size).each do |i|
      vals[0].push(get_square({:column => i, :row => i}))
      vals[1].push(get_square({:column => i, :row => size - i - 1}))
    end
    vals.map {|v| Row.new(size, {:vals => v}) }
  end

  def values
    vals = []
    @board.each do |i|
      vals.push(i.row_values)
    end
    vals
  end

  def copy
    Board.new(size, {:vals => values})
  end

  def game_over?
    row_results = (@board + columns + diagonals).map {|row| row.row_over?}
    if row_results.all? {|r| r == :draw}
      return :draw
    else row_results.each do |r|
        unless [:draw, false].include? r
          return r
        end
      end
    end
    return false
  end

  def find_all_possible_moves
    moves = []
    (0...size).each do |j|
      (0...size).each do |i|
        coords = {:column => i, :row => j}
        if empty_square?(coords)
          moves.push(coords)
        end
      end
    end
    moves
  end

  def set_square(coords, symbol)
    @board[coords[:row]].set_square(coords[:column], symbol)
  end

  def get_square(coords)
    @board[coords[:row]].get_square(coords[:column])
  end

  def empty_square?(coords)
    get_square(coords) == :' '
  end

  def check_game_over
    result = game_over?
    case result
    when :draw then
      @output_stream.puts "GAME OVER. WINNER: NONE."
      return true
    when false then return false
    else
      @output_stream.puts "GAME OVER. WINNER: #{result}."
      return true
    end
  end

end

class Row

  attr_reader :row

  # skip validation of n since Board handles it
  def initialize(n, params = {})
    @row = Array.new(n) { Square.new }
    @row.each do |i|
    @output_stream = params[:output] || $stdout
    end
    @size = n
    vals = params[:vals]
    if vals && vals.length > 0 # empty array is accepted
      raise InvalidBoardContents unless vals.length == n # uncaught
      vals.each_with_index do |symbol, index|
        set_square(index, symbol)
      end
    end
  end

  def display
    result = " "
    @row.each_with_index do |square, index|
      result += "#{square.symbol}"
      if index < @row.length - 1
        result += " | "
      end
    end
    @output_stream.puts result
  end

  def row_values
    @row.map {|s| s.symbol}
  end

  def set_square(column, symbol)
    @row[column].update(symbol)
  end

  def get_square(column)
    @row[column].symbol
  end

  def row_over?
    vals = row_values
    if vals[0] != :' ' && vals.all? {|s| s == vals[0]}
      return vals[0]
    elsif vals.none? {|s| s == :' '}
      return :draw
    else
      return false
    end
  end

end


class Square

  attr_reader :symbol

  def initialize()
    @symbol = :' '
  end

  def update(symbol)
    if Square.valid?(symbol)
      @symbol = symbol
    else
      raise InvalidSymbol.new(symbol)
    end
  end

  def Square.valid?(symbol)
    [:X, :O, :' '].include? symbol
  end

end

class Player

  attr_reader :symbol, :mode

  def initialize(mode, symbol)
    @mode = mode
    @symbol = symbol
  end

  # doesn't validate that (column, row) is on the board - turn() handles that
  def play(coords, board)
    if board.empty_square?(coords)
      board.set_square(coords, @symbol)
    else
      raise InvalidMove
    end
  end

  def choose_best_move(board)
    tree = build_tree(board)
    move_table = {}
    tree.children.each {|child| move_table[child.value] = child.move} # key collision doesn't matter because we don't care which of the top-ranking moves we make
    best_val = move_table.keys.sort[-1]
    move = move_table[best_val]
  end

  def build_tree(board)
    tree = GameTree.new(board.copy, @symbol)
    tree.grow_tree(@symbol)
    tree.evaluate(@symbol)
    tree
  end

end

class GameTree

  attr_reader :move, :board, :symbol, :children
  attr_accessor :value

  def initialize(board, symbol, move=nil)
    @move = move # previous move (how we got here) - can be nil
    @board = board
    @symbol = symbol # who will move next
    @value = nil # calculated later from bottom up
    @children = []
  end

  def add_child(move)
    board = @board.copy
    board.set_square(move, @symbol)
    symbol = opposite(@symbol)
    child = GameTree.new(board, symbol, move)
    @children.push(child)
    child
  end

  def grow_tree(symbol)
    moves = @board.find_all_possible_moves
    moves.each do |move|
      child = add_child(move)
      val = child.evaluate_leaf(symbol)
      if val
        child.value = val
      else
        child.grow_tree(symbol)
      end
    end
  end

  def evaluate_leaf(symbol) # @symbol is who is playing next; symbol comes from caller and is the perspective from which we are evaluating the leaf
    case @board.game_over?
    when symbol
      1
    when opposite(symbol)
      -1
    when :draw
      0
    when false
      nil
    else
      raise InvalidSymbol.new(symbol)
    end
  end

  def evaluate(symbol)
    if @value # do nothing
    elsif @symbol == symbol
      @value = @children.map {|n| n.evaluate(symbol)}.max
    else
      @value = @children.map {|n| n.evaluate(symbol) }.min
    end
    @value
  end

end

def create_board(io = {:input => $stdin, :output => $stdout})
  begin
    io[:output].puts "Welcome! First, choose the board size."
    n = io[:input].gets.chomp.to_i
    return Board.new(n, {:output => io[:output]})
  rescue InvalidBoardSize
    io[:output].puts "Sorry, board size must be a positive odd integer. Let's try this again."
    retry
  end
end

def opposite(symbol)
  symbol == :X ? :O : :X
end

def create_player(n, io = {:input => $stdin, :output => $stdout})
  symbol = n == 1 ? :X : :O
  mode = nil
  io[:output].puts "Enter 'a' for auto mode or 'm' for manual play for player #{symbol}."
  begin
    input = io[:input].gets.chomp
    case input.downcase
    when 'a'
      mode = :auto
    when 'm'
      mode = :manual
    else raise InvalidInput.new(input)
    end
  rescue InvalidInput => e
    io[:output].puts "Input #{e} is not valid. Please enter either 'a' or 'm'."
    retry
  end
  Player.new(mode, symbol)
end

def get_coordinates(symbol, size, io = {:input => $stdin, :output => $stdout})
  coords = { :column => nil, :row => nil }
  coords.each do |name, value|
    io[:output].puts "#{symbol}: Enter the #{name} of the square where you would like to play."
    begin
      c = io[:input].gets.chomp
      if (0...size).to_a.map {|i| i.to_s }.include? c
        coords[name] = c.to_i
      else raise InvalidInput.new(c)
      end
    rescue InvalidInput
      io[:output].puts "Please enter an integer from 0 to #{size - 1}."
      retry
    end
  end
  coords
end

def turn(board, player, io = {:input => $stdin, :output => $stdout})
  begin
    coords = (player.mode == :manual ? get_coordinates(player.symbol, board.size, io) : player.choose_best_move(board))
    player.play(coords, board)
    io[:output].puts "\n#{player.symbol} has played on (#{coords[:column]}, #{coords[:row]})."
    board.display
  rescue InvalidMove
    io[:output].puts "The square (#{coords["column"]}, #{coords["row"]}) is already occupied. Let's try this again."
    retry
  end
end

def game(io = {:input => $stdin, :output => $stdout})
  board = create_board(io)
  players = [create_player(1, io), create_player(2, io)]
  board.display
  loop do
    turn(board, players[0], io)
    break if board.check_game_over
    turn(board, players[1], io)
    break if board.check_game_over
  end
end

if __FILE__ == $0
  game
end
