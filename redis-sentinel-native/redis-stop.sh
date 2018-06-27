#!/bin/bash -ex

kill -9 $(ps aux|grep redis | grep -v 'grep' | awk '{print $2}')