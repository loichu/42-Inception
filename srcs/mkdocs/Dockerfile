FROM debian:buster

RUN apt-get update && apt-get install -y \
    python3 python3-pip \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install mkdocs-material==9.2.7

WORKDIR /root/mkdocs

CMD [ "mkdocs", "serve", "--dev-addr=0.0.0.0:8000" ]