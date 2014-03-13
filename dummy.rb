# encoding: utf-8
require 'colorize'
require_relative 'checkers'
require_relative 'board'
require_relative 'piece'
require_relative 'render'


a = Board.new
render = Render.new(a)
render.render

g = a.dup

a[[2,5]].perform_moves([[2,5],[3,6]])

render.render