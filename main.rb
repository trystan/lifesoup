
require 'rubygame'

screen = Rubygame::Screen.new [500, 500]
screen.fill [0, 0, 16]
screen.update

queue = Rubygame::EventQueue.new

running = true
while running do
  queue.each do |event|
    case event
      when Rubygame::QuitEvent
        running = false
    end
  end
end

Rubygame.quit
