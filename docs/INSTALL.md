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

This is a single-host stack: database, dialer and web all run on one machine using host networking.

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
git checkout v0.2.0          # or the latest tag
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

## 6. Build and start

```sh
docker-compose up -d --build
```

The first run compiles Asterisk, so give it time. Watch progress with:

```sh
docker-compose logs -f
```

---

## 7. Verify the install

**Services are up and the database is healthy:**

```sh
docker-compose ps
```

All three (`vicidial-db`, `vicidial-dialer`, `vicidial-web`) should be `Up`, with `db` showing `(healthy)`.

**The dialer picked up DAHDI timing:**

```sh
docker-compose exec dialer asterisk -rx "timing test"
```

Expected:

```
Using the 'DAHDI' timing module for this test.
```

If it says `timerfd`, the device isn't reaching the container — check §2.

**Conferencing is configured:**

```sh
docker-compose exec dialer asterisk -rx "confbridge show profile bridges"
```

`vici_agent_bridge` should be listed. It's generated by VICIdial's keepalive cron within a minute of first start.

**The web interfaces respond:**

| | |
|---|---|
| Admin | `http://<LOCAL_IP>/vicidial/admin.php` |
| Agent | `http://<LOCAL_IP>/agc/vicidial.php` |

Default VICIdial login is user **`6666`**, password **`1234`**. **Change it before putting this on a reachable network.**

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
