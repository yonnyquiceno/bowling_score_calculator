require_relative '../modules/validatable'
require_relative '../modules/checkable'
require_relative '../modules/printable'
require_relative '../classes/file_reader'
require_relative '../classes/scoreboard'
require_relative '../classes/frame_recorder'
require 'byebug'
require 'i18n'
require_relative '../config/i18n'

def capture_stdout(*)
  old = $stdout
  $stdout = fake = StringIO.new
  yield
  fake.string
ensure
  $stdout = old
end

RSpec.configure do |c|
  c.before { allow($stdout).to receive(:write) } # silencing stdout to avoid noise in the spec results
end
