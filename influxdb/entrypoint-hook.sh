#!/bin/bash

# [ -f /run/secrets/INFLUXDB_ADMIN_TOKEN ] && INFLUXDB3_AUTH_TOKEN="$(cat /run/secrets/INFLUXDB_ADMIN_TOKEN 2>/dev/null)"
#
# if [ -n "$INFLUXDB3_AUTH_TOKEN" ] && [ -d "$INFLUXDB3_PROVISIONING_DIR" ] && [ ! -f "$INFLUXDB3_DB_DIR/.provisioned" ]; then
#     if [ -d "$INFLUXDB3_PROVISIONING_DIR/databases" ]; then
#         find "$INFLUXDB3_PROVISIONING_DIR/databases" -name '*.json' -print0 | while read -d $'\0' file; do
#             dbName="$(cat $file | jq -r '.name')"
#             dbRetention="$(cat $file | jq -r '.retention' 2>/dev/null)"
#             influxdb3 create database \
#             $([ "$dbRetention" != "null" ] && [ "$dbRetention" != "none" ] && echo "--retention-period '$dbRetention'" ) \
#             "$dbName"
#         done
#         touch "$INFLUXDB3_DB_DIR/.provisioned"
#     fi
# else
#     echo "No auth token or no provisioning directory."
# fi

exec "$@"