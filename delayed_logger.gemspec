# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'delayed_logger/version'

Gem::Specification.new do |gem|
  gem.name          = "delayed_logger"
  gem.version       = DelayedLogger::VERSION
  gem.authors       = ["Shinya Kasatani"]
  gem.email         = ["kasatani@gmail.com"]
  gem.description   = %q{captures log and lets you write the log only when you need it}
  gem.summary       = %q{captures log and lets you write the log only when you need it}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
