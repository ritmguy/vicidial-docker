# Installation

How to get a working VICIdial stack from a clean host. Day-to-day operation is covered in [USAGE.md](USAGE.md).

Plan for the first build to take roughly **10–30 minutes** — Asterisk is compiled from source, so it depends heavily on how many cores the host has.

---

## 1. Requirements

| | |
|---|---|
| **Docker Engine** | 20.10+ |
| **Docker Compose** | **2.24.4+** — the `no-dahdi` override uses the `!reset` tag, which older versions don't understand |
| **RAM** | 4 GB minimum |
| **Disk** | 20 GB minimum |
| **Kernel** | must be able to build the `dahdi` module — see the next section |

By default this runs as a single-host stack: database, dialer and web all run on one machine using host networking. §5a covers splitting roles across more than one host; host networking applies throughout either way.

---

## 2. Prepare the dialer host (DAHDI)

> **Do this before you build.** The dialer maps `/dev/dahdi/timer`, so if the module isn't loaded, `docker-compose up` fails at container creation. That's deliberate — see below.

### Why it's required

VICIdial takes ConfBridge's timing from Asterisk's timing interface. Per [VICIdial's ConfBridge documentation](https://www.vicidial.org/docs/ConfBridge%20Documentation.txt):

> *"the `res_timing_timerfd.so` module which is the default is affected whenever Asterisk forks itself like whenever an AGI script is executed. This can cause audio frames to be skipped by ConfBridge. Vicidial uses AGI scripts heavily."*

VICIdial forks for AGI constantly, so on a busy dialer that shows up as choppy or dropped conference audio. DAHDI's kernel timer isn't affected by forking.

**No telephony hardware is needed.** `dahdi_dummy` is a pure software timing source.

### Supported kernels

DAHDI is an out-of-tree module built by DKMS, so the kernel has to be one DKMS can build against.

| | |
|---|---|
| **Known good** | Ubuntu 22.04 / 24.04 LTS, Debian 12–13, RHEL / Rocky / AlmaLinux 8–9, openSUSE Leap |
| **Known bad** | Very new kernels (for example Kali 6.19), where `dahdi-dkms` fails to compile |

You also need `linux-headers` matching the **running** kernel. If you've just applied updates, reboot first — otherwise DKMS builds against a kernel you aren't running.

### Secure Boot must be off

DKMS builds the module **unsigned**, so a Secure Boot host refuses to load it. The symptom is confusing, because it fails *even as root*:

```
modprobe: ERROR: could not insert 'dahdi': Operation not permitted
```

Check with `mokutil --sb-state`. Either disable Secure Boot in the machine's firmware, or enroll a MOK key and sign the module.

### Install and load

```sh
sudo apt-get install -y dahdi-dkms dahdi linux-headers-$(uname -r)
sudo modprobe dahdi && sudo modprobe dahdi_dummy
ls -l /dev/dahdi/timer
```

That last command must show a character device. Make it survive reboots:

```sh
echo -e "dahdi\ndahdi_dummy" | sudo tee /etc/modules-load.d/dahdi.conf
```

---

## 3. Get the code

Deploy from a **tag**, never from `main` — `main` is the active development line.

```sh
git clone https://github.com/ritmguy/vicidial-docker.git
cd vicidial-docker
git fetch --tags
git checkout v0.3.0          # or the latest tag
```

---

## 4. Set the database credentials

The real credentials file is not in the repository. Create it from the template:

```sh
cp docker/mysql/mysql.env.example docker/mysql/mysql.env
chmod 600 docker/mysql/mysql.env
$EDITOR docker/mysql/mysql.env
```

```ini
MYSQL_ROOT_PASSWORD="use-a-long-random-value"
MYSQL_DATABASE="asterisk"
MYSQL_USER="cron"
MYSQL_PASSWORD="1234"
```

> **`MYSQL_USER` and `MYSQL_PASSWORD` must match what VICIdial was built with** — by default `cron` / `1234`, as written into `/etc/astguiclient.conf` inside the image. If they don't match, the database starts fine but the dialer cannot connect to it. `MYSQL_ROOT_PASSWORD` is yours to choose.
>
> These values are only applied when the database volume is **empty**. Changing them later does not change an existing database.

---

## 5. Set the server IP

Use the address other machines reach this host on — not `127.0.0.1`.

The repository ships a helper that detects it and writes `.env`. Compose reads `.env` automatically, so this is a one-off and you don't need to `export` anything in future shells:

```sh
./generate-local-ip-env.sh
cat .env                          # LOCAL_IP=192.0.2.10
```

Or set it by hand, either way:

```sh
echo "LOCAL_IP=192.0.2.10" > .env       # persistent
export LOCAL_IP=192.0.2.10              # this shell only
```

`.env` is gitignored. If the host later moves to a different network, re-run the helper and `docker-compose up -d` — see [USAGE.md](USAGE.md#changing-the-servers-ip-address).

---

## 5a. Choose which roles this host runs

> **One machine running everything?** That's the common case — nothing to
> configure in this section; continue straight to [§6. Build and
> start](#6-build-and-start).
>
> **Splitting roles across machines?** Read both Multi-host subsections below,
> in order: [database side](#multi-host-database-side) first, then [dialer
> side](#multi-host-dialer-side) — a dialer can't start until the database
> accepts it.

A single machine runs all three roles, which is what most installs want and is
what you get from a plain:

```sh
docker-compose up -d
```

To split roles across machines, name the services that host should run:

```sh
docker-compose up -d db web      # on the database/web host
docker-compose up -d dialer      # on each dialer host
```

A dialer host must also be told where the database is, in `.env`:

```sh
VICI_DB=192.0.2.10
```

That `docker-compose up -d dialer` above is illustrative, and fine for a
first dialer — but a second or later dialer has a decision to make before it
ever starts, rather than running it as-is: the **[Multi-host: dialer
side](#multi-host-dialer-side)** section below covers it, once the database
side is done.

### Multi-host: database side

On the database host, list the addresses MariaDB should listen on — loopback
**plus** the one LAN address dialers reach it on:

```sh
echo 'VICI_DB_BIND=127.0.0.1,192.0.2.10' >> .env
docker-compose up -d --build db web
```

Keep `127.0.0.1` in the list, or the local `web` role loses its connection.
Never use `0.0.0.0`: with `network_mode: host` that is every interface the host
has, including VPN and Docker bridges. No spaces around the comma — Compose
splits a plain `command:` scalar on whitespace, so `127.0.0.1, 192.0.2.10`
(with a space) reaches `mariadbd` as two separate arguments and it refuses to
start. See [Database exposure](USAGE.md#database-exposure) for more.

Then grant each dialer, one address at a time:

```sh
docker-compose exec db grant-dialer 192.0.2.11
```

Restrict 3306 as well. Because `db` uses `network_mode: host`, ordinary `INPUT`
rules apply — unlike Docker's usual bridge networking, where published ports
bypass `INPUT` and firewall rules appear to be ignored. Accept loopback
**before** the drop: packets to `127.0.0.1` traverse `INPUT` too, so a bare
trailing DROP also cuts the local `web` → `db` connection — a symptom that's
easy to misattribute, since `db` still shows `(healthy)` while the web UI
throws PHP errors:

```sh
sudo iptables -I INPUT -i lo -j ACCEPT
sudo iptables -I INPUT -p tcp --dport 3306 -s 192.0.2.11 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 3306 -j DROP
```

Running `ufw` or `firewalld` instead? A plain `iptables -A INPUT ... -j DROP`
appends after those managers' own jump targets, so it's a no-op for traffic
they already accept — 3306 looks closed but isn't. Use the manager's own
rules. For `ufw` (add the `allow` first — rules are evaluated in the order
added):

```sh
sudo ufw allow from 192.0.2.11 to any port 3306 proto tcp
sudo ufw deny to any port 3306 proto tcp
```

Verify from a host you have not allowed through the firewall — `nc -vz -w 5
192.0.2.10 3306` should time out and fail (`-w 5` caps the wait instead of
`nc`'s full default timeout). And raw `iptables` rules don't survive a
reboot without `iptables-persistent` (or your distribution's equivalent).
See [Database exposure](USAGE.md#database-exposure) for the full reasoning.

### Multi-host: dialer side

Each dialer host needs its own address and the database's, in `.env`, before
its first build. Build only for now — **do not start it yet**, that depends on
whether this is the first dialer or not:

```sh
./generate-local-ip-env.sh          # LOCAL_IP=192.0.2.11
echo 'VICI_DB=192.0.2.10' >> .env
docker-compose build dialer          # build only -- do NOT start it yet
```

Both values are also honoured at runtime by the dialer (see [Changing the
server's IP address](USAGE.md#changing-the-servers-ip-address)), so a later
change is a restart, not necessarily a rebuild — but get them right from the
start anyway, to avoid a transient mismatch on first boot.

Now pick the path that matches this dialer — **read this before running `up`**:

**The first dialer:**

```sh
docker-compose up -d dialer
```

Nothing more is needed. A fresh database contains exactly one server row, and
the entrypoint adopts it and corrects its IP automatically.

**Each dialer after the first — register it, THEN start it, in this order:**

```sh
docker-compose run --rm dialer register-node --server-id=dialer2 --description="Dialer 2"
echo 'VICI_SERVER_ID=dialer2' >> .env
docker-compose up -d dialer
```

> **Do not run `docker-compose up -d dialer` for a second (or later) dialer
> before it's registered.** The entrypoint only refuses to guess when it sees
> **two or more** rows in `servers` — with just one row present (dialer 1's)
> and `VICI_SERVER_ID` unset, an unregistered dialer 2 looks, from the
> database's point of view, identical to a first dialer starting for the first
> time. It adopts that single row exactly as dialer 1 did, rewriting dialer
> 1's `server_id`, IP and its ~300 dependent rows (across `servers`,
> `server_updater`, `conferences` and `vicidial_conferences`) onto itself.
> `register-node` then refuses to register the correct address for dialer 1,
> because that address is now sitting on the row dialer 2 just stole. Both
> dialers end up broken, and recovering means repairing the database by hand.
> Registering first is what avoids this: it gives dialer 2 its own row before
> it ever starts, so there is no longer a single ambiguous row for it to adopt.

`register-node` refuses to overwrite an existing `server_id` or an
already-registered address, so re-running it is safe. Without
`VICI_SERVER_ID`, a dialer sharing a database with others will refuse to
correct any registration — deliberately, rather than risk overwriting another
node's.

Every host must also keep its clock synchronised (`ntp` or `chrony`). VICIdial
is sensitive to skew between dialers and the database.

Give the database host and every dialer host a **static address or a DHCP
reservation**. `VICI_DB_BIND` and each `grant-dialer` account are pinned to a
specific address; if one changes under DHCP, the next machine to hold that
address inherits the old grant and the old dialer needs re-granting and
re-pointing — see [Removing a grant](USAGE.md#removing-a-grant) and
[Changing the server's IP address](USAGE.md#changing-the-servers-ip-address).

That's the full multi-host setup for this host — you've already built and
started whatever roles it runs, following the sequence above. [§6. Build and
start](#6-build-and-start) and [§7. Verify the
install](#7-verify-the-install) below are the general build and verify steps
every install uses; on a role-limited host, keep naming your services there
too, rather than running the bare commands shown.

---

## 6. Build and start

```sh
docker-compose up -d --build
```

A host running only a subset of roles (§5a) should name its services here too — e.g. `docker-compose up -d --build db web` on the database host, `docker-compose up -d --build dialer` on a dialer host — or the bare command above builds and starts every role regardless.

**Multi-host database host:** the bare command above also tries to build and start `dialer`, which maps a DAHDI device (§2) that a database-only host usually doesn't have — so it fails at container creation instead of just doing unwanted work. Name your services (`db web`) here.

**Multi-host dialer hosts:** don't run `docker-compose up -d --build dialer` here for a second (or later) dialer. That both builds and starts it in one step, skipping the register-before-start ordering §5a walks through — and starting an unregistered dialer before it's registered can rewrite an existing dialer's registration. Follow §5a's build-then-register-then-start sequence instead.

The first run compiles Asterisk, so give it time. Watch progress with:

```sh
docker-compose logs -f
```

---

## 7. Verify the install

On a single host running everything, every check below applies. On a
role-limited host (§5a), each check names the role it needs — skip the ones
for roles that aren't here. That includes the two **Multi-host** checks at
the end: the first reads the `dialer` container's logs (dialer host only),
the second queries the `db` container directly (database host only).

**Services are up and the database is healthy:**

```sh
docker-compose ps
```

Expect `Up` for whichever services this host runs — all three
(`vicidial-db`, `vicidial-dialer`, `vicidial-web`) on a single-host install,
or just the ones you named in §5a on a role-limited host — with `db` showing
`(healthy)` wherever it's present.

**The dialer picked up DAHDI timing (dialer host):**

```sh
docker-compose exec dialer asterisk -rx "timing test"
```

Expected:

```
Using the 'DAHDI' timing module for this test.
```

If it says `timerfd`, the device isn't reaching the container — check §2.

**Conferencing is configured (dialer host):**

```sh
docker-compose exec dialer asterisk -rx "confbridge show profile bridges"
```

`vici_agent_bridge` should be listed. It's generated by VICIdial's keepalive cron within a minute of first start.

**The web interfaces respond (web host):**

| | |
|---|---|
| Admin | `http://<LOCAL_IP>/vicidial/admin.php` |
| Agent | `http://<LOCAL_IP>/agc/vicidial.php` |

Default VICIdial login is user **`6666`**, password **`1234`**. **Change it before putting this on a reachable network.** Neither URL is reachable locally from a dialer-only host — check them from the web host, or over the network at its address.

**Multi-host: the dialer reached the remote database.**

```sh
docker-compose logs dialer | grep -E 'waiting for DB|aligning|already registered'
```

If it instead prints a FATAL after 120s, the message lists the three usual
causes in the order worth checking — or jump straight to the one matching your
symptom in [USAGE.md's troubleshooting section](USAGE.md#troubleshooting).

**Multi-host: the database is listening where you expect — and nowhere else.**

```sh
docker-compose exec db sh -c 'mariadb -uroot -p"$MYSQL_ROOT_PASSWORD" -e "SELECT @@bind_address;"'
```

---

## Hosts that cannot run DAHDI

If the kernel genuinely can't build DAHDI, you can still run the stack:

```sh
docker-compose -f docker-compose.yaml -f docker-compose.no-dahdi.yaml up -d
```

This drops the device mapping and falls back to timerfd timing. **Suitable for evaluation, CI and development — not for live calling**, for the reason in §2. The dialer prints a warning on every start while in this mode.

---

## First-run troubleshooting

**`error gathering device information while adding custom device "/dev/dahdi/timer": no such file or directory`**
The `dahdi` module isn't loaded. Work through §2. If `modprobe` says `Operation not permitted`, that's Secure Boot.

**`env file ... docker/mysql/mysql.env not found`**
You skipped §4. Copy it from the example.

**Admin page returns HTTP 500, or the login is rejected**
Usually a database that was initialised with credentials that don't match VICIdial's. Confirm §4, then re-seed with `docker-compose down -v` followed by `docker-compose up -d` (**this destroys the database**).

**`ERROR 2026 (HY000): TLS/SSL error: SSL is required...`**
You're running the `mysql` client by hand. Debian's MariaDB 11 client wants TLS but the bundled server doesn't offer it — add `--skip-ssl`.

**`dahdi-dkms` fails to build**
The kernel is unsupported or headers don't match the running kernel. Check `uname -r` against the installed `linux-headers`, reboot if you recently updated, and see the supported-kernel table in §2.
