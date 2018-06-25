FROM docker.mirrors.ustc.edu.cn/library/redis:4.0.9-alpine

LABEL version="1.0.0"

ENV REDIS_SENTINEL_IP redis-sentinel
ENV REDIS_SENTINEL_PORT 26379
ENV REDIS_MASTER_NAME redismaster

WORKDIR /redis

COPY redis.conf ./

COPY redis-entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/redis-entrypoint.sh

EXPOSE 26379

ENTRYPOINT ["redis-entrypoint.sh"]
