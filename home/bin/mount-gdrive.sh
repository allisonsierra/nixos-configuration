#!/bin/sh

rclone mount gdrive: gdrive/ --vfs-cache-mode=full --dir-cache-time=5000h --poll-interval=10s --rc --rc-addr=:5572 --rc-no-auth --drive-pacer-min-sleep=10ms --drive-pacer-burst=200