#!/bin/bash

set -e

VERSION="$1" ; shift

test -n "$VERSION"

export DOCKER_BUILDKIT=1 
docker build --build-arg=HUMHUB_REPO=colpari "--build-arg=HUMHUB_VERSION=$VERSION" --target humhub_allinone -t "colpari/humhub:$VERSION" -t "colpari/humhub:latest" .
docker build --build-arg=HUMHUB_REPO=colpari "--build-arg=HUMHUB_VERSION=$VERSION" --target humhub_nginx -t "colpari/humhub:$VERSION-nginx" -t "colpari/humhub:latest-nginx" .
docker build --build-arg=HUMHUB_REPO=colpari "--build-arg=HUMHUB_VERSION=$VERSION" --target humhub_phponly -t "colpari/humhub:$VERSION-phponly" -t "colpari/humhub:latest-phponly" .

read -p "Upload images [y/n] ? "

[ "x$REPLY" != "xy" ] && exit 0

for image in "colpari/humhub:$VERSION" "colpari/humhub:latest" "colpari/humhub:$VERSION-nginx" "colpari/humhub:latest-nginx" "colpari/humhub:$VERSION-phponly" "colpari/humhub:latest-phponly"
do
    docker push "$image"
done
