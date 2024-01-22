#!/bin/bash
set -meuo pipefail

JUMPCOIN_DIR=/jump/.jumpcoin/
JUMPCOIN_CONF=/jump/.jumpcoin/jumpcoin.conf

if [ -z "${JUMPCOIN_RPCPASSWORD:-}" ]; then
  # Provide a random password.
  JUMPCOIN_RPCPASSWORD=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 24 ; echo '')
fi

if [ ! -e "${JUMPCOIN_CONF}" ]; then
  tee -a >${JUMPCOIN_CONF} <<EOF
server=1
rpcuser=${JUMPCOIN_RPCUSER:-jumpcoinrpc}
rpcpassword=${JUMPCOIN_RPCPASSWORD}
rpcclienttimeout=${JUMPCOIN_RPCCLIENTTIMEOUT:-30}
EOF
echo "Created new configuration at ${JUMPCOIN_CONF}"
fi

if [ $# -eq 0 ]; then
  /jump/jumpcoin/src/jumpcoind -rpcbind=:4444 -rpcallowip=* -printtoconsole=1
else
  exec "$@"
fi
