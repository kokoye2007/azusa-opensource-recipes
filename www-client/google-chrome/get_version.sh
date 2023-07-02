#!/bin/sh
# see: https://developer.chrome.com/docs/versionhistory/guide/

curl -s https://versionhistory.googleapis.com/v1/chrome/platforms/linux/channels/stable/versions | jq -r '.versions[0].version'
