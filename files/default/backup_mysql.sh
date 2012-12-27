#! /bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
set -e
. `dirname $0`/../lib/backup_scripts_lib.sh
set +e

HOSTNAME=$(hostname -s)
NAGIOS_HOSTNAME="$HOSTNAME"

usage () {
	echo "Usage: $0 --mysql-host|-H MYSQL_HOSTNAME --mysql-port|-P MYSQL_PORT --mysql-password|-p MYSQL_PASSWORD --mysql-user|-u MYSQL_USERNAME --nsca-host|-n NSCA_HOST --nsca-port NSCA_PORT --bucket|-b BUCKET"
	exit 1
}

# defaults
MYSQL_PORT=3306
NSCA_PORT=5667
MIN_FILE_SIZE=5000000
NAGIOS_SERVICE_NAME="mysql backup"
PREFIX=""
S3CMD_CONFIG_FILE="$HOME/backup.s3cfg"

args=$(getopt -u -o b:p:P:u:H:n: -l mysql-host:,mysql-password:,mysql-port:,mysql-user:,nsca-port:,nsca-host:,prefix:,bucket: -- $*)

[[ "$?" == 0 ]] || usage

set -- $args

while [[ "$1" != -- ]]; do
	case "$1" in
		-H|--mysql-host)	shift; MYSQL_HOST="$1"; shift;;
		-p|--mysql-password)	shift; MYSQL_PASSWORD="$1"; shift ;;
		-P|--mysql-port)	shift; MYSQL_PORT="$1"; shift ;;
		-u|--mysql-user)	shift; MYSQL_USERNAME="$1"; shift ;;
		-n|--nsca-host)		shift; NSCA_HOST="$1"; shift ;;
		--nsca-port)		shift; NSCA_PORT="$1"; shift ;;
		--)		        break ;;
		-p|--prefix)        shift; PREFIX="$1"; NAGIOS_SERVICE_NAME="$PREFIX"; shift;;
		-b|--bucket)		shift; BUCKET="$1"; shift ;;
		*)	echo "Uknown option $1"; usage ;;
	esac
done

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin
export PATH

mandatory MYSQL_HOST
mandatory MYSQL_PASSWORD
mandatory MYSQL_USERNAME
mandatory BUCKET

check_tool_exists s3cmd
check_tool_exists mysqldump
check_tool_exists send_nsca

DATE=$(date +%F)
DUMP_FILENAME=all-dbs-$DATE.sql.gz
TMPDIR="/tmp/$(basename $0)/$$"
mkdir -p "$TMPDIR"
cd $TMPDIR || die 3 "Can't chdir into $TMPDIR"

mysqldump --routines --triggers --lock-all-tables -h"$MYSQL_HOST" -p"$MYSQL_PASSWORD" -u"$MYSQL_USERNAME" -A | gzip -c >"$DUMP_FILENAME" || failed mysqldump
[[ ${PIPESTATUS[0]} -eq 0 ]] || failed mysqldump

SIZE=$(stat -c %s $DUMP_FILENAME)
SIZE_TXT="$(( $SIZE / 2 ** 20 )) MB"
if [[ $SIZE -lt $MIN_FILE_SIZE ]]; then
	die 2 "File size ($SIZE_TXT) is too small"
fi

#[[ -n "$PREFIX" && ${PREFIX%/} == ${PREFIX} ]] && PREFIX=$PREFIX/
upload_2_s3 $DUMP_FILENAME $BUCKET/$HOSTNAME/mysql

report2nsca "Uploaded $SIZE_TXT to s3://$BUCKET/$HOSTNAME/mysql/$DUMP_FILENAME" 0

# cleanup
rm $TMPDIR/*
rmdir "$TMPDIR"
exit 0
