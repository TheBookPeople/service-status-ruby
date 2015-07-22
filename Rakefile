require 'rake'
require 'rake/clean'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'service_status/version'

desc 'Run Code quality checks and tests '
task default: [:clean, :rubocop, :test]

desc 'Run Code quality checks, tests and then create Gem File'
task build: [:clean, :rubocop, :test, :gem]

CLEAN.include("service-status-#{ServiceStatus::VERSION}.gem")
CLEAN.include('coverage')

task :test do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/**/*_spec.rb'
    t.verbose = false
  end

  Rake::Task['spec'].execute
end

task :rubocop do
  RuboCop::RakeTask.new
end

task :gem do
  system 'gem build service-status.gemspec'
end
