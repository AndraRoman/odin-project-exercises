require 'connect_four'

describe Board do

  let(:board) { Board.new }

  describe ".initialize" do
    it "creates an array of seven empty columns if given no argument" do
      expect(board.columns.length).to be(7)
      board.columns.each { |c| expect(c).to eq([]) }
    end

    it "creates an output_stream instance variable with default value $stdout" do
      expect(board.instance_variable_get(:@output_stream)).to be($stdout)

      output_stream = StringIO.new
      new_board = Board.new(output_stream)
      expect(new_board.instance_variable_get(:@output_stream)).to be(output_stream)
    end
  end

  describe "#play" do
    it "pushes color into appropriate column" do
      board.play(6, :red)
      board.play(6, :yellow)
      expect(board.columns[6]).to eq([:red, :yellow])
    end

    it "raises exception if specified column is already full" do
      6.times { board.play(3, :red) }
      expect{ board.play(3, :red) }.to raise_exception(InvalidMove)
    end

    it "raises exception if specified column does not exist " do
      expect{ board.play(7, :yellow) }.to raise_exception(InvalidMove)
    end
  end

  describe "#display" do
    it "displays current board state" do
      output_stream = StringIO.new
      board.instance_variable_set(:@output_stream, output_stream)
      board.columns[0] = [:red, :red, :yellow]
      board.columns[3] = [:yellow, :red]
      board.display
      expect(output_stream.string).to eq("[\"   \", \"   \", \"   \", \"   \", \"   \", \"   \", \"   \"]\n[\"   \", \"   \", \"   \", \"   \", \"   \", \"   \", \"   \"]\n[\"   \", \"   \", \"   \", \"   \", \"   \", \"   \", \"   \"]\n[\"y  \", \"   \", \"   \", \"   \", \"   \", \"   \", \"   \"]\n[\"r  \", \"   \", \"   \", \"r  \", \"   \", \"   \", \"   \"]\n[\"r  \", \"   \", \"   \", \"y  \", \"   \", \"   \", \"   \"]\n")
    end
  end

  describe "#all_rows" do
    it "gives an array of all rows on the board, with nil for empty spaces" do
      a = [:red, :red, :red, :yellow, :yellow]
      board.columns = ([a, a.reverse, a, a.reverse, a, a.reverse, []])
      expect(board.all_rows[1]).to eq([:red, :yellow, :red, :yellow, :red, :yellow, nil])
      expect(board.all_rows[5]).to eq(Array.new(7, nil))
    end
  end

  describe "#all_diagonals" do
    it "gives an array of all diagonals on the board, going left to right, with nil for empty spaces" do
      a = [:red, :red, :red, :yellow, :yellow]
      board.columns = ([a, a.reverse, a, a.reverse, a, a.reverse, []])
      expect(board.all_diagonals.length).to be(12)
      expect(board.all_diagonals[0]).to eq([nil, nil, :red, :red, :yellow, nil])
      expect(board.all_diagonals[11]).to eq([:yellow, :red, :red, :yellow, nil, nil])
    end  
  end

  describe ".array_has_connect_four" do
    it "returns symbol that has a connect-four, if any" do
      expect(board.array_has_connect_four([:red, :red, :yellow, :red, :red, :red, :red])).to be(:red)
    end

    it "returns false otherwise" do
      expect(board.array_has_connect_four([:red, :red, :yellow, :yellow, :red])).to be(false)
    end
  end

  describe "#game_over?" do
    it "returns winner's symbol if there is a vertical connect-four" do
      4.times { board.play(1, :red) }
      expect(board.game_over?).to be(:red)
    end

    it "returns winner's symbol if there is a horizontal connect-four" do
      (0...4).each { |i| board.play(i, :red) }
      expect(board.game_over?).to be(:red)
    end

    it "returns winner's symbol if there is a downward diagonal connect-four" do
      (1...4).each { |i| i.times { board.play(3 - i, :yellow) } }
      (0...4).each { |i| board.play(i, :red) }
      expect(board.game_over?).to be(:red)
    end

    it "returns winner's symbol if there is an upward diagonal connect-four" do
      (1...4).each { |i| i.times { board.play(i, :yellow) } }
      (0...4).each { |i| board.play(i, :red) }
      expect(board.game_over?).to be(:red)
    end

    it "returns :nobody if all spaces have been filled and there is no connect-four" do
      a = [:red, :red, :red, :yellow, :yellow, :yellow]
      board.columns = ([a, a.reverse, a, a.reverse, a, a.reverse, a])
      expect(board.game_over?).to be(:nobody)
    end

    it "returns false otherwise" do
      board.columns[0] = [:red, :red, :red, :yellow, :yellow, :yellow]
      expect(board.game_over?).to be(false)
    end
  end
