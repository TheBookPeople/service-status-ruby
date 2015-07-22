require 'rake'
require 'rake/clean'
require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'
require 'service_status/version'

RuboCop::RakeTask.new

desc 'Run Code quality checks and tests '
task default: [:clean, 'rubocop:auto_correct', :test]

desc 'Run Code quality checks, tests and then create Gem File'
task build: [:clean, 'rubocop:auto_correct', :test, :gem]

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
  RuboCop::RakeTask.new(:rubocop) do |task|
    task.patterns = ['lib/**/*.rb']
    task.fail_on_error = true
  end
end

task :gem do
  system 'gem build service-status.gemspec'
end
