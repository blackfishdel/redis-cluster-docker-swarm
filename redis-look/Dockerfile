FROM registry.docker-cn.com/library/redis:4.0.9-alpine

LABEL version="1.0.0"

ENV REDIS_SENTINEL_IP redis-sentinel
ENV REDIS_MASTER_NAME redismaster
ENV REDIS_SENTINEL_PORT 26379

RUN mkdir /redis-data

COPY redis-entrypoint.sh /usr/local/bin/entrypoint.sh

RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /redis

COPY redis-4.0.9.conf ./redis.conf

EXPOSE 26379

ENTRYPOINT ["entrypoint.sh"]
