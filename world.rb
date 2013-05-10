
require_relative 'sector_grid.rb'

class World
  attr_reader :circles, :foods

  def initialize width, height
    @width = width
    @height = height
    @sectors = SectorGrid.new width, height

    @foods = []

    @circles = []
    500.times do
      add_circle Circle.new(@width, @height)
    end
  end

  def add_circle circle
    @circles << circle
    @sectors.resector circle
  end

  def update
    if @foods.length < 20
      @foods << [rand(@width), rand(@height)]
    end
    @circles.each do |circle|
      @sectors.unsector circle
      circle.update self
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
    @foods.each do |food|
      if circle.intersects_food? food
        circle.eat food
        @foods.delete food
      end
    end
    @sectors.nearby(circle).each do |other|
      circle.collide_with other if circle.intersects?(other)
    end
  end
end
