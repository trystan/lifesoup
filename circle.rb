require_relative 'physical.rb'

class Circle
  attr_reader :attack_value, :defense_value, :age, :parts
  attr_accessor :health

  include Physical

  def self.with_parts width, height, parts
    c = Circle.new width, height
    c.parts = parts
    c
  end

  def initialize width, height, parent = nil
    @radius = DEFAULT_RADIUS
    @max_speed = DEFAULT_MAX_SPEED
    @age = 1
    
    if parent
      inherit_genes parent
      mutate
    else
      random_genes width, height
    end

    calculate_attributes
    @health = @child_cost_value
  end

  def inherit_genes parent
    @position = [parent.position[0] + (rand(21) - 10), parent.position[1] + (rand(21) - 10)]
    @velocity = [parent.velocity[0] + (rand(3.0) - 1.0) / 10, parent.velocity[1] + (rand(3.0) - 1.0) / 10]
    @parts = parent.parts.clone
  end

  def random_genes width, height
    @position = [rand(width), rand(height)]
    @velocity = [(rand(3.0) - 1.0) * @max_speed, (rand(3.0) - 1.0) * @max_speed]
    @parts = []
    12.times do
      @parts << [:red, :yellow, :green, :blue, :purple].sample
    end
  end

  def parts= value
    @parts = value
    calculate_attributes
  end

  def alive?
    @health > 0 && @age <  @max_age_value
  end

  def radius
    [@radius, @age / 5].min
  end

  def mutate
    @parts[rand(@parts.length)] = [:red, :yellow, :green, :blue, :purple].sample
    calculate_attributes
  end

  def calculate_attributes
    @attack_value = 0
    @defense_value = 0
    @plant_value = 0
    @child_cost_value = HEALTH_LOST_TO_REPRODUCE
    @max_age_value = MAX_AGE

    @parts.each do |part|
      case part
      when :red
        @attack_value += RED_EFFECTIVENESS
      when :yellow
        @defense_value += YELLOW_EFFECTIVENESS
      when :green
        @plant_value += GREEN_EFFECTIVENESS
      when :blue
        @child_cost_value -= BLUE_EFFECTIVENESS
      when :purple
        @max_age_value += PURPLE_EFFECTIVENESS
      end
    end
  end

  def update world
    move
    reproduce world

    @health -= HEALTH_LOSS_PER_SECOND / 30.0
    @health += @plant_value / 30.0
    @age += 1
  end

  def reproduce world
    return if @health < HEALTH_REQUIRED_TO_REPRODUCE

    world.add_circle(Circle.new 100, 100, self)
    @health -= @child_cost_value
  end

  def collide_with other
    attack other
    bounce_off_of other
    other.attack self
    other.bounce_off_of self
  end

  def attack other
    amount = [(rand(attack_value) - rand(other.defense_value)), 0.0].max
    amount = [amount, other.health].min
    @health += amount * 0.9
    other.health -= amount
  end
end
