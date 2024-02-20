# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape_logging/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape_logging'
  spec.version       = GrapeLogging::VERSION
  spec.authors       = ['aserafin']
  spec.email         = ['adrian@softmad.pl']

  spec.summary       = %q{Out of the box request logging for Grape!}
  spec.description   = %q{This gem provides simple request logging for Grape with just few lines of code you have to put in your project! In return you will get response codes, paths, parameters and more!}
  spec.homepage      = 'https://github.com/araccaine/grape_logging'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'grape'
  spec.add_dependency 'rack'

  spec.add_development_dependency 'bundler', '~> 2.4'
  spec.add_development_dependency 'rake', '~> 11.3'
  spec.add_development_dependency 'rspec', '~> 3.13'
  spec.add_development_dependency 'pry-byebug', '~> 3.10'
end
