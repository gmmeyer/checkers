class Game


end


class Board

  attr_reader :board

  def initialize(n_of_pieces = 12)
    @n_of_pieces = n_of_pieces
    @board = make_board
    set_board
  end

  # def [](pos)
  #   col, row = pos
  #   grid[col][row]
  # end


  def make_board
    Array.new(8) { Array.new(8) }
  end

  def set_board
    #extensive fixing
    color = :black
    order = ['odd', 'even', 'odd', 'even']

    2.times do

      set_pieces(color, order)
      color = :red
      order.reverse!
      @board.reverse!

    end
    @board.reverse!
  end

  def set_pieces(color, order)
    row_count = 0
    piece_count = 0
    @board.length.times do |y|
      row_order = order[row_count]
      @board[0].length.times do |x|
        puts "x: #{x}, y: #{y}"
        if x.even? && row_order == 'even'
          @board[y][x] = Piece.new(color, [x,y], @board)
          piece_count += 1
        elsif x.odd? && row_order == 'odd'
          @board[y][x] = Piece.new(color, [x,y], @board)
          piece_count += 1
        end
        break if piece_count == @n_of_pieces
      end
      row_count += 1
    end
  end

  def render

  end


  def move_piece(start_pos, end_pos)
    move_start = self[start_pos[0]][start_pos[1]]
    move_end = self[end_pos[0]][end_pos[1]]
    move_start, move_end = nil, move_start
  end



  # def []=(pos,value)
  #   col,row = pos
  #   grid[col][row] = value
  # end

end







class Piece

  def initialize(color, position, board)
    @color = color
    @position = position
    @board = board
    @type = :pawn
  end

  def render
    if @type == :pawn
      @color.to_s[0].downcase
    elsif @type == :king
      @color.to_s[0].upcase
    end
  end

  def perform_slide(start_pos, end_pos)
    raise "I can't let you do that, Dave" unless check_slide(start_pos, end_pos)

    @board.move_piece(start_pos, end_pos)
    @position = [start_pos, end_pos]
  end

  def perform_jump(start_pos, jump_path, end_pos)

    unless check_jump(start_pos, first_jump, end_pos)
      raise "I can't let you do that, Dave"
    end

    unless check_jump_path(start_pos, jump_path, end_pos)
      @board.move_piece(start_pos, end_pos)
      @position = [start_pos, end_pos]
    end
  end

  def check_slide(start_pos, end_pos)

    if start_pos && end_pos.nil?
      if start_pos[0] + 1 == end_pos[0] && start_pos[1] + 1 == end_pos[1]
        return true
      end
    end
    false
  end



  def check_jump(start_pos, jump_path, end_pos)
    if start_pos && !jump_path.empty? && end_pos.nil?
      return true
    end
    false
  end

  def check_jump_path(start_pos, jump_path, end_pos)

    #this does not work for kings. need to rewrite this. do after phase 1.
    #use a range, make it +/- for kings, and + for pawns. It's pretty simple.

    unless start_pos[0] + 1 == jump_path[0][0]
      unless start_pos[1] + 1 == jump_path[0][1]
        return false
      end
    end

    (jump_path.length - 2).times do |i|
      unless jump_path[i][0] + 1 == jump_path[i + 1][0]
        unless jump_path[i][1] + 1 == jump_path[i + 1][1]
          return false
        end
      end
    end

    unless end_pos[0] == jump_path[-1][0] + 1
      unless end_pos[1] == jump_path[-1][1] + 1
        return false
      end
    end

  end

  def maybe_promote

    if @position[1] == 7 && @color == :black
      type = :king
    elsif @position[1] == 0 && @color == :red
      type = :king
    end
  end



end