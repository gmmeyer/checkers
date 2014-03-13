class Game


end


class Board

  attr_accessor :board

  def initialize(n_of_pieces = 12)
    @n_of_pieces = n_of_pieces
    @board = make_board
    set_board
    nil
  end

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

    end
  end

  def set_pieces(color, order)
    row_count = 0
    piece_count = 0
    @board.length.times do |y|
      y += 5 if color == :red
      row_order = order[row_count]
      @board[0].length.times do |x|
        #puts "x: #{x}, y: #{y}"
        if x.even? && row_order == 'even'
          @board[y][x] = Piece.new(color, [y,x], self)
          piece_count += 1
        elsif x.odd? && row_order == 'odd'
          @board[y][x] = Piece.new(color, [y,x], self)
          piece_count += 1
        end
        break if piece_count == @n_of_pieces
      end
      row_count += 1
    end
  end

  def render
    @board.each do |row|
      row.each do |piece|
        if piece
          print "#{piece.render} "
        else
          print "  "
        end
      end
      print "\n"
    end
  end


  def move_piece(start_pos, end_pos)
    @board[end_pos[0]][end_pos[1]],
    @board[start_pos[0]][start_pos[1]] =
    @board[start_pos[0]][start_pos[1]],
    nil
  end

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

    unless check_jump(start_pos, jump_path, end_pos)
      raise "I can't let you do that, Dave"
    end

    #if check_jump_path(start_pos, jump_path, end_pos)
    jumps = [start_pos] + [jump_path] + [end_pos]
    (jumps.length - 1).times do |i|
        @board.move_piece(jumps[i], jumps[i+1])
        @position = [jumps[i+1][0], jumps[i+1][1]]
    end
    #end
  end

  def check_slide(start_pos, end_pos)
    #puts 'hi'
    return true unless @board.board[end_pos[0]] && @board.board[end_pos[0]][end_pos[1]]
    if !start_pos.nil? && end_pos.nil?
      if start_pos[0] + 1 == end_pos[0] &&
        if start_pos[1] + 1 == end_pos[1] || start_pos[1] - 1 == end_pos[1]
          return true
        end
      end
    end
    false
  end

  def check_jump(start_pos, jump_path, end_pos)
    if @board.board[start_pos[0]][start_pos[1]] && !jump_path.empty? && @board.board[end_pos[0]][end_pos[1]].nil?
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