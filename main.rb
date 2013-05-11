
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
    color = { :red => [255, 64, 64],
              :yellow => [255, 255, 64],
              :green => [64, 255, 64],
              :blue => [64, 64, 255] }

    @screen.fill [0, 0, 16]
    @world.circles.each do |circle|
      #@screen.draw_circle_a circle.position, circle.radius, [128, 128, 128]

      x = circle.position[0]
      y = circle.position[1]
      r = circle.radius
      angle = 0
      diff = (360 / circle.parts.length) * Math::PI / 180

      circle.parts.each do |part|
        from = [x + r * Math::cos(angle), y + r * Math::sin(angle)]
        to = [x + r * Math::cos(angle + diff), y + r * Math::sin(angle + diff)]
        angle += diff
        @screen.draw_line from, to, color[part]
      end
    end
    @screen.flip
  end
end

Game.new.run!
