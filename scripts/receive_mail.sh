#!/bin/bash
# MTA? receive_message? webhook?

timestamp=$(date +%s)
cache_file="/tmp/message-${timestamp}"
while read pipe ; do echo $pipe >> $cache_file ; done

# curl -H "Content-Type: application/json" -X POST \
#     -d '{"message": "'"$(cat $cache_file)"'"}' \
#     http://localhost:3000/api/v1/mailing_lists/receive_message

curl -H "Content-Type: text/plain" -X POST \
    --data-urlencode @${cache_file} \
    http://localhost:3000/api/v1/mailing_lists/receive_message
