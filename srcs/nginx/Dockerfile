FROM debian:buster

RUN apt-get update && apt-get install -y nginx net-tools openssl

COPY ./nginx.conf /etc/nginx/nginx.conf
COPY ./self-signed.conf /etc/nginx/snippets/self-signed.conf
COPY ./ssl-params.conf /etc/nginx/snippets/ssl-params.conf

COPY ./nginx-entrypoint.sh /
RUN chmod +x /nginx-entrypoint.sh
ENTRYPOINT [ "/nginx-entrypoint.sh" ]

EXPOSE 443

CMD [ "nginx", "-g", "daemon off;" ]
