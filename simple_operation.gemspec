# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_operation/version'

Gem::Specification.new do |spec|
  spec.name          = "simple_operation"
  spec.version       = SimpleOperation::VERSION
  spec.authors       = ["Grzegorz Witek"]
  spec.email         = ["arnvald.to@gmail.com"]
  spec.summary       = %q{Create simple service object}
  spec.description   = %q{SimpleOperation is a very simple library that facilitates creating service objects}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
