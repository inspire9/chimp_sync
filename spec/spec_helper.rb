require 'bundler'

Bundler.setup :default, :development

require 'rails'
require 'combustion'
require 'chimp_sync'

Combustion.initialize! :action_controller, :active_record

require 'rspec/rails'

RSpec.configure do |config|
  config.use_transactional_fixtures = true
end
