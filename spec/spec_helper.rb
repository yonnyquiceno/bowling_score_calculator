require_relative '../modules/validatable'
require_relative '../modules/checkable'
require_relative '../modules/printable'
require_relative '../classes/scoreboard'
require 'byebug'
require 'i18n'
require_relative '../config/i18n'
I18n.config.available_locales = :es
I18n.locale = :es
I18n.load_path = ['config/locales/es.yml']
I18n.backend.load_translations

def capture_stdout(*)
  old = $stdout
  $stdout = fake = StringIO.new
  yield
  fake.string
ensure
  $stdout = old
end

RSpec.configure do |c|
  c.before { allow($stdout).to receive(:write) } # silencing stdout to avoid noise in the specs results
end
