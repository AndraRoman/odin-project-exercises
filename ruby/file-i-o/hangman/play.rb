require './lib/hangman'
include MiscMethods

dictionary = (File.readlines "dictionary").map { |w| w.strip }

game = Game.new(dictionary)

loop do
  letter = get_letter
  break unless game.turn(letter)
end

if game.won?
  puts "Congratulations, you win!"
else
  puts "You lose. The word was #{game.word}"
end