end

describe Player do
  describe ".initialize" do

    let(:player) { Player.new(:red) }

    it "creates a new player with specified color" do
      expect(player.color).to be(:red)
    end

    it "raises argument error if no color is given" do
      expect{ Player.new }.to raise_exception(ArgumentError)
    end

    it "creates an input_stream instance variable with default value $stdin" do
      expect(player.instance_variable_get(:@input_stream)).to be($stdin)

      input_stream = StringIO.new
      new_player = Player.new(:red, {:input => input_stream})
      expect(new_player.instance_variable_get(:@input_stream)).to be(input_stream)
    end

    it "creates an output_stream instance variable with default value $stdout" do
      expect(player.instance_variable_get(:@output_stream)).to be($stdout)

      output_stream = StringIO.new
      new_player = Player.new(:red, {:output => output_stream})
      expect(new_player.instance_variable_get(:@output_stream)).to be(output_stream)
    end
 
  end

  # the following works when Player.play does not take a StringIO as an argument
  # allow(player).to receive(:gets) {"3\n"}
  # but when an input stream is already specified, apparently this doesn't override it
  describe "#play" do

    let(:input_stream) { StringIO.new }
    let(:output_stream) { StringIO.new }
    let(:board) { Board.new }
    let(:player) { Player.new(:red, {:input => input_stream, :output => output_stream}) }

    it "prints prompt, gets a column from stdin, then plays in that column" do
      input_stream.print("3")
      input_stream.rewind
      player.play(board)
      expect(board.columns[3]).to eq([:red])
      expect(output_stream.string).to eq("Player red, which column will you play in?\n")
    end

    it "prints warning and retries if first user input is invalid" do
      input_stream.print("99\n3\n")
      input_stream.rewind
      player.play(board)
      expect(board.columns[3]).to eq([:red])
      expect(output_stream.string).to eq("Player red, which column will you play in?\nYou can't play there! Try again.\n")
    end
  end
end

describe "game" do
  let(:input_stream) { StringIO.new }
  let(:output_stream) { StringIO.new }
  let(:p1) { Player.new(:red, {:input => input_stream, :output => output_stream}) }
  let(:p2) { Player.new(:yellow, {:input => input_stream, :output => output_stream}) }
  let(:board) { Board.new(output_stream) }

  it "prints correct message and terminates when a player has won" do
    input_stream.print([1, 2, 1, 2, 1, 2, 1, 2].map{|i| i.to_s}.join("\n"))
    input_stream.rewind
    game(board, p1, p2, output_stream)
    out = output_stream.string.split("\n")
    expect(out.length).to be(50)
    expect(out[-1]).to eq("Game over! Winner is red.")
  end

  it "prints correct message and terminates when game is tied" do
    input_stream.print([0, 1, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 2, 3, 2, 3, 2, 3, 3, 2, 3, 2, 3, 2, 4, 5, 4, 5, 4, 5, 5, 4, 5, 4, 5, 4, 6, 6, 6, 6, 6, 6].map{|i| i.to_s}.join("\n"))
    input_stream.rewind
    game(board, p1, p2, output_stream)
    out = output_stream.string.split("\n")
    expect(out.length).to be(295)
    expect(out[-1]).to eq("Game over! Winner is nobody.")
  end
end
