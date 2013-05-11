
SECTOR_SIZE = 12

class SectorGrid
  def initialize width, height
    @sectors = Array.new(width / SECTOR_SIZE + 2) { Array.new(height / SECTOR_SIZE + 2) { [] } }
  end

  def nearby circle
    near = []
    offsets.each do |offset|
      col = @sectors[sector_x(circle) + offset[0]]
      next if !col
      sector = col[sector_y(circle) + offset[1]]
      next if !sector
      near += sector
    end
    near
  end

  def offsets
    [[-1,-1],[-1,0],[-1,1],[0,-1],[0,0],[0,1],[1,-1],[1,0],[1,1]]
  end

  def unsector circle
      @sectors[sector_x(circle)][sector_y(circle)].delete circle
  end

  def resector circle
      @sectors[sector_x(circle)][sector_y(circle)] << circle
  end

  def sector_x circle
    return [[circle.position[0] / SECTOR_SIZE + 1, 0].max, @sectors.length - 1].min
  end

  def sector_y circle
    return [[circle.position[1] / SECTOR_SIZE + 1, 0].max, @sectors[0].length - 1].min
  end
end