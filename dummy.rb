require_relative 'checkers'

a = Board.new
a.render

a.board[3][6].perform_slide([3,6], [4,7])
puts ' '
a.render

a.board[5][6].perform_jump([5,6], [4,7], [3,6])
puts ' '
a.render