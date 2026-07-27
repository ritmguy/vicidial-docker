# VICIdial Docker Compose Setup

A containerized deployment of VICIdial (Vicidial Internet Contact Center) using Docker Compose with MariaDB, web interface, and dialer components.

## 📌 Current Version

> ⚠️ **Deploying VICIdial? Use a tagged [release](../../releases), not `main`.**
> `main` is the active development line — expect in-progress changes. Tagged
> releases are the tested checkpoints meant for real installs.

<!--
Per-release block — replace this line on each release (see the maintainer release checklist). Format:

**vX.Y.Z** — 🏷️ **<tagline>.** <one-line theme>:

- 🐳 **<Headline>** — one concise sentence.
- 🐛 **<Headline>** — …
-->

**v0.4.0** — 🏷️ **A dialer can now run on its own host, against a remote database.** Multi-host installs, without changing the single-host default:

- 🌐 **`VICI_DB_BIND` opens the database to remote dialers** — set it to loopback plus one LAN address and restart; it defaults to `127.0.0.1`, identical to a single-host install.
- 🔑 **`grant-dialer <ip>`** adds a scoped `cron@'<ip>'` account to a *running* database, since the built-in init scripts only ever run once, against an empty volume. Refuses wildcards.
- 🧷 **`register-node`** creates a second (or later) dialer's full server record before it starts. The first dialer still needs nothing. Refuses to overwrite an existing registration.
- 📘 **Multi-host install and operation are documented** in [docs/INSTALL.md](docs/INSTALL.md#5a-choose-which-roles-this-host-runs) and [docs/USAGE.md](docs/USAGE.md), including the database-exposure tradeoffs.
- ⚠️ **Existing installs must rebuild** to get `grant-dialer` and `register-node` — Compose only builds an image that doesn't already exist, so a plain `up -d` silently leaves them missing.

Full release notes and prior versions are in [CHANGELOG.md](CHANGELOG.md).

## Documentation

| | |
|---|---|
| **[docs/INSTALL.md](docs/INSTALL.md)** | Host preparation, first install, and verifying it worked |
| **[docs/USAGE.md](docs/USAGE.md)** | Day-to-day operation, backups, upgrading, troubleshooting |
| **[CHANGELOG.md](CHANGELOG.md)** | What changed in each release |

## Overview

This Docker Compose configuration sets up a complete VICIdial environment with the following services:

- **Database (MariaDB)**: Primary database server for VICIdial
- **Dialer**: VICIdial dialer service for automated calling
- **Web**: Web interface for VICIdial administration and agent interface

## Architecture

```
┌─────────────┐    ┌──────────────┐    ┌─────────────┐
│   Web UI    │    │   Dialer     │    │  Database   │
│ (vicidial-  │    │ (vicidial-   │    │ (vicidial-  │
│    web)     │    │   dialer)    │    │     db)     │
└─────────────┘    └──────────────┘    └─────────────┘
       │                   │                   │
       └───────────────────┼───────────────────┘
                          │
                   Host Network Mode
```

All three services share one `docker/Dockerfile`: a common `base` stage (Debian trixie, PHP 8.4, one pinned VICIdial checkout) feeding `dialer`, `web` and `db` targets.

## Requirements

- Docker Engine 20.10+
- **Docker Compose 2.24.4+**
- 4 GB RAM, 20 GB disk minimum
- **A dialer host that can load the `dahdi` kernel module** — see below

> ### ⚠️ The dialer host must provide DAHDI timing
>
> The dialer maps `/dev/dahdi/timer`, so **`docker-compose up` fails if the `dahdi` module isn't loaded.** That's deliberate: VICIdial forks constantly for AGI, and Asterisk's default timerfd timer is disturbed by those forks, which makes ConfBridge drop conference audio.
>
> **No telephony hardware is required** — `dahdi_dummy` is a software timer. But the host kernel must be one DKMS can build against, and **Secure Boot must be off**.
>
> Full setup, supported kernels, and the escape hatch for hosts that can't run it: **[docs/INSTALL.md](docs/INSTALL.md)**.

## Quick start

```sh
git clone https://github.com/ritmguy/vicidial-docker.git
cd vicidial-docker
git fetch --tags && git checkout v0.4.0        # deploy from a tag, not main

# 1. host: load the DAHDI timer (see docs/INSTALL.md for kernel requirements)
sudo apt-get install -y dahdi-dkms dahdi linux-headers-$(uname -r)
sudo modprobe dahdi && sudo modprobe dahdi_dummy

# 2. database credentials (not shipped in the repo)
cp docker/mysql/mysql.env.example docker/mysql/mysql.env
$EDITOR docker/mysql/mysql.env

# 3. this host's LAN IP, then build
export LOCAL_IP=192.0.2.10
docker-compose up -d --build
```

Then open `http://<LOCAL_IP>/vicidial/admin.php` — the stock login is `6666` / `1234`, which you should change immediately.

**Read [docs/INSTALL.md](docs/INSTALL.md) before a real deployment**; the steps above are the short version and skip the verification steps.

## Repository layout

```
.
├── docker-compose.yaml              # the stack (DAHDI timing by default)
├── docker-compose.no-dahdi.yaml     # override: fall back to timerfd
├── docker/
│   ├── Dockerfile                   # one multi-stage build: base → dialer / web / db
│   ├── dialer/
│   │   ├── entrypoint.sh            # server registration, conf engine, timing
│   │   ├── register-node.sh         # registers a second (or later) dialer's server record
│   │   ├── crontab                  # VICIdial's cron jobs
│   │   ├── supervisord.conf
│   │   └── asterisk-conf/           # VICIdial's Asterisk configs
│   ├── web/
│   │   ├── conf/                    # Apache vhosts
│   │   └── html/
│   └── mysql/
│       ├── 00-init-grants.sh        # creates cron@localhost before the schema loads
│       ├── 03-lockdown.sh           # drops the wildcard DB accounts after it
│       ├── grant-dialer.sh          # grants a remote dialer's address on a live db
│       ├── my.cnf.mariadb           # binds MariaDB to loopback by default
│       └── mysql.env.example        # copy to mysql.env (gitignored)
└── docs/                            # INSTALL.md, USAGE.md
```

## Services

| Service | Container | What it is |
|---|---|---|
| `db` | `vicidial-db` | MariaDB 10.11. The schema is seeded from the pinned VICIdial checkout the first time the volume is empty. Persists in the `db_data` / `db_log` volumes. |
| `dialer` | `vicidial-dialer` | Asterisk 20.20.1 plus VICIdial's Perl backend and cron jobs. Maps `/dev/dahdi/timer`. Takes the server address at runtime, so an IP change is a restart, not a rebuild. |
| `web` | `vicidial-web` | Apache with PHP 8.4 serving the admin and agent interfaces. |

All three use host networking, so they bind directly to the host's interfaces.

## Security

- Change the stock `6666` VICIdial login before exposing this anywhere.
- `docker/mysql/mysql.env` holds real credentials and is gitignored — don't commit it.
- MariaDB binds to **loopback only by default**, with no wildcard accounts. Multi-host installs widen this to one named LAN address via `VICI_DB_BIND`, with per-dialer grants — never `0.0.0.0`. The `cron` password is VICIdial's default and has to be, so a network-bound database is protected only by those grants and your firewall: put it on a trusted segment. See [Database exposure](docs/USAGE.md#database-exposure).
- Host networking still puts **SIP and RTP** on every interface the host has. Firewall accordingly.
- See the security notes in [docs/USAGE.md](docs/USAGE.md).

---

**Note**: Review security settings, TLS termination and a backup strategy before production use.
