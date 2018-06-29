# Redis Cluster Cache for Docker Swarm

Redis集群利用Redis Sentinel自动故障转移,默认情况下持久化是关闭的。

## Usage

0. Setup docker swarm
1. 创建 overlay network:

```bash
docker network create --attachable --driver overlay redis
```

2. 修改 scripts/docker-compose.yml。
3. 运行 `bootstrap.sh`。

```bash
cd ./scripts
bash bootstrap.sh latest
```

4. 连接redis-cli

```bash
docker run --rm --network redis -ti docker.mirrors.ustc.edu.cn/library/redis:4.0.9-alpine redis-cli -h redis
```

外部项目要访问docker的redis集群，需要公开端口6379。这可以通过向docker-compose文件添加端口来完成：

```yaml
  redis:
    image: registry.int.mimikko.cn/redis-look
    ports:
      - "6379:6379"
```

## Details

创建一个称为`redis-zero`的docker服务，作为`redis sentinels`的initial master。`redis-look`实例也是`redis sentinels`的master，`redis sentinels`连接到`redis-zero`。等到连接成功，移除`redis-zero`实例，等待故障转移接管，这样一个新的redismaster将接管。可以使用`redis-utils` 重置 `redis sentinels`，刷新内部metadata的状态。

使用`redis-zero`作为引导步骤,`docker-compose.yml`只提供长时间运行的服务：

```yaml
version: '3.2'

services:

  redis-sentinel:
    image: registry.int.mimikko.cn/redis-sentinel
    environment:
      - REDIS_IP=redis-zero
      - REDIS_MASTER_NAME=redismaster
    deploy:
      replicas: 3
    networks:
      - redis

  redis1:
    image: registry.int.mimikko.cn/redis-look:${TAG:-latest}
    environment:
      - REDIS_SENTINEL_IP=redis-sentinel
      - REDIS_MASTER_NAME=redismaster
      - REDIS_SENTINEL_PORT=26379
    deploy:
      replicas: 1
    networks:
      - redis
    ports:
      - "6380:6379"

  redis2:
    image: registry.int.mimikko.cn/redis-look:${TAG:-latest}
    environment:
      - REDIS_SENTINEL_IP=redis-sentinel
      - REDIS_MASTER_NAME=redismaster
      - REDIS_SENTINEL_PORT=26379
    deploy:
      replicas: 1
    networks:
      - redis
    ports:
      - "6381:6379"

  redis3:
    image: registry.int.mimikko.cn/redis-look:${TAG:-latest}
    environment:
      - REDIS_SENTINEL_IP=redis-sentinel
      - REDIS_MASTER_NAME=redismaster
      - REDIS_SENTINEL_PORT=26379
    deploy:
      replicas: 1
    networks:
      - redis
    ports:
      - "6382:6379"

networks:
  redis:
    external: true
```

### Scaling

现在只需要扩大`redis`的slave个数和`redis-sentinel`的个数。

范例：

```bash
docker service scale helloworld=5
```

### 监控

```bash
docker run -d \
  --name cadvisor \
  --publish 9001:8080 \
  --volume /:/rootfs:ro \
  --volume /var/run:/var/run:rw \
  --volume /sys:/sys:ro \
  --volume /var/lib/docker/:/var/lib/docker:ro \
  docker.mirrors.ustc.edu.cn/google/cadvisor

```
