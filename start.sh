#!/bin/bash
ACCOUNTS=`parity --base-path /data --chain=dev account list | tr '\n' ',' | sed 's/,$//'` && \
/usr/bin/parity \
  --base-path /data \
  --chain=dev \
  --jsonrpc-hosts all \
  --jsonrpc-interface all \
  --ws-interface all \
  --jsonrpc-port 8945 \
  --geth \
  --no-ipc \
  --unlock ${ACCOUNTS} \
  --password <(echo "")
