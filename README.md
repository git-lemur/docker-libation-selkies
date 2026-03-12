# Docker Libation Selkies

A web-accessible version of [Libation](https://github.com/rmcrackan/Libation), an open-source Audible library manager. This image uses the [Selkies](https://github.com/linuxserver/docker-baseimage-selkies) base image from LinuxServer.io to provide a high-performance, browser-based GUI.

## Features

- **Web GUI:** Access Libation from any browser via VNC/WebRTC.
- **Native Installation:** Uses the official Libation `.deb` package for full compatibility and dependencies.
- **Multi-Arch Support:** Includes Dockerfiles for both AMD64 and ARM64 (AArch64).

## Quick Start

### 1. Build the image
```bash
docker build -t libation-selkies .
```

### 2. Run with Docker Compose
Create a `docker-compose.yaml` (or use the one provided in this repo):

```yaml
services:
  libation:
    image: libation-selkies:latest
    container_name: libation
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
    volumes:
      - ./config:/config
      - ./downloads:/data
    ports:
      - 8080:8080
    restart: unless-stopped
```

Run it:
```bash
docker-compose up -d
```

### 3. Access
Open your browser and navigate to:
`http://localhost:8080`

## Environment Variables

| Variable | Description |
| -------- | ----------- |
| `PUID` | User ID for file permissions |
| `PGID` | Group ID for file permissions |
| `TZ` | Timezone (e.g., `America/New_York`) |
| `TITLE` | Window title for the web interface |

## Volumes

- `/config`: Stores Libation settings, database, and logs.
- `/data`: Default location for downloaded audiobooks.

## License

Libation is licensed under the GPL-3.0 license. This Docker integration is provided as-is.
