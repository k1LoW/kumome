require 'bundler/gem_tasks'

begin
  require 'rspec/core/rake_task'
  require 'octorelease'
rescue LoadError
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
