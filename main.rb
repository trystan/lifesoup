
require 'rubygame'

class Game
  def initialize
    @screen = Rubygame::Screen.new [500, 500]
    @screen.fill [0, 0, 16]
    @screen.update

    @queue = Rubygame::EventQueue.new
  end

  def run!
    @running = true
    while @running do
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
end

Game.new.run!

