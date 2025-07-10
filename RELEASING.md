# Releasing grape_logging

There're no particular rules about when to release grape_logging. Release bug fixes frequently, features not so frequently and breaking API changes rarely.

### Pre-flight Checks

Run tests, check that all tests succeed locally.

```
bundle install
rake
```

Check that the last build succeeded in [GitHub Actions](https://github.com/aserafin/grape_logging/actions) for all supported platforms.

### Update Changelog

Change "Next Release" in [CHANGELOG.md](https://github.com/aserafin/grape_logging/blob/master/CHANGELOG.md) to the new version and date:

```
## [1.8.5] - 2024-06-28

### Changed
- Description of changes

### Fixed
- Description of fixes

### Added
- Description of additions

[1.8.5]: https://github.com/aserafin/grape_logging/compare/v1.8.4...v1.8.5
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Only include the sections (Changed, Fixed, Added, etc.) that have actual changes.

Commit your changes.

```shell
git add CHANGELOG.md lib/grape_logging/version.rb
git commit -m "Preparing for release, 1.8.5."
git push
```

### Release on RubyGems and GitHub

#### Option 1: Automated (Recommended)

Use the combined task that releases the gem and creates a GitHub release:

```shell
rake github_release
```

This will:
1. Build and push the gem to RubyGems
2. Create and push the git tag
3. Create a GitHub release with auto-generated changelog

#### Option 2: Manual

First, release the gem:

```shell
rake release
```

Output will look something like:
```
grape_logging 1.8.5 built to pkg/grape_logging-1.8.5.gem.
Tagged v1.8.5.
Pushed git commits and tags.
Pushed grape_logging 1.8.5 to rubygems.org.
```

Then create the GitHub release on the web or using `gh`:

```
gh release create v1.8.5 --generate-notes --verify-tag
```

This uses GitHub's automatic changelog generation feature to create release notes from merged pull requests and commits since the last release.

### Prepare for the Next Version

Modify `lib/grape_logging/version.rb`, increment the version number (eg. change `1.8.5` to `1.8.6`).

```ruby
module GrapeLogging
  VERSION = '1.8.6'.freeze
end
```

Add the next release to [CHANGELOG.md](https://github.com/aserafin/grape_logging/blob/master/CHANGELOG.md).

```
## [Next Release]

### Changed or Fixed or Added
- Your contribution here.
```

Commit your changes.

```
git add CHANGELOG.md lib/grape_logging/version.rb
git commit -m "Bump version to 1.8.6."
git push
```
