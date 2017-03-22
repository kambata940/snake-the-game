require 'timeout'
require 'io/console'

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
        command = wait(0.1) { STDIN.getch }
        direction = KEYS_MAPPING[command.to_s]

        direction ? game.move(direction) : game.next
      end
    end

    def initial_countdown
      system('clear')

      3.downto(1).each do |i|
        puts i
        sleep 1
      end
    end

    def draw(game)
      system('clear')
      puts Draw.new(game)
    end

    def wait(seconds)
      start_time = Time.new
      result = Timeout.timeout(seconds) { yield }
      end_time = Time.new

      time_diff = end_time.to_f - start_time.to_f
      sleep seconds - time_diff

      result
    rescue Timeout::Error
      nil
    end
  end
end
