ARG ALPINE_VERSION=3.24.3
ARG EXIM_VERSION=4.100.1

# ---------------------------------------------------------------------------
# Build stage
# ---------------------------------------------------------------------------
FROM alpine:${ALPINE_VERSION} AS builder

ARG EXIM_VERSION
ARG MAKEFILE=build-config/CustomMakefile

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
    tdb-dev \
    perl-file-fcntllock \
    gawk \
    wget

RUN addgroup -S exim && \
    adduser -S -G exim -h /var/spool/exim -s /sbin/nologin exim

WORKDIR /usr/local/src

RUN wget -q "https://ftp.exim.org/pub/exim/exim4/exim-${EXIM_VERSION}.tar.gz" && \
    tar xzf "exim-${EXIM_VERSION}.tar.gz" && \
    rm "exim-${EXIM_VERSION}.tar.gz"

COPY ${MAKEFILE} exim-${EXIM_VERSION}/Local/Makefile

RUN cd "exim-${EXIM_VERSION}" && \
    make -j"$(nproc)" && \
    make install

# ---------------------------------------------------------------------------
# Runtime stage
# ---------------------------------------------------------------------------
FROM alpine:${ALPINE_VERSION}

ARG EXIM_VERSION
LABEL maintainer="olegeech <olegeech@sytkovo.su>"
LABEL org.opencontainers.image.title="exim-alpine"
LABEL org.opencontainers.image.description="Exim on Alpine with LDAP, TLS, content scanning, SPF/DKIM/DMARC"
LABEL org.opencontainers.image.version="${EXIM_VERSION}"

RUN apk add --no-cache \
    ca-certificates \
    openssl \
    libldap \
    libspf2 \
    opendmarc \
    pcre2 \
    tdb-libs \
    db \
    libidn \
    linux-pam \
    gnu-libiconv \
    && addgroup -S exim \
    && adduser -S -G exim -h /var/spool/exim -s /sbin/nologin exim \
    && mkdir -p /etc/exim /var/spool/exim /var/log/exim \
    && chown -R exim:exim /var/spool/exim /var/log/exim

COPY --from=builder /usr/bin/exim /usr/bin/exim

WORKDIR /etc/exim

ENTRYPOINT ["exim"]
CMD ["-v", "-bdf", "-q15m"]
