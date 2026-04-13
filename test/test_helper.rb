# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "haml"
require "haml-rails"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
ActiveRecord::Migrator.migrations_paths << File.expand_path("../db/migrate", __dir__)
require "rails/test_help"
require "factory_bot_rails"

module Tarea
  module TestCurrentUserStub
    def stub_current_user(id = 123)
      Tarea::ApplicationController.class_eval do
        define_method(:current_user) do
          Struct.new(:id).new(id)
        end
      end
    end
  end
end

module ActiveSupport
  class TestCase
    include FactoryBot::Syntax::Methods
    include Tarea::TestCurrentUserStub
  end
end

class ActionDispatch::IntegrationTest
  include Tarea::TestCurrentUserStub
end
