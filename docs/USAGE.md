# Usage

Day-to-day operation. For a first install see [INSTALL.md](INSTALL.md).

All commands run from the repository directory, and every one of them needs `LOCAL_IP` set:

```sh
export LOCAL_IP=192.0.2.10
```

If you omit it, Compose substitutes an empty value and the dialer registers against the wrong address.

---

## Everyday commands

```sh
docker-compose ps                      # what's running, plus db health
docker-compose up -d                   # start (or apply config changes)
docker-compose down                    # stop, keep data
docker-compose restart dialer          # restart one service
docker-compose logs -f dialer          # follow one service
docker-compose logs -f                 # follow everything
```

Service names are `db`, `dialer` and `web`.

---

## Web interfaces

| | |
|---|---|
| Admin | `http://<LOCAL_IP>/vicidial/admin.php` |
| Agent | `http://<LOCAL_IP>/agc/vicidial.php` |

The stock VICIdial login is user `6666`, password `1234`. Change it before exposing this anywhere.

---

## Changing the server's IP address

The server address is applied at **runtime**, so moving the host to a different network is a restart, not a rebuild:

```sh
export LOCAL_IP=<new address>
docker-compose up -d
```

On start the dialer realigns the registered server from whatever address is currently in the database to the new one, updating both the database and `astguiclient.conf`.

---

## Checking the timing source

```sh
docker-compose exec dialer asterisk -rx "timing test"
```

