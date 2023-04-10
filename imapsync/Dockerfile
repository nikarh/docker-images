FROM alpine

RUN apk add --no-cache curl jq isync goimapnotify && \
    apk add --no-cache cyrus-sasl-xoauth2 --repository=http://dl-cdn.alpinelinux.org/alpine/edge/testing/

COPY ./root/ /
RUN chmod a+w /mbsync.conf

CMD ["/run.sh"]
