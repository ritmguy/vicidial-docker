# Docker Compose Project

This project uses Docker Compose to set up a multi-container application environment. The services defined include a MariaDB database, a Redis cache, and a Laravel-based application with PHP and Nginx.

## Services

### 1. **app**
- **Image**: `laravelphp/php-fpm`
- **Ports**: Exposes port `9000` (internal use by Nginx)
- **Volumes**: Mounts the application source code to `/var/www/html`
- **Depends on**: `db`, `redis`
- **Networks**: Connected to `frontend` and `backend`

### 2. **nginx**
- **Image**: `nginx:alpine`
- **Ports**: Maps port `80` on the host to `80` in the container
- **Volumes**:
  - Application code
  - Custom Nginx configuration (`./nginx/nginx.conf`)
- **Depends on**: `app`
- **Networks**: Connected to `frontend`

### 3. **db**
- **Image**: `mariadb:10.5`
- **Environment**:
  - `MYSQL_DATABASE`: `laravel`
  - `MYSQL_USER`: `user`
  - `MYSQL_PASSWORD`: `secret`
  - `MYSQL_ROOT_PASSWORD`: `secret`
- **Volumes**: Persists data to `dbdata`
- **Networks**: Connected to `backend`

### 4. **redis**
- **Image**: `redis:alpine`
- **Networks**: Connected to `backend`

## Volumes

- `dbdata`: Stores MariaDB data persistently

## Networks

- **frontend**: Handles external traffic via Nginx
- **backend**: Handles internal traffic between `app`, `db`, and `redis`

## Usage

### Starting the Containers

```bash
docker-compose up -d
