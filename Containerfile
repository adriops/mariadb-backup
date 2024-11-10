FROM alpine:3.15

RUN apk update && \
    apk add mariadb-client && \
    rm -R /var/cache/apk/*

ADD backup.sh /

ENTRYPOINT [ "/backup.sh" ]
