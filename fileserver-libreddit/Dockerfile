FROM rust:alpine AS builder

RUN apk add --no-cache musl-dev git
RUN git clone https://github.com/libreddit/libreddit /libreddit \
    && cd /libreddit \
    && git checkout oauth_spoof \
    && git rebase origin master

WORKDIR /libreddit
RUN cargo build --release

FROM alpine:latest

COPY --from=builder /usr/share/ca-certificates /usr/share/ca-certificates
COPY --from=builder /etc/ssl/certs /etc/ssl/certs
COPY --from=builder /libreddit/target/release/libreddit /usr/local/bin/libreddit

RUN adduser --home /nonexistent --no-create-home --disabled-password libreddit
USER libreddit

EXPOSE 8080

CMD ["libreddit"]
