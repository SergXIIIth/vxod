# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vxod/version'

Gem::Specification.new do |spec|
  spec.name          = "vxod"
  spec.version       = Vxod::VERSION
  spec.authors       = ["Sergey Makridenkov"]
  spec.email         = ["sergey@makridenkov.com"]
  spec.description   = %q{Social and password authorization solution}
  spec.summary       = %q{Authorization solution}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
