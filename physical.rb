module Physical
  attr_reader :position, :velocity

  def move
    brownian_motion
    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
  end

  def brownian_motion
    @velocity[0] = [[-@max_speed, @velocity[0] + (rand(3.0) - 1.0) / 5.0].max, @max_speed].min
    @velocity[1] = [[-@max_speed, @velocity[1] + (rand(3.0) - 1.0) / 5.0].max, @max_speed].min
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

  def distance_squared_to other
    dx = position[0] - other.position[0]
    dy = position[1] - other.position[1]
    
    dx * dx + dy * dy
  end

  def intersects? other
    return false if other == self

    distance_squared_to(other) <= (radius + other.radius) * (radius + other.radius)
  end

  def bounce_off_of other
    # not realistic, but effective
    speed = Math::sqrt(@velocity[1] * @velocity[1] + @velocity[0] * @velocity[0])

    angle = Math::atan2(@position[1] - other.position[1], @position[0] - other.position[0])

    @velocity[0] = speed * Math::cos(angle)
    @velocity[1] = speed * Math::sin(angle)
  end
end