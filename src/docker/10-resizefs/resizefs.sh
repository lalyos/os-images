#!/bin/bash
set -ex

RESIZE_DEV=${RESIZE_DEV:?"RESIZE_DEV not set."}
STAMP=/var/log/resizefs.done

if [ -e "${STAMP}" ]; then
    echo FS already resized.
    exit 0
fi

if [ -b "${RESIZE_DEV}" ]; then

  fdisk ${RESIZE_DEV} <<EOF
p
d
n
p
1


a
w
EOF
  partprobe
  resize2fs ${RESIZE_DEV}1 || :
else
  echo "Block device expected: ${RESIZE_DEV} is not."
  exit 1
fi

touch $STAMP
