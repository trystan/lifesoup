
require 'rubygame'
require_relative 'settings.rb'
require_relative 'world.rb'
require_relative 'circle.rb'

WIDTH = 600
HEIGHT = 600
COLORS = { :red => [255, 96, 96],
           :yellow => [255, 255, 96],
           :green => [96, 255, 96],
           :blue => [96, 96, 255] }

class Game
  def initialize
    @screen = Rubygame::Screen.new [WIDTH, HEIGHT], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = TARGET_FPS
    @speed = 1

    Rubygame::TTF.setup
    @font = Rubygame::TTF.new('/Library/Fonts/Times New Roman.ttf', 14)

    @world = World.new WIDTH, HEIGHT
    @world.populate STARTING_POPULATION
    #@world.add_circle Circle.with_parts(WIDTH, HEIGHT, [:red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red])
    #@world.add_circle Circle.with_parts(WIDTH, HEIGHT, [:green, :green, :green, :green, :green, :green, :green, :green, :green, :green, :green, :green])
  end

  def run
    @running = true
    while @running do
      @speed.times do
        events
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
    @screen.title = "life soup - #{@world.circles.length} creatures"

    if @speed > 1
      @screen.title += " (x#{@speed.to_s})"
    end

    text = @font.render 'Test', true, [123, 123, 123]
    text.blit @screen, [10, 10]
  end
end

Game.new.run
