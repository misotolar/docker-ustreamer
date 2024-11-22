FROM misotolar/alpine:3.20.2 as build

ENV USTREAMER_VERSION=6.17
ARG SHA256=92af80c94ccea9a9b09a1e6a77b67389b7d4f1574f3683d5001e0f54fff89c94
ADD https://github.com/pikvm/ustreamer/archive/refs/tags/v$USTREAMER_VERSION.tar.gz /tmp/ustreamer.tar.gz

WORKDIR /build

RUN set -ex; \
    apk add --no-cache \
        alpine-sdk \
        linux-headers \
        libjpeg-turbo-dev \
        libevent-dev \
        libbsd-dev \
    ; \
    echo "$SHA256 */tmp/ustreamer.tar.gz" | sha256sum -c -; \
    tar xf /tmp/ustreamer.tar.gz --strip-components=1; \
    make -j$(nproc); \
    rm -rf \
        /var/cache/apk/* \
        /var/tmp/* \
        /tmp/*

FROM misotolar/alpine:3.20.3

LABEL maintainer="michal@sotolar.com"

WORKDIR /usr/local/bin

RUN set -ex; \
    apk add --no-cache \
        libevent \
        libjpeg-turbo \
        libevent \
        libbsd \
    ; \
    rm -rf \
        /var/cache/apk/* \
        /var/tmp/* \
        /tmp/*

COPY --from=build /build/src/ustreamer.bin /usr/local/bin/ustreamer
