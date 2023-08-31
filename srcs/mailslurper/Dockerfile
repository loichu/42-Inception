FROM debian:buster

RUN apt update && apt install -y \
	lsb-release curl gpg bash tar \
    git libc-dev gcc \
    ca-certificates 

COPY go1.21.0.linux-amd64.tar.gz .
RUN tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH:/usr/local/go/bin
RUN mkdir -p "$GOPATH/src" "$GOPATH/bin" && chmod -R 1777 "$GOPATH"
WORKDIR $GOPATH

RUN mkdir -p /go/src/github.com \
    && git clone --branch release-1.15.0 https://github.com/mailslurper/mailslurper.git \
        /go/src/github.com/mailslurper

RUN go install github.com/mjibson/esc@latest

WORKDIR /go/src/github.com/mailslurper/cmd/mailslurper

RUN go get
RUN go generate
RUN go build

WORKDIR /go/src/github.com/mailslurper/cmd/mailslurper

RUN echo '{\n\
  "wwwAddress": "mailslurper",\n\
  "wwwPort": 8080,\n\
  "wwwPublicURL": "https://mail.42.fr",\n\
  "serviceAddress": "mailslurper",\n\
  "servicePort": 8085,\n\
  "servicePublicURL": "https://mail.42.fr/api",\n\
  "smtpAddress": "mailslurper",\n\
  "smtpPort": 2500,\n\
  "dbEngine": "SQLite",\n\
  "dbHost": "",\n\
  "dbPort": 0,\n\
  "dbDatabase": "./mailslurper.db",\n\
  "dbUserName": "",\n\
  "dbPassword": "",\n\
  "maxWorkers": 1000,\n\
  "autoStartBrowser": false,\n\
  "keyFile": "",\n\
  "certFile": "",\n\
  "adminKeyFile": "",\n\
  "adminCertFile": ""\n\
  }'\
  > config.json

EXPOSE 8080 8085 2500

CMD ["./mailslurper"]