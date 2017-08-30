# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'get_response_api/version'

Gem::Specification.new do |spec|
  spec.name          = 'get_response_api'
  spec.version       = GetResponseApi::VERSION
  spec.authors       = ['Juliane Lima', 'Rafael S.']
  spec.email         = ['juliane.lima@klickpages.com.br', 'rafael.costa@klickpages.com.br']

  spec.summary       = %q{Wrapper for integration with GetResponse API.}
  spec.description   = %q{See https://github.com/ignicaodigitalbr/get_response_api for more information.}
  spec.homepage      = 'https://github.com/ignicaodigitalbr/get_response_api'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.15'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'webmock'
  spec.add_runtime_dependency 'httparty', '~> 0.15'

  spec.required_ruby_version = '>=2.0.0'
end
