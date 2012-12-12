# report2nsca message return_code
report2nsca () {
	which send_nsca >/dev/null || return 1
        [[ -z "$NSCA_HOST" ]] && return 1
	echo -e "$NAGIOS_HOSTNAME\t$NAGIOS_SERVICE_NAME\t$2\t$1"| send_nsca -H $NSCA_HOST
}

# die MESSAGE RETURN_CODE
die () {
	echo "$1" >/dev/stderr
	report2nsca "$1" $2
	exit $2
}

mandatory () {
	if [[ -z $(eval echo \$$1) ]]; then
		die "$1 is missing!" 1
	fi
}

check_tool_exists () {
	echo -n "Checking for $1 ..."
	if ! which $1 >/dev/null; then
		die "$1 is missing!" 3
	fi
	echo " OK"
}

failed () {
	die "Failed $*" 4
}

function ok_or_fail () {
	if [[ $1 -ne 0 ]]; then
		echo "Failed $2" >&2
		report2nsca "Failed $2" 2
		exit 1
	fi
}

upload_2_s3 () {
    FILE2COPY="$1"
    S3_LOCATION="$2"
    s3cmd --config=$S3CMD_CONFIG_FILE put "$FILE2COPY" s3://$S3_LOCATION/
    S3_MD5=$(s3cmd --config=$S3CMD_CONFIG_FILE ls --list-md5 s3://$S3_LOCATION/$(basename $FILE2COPY) | awk '{print $4}')
    echo "$S3_MD5 *$FILE2COPY" | md5sum -c || failed "to upload $FILE2COPY to s3://$S3_LOCATION/$(basename $FILE2COPY)"
}

