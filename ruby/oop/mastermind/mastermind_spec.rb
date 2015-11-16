require 'mastermind'

# Pattern methods

describe "initialize pattern" do
  it "raises exception when given array of incorrect length" do
    expect { Pattern.new([1, 2, 3]) }.to raise_exception (IncorrectPatternLength)
  end

  it "raises exception when given array with invalid contents" do
      expect { Pattern.new(['a', 1, 2, 4]) }.to raise_error (InvalidInput)
      expect { Pattern.new(['a', 1, 2, 4]) }.to raise_error ('a')
  end
end

describe "to color" do
  it "maps valid inputs to colors" do
    output = [1, 3, 2].map {|i| Pattern.to_color(i)}
    expect(output).to eq(["orange", "green", "yellow"])
  end

  it "raises exception when given invalid input" do
    expect { Pattern.to_color(7) }.to raise_error(InvalidInput)
    expect { Pattern.to_color(7) }.to raise_error('7')
  end
end

# Comparison methods

describe "compare two patterns" do
  it "returns correct number of black and white pegs to display" do
    secret = [1, 2, 3, 4]
    guess = [1, 3, 2, 5]
    expect(compare_arrays(secret, guess)).to eq({:black => 1, :white => 2})
  end
end

# Codemaker methods

describe "codemaker play" do
  it "returns a comparison when codemaker is created with no argument" do
    cm = Codemaker.new
    result = cm.play(Pattern.new([1, 0, 1, 2]))
    expect(result).to include(:black => a_value_between(0, 4), :white => a_value_between(0, 4)) # inclusive
  end

  it "returns correct comparison when codemaker is created with explicit pattern" do
    cm = Codemaker.new([0, 0, 1, 1])
    result = cm.play(Pattern.new([1, 0, 1, 2]))
    expect(result).to eq({:black => 2, :white => 1})
  end
end

# Codebreaker methods

describe "computer codebreaker play" do
  it "makes default move at first and removes that move from @all_possibilities" do
    cb = Codebreaker.new
    first_move = cb.play
    expect(first_move.pattern).to eq([0, 0, 1, 1])
    expect(cb.instance_variable_get(:@all_possibilities)).not_to include([0, 0, 1, 1])
  end
end

describe "remove inconsistent possibilities" do
  it "given a last move and resulting comparison, eliminates possibilities inconsistent with that" do
    cb = Codebreaker.new
    cb.instance_variable_set(:@last_move, Pattern.new([2, 2, 3, 4]))
    cb.instance_variable_set(:@last_comparison, {:black => 0, :white => 3}) # 3 4 2 5
    cb.instance_variable_set(:@remaining_possibilities, Set.new([[3, 4, 2, 5], [2, 3, 2, 2], [3, 4, 2, 2], [4, 3, 6, 2]]))
    cb.remove_inconsistent_possibilities
    expect(cb.instance_variable_get(:@remaining_possibilities)).to eq(Set.new([[3, 4, 2, 5], [4, 3, 6, 2]]))
  end
end

describe "find best move" do
  it "chooses the best possible move" do
    cb = Codebreaker.new
    my_set = Set.new([[2, 2, 2, 2], [3, 4, 2, 5], [2, 3, 2, 2], [3, 4, 2, 2], [4, 3, 6, 2]])
    cb.instance_variable_set(:@last_move, Pattern.new([0, 0, 1, 1]))
    cb.instance_variable_set(:@last_comparison, {:black => 0, :white => 0})
    cb.instance_variable_set(:@remaining_possibilities, my_set.clone)
    cb.instance_variable_set(:@all_possibilities, my_set.clone)
    expect(cb.find_best_move).to eq([3, 4, 2, 5])
  end
end

describe "generate all possibilities" do
  it "generates all possible length-l arrangements of n elements" do
    cb = Codebreaker.new
    expect(cb.generate_all_possibilities(2, 2)).to eq(Set.new([[0, 0], [0, 1], [1, 0], [1, 1]]))
  end
end

# Other methods

describe "keystroke_to_color" do
  it "accepts initial letter of colors" do
    expect(keystroke_to_color('r')).to be(0)
    expect(keystroke_to_color('P')).to be(5)
  end

  it "accepts integers 0-5" do
    expect(keystroke_to_color('0')).to be(0)
    expect(keystroke_to_color('5')).to be(5)
  end
end

describe "keystroke_to_peg_number" do
  it "accepts only integers 0-4" do
    cb = HumanCodemaker.new
    expect(cb.keystroke_to_peg_number('4')).to be(4)
    expect{ cb.keystroke_to_peg_number('5') }.to raise_error(InvalidInput)
    expect{ cb.keystroke_to_peg_number('a') }.to raise_error(InvalidInput)
  end
end

describe "process_char" do
  it "accepts integers in the proper range and rejects others" do
    expect(process_char('3', 0...4)).to eq(3)
    expect { process_char('5', 0...4) }.to raise_error (InvalidInput)
  end

  it "accepts strings in the explicit list" do
    expect(process_char('hello', [], ['zero', 'one', 'hello'])).to be(2)
  end

  it "rejects invalid input with informative exception" do
    expect { process_char('a', 0...4, []) }.to raise_error (InvalidInput)
    expect { process_char('a', 0...4, []) }.to raise_error ('a')
  end
end
