#!/usr/bin/env bash

export ANY_FAILURE=""
NODE_PREFIX="${INFLUXDB3_NODE_IDENTIFIER_PREFIX:-node0}"
BASE_PATH="/var/lib/influxdb3/data/$NODE_PREFIX"
RETENTION_DAYS="${INFLUXDB_BACKUP_RETENTION_DAYS:-2}"
BACKUP_DIR="/backups/$(basename "$BASE_PATH")/$(TZ="UTC" date +"%Y-%m-%dT%H:%M:%SZ")"
mkdir -p "$BACKUP_DIR"
chmod 755 "/backups/$(basename "$BASE_PATH")"
chmod 755 "$BACKUP_DIR"

backupFailed() {
    ANY_FAILURE="_"
    originFilePath="$1"; shift
    originExitCode="$1"; shift
    echo "Backup of '$originFilePath' failed with exit code '$originExitCode', continuing to next file..."
}

echo "Starting backup of '$BASE_PATH' to '$BACKUP_DIR'..."

backupTargets=(snapshots dbs wal catalog snapshot-checkpoints _catalog_checkpoint)
for item in "${backupTargets[@]}"; do
    if [ -e "$BASE_PATH/$item" ]; then
        cp -ra "$BASE_PATH/$item" "$BACKUP_DIR/"
        exitCode="$?"; [ "$exitCode" -ne "0" ] && backupFailed "$item" "$exitCode"
    fi
done

echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "/backups/$(basename "$BASE_PATH")" -mindepth 1 -maxdepth 1 -type d -mtime +"$RETENTION_DAYS" -exec rm -rf {} +

{ [ -z "$ANY_FAILURE" ] && echo "Backup job completed successfully."; } || { echo "Backup job caused errors." && exit 1; }