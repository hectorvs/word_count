require 'set'

class WordCount

  COMMANDS={
      'l' => 'count_lines',
      '-lines' => 'count_lines',
      'w' => 'count_words',
      '-words' => 'count_words',
      'm' => 'count_chars',
      '-chars' => 'count_chars',
      'c' => 'count_bytes',
      '-bytes' => 'count_bytes',
      'L' => 'count_longest_line_size',
      '-max-line-length' => 'count_longest_line_size'
  }

  attr_reader :commands_to_run, :parsed_options, :files_to_count

  def initialize(arguments=[])

    @commands_to_run = {
        count_lines: false,
        count_words: false,
        count_chars: false,
        count_bytes: false,
        count_longest_line_size: false
    }

    @files_to_count = []
    @parsed_options = Set.new

    arguments.each do |arg|
      parse_argument(arg)
    end

    # if there were no detected options, these are the defaults
    if @parsed_options.size == 0
      @commands_to_run[:count_lines] = true
      @commands_to_run[:count_words] = true
      @commands_to_run[:count_chars] = true
    else

      @parsed_options.each do |opt|
        @commands_to_run[opt.to_sym] = true
      end

    end

  rescue Exception => e
    STDERR.puts e.message
    STDERR.puts "usage..."
    exit(1)
  end

private

  def parse_argument(arg='')

    return parse_options(arg[1..arg.size-1]) if arg[0] == '-'

    raise "File not found: #{arg}" unless File.exists?(arg)

    @files_to_count << arg

  end

  def parse_options(arg)
    if arg[0] == '-' # if it has another -, then it's a longform command
      option = COMMANDS.fetch(arg, false)
      raise "wc: invalid option -- '-#{arg}'" unless option

      # add a parsed option
      @parsed_options.add(option)

    else # if there is no -, then it's one or more single shortform commands
      arg.each_char do |c|
        option = COMMANDS.fetch(c, false)
        raise "wc: invalid option -- '#{c}'" unless option

        @parsed_options.add(option)
      end
    end
  end

end


