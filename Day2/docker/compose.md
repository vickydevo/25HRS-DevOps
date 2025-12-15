# README.md

## Docker Compose — Overview

Docker Compose is a tool for defining and running multi-container Docker applications using a single YAML file. It lets you describe services, networks and volumes, then start and stop the full app with a single command.

## Why use Docker Compose

- Define multi-container apps declaratively.
- Reproduce the same environment across machines.
- Simplify development workflows (one command to start).
- Manage service dependencies, ports, restart policies and environment variables in one place.

## Installation (brief)

Prerequisite: Docker Engine must be installed.

- macOS / Windows: Install Docker Desktop (includes Docker Compose).
    - https://www.docker.com/products/docker-desktop
- Linux:
    - If using Docker Engine v20.10+, use the built-in Compose V2 plugin:
        - Confirm with: `docker compose version`
    - Or install standalone Compose (deprecated) following official docs:
        - https://docs.docker.com/compose/install/

Verify:  
`docker compose version` or `docker-compose --version` (depending on install).

## Project setup

1. Place the compose file in your project root as `docker-compose.yml`.
2. If your service uses a local image, build it first:
     - `docker build -t springboot-test:30aug .`

3. Start services:
     - `docker compose up -d`

4. Useful commands:
     - `docker compose ps`
     - `docker compose logs -f springboot-backend`
     - `docker compose down`

## Example docker-compose.yml

```yaml
version: '3.8'

services:
    springboot:
        image: springboot-test:30aug
        container_name: springboot-backend
        ports:
            - "8083:8081"    # host:container (access app on host port 8083)
        restart: always
```

Notes:
- `restart: always` restarts the container on failure or host reboot.
- Adjust ports, environment variables, volumes, and networks as needed for your app.
- For local development consider mounting source code with `volumes:` and enabling hot reload.