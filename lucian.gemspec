# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lucian/version'

Gem::Specification.new do |spec|
  spec.name          = 'lucian'
  spec.version       = Lucian::VERSION
  spec.authors       = ['Tanapat Sainak']
  spec.email         = ['tanapat@computerlogy.com']

  spec.summary       = 'Lucian is a test framework for Docker environments using docker-compose.'
  spec.description   = 'Lucian is a test framework for Docker environments '\
                       'which running up containers using docker-compose.yml, '\
                       'and testing them using Rspec.'
  spec.homepage      = 'https://github.com/gastzars/lucian'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_runtime_dependency(%q<rspec-expectations>, ['~> 3.0'])
  spec.add_runtime_dependency(%q<docker-compose>, '~>1.0')

  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'bundler', '~> 1.13'
  spec.add_development_dependency 'guard', '~> 2.14'
  spec.add_development_dependency 'guard-rspec', '~> 4.7'
end
