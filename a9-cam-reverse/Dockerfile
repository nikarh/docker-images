FROM alpine

RUN apk add --no-cache git nodejs npm

RUN cd / &&git clone https://github.com/DavidVentura/cam-reverse.git \
    && cd cam-reverse \
    && npm ci \
    && npm run build \
    && touch /cam-reverse/config.yaml

ENTRYPOINT [ "node" ]
CMD [ "/cam-reverse/dist/bin.cjs", "http_server", "--config_file", "/cam-reverse/config.yaml" ]
