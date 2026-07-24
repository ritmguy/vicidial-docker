# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Deploys run from tags, never `main`.

## [Unreleased]

### Added

### Changed

### Fixed

## [0.1.0] - 2026-07-24

### Added

- Opt-in DAHDI timing overlay `docker-compose.dahdi.yaml`, which maps `/dev/dahdi/timer` into the dialer for hosts that load the `dahdi` kernel module; the entrypoint detects the device and switches Asterisk to DAHDI timing. It is not required — without it the dialer uses Asterisk's built-in `timerfd` timing and needs nothing from the host.
- `docker/mysql/mysql.env.example` as the template for database credentials.
- `.dockerignore`, keeping git metadata, docs and certificates out of the build context.

### Changed

- **BREAKING** — the base image is now **Debian trixie** (pinned by digest) with **native PHP 8.4** from Debian main; `ppa:ondrej/php` is gone. Existing installs must rebuild.
- **BREAKING** — conferencing moved from **MeetMe to ConfBridge**. `app_meetme` is no longer compiled, and the dialer entrypoint sets `servers.conf_engine='CONFBRIDGE'`.
- **BREAKING** — a first build now requires creating `docker/mysql/mysql.env` from `docker/mysql/mysql.env.example`.
- Upgraded Asterisk to vanilla **20.20.1** (from the EOL 18.21.0-vici), fetched over HTTPS and checked against a pinned SHA256.
- Rebuilt the images as a single multi-stage `docker/Dockerfile` (shared `base` feeding `dialer`, `web` and `db`), which roughly halves build time and removes the risk of the two images drifting onto different VICIdial checkouts. VICIdial is pinned to SVN r4005.
- The database schema is seeded directly from that pinned checkout, so schema and application code can no longer drift apart.
- Moved the astguiclient install directory to `/usr/share/astguiclient`.
- Re-added Docker bridge networks to the Compose file (commented out; host networking remains the default).

### Removed

- `app_meetme` (superseded by ConfBridge), along with the unused `certbot` and `ntp` packages.
- Committed `.DS_Store` files.

### Fixed

- The database load no longer aborts partway through: `cron@localhost` is created before the schema runs so its `GRANT` succeeds. Previously the failed grant discarded the admin user and server rows, which is what produced HTTP 500s in the admin UI.
- The dialer's `mysql` client no longer fails on Debian with "SSL is required, but the server does not support it" — the MariaDB 11.x client requires TLS while the bundled 10.11 server offers none, which silently skipped the `conf_engine` update. Local calls now pass `--skip-ssl`.
- The registered server IP is realigned from whichever address is currently in the database rather than only from the seeded placeholder, so changing the host's IP is picked up on restart instead of leaving a stale address indefinitely.
- Web assets are no longer shadowed by a stale anonymous `/var/www/html` volume, so rebuilt content is actually served.
- `server_ip` is no longer written with literal quotes around it.

### Security

- Database credentials are no longer committed: the real `mysql.env` is gitignored, only `mysql.env.example` ships, and the previously exposed root password was rotated.
- Configuration and SQL files are installed `0644` rather than world-writable.

[Unreleased]: https://github.com/ritmguy/vicidial-docker/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/ritmguy/vicidial-docker/releases/tag/v0.1.0
