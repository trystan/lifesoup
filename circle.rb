
class Circle
  attr_reader :position, :color, :radius

  def initialize
    @position = [rand(500), rand(500)]
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
end