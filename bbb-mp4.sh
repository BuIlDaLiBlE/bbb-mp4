#!/bin/bash

MEETING_ID=$1
script_dir=`dirname "$(realpath "$0")"`

# Load .env variables
set -a
source <(cat "$script_dir/.env" | \
	sed -e '/^#/d;/^\s*$/d' -e "s/'/'\\\''/g" -e "s/=\(.*\)/='\1'/g")
set +a

mkdir -p "$script_dir/log"

log_file="$script_dir/log/${MEETING_ID}.log"
# Redirect stdout and stderr to the log file
exec > >(tee -a $log_file) 2>&1

if [[ -e $COPY_TO_LOCATION/$MEETING_ID.mp4 ]]; then
	echo "Video already exists, aborting! $MEETING_ID"
	exit 1
fi

echo "converting $MEETING_ID to mp4" | systemd-cat -p warning -t bbb-mp4
echo "Start time: `date '+%d.%m.%Y %H:%M:%S'`"

docker run --rm -d \
	--name bbb-mp4_${MEETING_ID} \
	-v $PROCESSING_LOCATION:/usr/src/app/processing \
	-v $COPY_TO_LOCATION:/usr/src/app/processed \
	--env REC_URL=https://$BBB_DOMAIN_NAME/playback/presentation/2.3/$MEETING_ID \
	manishkatyan/bbb-mp4
docker logs -f bbb-mp4_${MEETING_ID} &>> $log_file &
