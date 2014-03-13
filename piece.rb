# encoding: utf-8

class InvalidMoveError < StandardError
end

class Piece

  attr_reader :color, :position, :type

  DELTAS = {
    [:pawn, :red] => [[1,1], [1,-1]],
    [:pawn, :black] =>[[-1,1], [-1,-1]],
    [:king, :red] => [[1,1], [1,-1], [-1,1], [-1,-1]],
    [:king, :black] => [[1,1], [1,-1], [-1,1], [-1,-1]]
  }

  def initialize(color, position, board, type = :pawn)
    @color = color
    @position = position
    @board = board
    @type = type
  end


  def perform_moves(move_path)
    if valid_move_seq?(move_path)
      perform_moves!(move_path)
    else
      raise InvalidMoveError.new "I can't let you move there, Dave."
    end
  end


  def valid_move_seq?(move_path)
    board_dup = @board.dup
    begin
      p @position
      p board_dup[@position].nil?
      board_dup[@position].perform_moves!(move_path)
    rescue InvalidMoveError => e
      return false
    else
      return true
    end
  end




  def perform_moves!(move_path)

    unless @board.pieces.map{ |x| x.position}.include?(move_path[0])
      raise InvalidMoveError.new "There's not a piece there!"
    end

    move_path.each do |move|
      unless @board.proper_moves.include?(move)
        raise InvalidMoveError.new 'Your move is not on the board'
      end
    end

    if move_path.length < 2
      raise InvalidMoveError.new "That's not a move."
    end

    begin
      if move_path.length == 2
        perform_slide(move_path[0], move_path[1])
      end
    rescue InvalidMoveError => e
      perform_jump(move_path)
      move_path.shift
      retry
    end
  end





  def perform_slide(start_pos, end_pos)

    #if it returns true, that means the move is bad and an error is raised
    #if it returns false, then the move is okay
    #Unless the move needs to be checked, we go on.
    #This is held through the rest of the moves

    unless check_slide(start_pos, end_pos)
      raise InvalidMoveError.new "I can't let you slide there, Dave"
    end

    @board.move_piece(start_pos, end_pos)
    @position = end_pos
  end

  def perform_jump(start_pos, end_pos)

    unless check_jump(start_pos, end_pos)
      raise InvalidMoveError.new "I can't let you jump there, Dave"
    end

    @board.move_piece(start_pos, end_pos)
    @position = end_pos
  end

  def check_slide(start_pos, end_pos)

    unless @board[end_pos].nil?
      return true
    end

    return true unless DELTAS[[@type,@color]].map do |delta|
      [delta[0]+start_pos[0], delta[1] + start_pos[1]]
    end.include?(end_pos)

    false
  end

  def check_jump(start_pos, end_pos, board)

    if @board[end_pos].nil?
      return true
    end

    if @board[end_pos].color == color
      return true
    end

    return true unless DELTAS[[@type,@color]].map do |delta|
      [delta[0]+start_pos[0], delta[1] + start_pos[1]]
    end.include?(end_pos)

    false
  end

  def maybe_promote

    if @position[1] == 7 && @color == :black
      type = :king
    elsif @position[1] == 0 && @color == :red
      type = :king
    end
  end

end