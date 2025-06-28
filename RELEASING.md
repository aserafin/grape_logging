# Releasing grape_logging

There're no particular rules about when to release grape_logging. Release bug fixes frequently, features not so frequently and breaking API changes rarely.

### Release

Run tests, check that all tests succeed locally.

```
bundle install
rake
```

Check that the last build succeeded in [GitHub Actions](https://github.com/aserafin/grape_logging/actions) for all supported platforms.

Change "Next Release" in [CHANGELOG.md](https://github.com/aserafin/grape_logging/blob/master/CHANGELOG.md) to the new version.

```
### 1.8.5 (2024/06/28)
```

Remove the line with "Your contribution here.", since there will be no more contributions to this release.

Commit your changes.

```
git add CHANGELOG.md lib/grape_logging/version.rb
git commit -m "Preparing for release, 1.8.5."
git push github master
```

Release.

```
$ rake release

grape_logging 1.8.5 built to pkg/grape_logging-1.8.5.gem.
Tagged v1.8.5.
Pushed git commits and tags.
Pushed grape_logging 1.8.5 to rubygems.org.
```

### Prepare for the Next Version

Modify `lib/grape_logging/version.rb`, increment the third number (eg. change `1.8.5` to `1.8.6`).

```ruby
module GrapeLogging
  VERSION = '1.8.6'.freeze
end
```

Add the next release to [CHANGELOG.md](https://github.com/aserafin/grape_logging/blob/master/CHANGELOG.md).

```
#### 1.8.6 (Next)

* Your contribution here.
```

Commit your changes.

```
git add CHANGELOG.md lib/grape_logging/version.rb
git commit -m "Bump version to 1.8.6."
git push github master
```
