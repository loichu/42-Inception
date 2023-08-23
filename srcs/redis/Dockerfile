FROM debian:12

RUN apt update && apt install -y \
	lsb-release curl gpg bash

RUN curl -fsSL https://packages.redis.io/gpg | gpg --dearmor -o /usr/share/keyrings/redis-archive-keyring.gpg

RUN echo "deb [signed-by=/usr/share/keyrings/redis-archive-keyring.gpg] https://packages.redis.io/deb $(lsb_release -cs) main" | tee /etc/apt/sources.list.d/redis.list

RUN apt update && apt install -y redis

EXPOSE 6379
CMD ["redis-server", "--protected-mode", "no"]
