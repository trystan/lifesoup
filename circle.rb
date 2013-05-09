
class Circle
  attr_reader :position, :color, :radius

  def initialize
    @position = [rand(500), rand(500)]
    @velocity = [rand(3.0) - 1.0, rand(3.0) - 1.0]
    @color = [rand(128) + 64, rand(128) + 64, rand(128) + 64]
    @radius = 5
  end

  def update
    @position[0] += @velocity[0]
    @position[1] += @velocity[1]
  end
end