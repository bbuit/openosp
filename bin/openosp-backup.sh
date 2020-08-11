#!/bin/bash

set -x

if [ -z "$BACKUP_BUCKET" ]
then
    BACKUP_BUCKET=backups
    echo "BACKUP_BUCKET env var not specified, defaulting to the 'backups' bucket."
fi

if [ -z "$BACKUP_CMD" ]
then
    BACKUP_CMD="mysqldump -uroot -p${MYSQL_ROOT_PASSWORD} oscar"
    echo "BACKUP_CMD env var not specified, defaulting to '${BACKUP_CMD}'."
fi

if [ -e $HOME/.aws/credentials ]
then
    echo "aws credentials found."
else
    echo "no ~/.aws/credentials file found. please mount one for me."
    exit 1
fi

if [ -z "$DUMP_LOCATION" ]
then
    DUMP_LOCATION='./dump'
    echo "DUMP location not specified, using $DUMP_LOCATION"
fi

site=$(pwd | grep -oh "[^/]*$")
filename=$site.$(date +%Y%m%d-%H%M%S)
folder=$(date +%Y%m)

mkdir -p $DUMP_LOCATION

docker exec -t ${site}_db_1 $BACKUP_CMD | bzip2 > $DUMP_LOCATION/db.sql.bz2

clinicname="openosp-${CLINIC_NAME:-$site}"
echo "done backups"

aws="docker run --rm -t -v $HOME/.aws:/root/.aws -v $(pwd):/open-osp amazon/aws-cli"

# Remove double quotes, user might input value enclosed in "" in local.env
BACKUP_BUCKET="${BACKUP_BUCKET//\"}"
$aws s3 sync /open-osp/volumes s3://$BACKUP_BUCKET/$clinicname/volumes --storage-class STANDARD_IA --exclude ".sync/*"
$aws s3 mv /open-osp/$DUMP_LOCATION/db.sql.bz2 s3://$BACKUP_BUCKET/$clinicname/$folder/$filename.sql.bz2

