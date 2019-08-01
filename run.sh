#!/bin/bash

# We use the autobuild to always test our new functionality. But YOU should not do that!
# Instead use the latest tagged version as the next row
# DOCKER_CONTAINER=sitespeedio/sitespeed.io:9.2.1

DOCKER_CONTAINER=sitespeedio/sitespeed.io-autobuild:latest
DOCKER_SETUP="--cap-add=NET_ADMIN  --shm-size=2g --rm -v /config:/config -v "$(pwd)":/sitespeed.io -v /etc/localtime:/etc/localtime:ro -e MAX_OLD_SPACE_SIZE=3072 "
CONFIG="--config /sitespeed.io"
BROWSERS=(chrome firefox)

# We loop through all directories we have
# We run many tests to verify the functionality of sitespeed.io and you can simplify this by
# removing things you don't need!


for file in $SERVER/desktop/urls/*.txt ; do
  [ -e "$file" ] || continue
  for browser in "${BROWSERS[@]}"
    do
    while read url; do
      # Note: If you use dots in your name you need to replace them before sending to Graphite
      # GRAPHITE_NAMESPACE=${GRAPHITE_NAMESPACE//[-.]/_}
      NAMESPACE="--graphite.namespace sitespeed_io.$(basename ${url%%.*})"
      docker run $DOCKER_SETUP $DOCKER_CONTAINER $NAMESPACE $CONFIG/config/desktop.json -b $browser $url --graphite.host 192.168.0.187
      #docker run --rm -v "$(pwd)":/sitespeed.io sitespeedio/sitespeed.io $url --browser $browser --graphite.host 192.168.0.187
      control
    done <$file
    done
done

# Remove the current container so we fetch the latest autobuild the next time
# If you run a stable version (as YOU should), you don't need to remove the container
# docker system prune --all --volumes -f
sleep 20
exit


# Remove the current container so we fetch the latest autobuild the next time
# If you run a stable version (as YOU should), you don't need to remove the container
# docker system prune --all --volumes -f
sleep 20
