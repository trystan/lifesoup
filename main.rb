
require 'rubygame'
require_relative 'circle.rb'

class Game
  def initialize
    @screen = Rubygame::Screen.new [500, 500]
    @screen.fill [0, 0, 16]

    @queue = Rubygame::EventQueue.new

    @circles = []
    while @circles.length < 100
      @circles << Circle.new
    end
  end

  def run!
    @running = true
    while @running do
      update
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
    @screen.fill [0, 0, 16]
    @circles.each do |circle|
      @screen.draw_circle_a circle.position, circle.radius, circle.color
    end
    @screen.update
  end

  def update
    @circles.each do |circle|
      circle.update
      bounds circle
      collide circle
    end
  end

  def bounds circle
    if circle.position[0] - circle.radius < 0
      circle.bounce :west
    end

    if circle.position[0] + circle.radius > 500
      circle.bounce :east
    end

    if circle.position[1] - circle.radius < 0
      circle.bounce :north
    end

    if circle.position[1] + circle.radius > 500
      circle.bounce :south
    end
  end

  def collide circle
    @circles.each do |other|
      if circle != other && circle.intersects?(other)
        circle.collide other
      end
    end
  end
end

Game.new.run!

