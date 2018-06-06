#!/bin/bash

set -ex

export TAG=${1:-"latest"}

docker stack rm cache
