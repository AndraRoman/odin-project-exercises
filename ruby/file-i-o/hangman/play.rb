require './lib/hangman'
include MiscMethods

dictionary = (File.readlines "dictionary").map { |w| w.strip }

# TODO interface for getting name

filename = choose_file

if filename
  file = File.read("#{filename}")
  puts "Opened saved game #{filename}."
  game = Marshal.load(file)
else
  puts "Starting new game."
  game = Game.new(dictionary)
end

game.display

loop do
  begin
    input = get_letter
  rescue SaveGame
    filename = get_filename
    save_game(game, filename)
  end
  break unless game.turn(input)
end

if game.won?
  puts "Congratulations, you win!"
else
  puts "You lose. The word was #{game.word}"
end
