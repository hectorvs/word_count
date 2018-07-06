require_relative '../lib/wc_option_parser'
require 'rspec'

RSpec.describe WCOptionParser, '#initialize' do
  before(:example) {
    @commands = {
        count_lines: false,
        count_words: false,
        count_chars: false,
        count_bytes: false,
        count_longest_line_size: false,
        help: false
    }
  }
  context 'when user runs the program' do

    it 'will have a default set of counts when no options are passed' do
      w = WCOptionParser.new

      @commands[:count_lines] = true
      @commands[:count_words] = true
      @commands[:count_chars] = true

      expect(w.commands_to_run).to eq @commands
    end
  end
end


RSpec.describe WCOptionParser, '#parse_argument' do
  before(:example) {
    @commands = {
        count_lines: false,
        count_words: false,
        count_chars: false,
        count_bytes: false,
        count_longest_line_size: false,
        help: false
    }
  }

  context 'correct options' do

    context 'shorthand' do

      it 'parses a single option' do
        w = WCOptionParser.new(['-l'])
        @commands[:count_lines] = true
        expect(w.commands_to_run).to eq @commands
      end

      it 'parses multiple options in a single -' do
        w = WCOptionParser.new(['-lc'])

        @commands[:count_lines] = true
        @commands[:count_bytes] = true

        expect(w.commands_to_run).to eq @commands
      end

      it 'parses all options in a single -' do
        w = WCOptionParser.new(['-lwmcL'])

        @commands[:count_lines] = true
        @commands[:count_words] = true
        @commands[:count_bytes] = true
        @commands[:count_chars] = true
        @commands[:count_longest_line_size] = true

        expect(w.commands_to_run).to eq @commands
      end

      it 'parses multiple options with several -' do
        w = WCOptionParser.new(['-l', '-L'])

        @commands[:count_lines] = true
        @commands[:count_longest_line_size] = true

        expect(w.commands_to_run).to eq @commands
      end

      it 'allows repeated options with several -' do
        w = WCOptionParser.new(['-l', '-l'])
        @commands[:count_lines] = true
        expect(w.commands_to_run).to eq @commands
      end

      it 'allows repeated options with one -' do
        w = WCOptionParser.new(['-llcc'])
        @commands[:count_lines] = true
        @commands[:count_bytes] = true
        expect(w.commands_to_run).to eq @commands
      end
    end

    context 'longform options' do
      it 'parses a single longform option' do
        w = WCOptionParser.new(['--lines'])
        @commands[:count_lines] = true
        expect(w.commands_to_run).to eq @commands
      end

      it 'parses a multiple longform option' do
        w = WCOptionParser.new(['--lines', '--bytes'])
        @commands[:count_lines] = true
        @commands[:count_bytes] = true
        
        expect(w.commands_to_run).to eq @commands
      end

      it 'allows a repeated longform option' do
        w = WCOptionParser.new(['--lines', '--lines'])
        @commands[:count_lines] = true
        
        expect(w.commands_to_run).to eq @commands
      end
    end

    context 'mixed options' do
      it 'allows mixed longform and shorthand options' do
        w = WCOptionParser.new(['--lines', '-m'])
        @commands[:count_lines] = true
        @commands[:count_chars] = true
        expect(w.commands_to_run).to eq @commands
      end
    end
    
    context 'repeat mixed options' do
      it 'allows mixed longform and shorthand options' do
        w = WCOptionParser.new(['--lines', '-m'])
        @commands[:count_lines] = true
        @commands[:count_chars] = true
        expect(w.commands_to_run).to eq @commands
      end
    end
  end

  context 'incorrect options' do
    it 'raises an error if it has an unrecognized option' do
      expect { WCOptionParser.new(['-x']) }.to raise_exception(SystemExit)
    end

    it 'raises an error if it has an unrecognized option even if there are valid options as well' do
      expect { WCOptionParser.new(['-lx']) }.to raise_exception(SystemExit)
    end

    it 'raises an error on unkown longform options' do
      expect { WCOptionParser.new(['--some-lines']) }.to raise_exception(SystemExit)
    end
  end

  context 'files' do
    # in the interest of time... it creates a file and deletes it after...
    it "allows only existing files to work" do
      `touch ./some_file`
      w = WCOptionParser.new(['./some_file'])
      expect(w.files_to_count).to eq ['./some_file']
      `rm ./some_file`
    end

    it "allows repeated files" do
      `touch ./some_file`
      w = WCOptionParser.new(['./some_file', './some_file'])
      expect(w.files_to_count).to eq ['./some_file', './some_file']
      `rm ./some_file`
    end

    it 'does not allow inexisting files' do
      expect{WCOptionParser.new(['./does_not_exist'])}.to raise_exception(SystemExit)
    end

  end
end
