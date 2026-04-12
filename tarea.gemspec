require_relative "lib/tarea/version"

Gem::Specification.new do |spec|
  spec.name        = "tarea"
  spec.version     = Tarea::VERSION
  spec.authors     = ["Andrew Sndier"]
  spec.email       = ["andrewsnider15@gmail.com"]
  spec.homepage    = "https://example.com"
  spec.summary     = "Homework and XP engine for language learning"
  spec.description = "A mountable Rails engine for homework, comprehension, practice, and XP tracking."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://example.com"
  spec.metadata["changelog_uri"] = "https://example.com"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 7.0.8.4"
  spec.add_dependency "haml"
  spec.add_dependency "haml-rails"
  spec.add_development_dependency "factory_bot_rails"
end

