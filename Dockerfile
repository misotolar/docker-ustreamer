FROM misotolar/alpine:3.21.0 as build

ENV USTREAMER_VERSION=6.18
ARG SHA256=9bd57e18a05bda54012ac8c3e4b906ff23e7c69787dd246de30c70c9ae507d6b
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

FROM misotolar/alpine:3.21.0

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
