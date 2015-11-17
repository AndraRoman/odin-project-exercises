class InvalidDictionary < Exception; end
class InvalidInput < Exception; end

module MiscMethods

  def choose_word(dictionary)
    filtered_dict = dictionary.select { |word| valid_word?(word) }
    raise InvalidDictionary if filtered_dict.length == 0
    n = rand(filtered_dict.length)
    filtered_dict[n].downcase
  end

  def valid_letter?(letter)
    raise InvalidInput.new(letter) unless letter.class == String && letter.length == 1
    (97...123).include?(letter.ord)
  end

  def valid_word?(word)
    (5...13).include?(word.length) && word.split("").all? {|letter| valid_letter?(letter.downcase)}
  end

  # no test
  def get_letter
    puts "Enter a letter."
    begin
      letter = gets.chomp.downcase
      if valid_letter?(letter)
        letter
      else
        raise InvalidInput(letter)
      end
    rescue InvalidInput => e
      puts "I don't understand #{e}. Input must be a single ASCII letter. Try again."
      retry
    end
  end

end

class Game
  include MiscMethods
  require 'set'

  attr_reader :word

  def initialize(dictionary, max = 10)
    @word = choose_word(dictionary)
    @max = max
    @letters = Set.new(@word.downcase.split(""))
    @correct_guesses = Set.new
    @wrong_guesses = Set.new
  end

  def process_guess(letter)
    if @letters.include?(letter)
      @correct_guesses.add(letter)
    else
      @wrong_guesses.add(letter)
    end
  end

  def turn(letter)
    process_guess(letter)
    display
    !won? && @wrong_guesses.size < @max
  end

  def won?
    @letters.subset?(@correct_guesses)
  end

  # no test
  def display
    progress = @word.split("").map { |l| @correct_guesses.include?(l) ? l : "_" }.join("")
    puts "Word: #{progress}"
    misses = @wrong_guesses.to_a.join(", ")
    puts "Misses: #{misses}"
  end

end

# TODO
# ASCII art
# ability to save game
# ability to select and open a saved game
