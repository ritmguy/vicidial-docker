# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Deploys run from tags, never `main`.

## [Unreleased]

### Added

### Changed

- Upgraded the dialer and web images to PHP 8.4 (via `ppa:ondrej/php`).
- Moved the astguiclient install directory to `/usr/share/astguiclient`.
- Re-added Docker bridge networks to the Compose file (commented out; host networking remains the default).

### Fixed

[Unreleased]: https://github.com/ritmguy/vicidial-docker/commits/main
