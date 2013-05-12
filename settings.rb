
TARGET_FPS = 30
STARTING_POPULATION = 50

DEFAULT_RADIUS = 6
DEFAULT_MAX_SPEED = 2.0
STARTING_HEALTH = 10.0
HEALTH_LOSS_PER_SECOND = 0.1
HEALTH_REQUIRED_TO_REPRODUCE = 20.0
HEALTH_LOST_TO_REPRODUCE = 10.0
MAX_AGE = 900
ATTACK_EFFECTIVENESS = 0.25

SECTOR_SIZE = DEFAULT_RADIUS * 2


fonts = ['/Library/Fonts/Courier New.ttf']

FONT_FILE = fonts.select { |path| File.exists?(path) } .first