lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'grape_logging/version'

Gem::Specification.new do |spec|
  spec.name          = 'grape_logging'
  spec.version       = GrapeLogging::VERSION
  spec.authors       = ['aserafin', 'Sami Samhuri']
  spec.email         = ['adrian@softmad.pl', 'sami@samhuri.net']

  spec.summary       = 'Out of the box request logging for Grape!'
  spec.description   = 'This gem provides simple request logging for Grape with just few lines ' \
                       'of code you have to put in your project! In return you will get response ' \
                       'codes, paths, parameters and more!'
  spec.homepage      = 'http://github.com/aserafin/grape_logging'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'grape', '>= 2.4.0'
  spec.add_dependency 'rack'

  spec.add_development_dependency 'rake', '~> 13.3'
  spec.add_development_dependency 'rspec', '~> 3.5'

  # This is pinned to an exact version otherwise we can't know which rules
  # are in play at any given time in different environments.
  spec.add_development_dependency 'rubocop', '1.77.0'
end
