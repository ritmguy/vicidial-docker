# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).
Deploys run from tags, never `main`.

## [Unreleased]

### Added

- `VICI_DB_BIND` sets the addresses MariaDB listens on, so a database can serve remote dialers without a rebuild. Defaults to `127.0.0.1`, unchanged for a single-host install.
- `grant-dialer <ip>` in the `db` image adds a scoped `cron@'<ip>'` account on a running container — `docker-compose exec db grant-dialer 192.0.2.11` — since the database's own init scripts only run once, against an empty volume. Refuses wildcards.
- `register-node --server-id=<id> [--description=<text>] [--server-ip=<ip>]` in the `dialer` image registers a second or subsequent dialer, creating its rows in `servers`, `server_updater`, `conferences` and `vicidial_conferences`. The first dialer needs no such step — it adopts the database's single seed row automatically. Refuses a duplicate `server_id` or `server_ip`.
- Multi-host installation and operation documented in `docs/INSTALL.md` and `docs/USAGE.md`.

### Changed

- **Existing installs must rebuild to use `grant-dialer` or `register-node`.** Both are new executables added to already-built images, and Compose only builds an image that doesn't exist yet — so a plain `docker-compose up -d db web` / `up -d dialer` on an existing install leaves the old images in place and skips them silently. Rebuild explicitly: `docker-compose up -d --build db web` for `grant-dialer` and `VICI_DB_BIND` support, `docker-compose up -d --build dialer` for `register-node` and the entrypoint's new registration logic. Without the rebuild, `grant-dialer` fails with `exec: "grant-dialer": executable file not found in $PATH`.
- The dialer's unreachable-database message now names the three usual causes — bind address, missing grant, firewall — instead of one generic line.
- `README.md` and `docs/USAGE.md` no longer present loopback-only binding as the mitigation for VICIdial's default `cron` password: that stopped being true once `VICI_DB_BIND` can name a LAN address.

### Fixed

## [0.3.0] - 2026-07-24

### Security

- **The database was reachable from the network with a default password.** MariaDB had no `bind-address`, so it listened on `0.0.0.0`; combined with `network_mode: host` that meant every interface the host has. The MariaDB image had also created wildcard `cron@'%'` and `root@'%'` accounts, so any host able to route to the machine could log into the VICIdial database as `cron` with the documented default password `1234` — which grants access to lead data, agent accounts and call metadata. MariaDB now binds to `127.0.0.1`, and a new init step replaces the wildcard accounts with explicit loopback ones (`cron@127.0.0.1`, `cron@::1`). **An existing installation keeps its wildcard accounts**, because init scripts only run against an empty database volume: restarting applies the loopback bind, which is the control that matters, and `docs/USAGE.md` gives a one-off command to remove the accounts as well.

### Added

- Roles can now be selected per host by naming services: `docker-compose up -d dialer` starts only the dialer, `up -d db web` only the database and web. A plain `docker-compose up -d` still starts everything.

### Changed

- `VICI_DB` is now honoured at runtime by the **dialer** and rewrites `VARDB_server` in `astguiclient.conf`, so VICIdial's cron jobs use the same database as the entrypoint. It was previously ignored, because the value baked into the image took precedence. The `web` service has no entrypoint and remains build-time only.
- The `dialer` and `web` services no longer declare `depends_on: db`, so they can start on a host with no local database. The dialer entrypoint already waits for the database before using it. This also changes first-boot behaviour on every install: on a cold start, a page load during the database's start-up window now returns a PHP database error rather than nothing listening; it resolves once the database is ready.

## [0.2.2] - 2026-07-24

### Fixed

- **Call recordings were destroyed whenever the dialer container was recreated.** Asterisk writes recordings to `/var/spool/asterisk/monitor` and VICIdial's cron mixes and compresses them into `monitorDONE/`, but nothing in that path was persisted — it lived in the container's writable layer. Recreating the container discarded all of it, and the documented way to upgrade (`docker-compose up -d --build`) recreates the container, so following the instructions destroyed the recordings. `/var/spool/asterisk` is now a named volume, which also covers voicemail. Note this only makes recordings durable on the dialer itself; transferring them to a web or dedicated recordings server, VICIdial's traditional arrangement, is still unwired.
- Removed a hardcoded `externip` address from the shipped `sip.conf`, which pointed at an unrelated public IP. The file is inert in this image — Asterisk is built without `chan_sip` and `chan_pjsip` is the channel driver — but it read as live configuration. NAT for pjsip is configured with `external_media_address` / `external_signaling_address` on the transport instead.

