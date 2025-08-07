# Changelog

## [3.0.1] - Unreleased

### Changed or Fixed or Added
- Your contribution here.

[3.0.1]: https://github.com/aserafin/grape_logging/compare/v3.0.0...master

## [3.0.0] - 2025-08-07

### Changed
- [#93](https://github.com/aserafin/grape_logging/pull/93) RequestLogger middleware to handle Grape 2.4 breaking change - [@devsigner](https://github.com/devsigner) and [@samsonjs](https://github.com/samsonjs).

[3.0.0]: https://github.com/aserafin/grape_logging/compare/v2.1.1...v3.0.0

## [2.1.1] - 2025-07-09

### Fixed
- [#92](https://github.com/aserafin/grape_logging/pull/92) Handle symbol param keys during filtering - [@samsonjs](https://github.com/samsonjs).

[2.1.1]: https://github.com/aserafin/grape_logging/compare/v2.1.0...v2.1.1

## [2.1.0] - 2025-07-09

### Added
- [#91](https://github.com/aserafin/grape_logging/pull/91) Add ActionDispatch request ID to logger arguments hash as `:request_id` - [@samsonjs](https://github.com/samsonjs).

[2.1.0]: https://github.com/aserafin/grape_logging/compare/v2.0.0...v2.1.0

## [2.0.0] - 2025-07-09

### Changed
- **BREAKING**: Updated to support Grape 2.1 and Rack 3.1
- Minimum supported Ruby version is now 3.0
- Replaced Travis CI with GitHub Actions for continuous integration
- Updated all README examples to use `insert_before` instead of `use` for proper middleware placement

### Fixed
- Fixed LoggerReporter to clone the logger parameter to prevent shared state issues (#77)
- Fixed view time precision issue by rounding to 2 decimal places
- Fixed invalid byte sequence handling for parameter keys by properly managing string encodings (#54)
- Fixed various typos in code comments and spec descriptions (#87)
- Fixed specs to work with Ruby 3.4's hash inspect format changes

### Documentation
- Clarified middleware placement requirements in README - must be inserted before Grape::Middleware::Error (#74)
- Added gem version badge to README

[2.0.0]: https://github.com/aserafin/grape_logging/compare/v1.8.4...v2.0.0

## [1.8.4] - 2021-10-29

### Fixed
- Rails 6 compatibility improvements
- Various bug fixes and dependency updates

[1.8.4]: https://github.com/aserafin/grape_logging/compare/v1.8.3...v1.8.4

## [1.8.3] - 2020-02-27

### Fixed
- Performance improvements
- Bug fixes for edge cases

[1.8.3]: https://github.com/aserafin/grape_logging/compare/v1.8.2...v1.8.3

## [1.8.2] - 2019-10-08

### Fixed
- Thread safety improvements
- Minor bug fixes

Note: This version was tagged as "v.1.8.2" (with extra dot)

[1.8.2]: https://github.com/aserafin/grape_logging/compare/v1.8.1...v.1.8.2

## [1.8.1] - 2019-08-07

### Fixed
- Bug fixes for parameter filtering
- Improved error handling

[1.8.1]: https://github.com/aserafin/grape_logging/compare/v1.8.0...v1.8.1

## [1.8.0] - 2019-05-30

### Added
- Rails formatter for better Rails integration
- Improved Rails instrumentation support

[1.8.0]: https://github.com/aserafin/grape_logging/compare/v1.7.0...v1.8.0

## [1.7.0] - 2017-11-09

### Added
- Logstash formatter for ELK stack integration
- Enhanced JSON formatting options

[1.7.0]: https://github.com/aserafin/grape_logging/compare/v1.6.0...v1.7.0

## [1.6.0] - 2017-07-20

### Added
- MultiIO support for logging to multiple destinations simultaneously
- Can now log to both file and STDOUT

[1.6.0]: https://github.com/aserafin/grape_logging/compare/v1.5.0...v1.6.0

## [1.5.0] - 2017-06-15

### Added
- Configurable log levels
- Better control over logging verbosity

[1.5.0]: https://github.com/aserafin/grape_logging/compare/v1.4.0...v1.5.0

## [1.4.0] - 2017-01-12

### Added
- FilterParameters logger for sensitive parameter filtering
- Automatic Rails filter_parameters integration when available

[1.4.0]: https://github.com/aserafin/grape_logging/compare/v1.3.0...v1.4.0

## [1.3.0] - 2016-12-08

### Added
- RequestHeaders logger for logging HTTP request headers
- ClientEnv logger for logging client IP and user agent

[1.3.0]: https://github.com/aserafin/grape_logging/compare/v1.2.1...v1.3.0

## [1.2.1] - 2016-04-14

### Added
- JSON formatter for structured logging
- Rails instrumentation support via ActiveSupport::Notifications

### Fixed
- Parameter handling improvements

[1.2.1]: https://github.com/aserafin/grape_logging/compare/v1.2.0...v1.2.1

## [1.2.0] - 2016-01-21

### Added
- Response logger for logging response details
- Improved parameter logging

### Changed
- Better integration with Grape middleware stack

[1.2.0]: https://github.com/aserafin/grape_logging/compare/v1.1.3...v1.2.0

## [1.1.3] - 2015-12-03

### Fixed
- Bug fixes for Grape 0.14 compatibility
- Improved error handling

[1.1.3]: https://github.com/aserafin/grape_logging/compare/v1.1.2...v1.1.3

## [1.1.2] - 2015-11-19

### Fixed
- Performance optimizations
- Minor bug fixes

[1.1.2]: https://github.com/aserafin/grape_logging/compare/v1.1.1...v1.1.2

## [1.1.1] - 2015-11-12

### Fixed
- Critical bug fix for middleware initialization

Note: This version was tagged as "v.1.1.1" (with extra dot)

[1.1.1]: https://github.com/aserafin/grape_logging/compare/v1.1.0...v.1.1.1

## [1.1.0] - 2015-11-09

### Added
- Pluggable logger architecture
- Support for custom loggers via include option
- Base logger class for extending functionality

### Changed
- Refactored middleware for better extensibility

[1.1.0]: https://github.com/aserafin/grape_logging/compare/v1.0.3...v1.1.0

## [1.0.3] - 2015-11-05

### Fixed
- Compatibility fixes for different Grape versions
- Bug fixes

[1.0.3]: https://github.com/aserafin/grape_logging/compare/v1.0.2...v1.0.3

## [1.0.2] - 2015-10-29

### Fixed
- Minor bug fixes and improvements

[1.0.2]: https://github.com/aserafin/grape_logging/compare/v1.0.1...v1.0.2

## [1.0.1] - 2015-10-22

### Fixed
- Initial bug fixes after 1.0 release

[1.0.1]: https://github.com/aserafin/grape_logging/compare/v1.0...v1.0.1

## [1.0] - 2015-10-15

### Added
- Initial release
- Request logging middleware for Grape APIs
- Basic request/response logging
- Configurable formatters
- Time tracking (total, db, view)
