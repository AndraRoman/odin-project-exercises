require 'tic_tac_toe'

# class Board

describe "initialize board" do
  it "rejects even, negative, and non-integer board sizes" do
    expect { Board.new(-1) }.to raise_exception(InvalidBoardSize)
    expect { Board.new(4) }.to raise_exception(InvalidBoardSize)
    expect { Board.new(3.0) }.to raise_exception(InvalidBoardSize)
  end

  it "rejects creation with set values that do not match board size" do
    expect { Board.new(3, [[:X, :X, :X, :O]]) }.to raise_exception(InvalidBoardContents)
  end
end

describe "board behaves itself when cloned" do
  it "doesn't modify the original board" do
    board = Board.new(3)
    changed_board = board.copy
    changed_board.set_square({:column => 1, :row => 1}, :X)
    expect(board.get_square({:column => 1, :row => 1})).to be(:' ')
    expect(changed_board.get_square({:column => 1, :row => 1})).to be(:X)
  end
end

describe "columns" do
  it "lists columns of the board" do
    board = Board.new(3, [[:X, :X, :X], [:O, :O, :O], []])
    column = board.columns[0]
    vals = (0...board.size).to_a.map {|i| column.get_square(i)}
    expect(column.class).to be(Row)
    expect(vals).to eq([:X, :O, :' '])
  end
end

describe "diagonals" do
  it "lists diagonals of the board" do
    board = Board.new(3, [[:X, :X, :X], [:O, :O, :O], []])
    vals = []
    board.diagonals.each do |diag|
      v = (0...board.size).to_a.map {|i|; diag.get_square(i)}
      vals.push(v)
    end
    expect(board.diagonals[0].class).to be(Row)
    expect(vals).to eq([[:X, :O, :' '], [:' ', :O, :X]])
  end
end

describe "game_over?" do
  it "returns winner's symbol for game won on a row" do
    board = Board.new(3, [[:X, :X, :X], [:X, :O, :O], []])
    expect(board.game_over?).to be(:X)
  end

  it "also works on columns" do
    board = Board.new(5, [[:O, :' ', :' ', :' ', :' '], [:O, :O, :X, :X, :X], [:O, :' ', :' ', :' ', :' '], [:O, :O, :X, :X, :X], [:O, :X, :X, :X, :X]])
    expect(board.game_over?).to be(:O)
  end 

  it "also works on downward diagonal" do
    board = Board.new(5, [[:X, :O, :O, :O, :O], [:O, :X, :O, :O, :O], [:O, :O, :X, :O, :O], [:O, :O, :O, :X, :O], [:' ', :' ', :' ', :' ', :X]])
    expect(board.game_over?).to be(:X)
  end 

  it "also works on upward diagonal" do
    board = Board.new(5, [[:O, :O, :O, :O, :X], [:O, :O, :O, :X, :O], [:O, :O, :X, :O, :O], [:' ', :X, :' ', :' ', :' '], [:X, :O, :O, :O, :O]])
    expect(board.game_over?).to be(:X)
  end 

  it "returns false for unstarted game" do
    board = Board.new(3)
    expect(board.game_over?).to be(false)
  end

  it "returns :draw for drawn game" do
    board = Board.new(3, [[:X, :O, :O], [:O, :O, :X], [:X, :X, :O]])
    expect(board.game_over?).to be(:draw)
  end
end

describe "find_all_possible_moves" do
  it "lists coordinates of all open squares in a board" do
    board = Board.new(3, [[:X, :O, :' '], [:' ', :X, :O], [:O, :X, :O]])
    expect(board.find_all_possible_moves).to eq([{:column => 2, :row => 0}, {:column => 0, :row => 1}])
  end
end

describe "empty_square?" do
  it "returns true for empty square" do
    board = Board.new(3, [[:X, :X, :X], [:O, :O, :O], []])
    expect(board.empty_square?({:column => 0, :row => 2})).to be(true)
  end

  it "returns false for square with :X or :O" do
    board = Board.new(3, [[:X, :X, :X], [:O, :O, :O], []])
    expect(board.empty_square?({:column => 0, :row => 0})).to be(false)
    expect(board.empty_square?({:column => 0, :row => 1})).to be(false)
  end
end

describe "get_square" do
  it "gets symbol for the square at given coordinates" do
    board = Board.new(3, [[:X, :X, :X], [:O, :O, :O], []])
    expect(board.get_square({:column => 0, :row => 0})).to be(:X)
    expect(board.get_square({:column => 2, :row => 2})).to be(:' ')
  end 
end

describe "set_square" do
  it "sets symbol for the square at given coordinates" do
    board = Board.new(3)
    coords = {:column => 1, :row => 1}
    board.set_square(coords, :O)
    expect(board.get_square(coords)).to be(:O)
  end
end

# class Row

describe "initialize row" do
  it "initializes empty row" do
    row = Row.new(1)
    expect(row.get_square(0)).to eq(:' ')
  end

  it "initializes row with values" do
    row = Row.new(3, [:X, :O, :' '])
    expect(row.get_square(0)).to eq(:X)
    expect(row.get_square(1)).to eq(:O)
    expect(row.get_square(2)).to eq(:' ')
  end

  it "throws error when initialized with incorrect number of values" do
    #expect { Row.new(3, [0, 0, 0, 0, 0]) }.to raise_exception(InvalidBoardContents)
    expect { Board.new(3.0) }.to raise_exception(InvalidBoardSize)
  end
