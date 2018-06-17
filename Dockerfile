FROM golang:alpine

ENV GLIBC 2.23-r3
ENV ALPINE_GLIBC_PUBKEY https://raw.githubusercontent.com/sgerrand/alpine-pkg-glibc/master/sgerrand.rsa.pub 
ENV ALPINE_GLIBC_APK    https://github.com/sgerrand/alpine-pkg-glibc/releases/download/$GLIBC/glibc-$GLIBC.apk

# Install libraries to enable docker-compose to work with GLIBC on Alpine
#  inspired by: https://github.com/docker/compose/pull/3856
RUN apk update && \
    apk add --no-cache openssl ca-certificates && \
    wget -q -O /etc/apk/keys/sgerrand.rsa.pub $ALPINE_GLIBC_PUBKEY && \
    wget $ALPINE_GLIBC_APK && \
    apk add --no-cache glibc-$GLIBC.apk && \
    rm glibc-$GLIBC.apk && \
    ln -s /lib/libz.so.1 /usr/glibc-compat/lib/ && \
    ln -s /lib/libc.musl-x86_64.so.1 /usr/glibc-compat/lib

COPY --from=docker/compose:1.21.2 /usr/local/bin/docker-compose /usr/local/bin/docker-compose

