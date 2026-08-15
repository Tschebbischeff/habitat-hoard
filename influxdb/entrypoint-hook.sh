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

[ -z "$UID" ] && UID="0"

tmpCronFile="$(mktemp)"
crontab -u "$(id -nu "${UID}")" -l 2>/dev/null | grep -v '/backup\.sh$' >"$tmpCronFile"
echo "${INFLUXDB_BACKUP_SCHEDULE} /backup.sh" >>"$tmpCronFile"
crontab -u "$(id -nu "${UID}")" "$tmpCronFile" || exit 1
rm "$tmpCronFile"

cron

exec "$@"