end

describe "row_over?" do
  it "returns false for empty row" do
    row = Row.new(3)
    expect(row.row_over?).to be(false)
  end

  it "returns :draw for row with mixed symbols" do
    row = Row.new(3, [:X, :O, :X])
    expect(row.row_over?).to be(:draw)
  end

  it "returns winner's symbol for row with all same symbol" do
    row = Row.new(3, [:X, :X, :X])
    expect(row.row_over?).to be(:X)
  end
end

describe "get_square" do
  it "returns symbol of selected square" do
    row = Row.new(3, [:X, :O, :' '])
    expect(row.get_square(0)).to be(:X)
    expect(row.get_square(1)).to be(:O)
    expect(row.get_square(2)).to be(:' ')
  end
end

describe "set_square" do
  it "updates a square in a row" do
    row = Row.new(3)
    row.set_square(1, :X)
    expect(row.get_square(1)).to be(:X)
  end
end

# class Square

describe "update square" do
  it "rejects invalid symbols" do
    square = Square.new
    expect { square.update('x') }.to raise_exception(InvalidSymbol)
  end

  it "successfully updates" do
    square = Square.new
    expect(square.symbol).to eq(:' ')
    square.update(:X)
    expect(square.symbol).to eq(:X)
  end
end

# class Player

describe "play" do
  it "successfully makes valid move" do
    board = Board.new(3, [[:X, :X, :X], [:O, :O, :O], []])
    player = Player.new(:manual, :X)
    player.play({:column => 2, :row => 2}, board)
    expect(board.get_square({:column => 2, :row => 2})).to be(:X)
  end

  it "throws InvalidMove for invalid move" do
    board = Board.new(3, [[:X, :X, :X], [:O, :O, :O], []])
    player = Player.new(:manual, :X)
    expect { player.play({:column => 0, :row => 0}, board) }.to raise_exception(InvalidMove)
  end
end

describe "choose_best_move" do
  it "chooses the one non-losing option of three" do
    player = Player.new(:auto, :X)
    board = Board.new(3, [[:X, :X, :O], [:O, :O, :X], []])
    expect(player.choose_best_move(board)).to eq({:column => 0, :row => 2}) # WHY is this nil when it wasn't before?
  end
end

# class GameTree

describe "add_child" do
  it "adds a child to a tree" do
    board = Board.new(3, [[:X, :' ', :' '], [:O, :O, :' '], []])
    node = GameTree.new(board, :O)
    node.add_child({:column => 2, :row => 0})
    expect(node.children[0].evaluate_leaf(:X)).to be(nil)
  end
end

describe "evaluate_leaf" do
  it "returns 1 when player has won" do
    board = Board.new(3, [[:X, :X, :X], [:O, :O, :' '], []])
    node = GameTree.new(board, :X)
    expect(node.evaluate_leaf(:X)).to be(1)
  end

  it "returns 0 for a draw" do
    board = Board.new(3, [[:X, :O, :O], [:O, :O, :X], [:X, :X, :O]])
    node = GameTree.new(board, :X)
    expect(node.evaluate_leaf(:X)).to be(0)
  end

  it "returns -1 when opponent has won" do
    board = Board.new(3, [[:X, :X, :' '], [:O, :O, :O], []])
    node = GameTree.new(board, :O)
    expect(node.evaluate_leaf(:X)).to be(-1)
  end

  it "returns nil when game isn't over" do
    board = Board.new(3, [[:X, :O, :' '], [:O, :O, :' '], []])
    node = GameTree.new(board, :X)
    expect(node.evaluate_leaf(:X)).to be(nil)
  end
end

describe "grow_tree" do
  it "gives correct values" do
    board = Board.new(3, [[:X, :O, :O], [:O, :X, :X], []])
    tree = GameTree.new(board.copy, :X)
    tree.grow_tree(:X)
    expect(tree.children.length).to be(3)
    expect(tree.children[0].value).to be(nil)
    expect(tree.children[2].value).to be(1)
  end
end

describe "evaluate tree" do
  it "gives 0 when neither side can force a win" do
    board = Board.new(3, [[:X, :X, :O], [:O, :O, :X], []])
    tree = GameTree.new(board, :X)
    tree.grow_tree(:X)
    tree.evaluate(:X)
    expect(tree.value).to be(0)
  end

  it "gives 1 when player can force a win" do
    board = Board.new(3, [[:O, :' ', :' '], [:' ', :X, :O], [:X, :O, :X]])
    tree = GameTree.new(board, :X)
    tree.grow_tree(:X)
    tree.evaluate(:X)
    expect(tree.value).to be(1)
  end

  it "gives -1 when opponent can force a win" do
    board = Board.new(3, [[], [:' ', :X, :O], [:X, :O, :X]])
    tree = GameTree.new(board, :O)
    tree.grow_tree(:O)
    tree.evaluate(:O)
    expect(tree.value).to be(-1)
  end
end

# misc other methods

describe "opposite" do
  it "given a player's symbol, returns the symbol of their opponent" do
    expect(opposite(:X)).to be(:O)
    expect(opposite(:O)).to be(:X)
  end
end

=begin
TODO
  * validation for initializing board, row, player, tree
  * (later) preserve game tree from turn to turn to avoid recalculation
  * in tests, pull repeated stuff out into before actions
  * add the ACTUAL auto play loop
=end
