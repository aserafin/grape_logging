require 'grape'
require 'rack/utils'
require 'zeitwerk'

# load zeitwerk
Zeitwerk::Loader.for_gem.tap do |loader|
  loader.inflector.inflect 'multi_io' => 'MultiIO'
  loader.setup
end

module GrapeLogging
end
