FROM ghcr.io/anujdatar/cups

ARG TARGETARCH

RUN apt-get update -qq && apt-get install -qqy wget

ENV CANON_URL="https://gdlp01.c-wss.com/gds/0/0100009240/40/linux-UFRII-drv-v630-m17n-07.tar.gz"
ENV CANON_SHA256="4ae588d8e4e14b25b74b8f8d2d5bee1e4621c27d2dd2e12ce7203e191693c755"

WORKDIR /tmp

RUN wget -q $CANON_URL -O canon-driver.tar.gz && \
    echo "$CANON_SHA256  canon-driver.tar.gz" | sha256sum -c - && \
    tar -xf canon-driver.tar.gz && \
    \
    case "$TARGETARCH" in \
        amd64) DIR="x64" ;; \
        arm64) DIR="ARM64" ;; \
        *) echo "Unsupported architecture: $TARGETARCH"; exit 1 ;; \
    esac && \
    \
    cd linux-UFRII-drv-*/${DIR}/Debian && \
    apt-get install -qqy ./cnrdrvcups-ufr2*.deb && \
    \
    cd /tmp && \
    rm -rf linux-UFRII-drv* canon-driver.tar.gz

CMD ["/entrypoint.sh"]
