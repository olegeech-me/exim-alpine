FROM alpine:3.20

LABEL maintainer="olegeech <olegeech@sytkovo.su>"

ARG EXIM_VERSION=4.98
ARG MAKEFILE=build-config/CustomMakefile

ENV EXIM_VERSION=${EXIM_VERSION}

# Install necessary dependencies for building Exim
RUN apk add --no-cache \
    build-base \
    openssl-dev \
    openldap-dev \
    pcre2-dev \
    libspf2-dev \
    opendmarc-dev \
    db-dev \
    perl-dev \
    linux-pam-dev \
    gnu-libiconv-dev \
    libidn-dev \
    tdb-libs \
    perl-file-fcntllock \
    gawk

# Set up Exim build environment
WORKDIR /usr/local/src

# Add exim user
RUN addgroup -S exim && \
    adduser -S -G exim -h /var/spool/exim -s /sbin/nologin exim

# Download and extract Exim source
RUN wget https://ftp.exim.org/pub/exim/exim4/exim-${EXIM_VERSION}.tar.gz && \
    tar xzf exim-${EXIM_VERSION}.tar.gz && \
    rm exim-${EXIM_VERSION}.tar.gz

# Add config for building
COPY ${MAKEFILE} exim-${EXIM_VERSION}/Local/Makefile

# Build and install Exim
RUN cd exim-${EXIM_VERSION} && \
    make && make install

# Clean up build dependencies to reduce image size
RUN apk del build-base

