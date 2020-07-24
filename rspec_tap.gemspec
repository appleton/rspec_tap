# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rspec_tap/version'

Gem::Specification.new do |spec|
  spec.name          = "rspec_tap"
  spec.version       = RspecTap::VERSION
  spec.authors       = ["Andrew Appleton"]
  spec.email         = ["andysapple@gmail.com"]

  spec.summary       = %q{A TAP formatter for rspec}

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", ">= 12.3.3"
  spec.add_development_dependency "rspec", "~> 3.4"
  spec.add_development_dependency "pry"
end
