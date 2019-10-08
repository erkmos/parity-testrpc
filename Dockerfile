FROM ubuntu:18.04 as builder

ARG PARITY_VERSION=2.6.4

COPY devaccount.json /data/keys/DevelopmentChain/UTC--2017-03-26T11-33-29Z--1e98bebd-5231-2167-c30a-db31a5b0499a
COPY transfer.sh /usr/bin/transfer.sh

WORKDIR /build
RUN apt-get update && \
    apt-get install -y curl netcat-openbsd && \
    curl -Os https://releases.parity.io/ethereum/v${PARITY_VERSION}/x86_64-unknown-linux-gnu/parity && \
    mv parity /usr/bin && \
    chmod +x /usr/bin/parity && \
    chown -R nobody /data

USER nobody
RUN bash -c 'for i in {1..10}; do /usr/bin/parity --base-path /data --chain dev account new --password <(echo ""); done' && \
    bash /usr/bin/transfer.sh

FROM ubuntu:18.04

COPY --from=builder /usr/bin/parity /usr/bin/parity
COPY --from=builder /data /data

COPY start.sh /usr/bin/start.sh

RUN useradd --uid 1000 --no-create-home parity && \
    chown -R parity:parity /data && \
    chmod +x /usr/bin/start.sh

USER parity

EXPOSE 8945 8546

ENTRYPOINT ["/usr/bin/start.sh"]
