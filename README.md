# Exim on Alpine Docker Image

Exim on Alpine with LDAP, TLS, content scanning, SPF, DKIM, and DMARC.

- **Exim**: 4.100.1
- **Alpine**: 3.24.3
- **Build**: multi-stage

## Pull

```bash
docker pull olegeech/exim-alpine:latest
```

## Build

```bash
docker build -t olegeech/exim-alpine:latest .
```

## Run

```bash
docker run -d \
    -v /path/to/exim.conf:/etc/exim/exim.conf \
    -p 25:25 \
    --name exim-server \
    olegeech/exim-alpine:latest
```
