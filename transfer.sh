#!/bin/bash
DATA='{"jsonrpc":"2.0","method":"eth_sendTransaction","params":[{"from":"0x00a329c0648769a73afac7f9381e08fb43dbea72","to":"RECEIVER","value":"0x52b7d2dcc80cd2e4000000","gas":"0x5208"}],"id":1}'
ACCOUNTS=`parity --base-path /data --chain=dev account list | tail -n 10`

/usr/bin/parity daemon --no-ipc --base-path /data --chain=dev --geth --unlock 0x00a329c0648769a73afac7f9381e08fb43dbea72 --password <(echo "") /data/parity.pid

echo "Waiting for parity rpc..."
while ! nc -z localhost 8545; do
  sleep 0.1 # wait for 1/10 of the second before check again
done

for acct in $ACCOUNTS
do
  payload=`echo $DATA | sed s/RECEIVER/$acct/`
  curl -s -H 'Content-Type: application/json' -X POST --data "$payload" http://127.0.0.1:8545
done

kill -9 `cat /data/parity.pid`
