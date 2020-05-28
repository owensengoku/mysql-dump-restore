#!/bin/bash

set -e
set -o pipefail


if [ -z "${SOURCE_MYSQL_USER}" ]; then
  echo "You need to set the SOURCE_MYSQL_USER environment variable."
  exit 1
fi

if [ -z "${SOURCE_MYSQL_PASSWORD}" ]; then
  echo "You need to set the SOURCE_MYSQL_PASSWORD environment variable."
  exit 1
fi

if [ -z "${SOURCE_MYSQL_HOST}" ]; then
  echo "You need to set the SOURCE_MYSQL_HOST environment variable or link to a container named MYSQL."
  exit 1
fi

if [ -z "${SOURCE_MYSQL_PORT}" ]; then
  echo "You need to set the SOURCE_MYSQL_PORT environment variable or link to a container named MYSQL."
  exit 1
fi

if [ -z "${SOURCE_MYSQL_DATABASE}" ]; then
  echo "You need to set the SOURCE_MYSQL_DATABASE environment variable or link to a container named MYSQL."
  exit 1
fi


if [ -z "${TARGET_MYSQL_USER}" ]; then
  echo "You need to set the TARGET_MYSQL_USER environment variable."
  exit 1
fi

if [ -z "${TARGET_MYSQL_PASSWORD}" ]; then
  echo "You need to set the TARGET_MYSQL_PASSWORD environment variable."
  exit 1
fi

if [ -z "${TARGET_MYSQL_HOST}" ]; then
  echo "You need to set the TARGET_MYSQL_HOST environment variable or link to a container named MYSQL."
  exit 1
fi

if [ -z "${TARGET_MYSQL_PORT}" ]; then
  echo "You need to set the TARGET_MYSQL_PORT environment variable or link to a container named MYSQL."
  exit 1
fi

if [ -z "${TARGET_MYSQL_DATABASE}" ]; then
  echo "You need to set the TARGET_MYSQL_DATABASE environment variable or link to a container named MYSQL."
  exit 1
fi


SOURCE_MYSQL_OPTS="-h $SOURCE_MYSQL_HOST --port $SOURCE_MYSQL_PORT -u $SOURCE_MYSQL_USER -p$SOURCE_MYSQL_PASSWORD"

echo "Starting dump of ${SOURCE_MYSQL_DATABASE} database(s) from ${SOURCE_MYSQL_HOST}..."

echo 'SET FOREIGN_KEY_CHECKS = 0;' > dump.sql
mysqldump $SOURCE_MYSQL_OPTS $MYSQLDUMP_OPTIONS $SOURCE_MYSQL_DATABASE >> dump.sql
echo 'SET FOREIGN_KEY_CHECKS = 1;' >> dump.sql

TARGET_MYSQL_OPTS="-h $TARGET_MYSQL_HOST --port $TARGET_MYSQL_PORT -u $TARGET_MYSQL_USER -p$TARGET_MYSQL_PASSWORD"

echo "Starting restore of ${TARGET_MYSQL_DATABASE} database(s) to ${TARGET_MYSQL_HOST}..."

mysql $TARGET_MYSQL_OPTS $TARGET_MYSQL_DATABASE < dump.sql

echo "Done!"

exit 0
