require_relative 'core'
require_relative 'draw'

module ConsoleRunner
  KEYS_MAPPING = {
    'a' => :left,
    'd' => :right,
    's' => :down,
    'w' => :up
  }.freeze

  class << self
    def call
      game = Game.new
      game.start

      initial_countdown

      loop do
        draw(game)
        command = read_last_char.chomp
        direction = KEYS_MAPPING[command]

        direction ? game.move(direction) : game.next

        sleep 0.5
      end
    end

    def initial_countdown
      system('clear')

      3.downto(1).each do |i|
        puts i
        sleep 1
      end
    end

    def read_last_char
      STDIN.read_nonblock(1)
    rescue IO::EAGAINWaitReadable
      ''
    end

    def draw(game)
      system('clear')
      puts Draw.new(game)
    end
  end
end
