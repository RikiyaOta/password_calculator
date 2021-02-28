#!/bin/sh

# $1 = Mix Env [required]

set -e

if [ -z "$1" ] || [ "$1" = "" ]; then
  echo "Pass Mix Env as the First Argument."
  exit 1
fi

if [ "$1" != "prod" ] && [ "$1" != "dev" ]; then
  echo "Invalid Mix Env."
  exit 1
fi

MIX_ENV=$1

BASE_DIR=$(dirname $0)
cd $BASE_DIR

PGPASSFILE="./auth/$MIX_ENV/database/$MIX_ENV.pgpass"
HOST=$(cat ./hosts/$MIX_ENV/database)
USERNAME=$(cat ./auth/$MIX_ENV/database/username)
PORT="5432"
DBNAME="password_calculator_db"

TIMESTAMP=$(date '+%Y%m%d%H%M%S')
OUTPUT_FILE_NAME="${DBNAME}__${MIX_ENV}__${TIMESTAMP}.sql"

PGPASSFILE=$PGPASSFILE pg_dump \
  --dbname=$DBNAME \
  --host=$HOST \
  --port=$PORT \
  --username=$USERNAME \
  --file="./backup/$OUTPUT_FILE_NAME"

COMPRESSED_FILE_NAME="${OUTPUT_FILE_NAME}.tar.gz"

tar -zcf "./backup/$COMPRESSED_FILE_NAME" "./backup/$OUTPUT_FILE_NAME"
rm -f "./backup/$OUTPUT_FILE_NAME"

echo $COMPRESSED_FILE_NAME
