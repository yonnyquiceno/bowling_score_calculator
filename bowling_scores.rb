# frozen_string_literal: true

require 'optparse'
require './modules/validatable'
require './modules/checkable'
require './modules/printable'
require './classes/file_reader'
require './classes/scoreboard'
require './classes/frame_recorder'
require 'byebug'
require 'i18n'
require './config/i18n'

OptionParser.new do |parser|
  parser.banner = 'Usage: bowling-scores.rb [options]'
  parser.on('-f', '--filename FILE_NAME', 'The name of the scores text file (with extension).') do |filename|
    ScoreBoard.new(filename).game_score
  end
  parser.on('-h', '--help', 'Show this help message') do
    puts parser
  end
end.parse!
