require 'bundler/gem_tasks'
require 'rspec/core/rake_task'
require 'rubocop/rake_task'

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.rspec_opts = ['-fd -c']
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RuboCop::RakeTask.new(:rubocop) do |t|
  t.patterns = ['lib/**/*.rb', 'spec/**/*.rb', 'Rakefile', 'Gemfile', 'grape_logging.gemspec']
end

task default: %i[spec rubocop]
