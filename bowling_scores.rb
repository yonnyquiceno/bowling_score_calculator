require 'optparse'
require './modules/validatable'
require './modules/checkable'
require './modules/calculable'
require './modules/printable'
require './classes/scoreboard'
require 'byebug'
require 'i18n'
I18n.config.available_locales = :es
I18n.locale = :es
I18n.load_path = ['config/locales/es.yml']
I18n.backend.load_translations

OptionParser.new do |parser|
  parser.banner = 'Usage: bowling-scores.rb [options]'
  parser.on('-f', '--filename FILE_NAME', 'The name of the scores text file (with extension).') do |filename|
    ScoreBoard.game_score(filename)
  end
  parser.on('-h', '--help', 'Show this help message') do
    puts parser
  end
end.parse!
