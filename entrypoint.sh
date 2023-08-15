#!/bin/bash
set -eu

SERVER_NAME="$FLY_MACHINE_ID"

# if command starts with an option, prepend rethinkdb
if [ "${1:0:1}" = '-' ]; then
	set -- rethinkdb $@
fi

if [ "$1" = 'proxy' ]; then
  echo "Running in proxy mode..."

  # Check whether a server is online
  getent hosts app.process.$FLY_APP_NAME.internal || (echo "[Error] No servers found!" && exit 1)

  set -- rethinkdb proxy --bind all --initial-password $RETHINKDB_PASSWORD --join app.process.$FLY_APP_NAME.internal
fi

if [ "$1" = 'database' ]; then
  echo "Running in database mode..."

  echo "Finding other hosts..."
  FIRST_HOST=`getent hosts app.process.rethinkdb-dev.internal | grep -vF "$FLY_PRIVATE_IP" | head -n 1 |  cut -d ' ' -f 1`

  set -- rethinkdb --server-name $SERVER_NAME --bind all --no-http-admin --initial-password $RETHINKDB_PASSWORD

  # Check whether there are other hosts to join
  if [ -z "$FIRST_HOST" ]; then
    echo "No other hosts found!"
  else
    echo "Joining: $FIRST_HOST"
    set -- "$@" --join $FIRST_HOST
  fi
fi

exec "$@"
