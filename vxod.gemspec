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

  spec.required_ruby_version = '>= 2.0'

  spec.add_development_dependency "bundler", "~> 1.3"

  spec.add_dependency 'sinatra', '>= 1.4.4'
  spec.add_dependency 'slim'
  spec.add_dependency 'bcrypt'
  spec.add_dependency 'sass'
  spec.add_dependency 'coffee-script'
  spec.add_dependency 'sinatra-assetpack'
  spec.add_dependency 'pony'
  spec.add_dependency 'i18n'

  spec.add_development_dependency 'omniauth'
  spec.add_development_dependency 'omniauth-twitter'
  spec.add_development_dependency 'omniauth-vkontakte'
  spec.add_development_dependency 'omniauth-facebook'
  spec.add_development_dependency 'omniauth-google-oauth2'
  spec.add_development_dependency 'omniauth-github'

  spec.add_development_dependency 'mongoid', '>= 3'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rack-test'
  spec.add_development_dependency 'capybara'
  spec.add_development_dependency 'selenium-webdriver'
  spec.add_development_dependency 'poltergeist'

  spec.add_development_dependency 'rb-fsevent'
  spec.add_development_dependency 'rerun'
  spec.add_development_dependency 'puma'
  spec.add_development_dependency 'config_env'
end
