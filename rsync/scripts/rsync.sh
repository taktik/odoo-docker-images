#!/bin/bash
lockfile=/var/tmp/rsynclock
if ( set -o noclobber; echo "$$" > "$lockfile" ) 2> /dev/null; then

        trap 'rm -f "$lockfile"; exit $?' INT TERM EXIT

        source /root/.profile
        RSYNC_PATTERN=${RSYNC_PATTERN:-*.dump}
        RSYNC_FROM=${RSYNC_FROM:-false}
        RSYNC_FROM_DIR=${RSYNC_FROM_DIR:-/sync/}
        RSYNC_FROM_PORT=${RSYNC_FROM_PORT:-22}
        RSYNC_BWLIMIT=${RSYNC_BWLIMIT:-0} # Bandwidth limit, 0 means no limit
        DAYS_TO_KEEP=${DAYS_TO_KEEP:-30}
        if [ -z "$RSYNC_FROM" ] || [ "$RSYNC_FROM" == "false" ];then
            >&2 echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`][error] \"Variable RSYNC_FROM is not set, cannot rsync\""
            exit 1
        fi

        rsync -a --out-format='%t %b %f' --bwlimit="$RSYNC_BWLIMIT" --files-from=<(ssh -p $RSYNC_FROM_PORT $RSYNC_FROM "find $RSYNC_FROM_DIR -type f -name \"$RSYNC_PATTERN\" -mtime -$DAYS_TO_KEEP | sed -e \"s@^$RSYNC_FROM_DIR@@g\";") --rsh="ssh -p$RSYNC_FROM_PORT" "$RSYNC_FROM:$RSYNC_FROM_DIR" /sync/
        find /sync/ -mtime +$DAYS_TO_KEEP -name "$RSYNC_PATTERN" ! -name "*-monthly.*" ! -name "*-weekly.*" -exec rm -rf '{}' ';'

        rm -f "$lockfile"
        trap - INT TERM EXIT
else
        >&2 echo "[`date -u +'%Y-%m-%dT%H:%M:%SZ'`][error] \"Lock Exists: $lockfile owned by $(cat $lockfile)\""
fi
