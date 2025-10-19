FROM node:alpine

RUN apk add --no-cache git

RUN git clone https://github.com/DavidVentura/cam-reverse.git
RUN cd cam-reverse && npm ci && npm run build
RUN touch /cam-reverse/config.yaml

CMD [ "/cam-reverse/dist/bin.cjs", "http_server", "--config_file", "/cam-reverse/config.yaml" ]
