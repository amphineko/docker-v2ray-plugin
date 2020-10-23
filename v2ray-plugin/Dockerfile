FROM alpine:3.12 as shadowsocks-libev-build

ARG SHADOWSOCKS_LIBEV_VERSION
ENV SHADOWSOCKS_LIBEV_VERSION=${SHADOWSOCKS_LIBEV_VERSION}

RUN apk --no-cache add \
    # dependencies
    c-ares-dev libev-dev libsodium-dev linux-headers mbedtls-dev pcre-dev \
    # build tools
    autoconf automake build-base git libtool

RUN git clone --recurse-submodules https://github.com/shadowsocks/shadowsocks-libev -b ${SHADOWSOCKS_LIBEV_VERSION} /source

WORKDIR /source

RUN set -ex \
    && ./autogen.sh \
    && ./configure --disable-documentation --prefix=/build \
    && make install



FROM golang:1.15-alpine as v2ray-build

ARG V2RAY_PLUGIN_VERSION
ENV V2RAY_PLUGIN_VERSION=${V2RAY_PLUGIN_VERSION}

RUN apk --no-cache add git

RUN git clone https://github.com/shadowsocks/v2ray-plugin -b ${V2RAY_PLUGIN_VERSION} /v2ray-plugin

WORKDIR /v2ray-plugin

RUN go build



FROM alpine:3.12

RUN apk --no-cache add \
    # dependencies
    c-ares libev libsodium mbedtls pcre \
    # runtime tools
    bash tini

# copy baked binaries from previous stage
COPY --from=shadowsocks-libev-build /build/bin/ss-server /usr/bin/ss-server
COPY --from=v2ray-build /v2ray-plugin/v2ray-plugin /usr/bin/v2ray-plugin

ENTRYPOINT [ "/sbin/tini", "--" ]

ADD ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

CMD "/docker-entrypoint.sh"
