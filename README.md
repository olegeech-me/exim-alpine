# Exim on Alpine Docker Image

This repository contains the Dockerfile for building a lightweight Exim mail server on Alpine Linux. Exim is compiled with support for LDAP, TLS, content scanning using ClamAV, and other important modules.

## Features

- **Exim version**: 4.98
- **Base image**: Alpine Linux 3.20-latest
- **Modules included**:
  - LDAP support
  - TLS with OpenSSL
  - Content scanning
  - SPF, DKIM, and DMARC
  - Maildir support

## How to Use

### Build the Docker Image

Clone this repository and run the following command to build the Docker image:

```bash
git clone https://github.com/olegeech-me/exim-alpine.git
cd exim-alpine
docker build -t exim-alpine .
```

### Customizing the Build

You can customize your Exim build by modifying the Dockerfile or the Makefile found in the `build-config` directory.

- **Dockerfile**: This file defines the base Alpine image, dependencies, and steps for building Exim.
- **Custom Makefile**: Located in the `build-config/CustomMakefile`, this file allows you to control the compilation options and included features for Exim. Update this file to enable or disable specific modules, such as DNSSEC, DANE, or SPF.
- **Default Makefile**: Serves as an example of all available Exim flags. Use it as a reference to build your own cusom Makefile.

#### Example: Customizing Makefile

To add or remove features from your Exim build, edit the `CustomMakefile`:

```bash
# Example: Disable DNSSEC and DANE support
DISABLE_DNSSEC=yes
SUPPORT_DANE=no
```

Once you’ve made your changes, rebuild the Docker image:

```bash
docker build -t exim-alpine .
```

### Example: Run the Docker Image
Here’s an example of running the container with a mounted configuration file:

```bash
docker run -d \
    -v /path/to/exim.conf:/etc/exim/exim.conf \
    -p 25:25
    --name exim-server \
    exim-alpine
```



