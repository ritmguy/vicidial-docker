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

**v0.2.0** — 🏷️ **DAHDI timing by default.** Corrects the v0.1.0 timing default to match VICIdial's own ConfBridge guidance:

- ⏱️ **DAHDI is now the default conference timer** — the dialer maps `/dev/dahdi/timer`, because Asterisk's default timerfd is disturbed by the AGI forking VICIdial does constantly, which makes ConfBridge skip audio frames.
- ⚠️ **Breaking: the dialer host must load the `dahdi` kernel module** — without it `docker-compose up` fails rather than starting a dialer with bad audio timing. No telephony hardware is needed; `dahdi_dummy` is a software timer.
- 📋 **Host requirements are now documented** — supported kernels, the Secure Boot restriction, setup commands and how to verify the active timing source.
- 🚧 **Escape hatch for unsuitable hosts** — `docker-compose.no-dahdi.yaml` falls back to timerfd so the stack still runs for evaluation and CI, and the dialer warns loudly at every startup while it's in use.
- ⬆️ **Requires Docker Compose 2.24.4+** — that override depends on the `!reset` tag.

Previously, in **v0.1.0** — the first tagged release: one multi-stage build with VICIdial pinned to SVN r4005, Debian trixie with native PHP 8.4, vanilla Asterisk 20.20.1 (SHA256-pinned), ConfBridge replacing MeetMe, database credentials removed from the repo, and a fix for the broken schema import that was causing HTTP 500s in the admin UI.

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
git fetch --tags && git checkout v0.2.0        # deploy from a tag, not main

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
│   │   ├── crontab                  # VICIdial's cron jobs
│   │   ├── supervisord.conf
│   │   └── asterisk-conf/           # VICIdial's Asterisk configs
│   ├── web/
│   │   ├── conf/                    # Apache vhosts
│   │   └── html/
│   └── mysql/
│       ├── 00-init-grants.sh        # creates cron@localhost before the schema loads
│       ├── my.cnf.mariadb
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
- Host networking puts MariaDB and SIP on every interface the host has. Firewall accordingly.
- See the security notes in [docs/USAGE.md](docs/USAGE.md).

---

**Note**: Review security settings, TLS termination and a backup strategy before production use.
