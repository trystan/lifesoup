
require 'rubygame'
require_relative 'settings.rb'
require_relative 'world.rb'
require_relative 'circle.rb'

WIDTH = 600
HEIGHT = 600
COLORS = { :red => [200, 96, 96],
           :yellow => [200, 200, 96],
           :green => [96, 200, 96],
           :blue => [96, 96, 200] }

class Game
  def initialize
    @screen = Rubygame::Screen.new [WIDTH, HEIGHT], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = TARGET_FPS
    @speed = 1

    Rubygame::TTF.setup
    @font = Rubygame::TTF.new(FONT_FILE, 16)

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
      @screen.flip
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
    @screen.title = "life soup"

    if @speed > 1
      @screen.title += " (x#{@speed})"
    end

    counts = { :red => 0, :yellow => 0, :green => 0, :blue => 0 }
    @world.circles.each do |circle|
      circle.parts.each do |part|
        counts[part] += 1
      end
    end

    y = 0
    size = 17
    ["Creatures #{@world.circles.length}", 
     "  Reds    #{counts[:red]}", 
     "  Yellows #{counts[:yellow]}", 
     "  Greens  #{counts[:green]}", 
     "  Blues   #{counts[:blue]}"].each do |text|
      @font.render(text, false, [250, 250, 250]).blit @screen, [5, y += size]
    end
  end
end

Game.new.run
