require_relative 'core'
require_relative 'draw'
require_relative 'raw_console'

class ConsoleRunner
  KEYS_MAPPING = {
    'a' => :left,
    'd' => :right,
    's' => :down,
    'w' => :up,
    'q' => :quit
  }.freeze

  FRAMES_PER_SECOND = 10

  def self.call
    new.call
  end

  def call
    RawConsole.new do |console|
      game.start

      initial_countdown(console)

      loop do
        sleep 1.0 / FRAMES_PER_SECOND

        command = pluck_command(console)
        break if command == 'quit'

        command ? game.move(command) : game.next
        draw(console)
      end
    end
  end

  private

  def game
    @game ||= Game.new
  end

  def initial_countdown(console)
    system('clear')

    3.downto(1).each do |i|
      console.puts i
      sleep 1
    end
  end

  def draw(console)
    system('clear')
    console.puts Draw.new(game)
  end

  def pluck_command(console)
    last_key = console.last_char!

    KEYS_MAPPING[last_key.to_s]
  end
end
