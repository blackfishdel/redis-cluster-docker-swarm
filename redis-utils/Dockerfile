FROM registry.docker-cn.com/library/redis:4.0.9-alpine

LABEL version="1.0.0"

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]
