require 'io/console'
require 'io/wait'

# Make the work with the Raw console mode easier
class RawConsole
  attr_reader :stdin

  def initialize
    @input_buffer = ''

    STDIN.raw do |stdin|
      @stdin = stdin
      yield(self)
    end
  ensure
    STDIN.cooked!
  end

  def puts(str)
    str = str.to_s.gsub("\n", "\r\n")

    print("#{str}\r\n")
  end

  def last_char
    poll_stdin[-1]
  end

  def last_char!
    char = last_char
    @input_buffer = ''

    char
  end

  def poll_stdin
    while (char = stdin.ready? && stdin.sysread(1))
      @input_buffer << char
    end
    @input_buffer
  end
end
