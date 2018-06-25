#!/bin/sh

REDIS_SENTINEL_NAME="$1"
REDIS_MASTER_NAME="$2"

REDIS_SENTINEL_IP=
REDIS_SENTINEL_PORT=

shift 2

get_value() {
	ip="$1"
	port="$2"
	master_name="$3"
	key="$4"
	echo $(redis-cli -h $ip -p $port sentinel master $master_name | grep -A 1 $key | tail -n1)
}

case ${1} in
	reset)
		shift 1

		key="$1"
		target="$2"

		echo "Reseting sentinel for ip: ${REDIS_SENTINEL_IP}"
		redis-cli -h $REDIS_SENTINEL_IP -p $REDIS_SENTINEL_PORT sentinel reset $REDIS_MASTER_NAME

		until [ "$(get_value $REDIS_SENTINEL_IP $REDIS_SENTINEL_PORT $REDIS_MASTER_NAME $key)" = "$target" ]; do
			echo "$key not equal to $target - sleeping"
			sleep 2
		done
		;;
	value)
		shift 1

		key="$1"

		value=$(get_value $REDIS_SENTINEL_IP $REDIS_SENTINEL_PORT $REDIS_MASTER_NAME $key)

		echo "$value"
		;;
	show)
		shift 1

		key="$1"

		k_value="$(get_value $REDIS_SENTINEL_IP $REDIS_SENTINEL_PORT $REDIS_MASTER_NAME $key)"

		echo "${REDIS_SENTINEL_IP}: ${k_value}"
		;;
esac
