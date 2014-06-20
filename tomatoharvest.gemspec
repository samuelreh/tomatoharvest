# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tomatoharvest'

Gem::Specification.new do |spec|
  spec.name          = "tomatoharvest"
  spec.version       = TomatoHarvest::VERSION
  spec.authors       = ["Sam Reh"]
  spec.email         = ["samuelreh@gmail.com"]
  spec.summary       = %q{Log your pomodoros to Harvest}
  spec.description   = %q{Command line pomodoro timer that logs to Harvest.}
  spec.homepage      = "http://github.com/samuelreh/tomatoharvest/"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake",    "~> 10.3.2"
  spec.add_development_dependency "rspec",   "~> 3.0.0"
  spec.add_development_dependency "webmock", "~> 1.18.0"

  spec.add_dependency('thor', '~> 0.19')
  spec.add_dependency('harvested', '~> 2.0.0')
  spec.add_dependency('daemons',  '~> 1.1.9')
  spec.add_dependency('terminal-notifier', '~> 1.4') if TomatoHarvest::OS.mac?
end
