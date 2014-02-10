require 'json'
require 'hashie/rash'
require 'httparty'

require 'edmodo/configuration'
require 'edmodo/api/client'
require 'edmodo/errors'

# Data Models
require 'edmodo/model'
require 'edmodo/user'
require 'edmodo/group'

# API Operations
require 'edmodo/api/endpoints'
require 'edmodo/api/resource'
require 'edmodo/api/groups'
require 'edmodo/api/users'

module Edmodo
  VERSION = File.read(File.expand_path(File.join(File.dirname(__FILE__), '..', 'VERSION'))).strip
  extend Configuration
  extend API::Endpoints
end
