
SECTOR_SIZE = 10

class World
  attr_reader :circles

  def initialize width, height
    @width = width
    @height = height

    @sectors = Array.new(width / SECTOR_SIZE) { Array.new(height / SECTOR_SIZE) { [] } }

    @circles = []
    500.times do
      c = Circle.new(@width, @height)
      @circles << c
      resector c
    end
  end

  def update
    @circles.each do |circle|
      unsector circle
      circle.update
      bounds circle
      collide circle
      resector circle
    end
  end

  def bounds circle
    if circle.position[0] - circle.radius < 0
      circle.bounce :west
    elsif circle.position[0] + circle.radius > WIDTH
      circle.bounce :east
    end

    if circle.position[1] - circle.radius < 0
      circle.bounce :north
    elsif circle.position[1] + circle.radius > HEIGHT
      circle.bounce :south
    end
  end

  def collide circle
    nearby(circle).each do |other|
      circle.collide_with other if circle.intersects?(other)
    end
  end

  def nearby circle
    near = []
    x = circle.position[0] / SECTOR_SIZE
    y = circle.position[1] / SECTOR_SIZE
    offsets = [[-1,-1],[-1,0],[-1,1],[0,-1],[0,0],[0,1],[1,-1],[1,0],[1,1]]
    offsets.each do |offset|
      col = @sectors[x + offset[0]]
      next if !col
      sector = col[y + offset[1]]
      next if !sector
      sector.each do |other|
        near << other
      end
    end
    near
  end

  def unsector circle
      @sectors[circle.position[0]/SECTOR_SIZE][circle.position[1]/SECTOR_SIZE].delete circle
  end

  def resector circle
      @sectors[circle.position[0]/SECTOR_SIZE][circle.position[1]/SECTOR_SIZE] << circle
  end
end
