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

  def [](row, col)
    @board[row][col]
  end

  def make_board
    Array.new(8) { Array.new(8) }
  end

  def set_board
    #extensive fixing
    color = :black
    spaces = proper_moves

    2.times do

      n_of_pieces.times do |i|
        self[spaces[i][0], spaces[i][1]] = Piece.new(color, spaces[i], self)
      end

      spaces.reverse!
      set_pieces(color, order)
      color = :red
    end
  end

  def proper_moves
    move_array = []
    8.times do |i|
      8.times do |j|
        move_array << [i,j] if ( i.even? && j.odd? ) || ( i.odd? && j.even? )
      end
    end
    move_array
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
    @board[end_pos[0]][end_pos[1]] = @board[start_pos[0]][start_pos[1]]
    @board[start_pos[0]][start_pos[1]] = nil
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

  def perform_moves!(move_path)

    move_path.each do |move|
      raise NotImplementedError unless move.include?(@board.proper_moves)
    end

    (move_path.length - 1).time do |i|

      perform_slide(move_path[i], move_path[i + 1])

    end


  end









  def perform_slide(start_pos, end_pos)
    raise "I can't let you do that, Dave" unless check_slide(start_pos, end_pos)
    # return false unless check_slide(start_pos, end_pos)

    @board.move_piece(start_pos, end_pos)
    @position = end_pos
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




  #rewrite these methods entirely with the board dup thing.

  def check_slide(start_pos, end_pos)
    #puts 'hi'
    return true unless @board.board[end_pos[0]] &&
                       @board.board[end_pos[0], end_pos[1]]


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
    if @board.board[start_pos[0], start_pos[1]] && !jump_path.empty? &&
       @board.board[end_pos[0], end_pos[1]].nil?
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