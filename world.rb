
class World
  attr_reader :circles

  def initialize width, height
    @width = width
    @height = height

    @circles = []
    while @circles.length < 100
      @circles << Circle.new(@width, @height)
    end
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

    if circle.position[0] + circle.radius > WIDTH
      circle.bounce :east
    end

    if circle.position[1] - circle.radius < 0
      circle.bounce :north
    end

    if circle.position[1] + circle.radius > HEIGHT
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
