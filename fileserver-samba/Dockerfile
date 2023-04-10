FROM alpine

RUN apk add --no-cache samba samba-common-tools tzdata runit shadow curl jq

RUN mkdir -p /etc/runit/smbd && \
    mkdir -p /etc/runit/nmbd && \
    echo -e "#!/bin/sh\nsmbd -F --no-process-group" > /etc/runit/smbd/run && \
    echo -e "#!/bin/sh\nnmbd -F --no-process-group" > /etc/runit/nmbd/run && \
    chmod +x /etc/runit/*/run

VOLUME /var/lib/samba
VOLUME /var/cache/samba

ENV UID=1000
ENV GID=1000

COPY ./root/ /

EXPOSE 137 138 139 445

ENTRYPOINT [ "/scripts/entrypoint.sh" ]
CMD ["ionice", "-c", "3", "runsvdir", "-P", "/etc/runit"]
