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

echo "Dumping database..."
pg_dump "$DATABASE_URL" --no-owner --no-acl | gzip > "/tmp/$FILE"

echo "Uploading to bucket..."
aws s3 cp "/tmp/$FILE" "s3://$AWS_S3_BUCKET_NAME/backups/$FILE" \
  --endpoint-url "$AWS_ENDPOINT_URL"

echo "Uploaded backup to $FILE"