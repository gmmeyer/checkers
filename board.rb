# encoding: utf-8

require 'colorize'

class Board

  attr_accessor :board

  def initialize(n_of_pieces = 12, set = true)
    @n_of_pieces = n_of_pieces
    @board = make_board
    if set
      set_board
    end
  end

  def [](pos)
    row, col = pos
    @board[row][col]
  end

  def []=(pos, value)
    row, col = pos
    @board[row][col] = value
  end

  def make_board
    Array.new(8) { Array.new(8) }
  end

  def set_board
    color = :black
    spaces = proper_moves

    2.times do

      @n_of_pieces.times do |i|
        Piece.new(color, spaces[i], self)
      end

      spaces.reverse!
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


  def dup
    dup_board = Board.new(12, false)

    pieces.each do |piece|
      pos = piece.position.dup
      Piece.new(piece.color, pos, dup_board, piece.type)
    end

    dup_board
  end




  def pieces
    @board.flatten.compact
  end

  def move_piece(start_pos, end_pos)
    @board[end_pos[0]][end_pos[1]] = @board[start_pos[0]][start_pos[1]]
    @board[start_pos[0]][start_pos[1]] = nil
  end

end