# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'service_status/version'

Gem::Specification.new do |spec|
  spec.name          = "service-status"
  spec.version       = ServiceStatus::VERSION
  spec.authors       = ["William Griffiths","Luke Farrar"]
  spec.email         = ["william.griffiths@thebookpeople.co.uk","luke.farrar@thebookpeople.co.uk"]
  spec.summary       = %q{Provides a simple JSON service status report.}
  spec.description   = %q{When monitoring REST servers it is useful to have a standard /status page. This gem provides such content.}
  spec.homepage      = ""
  spec.license       = "GPLv3"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.2"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "sys-filesystem"
end
