
require 'rubygame'
require_relative 'world.rb'
require_relative 'circle.rb'

WIDTH = 600
HEIGHT = 600

class Game
  def initialize
    @screen = Rubygame::Screen.new [WIDTH, HEIGHT], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = 'life soup'

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 300

    @world = World.new WIDTH, HEIGHT
  end

  def run!
    @running = true
    while @running do
      10.times do
        @world.update
      end
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
    @world.foods.each do |food|
      @screen.draw_circle_a food, 2, [32, 200, 32]
    end
    @world.circles.each do |circle|
      @screen.draw_circle_a circle.position, circle.radius, circle.color
    end
    @screen.flip
  end
end

Game.new.run!
