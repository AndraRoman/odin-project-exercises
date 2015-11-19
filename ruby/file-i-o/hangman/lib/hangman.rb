class InvalidDictionary < Exception; end
class InvalidInput < Exception; end
class SaveGame < Exception; end

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

  def get_letter
    puts "Enter a guess, or press '0' to save."
    begin
      letter = gets.chomp.downcase
      if valid_letter?(letter)
        letter
      elsif letter == "0"
        raise SaveGame
      else
        raise InvalidInput(letter)
      end
    rescue InvalidInput => e
      puts "I don't understand #{e}. Input must be a single ASCII letter. Try again."
      retry
    end
  end

  # don't care about catching errors here - if input is invalid, just start a new game.
  def choose_file
    filenames = Dir["saved_games/*"]
    filenames.each_with_index do |fn, index|
      puts "#{index.to_s.ljust(10)} #{File.basename(fn)}"
    end
    puts "Press enter to start a new game. To open a saved game, enter the number next to the filename."
    num = gets.chomp
    begin
      filenames[Integer(num)]
    rescue ArgumentError, TypeError
      nil
    end
  end

  def get_filename
    puts "Enter a filename to save this game to."
    gets.chomp
  end

  def save_game(game, name)
    content = Marshal.dump(game)
    Dir.mkdir("saved_games") unless Dir.exists?("saved_games")
    filename = "saved_games/#{name}"
    File.open(filename, 'w') { |file| file.puts content }
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

  def display
    progress = @word.split("").map { |l| @correct_guesses.include?(l) ? l : "_" }.join("")
    puts "Word: #{progress}"
    misses = @wrong_guesses.to_a.join(", ")
    puts "Misses: #{misses}"
  end

end
