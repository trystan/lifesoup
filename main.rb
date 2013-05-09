
require 'rubygame'
require_relative 'world.rb'
require_relative 'circle.rb'

WIDTH = 500
HEIGHT = 500

class Game
  def initialize
    @screen = Rubygame::Screen.new [WIDTH, HEIGHT], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = 'life soup'

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30
    
    @world = World.new WIDTH, HEIGHT
  end

  def run!
    @running = true
    while @running do
      @world.update
      draw
      events
      @clock.tick
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
    @screen.flip
  end
end

Game.new.run!
