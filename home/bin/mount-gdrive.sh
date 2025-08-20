#!/bin/sh

rclone mount gdrive: gdrive/ --vfs-cache-mode=full --dir-cache-time=5000h --poll-interval=10s --rc --rc-addr=:5572 --rc-no-auth --drive-pacer-min-sleep=10ms --drive-pacer-burst=200

# Useful command to run after mount is active
# rclone rc vfs/refresh recursive=true