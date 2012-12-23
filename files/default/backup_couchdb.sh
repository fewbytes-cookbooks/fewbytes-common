#! /bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin
set -e
. `dirname $0`/../lib/backup_scripts_lib.sh
set +e

function usage () {
	echo "$0: Backup a file to s3."
	echo "Usage: $0 [-b BUCKET] [-t TMPDIR] [-H NSCA_HOST ] [-P NSCA_PORT] [-n HOSTNAME] [-s NAGIOS_SERVICE_NAME] -p PREFIX DB"
	exit 0
}

function ok_or_fail () {
	if [[ $1 -ne 0 ]]; then
		echo "Failed $2" >&2
		report2nsca "Failed $2" 2
		exit 1
	fi
}
TEMPDIR=/mnt
BUCKET=""
NSCA_PORT=5667
STATUS=3
HOSTNAME=$(hostname -s)
NAGIOS_HOSTNAME="$HOSTNAME"
S3CMD_CONFIG_FILE="$HOME/backup.s3cfg"

while getopts hp:b:jzt:P:n:H: opt; do
	case $opt in
		b)	BUCKET="$OPTARG" ;;
		t)	TEMPDIR="$OPTARG"
			if [[ ! -d "$TEMPDIR" ]]; then
				echo "$TEMPDIR isn't a valid directory"
				exit 2
			fi
			;;
		p)	PREFIX="$OPTARG" ;;
		H)	NSCA_HOST="$OPTARG" ;;
		P)	NSCA_PORT="$OPTARG" ;;
		n)	NAGIOS_HOSTNAME="$OPTARG" ;;
		s)	NAGIOS_SERVICE_NAME="$OPTARG" ;;
		h|*) 	usage ;;
	esac
done

eval DB=\${$OPTIND}

check_tool_exists couchdb-dump

DATEEXT=$(date +%F)
TEMPDIR="$TEMPDIR/couchdb-backup/$$"

couchdb-dump http://127.0.0.1/$DB |gzip -c > $TMPDIR/couchdb-$PREFIX.dump.gz
RET="$?"
[[ "$RET" -eq 0 ]] || die "Failed to dump couchdb, couchdb-dump returned $RET" 2
DEL_FILE="$TMPDIR/couchdb-$PREFIX.dump.gz"

upload_2_s3 "$TMPDIR/couchdb-$PREFIX.dump.gz" "$BUCKET/$HOSTNAME/$PREFIX/$DATEEXT"

SIZE=$(ls -lh "$TMPDIR/couchdb-$PREFIX.dump.gz" | cut -d" " -f5)
report2nsca "Backuped $SIZE" 0
# cleanup
if [[ -n "$DEL_FILE" && "$DEL_FILE" != "$FILE" ]]; then
	rm "$DEL_FILE"
    rmdir  "$TEMPDIR"
fi
