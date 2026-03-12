# Docker Libation Selkies

A web-accessible version of [Libation](https://github.com/rmcrackan/Libation), an open-source Audible library manager. This image uses the [Selkies](https://github.com/linuxserver/docker-baseimage-selkies) base image from LinuxServer.io to provide a high-performance, browser-based GUI.

## Features

- **Web GUI:** Access Libation from any browser via VNC/WebRTC.
- **Native Installation:** Uses the official Libation `.deb` package for full compatibility and dependencies.
- **Multi-Arch Support:** Includes Dockerfiles for both AMD64 and ARM64 (AArch64).

## Quick Start

### 1. Create a `docker-compose.yaml`
You can download the `docker-compose.yaml` from this repository or create a new one with the following content:

```yaml
services:
  libation:
    image: ghcr.io/git-lemur/docker-libation-selkies:latest
    container_name: libation
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Etc/UTC
      - CUSTOM_USER=admin
      - PASSWORD=password123
    volumes:
      - ./config:/config
      - ./downloads:/config/Libation/Books
    ports:
      - 8080:8080
    restart: unless-stopped
```

### 2. Run the container
Run the following command in the same directory as your `docker-compose.yaml`:

```bash
docker-compose up -d
```

### 3. Access
Open your browser and navigate to:
`http://localhost:8080`

## Custom Build (Optional)
If you want to build the image locally from source:
```bash
docker build -t libation-selkies .
```

## Environment Variables

| Variable | Description |
| -------- | ----------- |
| `PUID` | User ID for file permissions |
| `PGID` | Group ID for file permissions |
| `TZ` | Timezone (e.g., `America/New_York`) |
| `TITLE` | Window title for the web interface |
| `CUSTOM_USER` | Username for web interface authentication |
| `PASSWORD` | Password for web interface authentication |

## Volumes

- `/config`: Stores Libation settings, database, and logs.
- `/config/Libation/Books`: Default location for downloaded audiobooks (mapped to `./downloads`).

## License

Libation is licensed under the GPL-3.0 license. This Docker integration is provided as-is.
