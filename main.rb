
require 'rubygame'

class Game
  def initialize
    @screen = Rubygame::Screen.new [500, 500]
    @screen.fill [0, 0, 16]

    @queue = Rubygame::EventQueue.new
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
    @screen.draw_circle [rand(500), rand(500)], 4, [rand(128) + 64, rand(128) + 64, rand(128) + 64]
    @screen.update
  end
end

Game.new.run!

