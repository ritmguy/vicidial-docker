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

**v0.2.1** — 🏷️ **Server-identity fix.** A patch on top of v0.2.0:

- 🐛 **A dialer could overwrite another server's registration.** It identified its own row in `servers` by taking the first one returned — fine for a single server, but two dialers sharing a database would rewrite each other's IP on every restart. Nodes now identify themselves by VICIdial's unique `server_id` (set `VICI_SERVER_ID`), and refuse to realign anything rather than guess when it's ambiguous. This was reachable in a single-server install too, just by adding a second server in the admin UI.

This patches **v0.2.0**, which made **DAHDI timing the default** per VICIdial's ConfBridge guidance — so the dialer host must load the `dahdi` kernel module (no telephony hardware needed) and Docker Compose 2.24.4+ is required. See [`docs/INSTALL.md`](docs/INSTALL.md), or `docker-compose.no-dahdi.yaml` for hosts that can't.

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
