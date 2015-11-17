require './tic_tac_toe'

board = create_board
players = [create_player(1), create_player(2)]
board.display
loop do
  turn(board, players[0])
  break if board.check_game_over
  turn(board, players[1])
  break if board.check_game_over
end
