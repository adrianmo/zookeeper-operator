#!/usr/bin/env bash
set -ex

function zkConfig() {
  echo "$HOST.$DOMAIN:$QUORUM_PORT:$LEADER_PORT:$ROLE;$CLIENT_PORT"
}

function zkConnectionString() {
  # Lookup the zookeeper ensemble membership using the headless cluster service domain.
  # We execute 2 lookups so that we can reference each node by hostname rather than IP.
  HOSTS=`nslookup $DOMAIN | awk '{print $4}'`
  ZK_CONNECTION_STRING=""
  for i in $HOSTS; do
    if [[ "$ZK_CONNECTION_STRING" == "" ]]; then
      ZK_CONNECTION_STRING="${i}:${CLIENT_PORT}"
    else
      ZK_CONNECTION_STRING="${ZK_CONNECTION_STRING},${i}:${CLIENT_PORT}"
    fi
  done
  if [[ "$ZK_CONNECTION_STRING" == "" ]]; then
    echo "localhost:${CLIENT_PORT}"
  else
    echo $ZK_CONNECTION_STRING
  fi
}
