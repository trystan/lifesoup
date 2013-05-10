
require_relative 'sector_grid.rb'

class World
  attr_reader :circles

  def initialize width, height
    @width = width
    @height = height
    @sectors = SectorGrid.new width, height

    @circles = []
    500.times do
      c = Circle.new(@width, @height)
      @circles << c
      @sectors.resector c
    end
  end

  def update
    @circles.each do |circle|
      @sectors.unsector circle
      circle.update
      bounds circle
      collide circle
      @sectors.resector circle
    end
    @circles = @circles.select { |c| c.alive? }
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
