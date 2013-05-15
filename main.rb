
require 'rubygame'
require_relative 'settings.rb'
require_relative 'world.rb'
require_relative 'circle.rb'

WIDTH = 600
HEIGHT = 600
COLORS = { :red => [200, 96, 96],
           :yellow => [200, 200, 96],
           :green => [96, 200, 96],
           :blue => [96, 96, 200],
           :purple => [200, 96, 200] }

class Game
  def initialize
    @position = [0,0]
    @screen = Rubygame::Screen.new [WIDTH, HEIGHT], 0, [Rubygame::HWSURFACE, Rubygame::DOUBLEBUF]
    @queue = Rubygame::EventQueue.new
    @clock = Rubygame::Clock.new
    @clock.target_framerate = TARGET_FPS
    @speed = 1
    @zoom = 1.0

    Rubygame::enable_key_repeat 0.5, 0.03

    Rubygame::TTF.setup
    @font = Rubygame::TTF.new(FONT_FILE, 16)

    @world = World.new WIDTH, HEIGHT
    #@world.populate STARTING_POPULATION
    #@world.add_circle Circle.with_parts(WIDTH, HEIGHT, [:red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red, :red])
    @world.add_circle Circle.with_parts(WIDTH, HEIGHT, [:green, :green, :green, :green, :green, :green, :green, :green, :green, :green, :green, :green])
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
          if event.key == Rubygame::K_PLUS || event.key == Rubygame::K_EQUALS
            @speed += 1
          elsif event.key == Rubygame::K_MINUS
            @speed = [@speed - 1, 0].max
          elsif event.key == Rubygame::K_LEFT
            @position[0] = [0, @position[0] - 10.0 / @zoom].max
          elsif event.key == Rubygame::K_DOWN
            @position[1] = [600, @position[1] + 10.0 / @zoom].min
          elsif event.key == Rubygame::K_RIGHT
            @position[0] = [600, @position[0] + 10.0 / @zoom].min
          elsif event.key == Rubygame::K_UP
            @position[1] = [0, @position[1] - 10.0 / @zoom].max
          elsif event.key == Rubygame::K_Z
            @zoom = [0.5, @zoom - 0.1].max
          elsif event.key == Rubygame::K_X
            @zoom = [2.0, @zoom + 0.1].min
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
    x = (circle.position[0] - @position[0]) * @zoom
    y = (circle.position[1] - @position[1]) * @zoom
    r = circle.radius * @zoom
    angle = 0
    diff = (360 / circle.parts.length) * Math::PI / 180

    circle.parts.each do |part|
      from = [x + r * Math::cos(angle), y + r * Math::sin(angle)]
      to = [x + r * Math::cos(angle + diff), y + r * Math::sin(angle + diff)]
      angle += diff
      @screen.draw_line_a from, to, COLORS[part]
    end
  end

  def draw_hud
    @screen.title = "life soup"

    if @speed == 0
      @screen.title += " (paused)"
    elsif @speed > 1
      @screen.title += " (x#{@speed})"
    end

    counts = { :red => 0, :yellow => 0, :green => 0, :blue => 0, :purple => 0 }
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
     "  Blues   #{counts[:blue]}", 
     "  Purples #{counts[:purple]}"].each do |text|
      @font.render(text, false, [250, 250, 250]).blit @screen, [5, y += size]
    end


    @font.render("[-] to slow down, [+] to speed up", false, [250, 250, 250]).blit @screen, [5, 600 - 35]
    @font.render("[z] to zoom out,  [x] to zoom in, arrows to move", false, [250, 250, 250]).blit @screen, [5, 600 - 20]
  end
end

Game.new.run
