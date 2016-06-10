require 'benchmark'

class WCEngine
  attr_reader :file_lines

  #load the file first so if it has muliple counts, file gets loaded only once

  def initialize(input="")
    # did a quick benchmark with scan and readlines
    # on a ~20MB file
    # both methods load the whole file into memory... it would be
    # better if we could use streams to avoid this.
    #
    # Benchmark.bm do |x|
    #   x.report { File.read(file).scan(/\n/).count }
    #   x.report { File.open(file, "r").readlines.size }
    # end
    #
    # in the end, the readlines method was faster
    # user     system      total        real
    # 0.410000   0.040000   0.450000 (  0.460437) //scan
    # 0.200000   0.060000   0.260000 (  0.245466) // readlines

    # two options, we either get a file, or we get input from stdin
    if File.exists?(input)
      @raw_input = File.open(input,"r").read
    else
      @raw_input = input
    end

  end

  def count_lines
    @raw_input.scan(/\n/).count
  end

  def count_words
    @raw_input.split(" ").length
  end

  def count_chars
    @raw_input.size
  end

  def count_bytes
    @raw_input.bytesize
  end

  # doesn't count newlines in the unix impl
  def count_longest_line_size
    longest_line_size = 0

    @raw_input.split("\n").each do |line|
      longest_line_size = line.strip.size if line.strip.size > longest_line_size
    end

    longest_line_size
  end
end
