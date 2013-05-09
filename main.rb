
require 'rubygame'
require_relative 'circle.rb'

class Game
  def initialize
    @screen = Rubygame::Screen.new [500, 500]
    @screen.fill [0, 0, 16]

    @queue = Rubygame::EventQueue.new

    @circles = []
    while @circles.length < 100
      @circles << Circle.new
    end
  end

  def run!
    @running = true
    while @running do
      draw
      events
    end
  end

  def events
    @queue.each do |event|
      case event
        when Rubygame::QuitEvent
          Rubygame.quit
          @running = false
      end
    end
  end

  def draw
    @circles.each do |circle|
      @screen.draw_circle circle.position, circle.radius, circle.color
    end
    @screen.update
  end
end

Game.new.run!

