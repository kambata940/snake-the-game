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

  SPEED_LEVEL = 2 # possible values: [1, 2, 3]

  def self.call
    new.call
  end

  def call
    RawConsole.new do |console|
      game.start

      initial_countdown(console)

      command = nil
      each_frame do |tick|
        last_command = pluck_command(console)
        command = last_command if last_command

        break if command == :quit

        if (tick % SPEED_LEVEL).zero?
          command ? game.move(command) : game.next
          draw(console)
        end
      end
    end
  end

  private

  def game
    @game ||= Game.new
  end

  def each_frame
    tick = 0
    loop do
      sleep 1.0 / 24
      yield(tick % 24 + 1)

      tick += 1
    end
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
