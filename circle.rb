
class Circle
  attr_reader :position, :color, :radius

  def initialize
    @position = [rand(50 * 10), rand(50) * 10]
    @velocity = [rand(3.0) - 1.0, rand(3.0) - 1.0]
    @color = [rand(128) + 64, rand(128) + 64, rand(128) + 64]
    @radius = 5
    @max_speed = 2.0
  end

  def update
    @velocity[0] = [[-@max_speed, @velocity[0] + (rand(3.0) - 1.0) / 10.0].max, @max_speed].min
    @velocity[1] = [[-@max_speed, @velocity[1] + (rand(3.0) - 1.0) / 10.0].max, @max_speed].min

    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
  end

  def bounce direction
    case direction
    when :west
      @velocity[0] *= -1 if @velocity[0] < 0
    when :east
      @velocity[0] *= -1 if @velocity[0] > 0
    when :north
      @velocity[1] *= -1 if @velocity[1] < 0
    when :south
      @velocity[1] *= -1 if @velocity[1] > 0
    end
  end

  def intersects? other
    dx = position[0]-other.position[0]
    dy = position[1]-other.position[1]
    r2 = radius + other.radius

    dx * dx + dy * dy <= r2 * r2
  end

  def collide other
    collide_once other
    other.collide_once self
  end

  def collide_once other
    # not realistic, but effective
    speed = Math::sqrt(@velocity[1] * @velocity[1] + @velocity[0] * @velocity[0])

    angle = Math::atan2(@position[1] - other.position[1], @position[0] - other.position[0])

    @velocity[0] = (@velocity[0] + speed * Math::cos(angle)) / 2
    @velocity[1] = (@velocity[1] + speed * Math::sin(angle)) / 2
  end
end