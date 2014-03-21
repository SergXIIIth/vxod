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
  spec.homepage      = "https://github.com/SergXIIIth/vxod"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"

  spec.add_dependency 'sinatra', '>= 1.4.4'
  spec.add_dependency 'slim'
  spec.add_dependency 'sass'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'mongoid'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rack-test'

  spec.add_development_dependency 'rerun'
  spec.add_development_dependency 'puma'
end
