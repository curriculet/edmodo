require 'spec_helper'
require 'rash'

describe Edmodo::Configuration do

  before do
    set_testing_configuration
  end

  describe '.configure' do

    Edmodo::Configuration::VALID_CONFIG_KEYS.each do |key|
      it "should set the #{key}" do
        Edmodo.configure do |config|
          if key == :timeout
            config.send("#{key}=", 10)
            Edmodo.send(key).should eq 10
          else
            config.send("#{key}=", key)
            Edmodo.send(key).should eq key
          end
        end
      end
    end
  end

  describe "default values" do
    before{ Edmodo.reset! }
    Edmodo::Configuration::VALID_CONFIG_KEYS.each do |key|
      describe ".#{key}" do
        it 'should return the default value' do

          Edmodo.send(key).should eq Edmodo::Configuration.const_get("DEFAULT_#{key.upcase}")
        end
      end
    end
  end
end
