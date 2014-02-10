$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'vcr'
require 'webmock/rspec'
require 'edmodo'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

WebMock.disable_net_connect!


VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_tapes'
  c.hook_into :webmock
  c.configure_rspec_metadata!
  c.default_cassette_options = {
    #record:                      (ENV['TRAVIS'] ? :none : :once)
    #record:                      :new_episodes
    #record:                      :all
    record:                      :none
  }

  c.filter_sensitive_data("<EDMODO_API_KEY>") do
    edmodo_api_key
  end

  c.filter_sensitive_data("<EDMODO_ACCESS_TOKEN>") do
      edmodo_access_token
  end
end

RSpec.configure do |config|
  config.include EdmodoHelpers
  config.color_enabled = true
  config.tty = true
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.order = "random"
end


def edmodo_api_key
  ENV.fetch 'EDMODO_API_KEY', 'x' * 40
end

def edmodo_access_token
  ENV.fetch 'EDMODO_ACCESS_TOKEN', 'atok_xxxxxxxxxxxxxxxxxxxx'
end