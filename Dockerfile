FROM misotolar/alpine:3.20.1 as build

ENV USTREAMER_VERSION=6.12
ARG SHA256=6ebfebdad21cf381f2026f0b0b0c9dc024b1dd6d156b71b7a6977fdbe2db8a0b
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

FROM misotolar/alpine:3.20.1

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
