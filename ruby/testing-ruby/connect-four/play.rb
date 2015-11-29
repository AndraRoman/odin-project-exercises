require './connect_four'

board = Board.new
p1 = Player.new(:red)
p2 = Player.new(:yellow)

game(board, p1, p2)
