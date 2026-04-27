#!/bin/sh
set -e

ERR="
Check the repository README for instructions on how to set up the required environment variables @ https://github.com/YellowMacaroni/Railway-PG-Backup."

if [ -z "$DATABASE_URL" ]; then
  echo "Error: DATABASE_URL is not set$ERR" >&2
  exit 1
fi

if [ -z "$AWS_S3_BUCKET_NAME" ]; then
  echo "Error: AWS_S3_BUCKET_NAME is not set$ERR" >&2
  exit 1
fi

if [ -z "$AWS_ENDPOINT_URL" ]; then
  echo "Error: AWS_ENDPOINT_URL is not set$ERR" >&2
  exit 1
fi

TS=$(date -u +%Y-%m-%dT%H-%M-%SZ)
FILE="backup_${TS}.sql.gz"

notify() {
  # $1 = title, $2 = description, $3 = color (decimal)
  [ -z "$DISCORD_WEBHOOK_URL" ] && return 0
  curl -s -H "Content-Type: application/json" \
    -X POST \
    -d "{\"embeds\":[{\"title\":\"$1\",\"description\":\"$2\",\"color\":$3}]}" \
    "$DISCORD_WEBHOOK_URL" > /dev/null || true
}

notify "Backup Started" "**File:** $FILE" 3447003
trap 'notify "Backup Failed" "\`$FILE\` failed at $(date -u)" 4437377' EXIT

echo "Dumping database..."
pg_dump "$DATABASE_URL" --no-owner --no-acl | gzip > "/tmp/$FILE"

SIZE=$(du -h "/tmp/$FILE" | cut -f1)

echo "Uploading to bucket..."
aws s3 cp "/tmp/$FILE" "s3://$AWS_S3_BUCKET_NAME/backups/$FILE" \
  --endpoint-url "$AWS_ENDPOINT_URL"

trap - EXIT
notify "Backup Successful" "**File:** \`$FILE\`\\n**Size:** $SIZE" 4437377

echo "Uploaded backup to $FILE ($SIZE)"