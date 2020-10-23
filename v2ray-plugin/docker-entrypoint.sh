#!/bin/bash

set -e

if [ -z $PASSWORD ]; then
    echo FATAL: Password should be defined via environment variables. >&2
    exit 1
fi

exec /usr/bin/ss-server \
    -s ${SERVER_HOST:-0.0.0.0} \
    -p ${SERVER_PORT:-8388} \
    -k ${PASSWORD} \
    -m ${METHOD:-chacha20-ietf-poly1305} \
    ${RESOLVERS:+-d $RESOLVERS} \
    ${BIND_ADDRESS:+-b $BIND_ADDRESS} \
    --plugin /usr/bin/v2ray-plugin \
    --plugin-opts "${V2RAY_OPTS:-server}" \
    $ARGS
