
SECTOR_SIZE = 12

class SectorGrid
  def initialize width, height
    @sectors = Array.new(width / SECTOR_SIZE + 2) { Array.new(height / SECTOR_SIZE + 2) { [] } }
  end

  def nearby circle
    near = []
    offsets.each do |offset|
      col = @sectors[sectorx(circle) + offset[0]]
      next if !col
      sector = col[sectory(circle) + offset[1]]
      next if !sector
      near += sector
    end
    near
  end

  def offsets
    [[-1,-1],[-1,0],[-1,1],[0,-1],[0,0],[0,1],[1,-1],[1,0],[1,1]]
  end

  def unsector circle
      @sectors[sectorx(circle)][sectory(circle)].delete circle
  end

  def resector circle
      @sectors[sectorx(circle)][sectory(circle)] << circle
  end

  def sectorx circle
    return circle.position[0] / SECTOR_SIZE + 1
  end

  def sectory circle
    return circle.position[1] / SECTOR_SIZE + 1
  end
end