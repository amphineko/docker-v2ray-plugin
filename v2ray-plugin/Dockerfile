ARG SHADOWSOCKS_LIBEV_VERSION

FROM golang:1.15-alpine as build

ARG V2RAY_PLUGIN_VERSION
ENV V2RAY_PLUGIN_VERSION=${V2RAY_PLUGIN_VERSION}

RUN apk --no-cache add git tini \
    && git clone https://github.com/shadowsocks/v2ray-plugin -b ${V2RAY_PLUGIN_VERSION} /v2ray-plugin

WORKDIR /v2ray-plugin

RUN go build

FROM shadowsocks/shadowsocks-libev:$SHADOWSOCKS_LIBEV_VERSION

# copy baked binary from previous stage
COPY --from=build /v2ray-plugin/v2ray-plugin /usr/bin/v2ray-plugin

# copy pre-downloaded tini from previous stage
# `apk add` won't run as nobody (specified on shadowsocks/shadowsocks-libev)
COPY --from=build /sbin/tini /sbin/tini

# use tini to reap stalled zombie v2ray-plugin
ENTRYPOINT [ "/sbin/tini", "--" ]

# image variables
ENV ARGS=
ENV DNS_ADDRS       8.8.8.8,8.8.4.4
ENV METHOD          aes-256-gcm
ENV PASSWORD=
ENV PLUGIN_OPTS     server
ENV SERVER_ADDR     0.0.0.0
ENV SERVER_PORT     8388
ENV TIMEOUT         300
ENV TZ              UTC

# TODO: complete argument filling
CMD exec /usr/bin/ss-server \
    -d $DNS_ADDRS \
    -k ${PASSWORD:-$(hostname)} \
    -m $METHOD \
    -p $SERVER_PORT \
    --plugin /usr/bin/v2ray-plugin \
    --plugin-opts "$PLUGIN_OPTS" \
    -s $SERVER_ADDR \
    -t $TIMEOUT \
    -u \
    $ARGS
