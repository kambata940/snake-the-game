class Draw
  BoardPixel = Struct.new(:x, :y, :to_s)
  BorderPixel = Struct.new(:to_s)

  CELL_TO_SYMBOL = {
    empty: ' ',
    snake: '*',
    award: '@',
    border: '#'
  }.freeze

  attr_reader :board, :snake, :award

  def initialize(game)
    @board = game.board
    @snake = game.snake
    @award = game.award
  end

  def pixel_board
    board.map do |(x, y)|
      case [x, y]
      when award then BoardPixel.new(x, y, '@')
      when *snake.body then BoardPixel.new(x, y, '*')
      else BoardPixel.new(x, y, ' ')
      end
    end
  end

  def pixel_matrix
    pixel_board.group_by(&:y).values
  end

  def pixel_matrix_with_border
    upper_border = Array.new(board.size, border_pixel)
    lower_border = Array.new(board.size, border_pixel)

    pixel_matrix.unshift(upper_border)
                .push(lower_border)
                .map do |row|
                  row.unshift(border_pixel).push(border_pixel)
                end
  end

  def to_s
    pixel_matrix_with_border.map { |row| "#{row.join}\n" }.join
  end

  def border_pixel
    BorderPixel.new('#')
  end
end
# game = Game.new
# game.next()
# game.next()
