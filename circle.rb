
class Circle
  attr_reader :position, :color, :velocity, :attack_value, :defense_value, :age, :parts
  attr_accessor :health

  def self.with_parts width, height, parts
    c = Circle.new width, height
    c.parts = parts
    c
  end

  def initialize width, height, parent = nil
    if parent
      @position = [parent.position[0] + (rand(31) - 15), parent.position[1] + (rand(31) - 15)]
      @velocity = [parent.velocity[0] + (rand(3.0) - 1.0) / 10, parent.velocity[1] + (rand(3.0) - 1.0) / 10]
      @health = 4.0
      @parts = parent.parts.clone
      mutate
    else
      @position = [rand(width / 10) * 10, rand(height / 10) * 10]
      @velocity = [rand(3.0) - 1.0, rand(3.0) - 1.0]
      @health = 8.0
      @parts = []
      12.times do
        @parts << [:red, :yellow, :green, :blue].sample
      end
    end
    @radius = 6
    @max_speed = 3.0
    @age = 1

    calculate_attributes
  end

  def parts= value
    @parts = value
    calculate_attributes
  end

  def alive?
    @health > 0 && @age < 900
  end

  def radius
    [@radius, @age / 5].min
  end

  def mutate
    @parts[rand(@parts.length)] = [:red, :yellow, :green, :blue].sample
    calculate_attributes
  end

  def calculate_attributes
    @attack_value = 0
    @defense_value = 0
    @plant_value = 0

    @parts.each do |part|
      case part
      when :red
        @attack_value += 1
      when :yellow
        @defense_value += 1
      when :green
        @plant_value += 1
      end
    end
  end

  def update world
    move
    reproduce world

    @health += @plant_value / 12.0 / 30.0
    @age += 1
  end

  def move
    if rand(10) == 1
      @velocity[0] = [[-@max_speed, @velocity[0] + (rand(3.0) - 1.0) / 5.0].max, @max_speed].min
      @velocity[1] = [[-@max_speed, @velocity[1] + (rand(3.0) - 1.0) / 5.0].max, @max_speed].min
    end

    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
  end

  def reproduce world
    return if @health < 10.0

    world.add_circle(Circle.new 100, 100, self)
    @health -= 5
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
    attack other
    bounce_off_of other
  end

  def attack other
    amount = [rand(attack_value) - rand(other.defense_value), 0.0].max / 5.0
    return if amount == 0

    @health += amount * 0.9
    other.health -= amount
  end

  def bounce_off_of other
    # not realistic, but effective
    speed = Math::sqrt(@velocity[1] * @velocity[1] + @velocity[0] * @velocity[0])

    angle = Math::atan2(@position[1] - other.position[1], @position[0] - other.position[0])

    @velocity[0] = speed * Math::cos(angle)
    @velocity[1] = speed * Math::sin(angle)
  end
end
