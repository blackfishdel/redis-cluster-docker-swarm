# Redis Cluster Cache for Docker Swarm

Quick and dirty Redis cluster taking advantage of Redis Sentinel for automatic failover. Persistence is turned off by default.

## Usage

1. Setup docker swarm
1. build images
```bash
bash scripts/build.sh
```
1. Create a overlay network:
```bash
docker network create --attachable --driver overlay redis
```
1. Modify scripts/docker-compose.yml to how you want to deploy the stack.
1. Run `scripts/bootstrap.sh`.
```bash
bash scripts/bootstrap.sh latest
```
1. Connect to with redis-cli
```bash
docker run --rm --network redis -ti registry.docker-cn.com/library/redis:4.0.9-alpine redis-cli -h redis
```
To access the redis cluster outside of docker, port 6379 needs to be expose. This can be done by adding ports to the docker-compose file:

```yaml
...
  redis:
    image: thomasjpfan/redis-look
    ports:
      - "6379:6379"
...
```
1. test redis cluster
```bash
bash scripts/test_init.sh
```
1. remove docker stack
```bash
bash scripts/cleanup.sh
```
## Details

A docker service called `redis-zero` is created to serve as the initial master for the redis sentinels to setup. The `redis-look` instances watches the redis sentinels for a master, and connects to `redis-zero` once a master has been decided. Once the dust has settled, remove the `redis-zero` instance and wait for failover to take over so a new redis-master will take over. Use `redis-utils` to reset sentinels so that its metadata is accurate with the correct state.

The use of `redis-zero` as a bootstrapping step allows for the `docker-compose.yml` to provide only the long running services:

```yaml
version: '3.1'

services:

  redis-sentinel:
    image: thomasjpfan/redis-sentinel
    environment:
      - REDIS_IP=redis-zero
      - REDIS_MASTER_NAME=redismaster
    deploy:
      replicas: 3
    networks:
      - redis

  redis:
    image: thomasjpfan/redis-look
    environment:
      - REDIS_SENTINEL_IP=redis-sentinel
      - REDIS_MASTER_NAME=redismaster
      - REDIS_SENTINEL_PORT=26379
    deploy:
      replicas: 3
    networks:
      - redis

networks:
  redis:
    external: true

```

### Scaling

From now on just scale `redis` to expand the number of slaves or scale `redis-sentinel` to increase the number of sentinels.
