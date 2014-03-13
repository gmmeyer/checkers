class Render

  #put this back into board.rb and piece.rb
  #refactor heavily

  def initialize(board)
    @board = board

  end

  def render_piece(piece)
    if piece.type == :pawn
      #@color.to_s[0].downcase
      str = " " + "\u25ef".encode('utf-8') + " "
      if piece.color == :red
        return str.colorize(:color => :light_red, :background => :light_white)
      else
        return str.colorize(:color => :black, :background => :light_white)
      end
    elsif piece.type == :king
      #@color.to_s[0].upcase
      str = " " + "\u2295".encode('utf-8') + " "
      if piece.color == :red
        return str.colorize(:color => :light_red, :background => :light_white)
      else
        return str.colorize(:color => :black, :background => :light_white)
      end
    end
    str
  end

  def render
    string = ''
    8.times do |i|
      8.times do |j|
        if !@board.proper_moves.include?([i,j])
          print "   ".colorize(:background => :red)
        elsif @board[[i,j]].nil? && @board.proper_moves.include?([i,j])
          print "   ".colorize(:background => :light_white)
        elsif @board[[i,j]].type == :pawn
          print render_piece(@board[[i,j]])
        elsif @board[[i,j]].type == :king
          print render_piece(@board[[i,j]])
        else
          print "   ".colorize(:background => :red)
          print "   ".colorize(:background => :red)
        end
      end
      print "\n"
    end
    string
  end

end