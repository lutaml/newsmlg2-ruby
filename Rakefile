# frozen_string_literal: true

require 'bundler/gem_tasks'

Dir[File.expand_path('lib/tasks/*.rake', __dir__)].each { |task| import task }

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
  task :default do
    warn 'rspec not available — skipping specs'
  end
end
