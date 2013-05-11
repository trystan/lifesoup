
class Circle
  attr_reader :position, :color, :radius, :velocity, :parts

  def alive?
    @health > 0
  end

  def initialize width, height, parent = nil
    if parent
      @position = [parent.position[0] + (rand(11) - 5), parent.position[1] + (rand(11) - 5)]
      @velocity = [parent.velocity[0] + (rand(3.0) - 1.0) / 10, parent.velocity[1] + (rand(3.0) - 1.0) / 10]
      @health = 5.0
      @parts = parent.parts.copy
    else
      @position = [rand(width / 10) * 10, rand(height / 10) * 10]
      @velocity = [rand(3.0) - 1.0, rand(3.0) - 1.0]
      @health = 10
      @parts = []
      24.times do
        @parts << [:red, :yellow, :green, :blue].sample
      end
    end
    @radius = 24
    @max_speed = 1.0
  end

  def update world
    if rand(10) == 1
      @velocity[0] = [[-@max_speed, @velocity[0] + (rand(3.0) - 1.0) / 5.0].max, @max_speed].min
      @velocity[1] = [[-@max_speed, @velocity[1] + (rand(3.0) - 1.0) / 5.0].max, @max_speed].min
    end

    @position[0] += @velocity[0]
    @position[1] += @velocity[1]

    if @health > 10.0
      world.add_circle(Circle.new 100, 100, self)
      @health -= 5.0
    end
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
    return false if other == self

    dx = position[0] - other.position[0]
    dy = position[1] - other.position[1]
    r2 = radius + other.radius

    dx * dx + dy * dy <= r2 * r2
  end

  def collide_with other
    # attack other
    bounce_off_of other
  end

  def attack other
    @health -= 5
  end

  def bounce_off_of other
    # not realistic, but effective
    speed = Math::sqrt(@velocity[1] * @velocity[1] + @velocity[0] * @velocity[0])

    angle = Math::atan2(@position[1] - other.position[1], @position[0] - other.position[0])

    @velocity[0] = speed * Math::cos(angle)
    @velocity[1] = speed * Math::sin(angle)
  end
end
