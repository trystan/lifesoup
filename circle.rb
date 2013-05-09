
class Circle
  attr_reader :position, :color, :radius

  def initialize
    @position = [rand(500), rand(500)]
    @color = [rand(128) + 64, rand(128) + 64, rand(128) + 64]
    @radius = 5
  end

  def update
    @position[0] += rand(5) - 2
    @position[1] += rand(5) - 2
  end
end