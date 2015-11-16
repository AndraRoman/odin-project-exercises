require './mastermind'

codemaker_mode = get_mode("Choose mode for codemaker. Enter 'a' for auto or 'm' for manual.")
codebreaker_mode = get_mode("Choose mode for codebreaker. Enter 'a' for auto or 'm' for manual.")

codemaker = (codemaker_mode == 0 ? Codemaker.new : HumanCodemaker.new)
codebreaker = (codebreaker_mode == 0 ? Codebreaker.new : HumanCodebreaker.new)

current_turn = 0
max_turns = 12

# TODO the following is dumb
winner = codemaker

while current_turn < max_turns do
  begin
    b = full_turn(codemaker, codebreaker)
    if b[:black] == 4
      winner = codebreaker
      break
    end
    current_turn += 1
  rescue CheatingDetected
    break
  end
end

if winner == codebreaker
  puts "Congratulations, you guessed the secret code!"
else
  puts "You lose."
  codemaker.reveal
end