### Changed

- `docs/USAGE.md` now documents the recordings volume, how to back it up, that recordings accumulate on the dialer because the transfer and cleanup cron jobs ship commented out, and that `docker-compose down -v` destroys recordings as well as the database.

## [0.2.1] - 2026-07-24

### Added

- `VICI_SERVER_ID` (optional) on the dialer service. Set it to the node's VICIdial `server_id` when more than one server shares the database, so the dialer can identify its own row in `servers`. A single-server install can leave it unset.

### Fixed

- **The dialer could overwrite another server's registration.** It identified "its own" row in `servers` by taking the first row returned, which is only correct for a single server. With two dialers sharing one database, each would run `ADMIN_update_server_ip.pl` against whichever row came first and rewrite the other node's `server_ip` on every restart — the two would take turns stealing each other's identity, corrupting both the database and `astguiclient.conf`. A node now identifies itself by the unique `server_id`; when several servers share a database and `VICI_SERVER_ID` is unset, it skips IP alignment and logs why instead of guessing. The `conf_engine` update is likewise scoped to the node's own row. This was reachable in a single-server install too, simply by adding a second server through the admin UI.

## [0.2.0] - 2026-07-24

### Added

- `docker-compose.no-dahdi.yaml`, an escape hatch that removes the DAHDI device mapping for hosts whose kernel cannot build the module. It falls back to timerfd timing so the stack starts anywhere, and is intended for evaluation, CI and development rather than live calling.
- **`docs/INSTALL.md`** — installation from a clean host: requirements, DAHDI host preparation (supported kernels, the Secure Boot restriction, setup commands), creating the credentials file, building, and verifying the result.
- **`docs/USAGE.md`** — day-to-day operation: everyday commands, changing the server's IP, database access, backup and restore, upgrading between tags, volumes, troubleshooting and security notes.

### Changed

- **BREAKING** — **DAHDI timing is now the default.** The dialer maps `/dev/dahdi/timer`, so the `dahdi` kernel module must be loaded on the dialer host; without it `docker-compose up` fails at container creation. This follows VICIdial's own ConfBridge documentation: Asterisk's default `res_timing_timerfd` is disturbed whenever Asterisk forks — which VICIdial does constantly for AGI — and that causes ConfBridge to skip audio frames. No telephony hardware is needed, only the software `dahdi_dummy` timer.
- **BREAKING** — the minimum supported Docker Compose is now **2.24.4**, since the `no-dahdi` override relies on the `!reset` tag introduced in that version.
- The dialer logs a prominent warning at startup whenever it falls back to timerfd timing, so an unsuitable host is obvious in the logs rather than silent.
- The README is now a front page — overview, current release, requirements and a quick start — with installation and operation moved into `docs/`. Its previous setup instructions described a layout that no longer existed: files removed during the multi-stage rebuild, a `mysql.env` that is no longer shipped, a `/var/www/html` volume that was deliberately dropped, and a `certbot` service that is gone.

### Removed

- `docker-compose.dahdi.yaml`, which is redundant now that DAHDI is the default. Hosts that cannot run DAHDI use `docker-compose.no-dahdi.yaml` instead.

### Fixed

- `generate-local-ip-env.sh` now works on Linux. It used `ifconfig`, which modern distributions don't install by default, and concatenated every address on a multi-homed host into one malformed value. It now takes the source address of the default route, writes a single address, and fails with a clear message if it can't determine one.

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

[Unreleased]: https://github.com/ritmguy/vicidial-docker/compare/v0.3.0...HEAD
[0.3.0]: https://github.com/ritmguy/vicidial-docker/releases/tag/v0.3.0
[0.2.2]: https://github.com/ritmguy/vicidial-docker/releases/tag/v0.2.2
[0.2.1]: https://github.com/ritmguy/vicidial-docker/releases/tag/v0.2.1
[0.2.0]: https://github.com/ritmguy/vicidial-docker/releases/tag/v0.2.0
[0.1.0]: https://github.com/ritmguy/vicidial-docker/releases/tag/v0.1.0
