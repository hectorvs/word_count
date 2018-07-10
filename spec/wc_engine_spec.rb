require_relative '../lib/wc_engine'
require 'rspec'

RSpec.describe WCEngine, '#count_lines' do
  it "should count the newlines in a file" do
    test_file = "./some_file"

    File.open(test_file, "w") do |f|
      f.puts "one new line"
      f.puts "two new lines"
    end
    
    

    wc = WCEngine.new(test_file)
    lines = wc.count_lines
    expect(lines).to eq 2

    File.delete(test_file)
  end

  it "should count lines in an empty file as 0" do
    `touch ./some_file`
    wc = WCEngine.new("./some_file")

    lines = wc.count_lines
    expect(lines).to eq 0
    `rm ./some_file`
  end
  
  it "repeat should count lines in an empty file as 0" do
    `touch ./some_file`
    wc = WCEngine.new("./some_file")

    lines = wc.count_lines
    expect(lines).to eq 0
    `rm ./some_file`
  end

  it "should also read a string" do
    wc = WCEngine.new("this is some string\nanother line\n")
    line_count = wc.count_lines
    expect(line_count).to eq 2
  end

  it "should not count the last line if it does not have a newline" do
    test_file = "./some_file"

    File.open(test_file, "w") do |f|
      f.puts "one new line"
      f.puts "two new lines"
      f.write "no new line"
    end

    wc = WCEngine.new(test_file)
    lines = wc.count_lines

    expect(lines).to eq 2

    File.delete(test_file)
  end
end

RSpec.describe WCEngine, '#count_bytes' do
  it "should count the bytes in a file" do

    test_file = "./some_bin_file"

    # write 2 bytes to the file...
    File.open(test_file, "wb") do |f|
      f.write "\xFF\xFF"
    end

    wc = WCEngine.new(test_file)
    bytes = wc.count_bytes
    expect(bytes).to eq 2

    File.delete(test_file)
  end

  it "should count unicode chars as multi byte" do
    test_file = "./some_file"

    # 3 bytes per char
    File.open(test_file, "w") do |f|
      f.write "中英字典"
    end

    wc = WCEngine.new(test_file)

    chars = wc.count_bytes
    expect(chars).to eq 12

    File.delete("./some_file")
  end

  it "should count bytes in an empty file as 0" do
    `touch ./some_file`
    wc = WCEngine.new("./some_file")

    lines = wc.count_bytes
    expect(lines).to eq 0
    `rm ./some_file`
  end
end

RSpec.describe WCEngine, '#count_chars' do
  it "should count the chars in a file" do
    test_file = "./some_file"

    File.open(test_file, "w") do |f|
      f.puts "12345"  #5 chars + new line
      f.puts "12345"  #5 chars + new line
    end

    wc = WCEngine.new(test_file)
    chars = wc.count_chars
    expect(chars).to eq 12

    File.delete(test_file)
  end

  it "should count unicode chars as single chars" do
    test_file = "./some_file"

    File.open(test_file, "w") do |f|
      f.write "中英字典"  #4
    end

    wc = WCEngine.new(test_file)
    chars = wc.count_chars
    expect(chars).to eq 4

    File.delete(test_file)
  end

  it "should count chars in an empty file as 0" do
    `touch ./some_file`
    wc = WCEngine.new("./some_file")

    lines = wc.count_chars
    expect(lines).to eq 0
    `rm ./some_file`
  end
end

RSpec.describe WCEngine, '#count_words' do

  it "should count the words in a file" do

    test_file = "./some_file"

    File.open(test_file, "w") do |f|
      f.puts "this are four words"
      f.puts "" # no words
      f.puts "four more words here"
    end

    wc = WCEngine.new(test_file)
    word_count = wc.count_words
    expect(word_count).to eq 8

    File.delete(test_file)

  end

  it "should give 0 on empty file" do
    `touch ./some_file`

    wc = WCEngine.new("./some_file")
    word_count = wc.count_words
    expect(word_count).to eq 0

    `rm ./some_file`
  end
end

RSpec.describe WCEngine, "#count_longest_line_size" do
  it "should give you the number of chars in the longest line" do

    test_file = "./some_file"

    File.open(test_file, "w") do |f|
      f.puts "this line is of longer than the rest"
      f.puts "" # no words
      f.puts "four more words here"
    end

    wc = WCEngine.new(test_file)
    word_count = wc.count_longest_line_size
    expect(word_count).to eq 36

    File.delete(test_file)
  end
end
