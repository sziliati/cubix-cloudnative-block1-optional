#!/bin/sh

IMAGE="ghcr.io/sziliati/cubix/1/optional/app:springboot"

if [ "$1" = "local" ]; then
  IMAGE="cubix-optional:local"
  echo 'Building local image, this may take a while...'
fi

docker rm -f test > /dev/null 2>&1 || true
docker run -d --name test -p 8080:8080 "$IMAGE" > /dev/null
sleep 10
curl --fail http://localhost:8080/demo/test
RESULT=$?
if [ $RESULT -ne 0 ]; then
  echo "Verification failed, here are the logs"
  docker logs test
fi
docker stop test > /dev/null 2>&1 || true
docker rm test > /dev/null 2>&1 || true
exit $RESULT