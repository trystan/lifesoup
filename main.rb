
require 'rubygame'
require_relative 'world.rb'
require_relative 'circle.rb'

WIDTH = 500
HEIGHT = 500

class Game
  def initialize
    @screen = Rubygame::Screen.new [WIDTH, HEIGHT]
    @screen.fill [0, 0, 16]

    @queue = Rubygame::EventQueue.new
    @world = World.new WIDTH, HEIGHT
  end

  def run!
    @running = true
    while @running do
      @world.update
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
    @screen.fill [0, 0, 16]
    @world.circles.each do |circle|
      @screen.draw_circle_a circle.position, circle.radius, circle.color
    end
    @screen.update
  end
end

Game.new.run!
