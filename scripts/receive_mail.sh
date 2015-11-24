#!/bin/bash
#
# Receive a message from STDIN and send it to the REST API at the address
# sent as a the fisrt parameter
#
# E.g. `cat mail.txt | receive_mail.sh http://lists.domain.tld`

entrypoint=$1
timestamp=$(date +%s)
cache_file="/tmp/message-${timestamp}"
while read pipe ; do echo $pipe >> $cache_file ; done

curl -H "Content-Type: text/plain" -X POST \
    --data-urlencode @${cache_file} \
    ${entrypoint}/api/v1/mailing_lists/receive_message \
    &> /dev/null
exit_status=$?

rm $cache_file

if [ $exit_status -ne 0 ]; then
  exit 75
fi

exit 0
