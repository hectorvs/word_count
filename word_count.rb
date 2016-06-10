class WordCount
  attr_reader :commands

  def initialize
    @commands = {
        c: "count_bytes",
        bytes: "count_bytes",
        m: "count_chars",
        chars: "count_chars",
        l: "count_lines",
        lines: "count_lines",
        L: "longest_line_size",
        maxlinelength: "longest_line_size",
        w: "count_words",
        words: "count_words",
    }
  end

  def parse_options(args=[])



  end

end

wc = WordCount.new

puts ARGV.inspect

wc.parse_options(ARGV)

puts ARGV.inspect

