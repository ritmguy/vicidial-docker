# Vicidial in Docker

This project provides a Docker-based setup for running a self-hosted [Vicidial](http://www.vicidial.org/) call center solution. It uses multiple containers to separate concerns, including a MariaDB backend and a dialer application container. Optional support for Let's Encrypt certificates via Certbot is included (commented out for now).

---

## ![headset](https://img.icons8.com/ios-filled/50/000000/headset.png) Services

### `db` - MariaDB Database
- **Container Name:** `vicidial-db`
- **Dockerfile:** `./docker/mysql/Dockerfile.mariadb`
- **Environment Variables:** Loaded from `./docker/mysql/mysql.env`
- **Volumes:**
  - Persistent DB data: `db_data:/var/lib/mysql`
  - DB logs: `db_log:/var/log/mysql`
  - SQL import files: `./docker/mysql/import:/var/lib/mysql-files`
- **Healthcheck:** Uses `mysqladmin ping` on socket `/tmp/mysql.sock`
- **IP Address:** `10.10.10.10` (on backend network)
- **Restart Policy:** `unless-stopped`

---

### `dialer` - Vicidial Application
- **Container Name:** `vicidial-dialer`
- **Dockerfile:** `./docker/app/Dockerfile.ubuntu`
- **Build Args:**
  - `VICI_DB=10.10.10.10`
  - `VICI_HOST=10.10.10.15`
- **Volumes:**
  - Web content: `/var/www/html`
  - SSL Certs: 
    - `./docker/certbot/letsencrypt/certs:/etc/letsencrypt`
    - `./docker/certbot/letsencrypt/data:/var/lib/letsencrypt`
- **Ports Exposed:**
  - HTTP: `8080:80`
  - SIP: `5060:5060`
  - IAX2: `4569:4569`
- **Networks:**
  - `vici-backend` (IP: `10.10.10.15`)
  - `vici-frontend`
- **Depends On:** Waits for healthy `db`

---

### (Optional) `certbot` - Let's Encrypt SSL Generation
*Currently commented out.*

- **Image:** `certbot/certbot`
- **Volumes:** Inherits from `dialer`
- **Command:**
  ```bash
  certonly --keep-until-expiring --standalone \
    --email test@test.com --agree-tos \
    --no-eff-email -d vici-dev.protect247.app
