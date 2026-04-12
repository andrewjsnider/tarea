# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "haml"
require "haml-rails"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"
require "factory_bot_rails"

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
  end
end

