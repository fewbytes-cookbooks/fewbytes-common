#! /bin/bash
PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/bin:/opt/doat/bin
set -e
. /opt/fewbytes/lib/backup_scripts_lib.sh
set +e

function usage () {
	echo "$0: Backup a file to s3."
	echo "Usage: $0 [-j] [-z] [-b BUCKET] [-t TMPDIR] [-H NSCA_HOST ] [-P NSCA_PORT] [-n HOSTNAME] [-s NAGIOS_SERVICE_NAME] -p PREFIX filename"
	exit 0
}

set_var () {
	if eval [[ -n "\$$1" ]]; then
		echo "Can't set $1 twice!" >&2
		report2nsca "Arguments error" 3
		exit 1
	fi
	eval $1=$2
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
		j)	set_var COMPRESSOR "bzip2";;
		z)	set_var COMPRESSOR "gzip";;
		H)	NSCA_HOST="$OPTARG" ;;
		P)	NSCA_PORT="$OPTARG" ;;
		n)	NAGIOS_HOSTNAME="$OPTARG" ;;
		s)	NAGIOS_SERVICE_NAME="$OPTARG" ;;
		h|*) 	usage ;;
	esac
done

eval FILE=\${$OPTIND}

if [[ -z "$PREFIX" ]]; then
	echo "You must supply a prefix!"
	exit 1
fi
if [[ ! -r "$FILE" ]]; then
	echo "Can't find file $FILE" >&2
	exit 2
fi

if [[ -z "$NAGIOS_SERVICE_NAME" ]]; then
	NAGIOS_SERVICE_NAME="$PREFIX backup"
fi

case "$COMPRESSOR" in
    gzip) EXT=gz; C=z;;
    bzip2)  EXT=bz2; C=j;;
    *) EXT=gz; C=z;;
esac

check_tool_exists s3cmd
check_tool_exists $COMPRESSOR

DATEEXT=$(date +%F)
TEMPDIR="$TEMPDIR/Backup2S3_$PREFIX/$$"
mkdir -p "$TEMPDIR"

if [[ -d "$FILE" ]]; then
    FILE2COPY="$TEMPDIR/$(basename $FILE).tar.$EXT"
    check_tool_exists tar
    RET=$?
    tar -c${C}f $FILE2COPY $FILE
    ok_or_fail $RET "to tar $FILE"
else
    FILE2COPY=$TEMPDIR/$(basename $FILE).$EXT
    cat $FILE | $COMPRESSOR -c > $FILE2COPY
    RET=$?
    ok_or_fail $RET "compression"
fi
DEL_FILE=$FILE2COPY

# copy to s3
upload_2_s3 "$FILE2COPY" "$BUCKET/$HOSTNAME/$PREFIX/$DATEEXT"
SIZE=$(ls -lh $FILE2COPY | cut -d" " -f5)
report2nsca "Backuped $SIZE" 0
# cleanup
if [[ -n "$DEL_FILE" && "$DEL_FILE" != "$FILE" ]]; then
	rm "$DEL_FILE"
    rmdir  "$TEMPDIR"
fi