`Using the 'DAHDI' timing module` is what you want. If it reports `timerfd`, the dialer is running without DAHDI timing — fine for evaluation, but see the warning in [INSTALL.md §2](INSTALL.md#2-prepare-the-dialer-host-dahdi) before using it for live calls. The dialer also prints a warning at startup in that state:

```sh
docker-compose logs dialer | grep entrypoint
```

---

## Asterisk CLI

```sh
docker-compose exec dialer asterisk -rvvv          # interactive console
docker-compose exec dialer asterisk -rx "core show channels"
docker-compose exec dialer asterisk -rx "sip show peers"
docker-compose exec dialer asterisk -rx "confbridge show profile bridges"
```

---

## Database access

From the **db** container:

```sh
docker-compose exec db mysql -uroot -p asterisk
```

From the **dialer** container you must disable TLS, because Debian's MariaDB 11 client requires it while the bundled 10.11 server doesn't offer it:

```sh
docker-compose exec dialer mysql --skip-ssl -h127.0.0.1 -ucron -p1234 asterisk
```

Omitting `--skip-ssl` there gives `ERROR 2026 (HY000): TLS/SSL error: SSL is required, but the server does not support it`.

---

## Backup and restore

Back up (the password is `MYSQL_ROOT_PASSWORD` from `docker/mysql/mysql.env`):

```sh
docker-compose exec -T db mysqldump -uroot -p"<root password>" asterisk > vicidial-$(date +%F).sql
```

Restore into a running stack:

```sh
docker-compose exec -T db mysql -uroot -p"<root password>" asterisk < vicidial-2026-07-24.sql
```

Take a backup before any upgrade that resets the database.

---

## Upgrading

Deploy from tags, never `main`.

```sh
git fetch --tags
git checkout v0.2.0
export LOCAL_IP=192.0.2.10
docker-compose up -d --build
```

**Read the release notes first.** Most upgrades keep your data — the database initialises only against an empty volume, so an existing install is untouched. If a release changes the schema or the init scripts, it will say so explicitly, and applying it means either re-seeding (below, destructive) or migrating by hand.

---

## Rebuilding

```sh
docker-compose up -d --build              # rebuild everything that changed
docker-compose build --no-cache dialer    # force a clean dialer rebuild
```

A dialer rebuild recompiles Asterisk and takes a while. Changes to `entrypoint.sh` are cheap; changes to the base image or the Asterisk build are not.

---

## Data and volumes

| Volume | Holds | Path in container |
|---|---|---|
| `db_data` | The VICIdial database | `/var/lib/mysql` |
| `db_log` | MariaDB logs | `/var/log/mysql` |
| `asterisk_spool` | **Call recordings** and voicemail | `/var/spool/asterisk` |

Everything else lives in the images and is rebuilt from source, so those three are the state worth backing up.

Recordings land in `/var/spool/asterisk/monitor`, and VICIdial's cron mixes and compresses them into `monitorDONE/` every few minutes. They stay on the dialer: the job that would transfer them elsewhere (`AST_CRON_audio_3_ftp.pl`) is commented out in the crontab by default, so **plan for disk growth** — the 7-day cleanup job is commented out too.

Backing recordings up:

```sh
docker run --rm -v vicidial-docker_asterisk_spool:/data -v "$PWD":/backup alpine \
  tar czf /backup/recordings-$(date +%F).tar.gz -C /data .
```

**Destroying data:**

```sh
docker-compose down -v          # ⚠️ deletes db_data, db_log AND asterisk_spool
```

That removes the database *and every call recording*. The next `up` re-seeds a fresh VICIdial schema. It's the correct fix for a database that was initialised wrongly, and the wrong answer to almost everything else — take a backup first.

---

## Optional: running without DAHDI

```sh
docker-compose -f docker-compose.yaml -f docker-compose.no-dahdi.yaml up -d
```

Falls back to Asterisk's timerfd timer so the stack runs on any kernel. Evaluation, CI and development only — not live calling.

Pass **both** `-f` flags whenever you start or recreate containers (`up`, or a `restart` after changing configuration) — otherwise Compose reads only the base file and tries to re-add the DAHDI device, which fails on a host that hasn't got it. Commands that just act on already-running containers (`ps`, `logs`, `exec`) work fine without them.

---

## More than one server in the database

A single-server install needs nothing here. But VICIdial lets you add further servers in the admin UI, and the dialer has to know which row in `servers` is its own before it corrects that row's IP address.

It identifies itself by VICIdial's `server_id`:

```yaml
services:
  dialer:
    environment:
      - VICI_SERVER_ID=dialer1      # this node's server_id
```

or per invocation:

```sh
VICI_SERVER_ID=dialer1 docker-compose up -d dialer
```

**If several servers share the database and `VICI_SERVER_ID` isn't set, the dialer will not realign any server's IP.** It logs why and carries on, instead of guessing and possibly rewriting another dialer's registration. You'll see:

```
[entrypoint] N servers share this database, but VICI_SERVER_ID is not
[entrypoint] set, so this node cannot tell which row is its own.
[entrypoint] SKIPPING server-IP alignment ...
```

The fix is to set the variable to the `server_id` shown in the admin UI under Admin → Servers.

> Note: this makes multi-server *safe*, not *supported*. A full multi-dialer topology — remote database access, credential distribution, shared recordings — is not covered by this stack yet.

---

## Running a subset of roles

Name the services a host should run:

```sh
docker-compose up -d              # everything (default)
docker-compose up -d db web       # database + web only
docker-compose up -d dialer       # dialer only
```

Nothing in the compose file needs changing for this — the services no longer
depend on each other, so naming one starts only that one. A dialer started
before its database waits for it rather than failing; watch it with:

```sh
docker-compose logs -f dialer
```

A dialer on a host with no local database also needs `VICI_DB` set in `.env`
to point at the database host.

On a cold `docker-compose up -d`, a page load during the database's start-up
window — roughly 20-40 seconds while it initialises — can hit a PHP database
error rather than simply not responding, because `web` no longer waits for
`db`. This is most noticeable on a fresh volume's first boot, but the same
brief window exists on any restart too; wait for `docker-compose ps` to show
`db` as `(healthy)` and reload.

---

## Networking

All three services use host networking, so they bind directly to the host's interfaces and there is no Docker port mapping to configure. The ports in play:

| Port | Purpose |
|---|---|
| 80 / 443 | Web (admin and agent interfaces) |
| 5060 tcp+udp | SIP signalling |
| 10000–20000 udp | RTP media |
| 4569 udp | IAX2 |
| 8089 tcp | Asterisk WebSocket / WSS |
| 3306 | MariaDB |

Host networking means **the database port is reachable on every interface the host has.** Firewall it, or bind it to the interface you intend, before putting this on an untrusted network.

---

## Troubleshooting

**A service keeps restarting** — read its log first:
```sh
docker-compose logs --tail=50 dialer
```

**Dialer can't reach the database** — check `db` is healthy (`docker-compose ps`), and that `MYSQL_USER`/`MYSQL_PASSWORD` in `mysql.env` match VICIdial's `cron`/`1234`. A mismatch only shows up as connection failures in the dialer, because the database itself starts perfectly.

**Admin UI returns HTTP 500** — usually an incomplete database. Confirm the admin user exists:
```sh
docker-compose exec -T dialer sh -c 'mysql --skip-ssl -h127.0.0.1 -ucron -p1234 asterisk -N -e "SELECT count(*) FROM vicidial_users WHERE user=\"6666\";"'
```
`0` means the schema didn't load completely and the database needs re-seeding.

**Choppy or dropped conference audio** — check the timing source. If it says `timerfd`, that is the documented cause; see [INSTALL.md §2](INSTALL.md#2-prepare-the-dialer-host-dahdi).

**Changes to web files don't appear** — rebuild rather than restart; web assets are baked into the image:
```sh
docker-compose up -d --build web
```

---

## Security notes

- Change the VICIdial `6666` login, and the `cron` database password (which must be changed in both `mysql.env` and VICIdial's configuration together).
- Never commit `docker/mysql/mysql.env` — it's gitignored for that reason.
- Host networking exposes MariaDB and SIP on all interfaces; firewall accordingly.
- `tty: true` on the web service is a development convenience; comment it out in production.
- Rebuild periodically to pick up base-image security updates.
