FROM debian:12

RUN apt update && apt install -y \
	lsb-release curl gpg bash vsftpd man

COPY vsftpd.conf /etc/vsftpd.conf

RUN mkdir -p /var/run/vsftpd/empty

COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 21
CMD ["vsftpd"] 