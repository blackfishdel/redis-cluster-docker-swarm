#!/bin/bash

set -ex

echo "Create stand in volume for scripts"
docker create -v /scripts --name scripts alpine:3 /bin/true

echo "Moving check_scaling.sh to scripts"
docker cp scripts scripts:/

echo "Starting init tests"
docker run --rm --network redis --volumes-from scripts \
	registry.docker-cn.com/library/redis:4.0.9-alpine sh /scripts/check_scaling.sh 2 2
