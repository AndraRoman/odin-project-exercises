require 'hangman'
include MiscMethods

describe "choose_word" do
  it "chooses a random string from an array" do
    strings = ["penguin", "otter", "squirrel"]
    expect(strings).to include(choose_word(strings))
  end

  it "throws exception if dictionary contains no words of valid length" do
    strings = ["ant", "mesmerizingly"]
    expect { choose_word(strings) }.to raise_exception(InvalidDictionary)
  end
end

describe "valid_letter?" do
  it "accepts lowercase ASCII characters" do
    expect(valid_letter?("a")).to be(true)
    expect(valid_letter?("z")).to be(true)
  end

  it "rejects all other characters" do
    expect(valid_letter?(" ")).to be(false)
    expect(valid_letter?("\u00E9")).to be(false)
    expect(valid_letter?("A")).to be(false)
  end

  it "throws exception when given input other than a single-character string" do
    expect { valid_letter?(3) }.to raise_exception(InvalidInput)
    expect { valid_letter?("aa") }.to raise_exception(InvalidInput)
  end
end

describe "valid_word?" do
  it "accepts valid words" do
    expect(valid_word?("elephant")).to be(true)
    expect(valid_word?("ElepHANt")).to be(true)
  end

  it "rejects invalid words" do 
    expect(valid_word?("ants")).to be(false)
    expect(valid_word?("mesmerizingly")).to be(false)
    expect(valid_word?("only a test")).to be(false)
  end
end

# Game class

describe "initialize game" do
  it "creates letter set" do
    game = Game.new(["penguin"])
    expect(game.instance_variable_get(:@letters)).to eq(Set.new(["p", "e", "n", "g", "u", "i"]))
  end
end

describe "process_guess" do
  it "adds incorrect guesses to @wrong_guesses" do
    game = Game.new(["penguin"])
    game.process_guess("c")
    expect(game.instance_variable_get(:@correct_guesses)).to eq(Set.new)
    expect(game.instance_variable_get(:@wrong_guesses)).to eq(Set.new(["c"]))
  end

  it "adds correct guesses to @correct_guesses" do
    game = Game.new(["penguin"])
    game.process_guess("n")
    expect(game.instance_variable_get(:@correct_guesses)).to eq(Set.new(["n"]))
    expect(game.instance_variable_get(:@wrong_guesses)).to eq(Set.new)
  end
end

describe "turn" do
  it "returns false if game is won at end of turn" do
    game = Game.new(["penguin"])
    game.instance_variable_set(:@correct_guesses, Set.new("pegui".split("")))
    expect(game.turn("n")).to be(false)
  end

  it "returns false if game is lost at end of turn" do
    game = Game.new(["penguin"], 5)
    game.instance_variable_set(:@wrong_guesses, Set.new("abcd".split("")))
    expect(game.turn("k")).to be(false)
  end

  it "returns true otherwise" do
    game = Game.new(["penguin"])
    expect(game.turn("e")).to be(true)
  end
end

describe "won?" do
  it "returns true if all letters of word have been guessed" do
    game = Game.new(["penguin", "otter", "squirrel"])
    game.instance_variable_set(:@correct_guesses, Set.new(["x", "y", "z"]))
    game.instance_variable_set(:@letters, Set.new(["x", "y"]))
    expect(game.won?).to be(true)
  end

  it "returns false otherwise" do
    game = Game.new(["penguin", "otter", "squirrel"])
    game.instance_variable_set(:@correct_guesses, Set.new(["x", "y", "z"]))
    game.instance_variable_set(:@letters, Set.new(["x", "y", "z", "a"]))
    expect(game.won?).to be(false)
  end
end
