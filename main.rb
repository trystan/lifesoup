
require 'rubygame'
require_relative 'world.rb'
require_relative 'circle.rb'

WIDTH = 600
HEIGHT = 600
COLORS = { :red => [255, 64, 64],
           :yellow => [255, 255, 64],
           :green => [64, 255, 64],
           :blue => [64, 64, 255] }

class Game
  def initialize
    @screen = Rubygame::Screen.new [WIDTH, HEIGHT], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @screen.title = 'life soup'

    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = 30

    @world = World.new WIDTH, HEIGHT
    @speed = 1
  end

  def run
    @running = true
    while @running do
      events
      @speed.times do
        @world.update
      end
      draw
      draw_hud
      @clock.tick
    end
    Rubygame.quit
  end

  def events
    @queue.each do |event|
      case event
        when Rubygame::QuitEvent
          @running = false
        when Rubygame::KeyDownEvent
          if event.key == 61
            @speed += 1
          elsif event.key == 45
            @speed = [@speed - 1, 1].max
          end
      end
    end
  end

  def draw
    @screen.fill [0, 0, 16]
    @world.circles.each do |circle|
      draw_circle circle
    end
    @screen.flip
  end

  def draw_circle circle
    x = circle.position[0]
    y = circle.position[1]
    r = circle.radius
    angle = 0
    diff = (360 / circle.parts.length) * Math::PI / 180

    circle.parts.each do |part|
      from = [x + r * Math::cos(angle), y + r * Math::sin(angle)]
      to = [x + r * Math::cos(angle + diff), y + r * Math::sin(angle + diff)]
      angle += diff
      @screen.draw_line from, to, COLORS[part]
    end
  end

  def draw_hud
    @screen.title = 'life soup - ' + @world.circles.length.to_s + ' creatures'

    if @speed > 1
      @screen.title += ' (x' + @speed.to_s + ')'
    end
  end
end

Game.new.run
