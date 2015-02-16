# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'normalizer/version'

Gem::Specification.new do |spec|
  spec.name          = "normalizer"
  spec.version       = Normalizer::VERSION
  spec.authors       = ["akicho8"]
  spec.email         = ["akicho8@gmail.com"]
  spec.description   = %q{This is a function that can be used as validator}
  spec.summary       = %q{Value normalizer}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake"
  spec.add_development_dependency "test-unit"
  spec.add_development_dependency "sqlite3"

  spec.add_dependency "activesupport"
  spec.add_dependency "activemodel"
  spec.add_dependency "activerecord"
  spec.add_dependency "rails-deprecated_sanitizer"
end
