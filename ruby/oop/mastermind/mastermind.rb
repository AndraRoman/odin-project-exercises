class IncorrectPatternLength < Exception; end
class InvalidInput < Exception; end
class CheatingDetected < Exception; end

module MiscFunctions
  def keystroke_to_color(c)
    process_char(c, 0...6, ["r", "o", "y", "g", "b", "p"])
  end

  def process_char(char, range, strings = [])
    range_as_chars = range.to_a.map {|i| i.to_s}
    c = char.downcase
    if range_as_chars.include?(c)
      char.to_i
    elsif strings.include?(c)
      strings.index(c)
    else
      raise InvalidInput.new(c)
    end
  end

  # filled square for black, open for white
  def display_comparison(hash)
    s = "\u25a0" * hash[:black] + "\u25a1" * hash[:white]
    puts s.ljust(4, '_')
  end

  def compare_arrays(secret, guess)
    full_matches = 0
    partial_matches = 0
    s = secret.clone
    g = guess.clone
    s.each_with_index do |i, index|
      full_matches += 1 if i == guess[index]
      g_ind = g.index(i)
      if g_ind
        partial_matches += 1
        g.delete_at(g_ind)
      end
    end
    partial_matches -= full_matches
    {:black => full_matches, :white => partial_matches}
  end

end

class Pattern

  @@colors = ["red", "orange", "yellow", "green", "blue", "purple"]

  attr_reader :pattern

  def initialize(pattern)
    if pattern.length != 4
      raise IncorrectPatternLength.new(pattern)
    else
      pattern.each do |i|
        raise InvalidInput.new(i) unless (0...6).to_a.include?(i)
      end
    end
    @pattern = pattern
  end

  def Pattern.to_color(i)
    if (0...6).to_a.include?(i)
      @@colors[i]
    else raise InvalidInput.new(i)
    end
  end

  def display
    disp = ""
    @pattern.each do |i|
      disp += Pattern.to_color(i).ljust(10)
    end
    puts disp
  end

end

class Codemaker

  def initialize(array = Array.new(4) { rand 6 })
    @secret = Pattern.new(array)
  end

  def play(guess)
    comparison = compare_arrays(@secret.pattern, guess.pattern)
    display_comparison(comparison)
    comparison
  end

  def reveal
    print "The secret was "
    @secret.display
  end

end

class Codebreaker
require 'set'

  attr_writer :last_comparison

  def initialize
    @all_possibilities = generate_all_possibilities(4, 6)
    @remaining_possibilities = @all_possibilities.clone
    @all_possible_comparisons = all_peg_combinations
    @last_comparison = nil
  end

  def all_peg_combinations
    combinations = generate_all_possibilities(2, 5).select{ |i| i[0] + i[1] <= 4 }.uniq
    Set.new(combinations.map {|i| {:black => i[0], :white => i[1]}}) 
  end

  def play
    remove_inconsistent_possibilities if @last_comparison
    best_move = (@last_comparison.nil? ? [0, 0, 1, 1]: find_best_move)
    @last_move = Pattern.new(best_move)
    @all_possibilities.subtract(Set.new([best_move]))
    @last_move.display
    if @remaining_possibilities.size == 0
      puts "Hey, you're cheating! I quit."
      raise CheatingDetected
    end
    @last_move
  end

  def remove_inconsistent_possibilities
    inconsistent_possibilities = Set.new()
    @remaining_possibilities.each do |i|
      inconsistent_possibilities.add(i) if !consistent?(i, @last_move.pattern, @last_comparison)
    end
    @remaining_possibilities.subtract(inconsistent_possibilities)
  end

  def find_best_move
    max_score_so_far = 0
    best_move_so_far = @all_possibilities.first # arbitrary
    @all_possibilities.each do |i|
      scores = [] # minimum number of elements that would be eliminated by this guess
      @all_possible_comparisons.each do |c|
        s = 0
        @remaining_possibilities.each do |r|
          s += 1 if !consistent?(r, i, c)
        end
        scores.push(s)
      end
      score = scores.min
      if (score > max_score_so_far || (score == max_score_so_far && @remaining_possibilities.include?(i) && !@remaining_possibilities.include?(best_move_so_far)))
        max_score_so_far = score
        best_move_so_far = i
      end
    end
    best_move_so_far
  end

  def consistent?(guess, secret, comparison)
    compare_arrays(guess, secret) == comparison
  end

  def generate_all_possibilities(length, count)
    arr = []
    arr = g_a_p_helper(length, count, arr).flatten(length - 1)
    Set.new(arr)
  end

  def g_a_p_helper(length, count, arr)
    if length > 0
      new_array = Array.new(count) {|i| arr.clone.push(i)}
        new_array.each_with_index do |a, index| 
          new_array[index] = g_a_p_helper(length - 1, count, a)
        end
      new_array
    else
      arr 
    end
  end

end

class HumanCodemaker
include MiscFunctions

  def initialize
  end

  def play(guess) 
    begin
      puts "Enter the number of black pegs."
      black_num = keystroke_to_peg_number(gets.chomp)
      puts "Enter the number of white pegs."
      white_num = keystroke_to_peg_number(gets.chomp)
      comparison = {:black => black_num, :white => white_num}
      display_comparison(comparison)
      comparison
    rescue InvalidInput => e
      puts "Must be an integer from 0 to 4. Try again."
      retry
    end
  end

  def keystroke_to_peg_number(c)
    process_char(c, 0...5)
  end

  def reveal
  end

end

class HumanCodebreaker
include MiscFunctions

  attr_writer :last_comparison

  def initialize
  end

  def play
    puts "Enter your guess. 0 => red, 1 => orange, 2 => yellow, 3 => green, 4 => blue, and 5 => purple."
    begin
      array = []
      gets.chomp.split("").each do |i|
        array.push(keystroke_to_color(i))
      end
      guess = Pattern.new(array)
      guess.display
    rescue InvalidInput => e
      puts "I don't understand the color #{e.message}. Try again."
      retry
    rescue IncorrectPatternLength
      puts "You must guess exactly four colors. Try again."
      retry
    end
    guess
  end

end

include MiscFunctions

def get_mode(message)
  puts message
  begin
    input = gets.chomp
    process_char(input, [], ['a', 'm'])
  rescue InvalidInput => e
    puts "I don't understand the mode #{e}. Try again."
    retry
  end
end

def full_turn(codemaker, codebreaker)
  guess = codebreaker.play
  comparison = codemaker.play(guess)
  codebreaker.last_comparison = comparison
end
