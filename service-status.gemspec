# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'service_status/version'

Gem::Specification.new do |spec|
  spec.name          = 'service-status'
  spec.version       = ServiceStatus::VERSION
  spec.authors       = ['William Griffiths', 'Luke Farrar']
  spec.email         = ['william.griffiths@thebookpeople.co.uk', 'luke.farrar@thebookpeople.co.uk']
  spec.summary       = 'Provides a simple JSON service status report.'
  spec.description   = 'When monitoring REST servers it is useful to have a standard /status page. This gem provides such content.'
  spec.homepage      = 'https://github.com/TheBookPeople/service-status-ruby'
  spec.license       = 'GPLv3'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_dependency 'sys-filesystem', '~> 1.1'
  spec.add_development_dependency 'rake', '~> 10.4'
  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'guard-rspec', '~> 4.5'
  spec.add_development_dependency 'rb-inotify', '~> 0.9'
  spec.add_development_dependency 'rb-fsevent', '~> 0.9'
  spec.add_development_dependency 'rb-fchange', '~> 0.0'
  spec.add_development_dependency 'terminal-notifier-guard', '~> 1.6'
  spec.add_development_dependency 'rubocop', '~> 0.28'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
  spec.add_development_dependency 'webmock', '~> 1.21'
  spec.add_development_dependency 'vcr', '~> 2.9'
  spec.add_development_dependency 'timecop', '~> 0.7'
end
