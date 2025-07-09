require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

task default: :spec

desc 'Release gem and create GitHub release'
task github_release: :release do
  require 'grape_logging/version'

  version = "v#{GrapeLogging::VERSION}"

  # Check if gh CLI is available
  unless system('which gh > /dev/null 2>&1')
    puts "\n⚠️  GitHub CLI (gh) not found"
    puts "To create a GitHub release with auto-generated changelog, install gh:"
    puts "  brew install gh  # macOS with Homebrew"
    puts "  # or visit: https://github.com/cli/cli#installation"
    puts "\nYou can manually create the release with:"
    puts "  gh release create v#{GrapeLogging::VERSION} --generate-notes"
    next
  end

  # Create GitHub release
  puts "\nCreating GitHub release #{version}..."

  if system('gh', 'release', 'create', version, '--generate-notes', '--verify-tag')
    puts "✅ GitHub release #{version} created successfully"
  else
    puts "❌ Failed to create GitHub release"
    puts "You can manually create it with:"
    puts "  gh release create '#{version}' --generate-notes --verify-tag"
  end
end
