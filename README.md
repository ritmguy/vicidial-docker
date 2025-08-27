# VICIdial Docker Compose Setup

A containerized deployment of VICIdial (Vicidial Internet Contact Center) using Docker Compose with MariaDB, web interface, and dialer components.

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

## Prerequisites

- Docker Engine 20.10+
- Docker Compose 2.0+
- Minimum 4GB RAM
- Minimum 20GB disk space

## Environment Setup

1. **Clone the repository** and navigate to the project directory

2. **Set up environment variables**:

   ```bash
   export LOCAL_IP=your.server.ip.address
   ```

   Replace `your.server.ip.address` with your actual server IP address.

3. **Configure MySQL environment**:
   Edit `./docker/mysql/mysql.env` with your database configuration.

## Directory Structure

```
.
├── docker-compose.yaml
├── docker/
│   ├── mysql/
│   │   ├── Dockerfile.mariadb
│   │   ├── mysql.env
│   │   └── import/          # MySQL import files
│   ├── dialer/
│   │   └── Dockerfile
│   ├── web/
│   │   └── Dockerfile
│   └── certbot/
│       └── letsencrypt/
│           ├── certs/
│           └── data/
```

## Services Configuration

### Database Service (db)

- **Container**: `vicidial-db`
- **Image**: Custom MariaDB build
- **Health Check**: MySQL ping on socket `/tmp/mysql.sock`
- **Volumes**:
  - `db_data`: Database files persistence
  - `db_log`: Database logs
  - `./docker/mysql/import`: Import directory for SQL files
- **Network**: Host mode

### Dialer Service (dialer)

- **Container**: `vicidial-dialer`
- **Dependencies**: Database service (healthy)
- **Build Args**:
  - `VICI_DB=127.0.0.1`
  - `VICI_HOST=${LOCAL_IP}`
  - `VICI_EXT_IP=${LOCAL_IP}`
- **Network**: Host mode

### Web Service (web)

- **Container**: `vicidial-web`
- **Dependencies**: Database service (healthy)
- **Build Args**:
  - `VICI_DB=127.0.0.1`
  - `VICI_HOST=${LOCAL_IP}`
  - `VICI_EXT_IP=${LOCAL_IP}`
  - `VICI_WEB_HOST=true`
- **Volumes**:
  - `/var/www/html`: Web files
  - SSL certificates (Let's Encrypt)
- **Network**: Host mode

## Installation & Usage

### 1. Start the Services

```bash
# Build and start all services
docker-compose up -d

# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f web
docker-compose logs -f dialer
docker-compose logs -f db
```

### 2. Check Service Status

```bash
# Check running containers
docker-compose ps

# Check database health
docker-compose exec db mysqladmin ping -h localhost -S /tmp/mysql.sock
```

### 3. Access the Application

- **Web Interface**: `http://your-server-ip/vicidial/admin.php`
- **Agent Interface**: `http://your-server-ip/agc/vicidial.php`

## Important Notes

### Network Configuration

- All services use **host network mode** for direct access to host networking
- This bypasses Docker's internal networking and uses the host's network stack directly
- Commented port mappings are available if you prefer bridge networking

### SSL/TLS Support

- SSL certificate support via Let's Encrypt (currently commented out)
- Uncomment the `certbot` service for automatic SSL certificate generation
- Update email and domain in the certbot configuration before enabling

### Development vs Production

- The `tty: true` option in the web service provides readable logs for development
- Comment this line in production deployments

## Volumes

| Volume    | Purpose                    | Path             |
| --------- | -------------------------- | ---------------- |
| `db_data` | Database files persistence | `/var/lib/mysql` |
| `db_log`  | Database logs              | `/var/log/mysql` |

## Troubleshooting

### Common Issues

1. **Database Connection Issues**:

   ```bash
   # Check database health
   docker-compose exec db mysqladmin ping -h localhost -S /tmp/mysql.sock
   ```

2. **Permission Issues**:

   ```bash
   # Check container logs
   docker-compose logs db
   ```

3. **Network Connectivity**:
   - Ensure `LOCAL_IP` environment variable is set correctly
   - Verify firewall settings allow necessary ports

### Service Management

```bash
# Restart specific service
docker-compose restart web

# Rebuild and restart
docker-compose up -d --build web

# Stop all services
docker-compose down

# Stop and remove volumes (⚠️ DATA LOSS)
docker-compose down -v
```

## Maintenance

### Backup Database

```bash
# Create database backup
docker-compose exec db mysqldump -u root -p --all-databases > backup.sql
```

### Update Services

```bash
# Pull latest changes and rebuild
git pull
docker-compose down
docker-compose up -d --build
```

## Security Considerations

- Change default database credentials in `mysql.env`
- Use strong passwords for all accounts
- Consider implementing SSL/TLS certificates for production
- Regularly update base images and dependencies
- Monitor container logs for suspicious activities

---

**Note**: This is a development/testing configuration. For production deployments, review security settings, enable SSL, and configure appropriate backup strategies.
