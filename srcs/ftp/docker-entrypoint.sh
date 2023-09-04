#!/bin/sh
set -e

if ! id -u $FTP_USER >/dev/null 2>&1; then
    adduser --gecos "" --disabled-password ${FTP_USER}
    echo "${FTP_USER}:${FTP_PASSWORD}" | chpasswd
    echo ${FTP_USER} | tee -a /etc/vsftpd.userlist
    usermod -aG www-data ftpuser
fi

exec "$@"