# frozen_string_literal: true

require 'spec_helper'

describe Printable do
  let(:dummy_class) do
    Class.new do
      extend Printable
    end
  end
  let(:values) { %w[3 7 6 F 10] }
  let(:game_scoreboard) do
    {
      'Jeff': {
        pinfalls: [' ', 'X', '7', '/', '9', 0, ' ', 'X', '0', 8, '8', '/', 'F', 6, ' ', 'X', ' ', 'X', 'X', 8, 1],
        scores: [20, 39, 48, 66, 74, 84, 90, 120, 148, 167]
      },
      'John': {
        pinfalls: ['3', '/', '6', 3, ' ', 'X', '8', 1, ' ', 'X', ' ', 'X', '9', 0, '7', '/', '4', 4, 'X', 9, 0],
        scores: [16, 25, 44, 53, 82, 101, 110, 124, 132, 151]
      }
    }
  end

  describe '#printable' do
    it 'prints the game results' do
      printed = capture_stdout do
        dummy_class.send(:print_results, game_scoreboard)
      end
      expect(printed).to include(
        'Jeff',
        'John',
        'Score   20      39      ',
        'Pinfalls    X   7   /   9   0       X   0'
      )
    end
  end

  describe '#prin_errors' do
    it 'prints to STDOUT all the errors form @errors' do
      dummy_class.instance_variable_set(:@errors, ['first error', 'second error', 'last error'])
      printed = capture_stdout do
        dummy_class.send(:print_errors)
      end
      expect(printed).to eq("\"first error\"\n\"second error\"\n\"last error\"\n")
    end
  end

  describe '#format_output_line' do
    it 'formats the output line before sending it to STDOUT' do
      expect(dummy_class.send(:format_output_line, 5, 'FCol', values))
        .to eq('FCol    3    7    6    F    10   ')
    end
  end
end
