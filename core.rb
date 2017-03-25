class Game
  attr_reader :board, :snake, :award

  def initialize
    @board = Board.new(30)
    @snake = Snake.new(5)
  end

  def start
    set_award
    self
  end

  def move(direction = nil)
    head = snake.move(direction)

    raise 'Self eaten! Game Over :(' if snake.selfeaten?

    case head
    when award
      snake.grow
      set_award
    when *board
      nil
    else
      raise 'Border hit! Game Over :('
    end
  end

  alias next move

  def set_award
    empty_cells = board.reject { |coordinate| snake.body.include?(coordinate) }

    @award, * = empty_cells.sample(1)
  end
end

class Snake
  OFFSET_BY_DIRECTION = {
    right: [1, 0],
    left: [-1, 0],
    up: [0, -1],
    down: [0, 1]
  }.freeze

  attr_reader :direction, :body, :trace

  def initialize(size, direction: :right)
    @direction = direction
    @body = Array.new(size) { |i| [i, 0] } # array of coordinates [x,y]
    @trace = [] # stack of coordinates [x, y]
  end

  def move(new_direction = nil)
    @direction = new_direction if new_direction

    new_head = next_head

    body.push(new_head)
    trace.push(body.shift)

    new_head
  end

  def grow
    body.unshift(trace.pop)
  end

  def selfeaten?
    body.uniq.size < body.size
  end

  def head
    body.last
  end

  def next_head
    offset_x, offset_y = OFFSET_BY_DIRECTION[direction]
    head_x, head_y = head

    [head_x + offset_x, head_y + offset_y]
  end
end

class Board
  include Enumerable

  attr_reader :size

  def initialize(size)
    @size = size
    @elements = (0..(size - 1)).flat_map do |y|
      (0..(size - 1)).map { |x| [x, y] }
    end
  end

  def each(&block)
    @elements.each(&block)
  end
end
