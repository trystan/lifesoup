
class Circle
  attr_reader :position, :color, :radius

  def alive?
    @alive
  end

  def initialize width, height
    @position = [rand(width / 10) * 10, rand(height / 10) * 10]
    @velocity = [rand(3.0) - 1.0, rand(3.0) - 1.0]
    @radius = 4
    @max_speed = 1.0
    @rps = [:rock, :paper, :scisors].sample
    @alive = true
    
    case @rps
    when :rock
      @color = [192, 32, 32]
    when :paper
      @color = [32, 192, 32]
    when :scisors
      @color = [32, 32, 192]
    end
  end

  def update
    if rand(10) == 1
      @velocity[0] = [[-@max_speed, @velocity[0] + (rand(3.0) - 1.0) / 5.0].max, @max_speed].min
      @velocity[1] = [[-@max_speed, @velocity[1] + (rand(3.0) - 1.0) / 5.0].max, @max_speed].min
    end

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
    return false if other == self

    dx = position[0]-other.position[0]
    dy = position[1]-other.position[1]
    r2 = radius + other.radius

    dx * dx + dy * dy <= r2 * r2
  end

  def collide_with other
    attack other
    bounce_off_of other
  end

  def attack other
    @alive = false if other.beats? @rps
  end

  def beats? other_rps
    @rps == :rock && other_rps == :scisors || @rps == :scisors && other_rps == :paper || @rps == :paper && other_rps == :rock
  end

  def bounce_off_of other
    # not realistic, but effective
    speed = Math::sqrt(@velocity[1] * @velocity[1] + @velocity[0] * @velocity[0])

    angle = Math::atan2(@position[1] - other.position[1], @position[0] - other.position[0])

    @velocity[0] = (@velocity[0] + speed * Math::cos(angle) * 2) / 3
    @velocity[1] = (@velocity[1] + speed * Math::sin(angle) * 2) / 3
  end
end
