
require_relative 'sector_grid.rb'

class World
  attr_reader :circles

  def initialize width, height
    @width = width
    @height = height
    @sectors = SectorGrid.new width, height
    @circles = []
  end

  def populate count
    count.times do
      add_circle Circle.new(@width, @height)
    end
  end

  def add_circle circle
    @circles << circle
    @sectors.resector circle
  end

  def remove_circle circle
    @circles.delete circle
    @sectors.unsector circle
  end

  def update
    @circles.each do |circle|
      @sectors.unsector circle
      circle.update self
      bounds circle
      collide circle
      if circle.alive?
        @sectors.resector circle
      else
        remove_circle circle
      end
    end
  end

  def bounds circle
    if circle.position[0] - circle.radius < 0
      circle.bounce :west
    elsif circle.position[0] + circle.radius > @width
      circle.bounce :east
    end

    if circle.position[1] - circle.radius < 0
      circle.bounce :north
    elsif circle.position[1] + circle.radius > @height
      circle.bounce :south
    end
  end

  def collide circle
    @sectors.nearby(circle).each do |other|
      circle.collide_with other if circle.intersects?(other)
    end
  end
end
