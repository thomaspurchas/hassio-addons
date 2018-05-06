#!/bin/bash
set -e

CONFIG_PATH=/data/options.json
INFLUX_DATA=/data/influxdb

DATABASES=$(jq --raw-output ".databases[]" $CONFIG_PATH)

# Init influxdb
if [ ! -d "$INFLUX_DATA" ]; then
    echo "[INFO] Create a new influxdb initial system"
    mkdir -p $INFLUX_DATA > /dev/null
else
    echo "[INFO] Use exists influxdb initial system"
fi

# Start influxdb
echo "[INFO] Start InfluxDB"
influxd &
INFLUXDB_PID=$!

# Wait until DB is running
while ! influx -execute "" 2> /dev/null; do
    sleep 1
done

# Init databases
echo "[INFO] Init custom database"
for line in $DATABASES; do
    echo "[INFO] Create database $line"
    influx -execute "CREATE DATABASE $line;" 2> /dev/null || true
done

# Register stop
function stop_influxd() {
    kill $INFLUXDB_PID
}
trap "stop_influxd" SIGTERM SIGHUP

wait "$INFLUXDB_PID"
