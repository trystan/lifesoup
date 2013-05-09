
SECTOR_SIZE = 10

class SectorGrid
  def initialize width, height
    @sectors = Array.new(width / SECTOR_SIZE) { Array.new(height / SECTOR_SIZE) { [] } }
  end

  def nearby circle
    near = []
    x = circle.position[0] / SECTOR_SIZE
    y = circle.position[1] / SECTOR_SIZE
    offsets.each do |offset|
      col = @sectors[x + offset[0]]
      next if !col
      sector = col[y + offset[1]]
      next if !sector
      sector.each do |other|
        near << other
      end
    end
    near
  end

  def offsets
    [[-1,-1],[-1,0],[-1,1],[0,-1],[0,0],[0,1],[1,-1],[1,0],[1,1]]
  end

  def unsector circle
      @sectors[circle.position[0]/SECTOR_SIZE][circle.position[1]/SECTOR_SIZE].delete circle
  end

  def resector circle
      @sectors[circle.position[0]/SECTOR_SIZE][circle.position[1]/SECTOR_SIZE] << circle
  end
end