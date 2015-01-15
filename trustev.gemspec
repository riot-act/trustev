# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'trustev/version'

Gem::Specification.new do |spec|
  spec.name          = 'trustev'
  spec.version       = Trustev::VERSION
  spec.authors       = ['Jonah Hirsch']
  spec.email         = ['jonah@giftcardzen.com']
  spec.summary       = %q{Ruby wrapper for Trustev API.}
  spec.description   = %q{A Ruby wrapper for the Trustev API.}
  spec.homepage      = 'https://github.com/giftcardzen/trustev'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'minitest', '~> 5.4'
  spec.add_development_dependency 'simplecov', '~> 0.9'
  spec.add_development_dependency 'faker', '~> 1.4'

  spec.add_runtime_dependency 'httparty', '~> 0.13'
  spec.add_runtime_dependency 'multi_json', '~> 1.10'
  spec.add_runtime_dependency 'require_all', '~> 1.3'
end
