FROM postgres:18.3-alpine

RUN apk add --no-cache aws-cli coreutils curl pigz

COPY backup.sh /backup.sh
RUN chmod +x /backup.sh

CMD ["/backup.sh"]