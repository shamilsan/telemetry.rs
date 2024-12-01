FROM rust:1.82-slim as backend-builder
WORKDIR /tmp
RUN apt-get update && apt-get install -y git pkg-config libssl-dev build-essential
RUN git clone https://github.com/paritytech/substrate-telemetry.git
WORKDIR /tmp/substrate-telemetry/backend
RUN cargo build --release

FROM node:16-slim as frontend-builder
WORKDIR /tmp
COPY --from=backend-builder /tmp/substrate-telemetry /tmp/substrate-telemetry
COPY ./frontend/ /tmp/substrate-telemetry/frontend/
WORKDIR /tmp/substrate-telemetry/frontend
RUN find ./src -name "*.css" -type f -exec sed -ie 's/#e6007a/#00a87a/g' {} \;
RUN yarn install && yarn build

FROM nginx:1.27.3
WORKDIR /app
RUN rm -rf /etc/nginx/conf.d/*
COPY --from=backend-builder /tmp/substrate-telemetry/backend/target/release/telemetry_core /usr/local/bin/telemetry_core
COPY --from=backend-builder /tmp/substrate-telemetry/backend/target/release/telemetry_shard /usr/local/bin/telemetry_shard
COPY --from=frontend-builder /tmp/substrate-telemetry/frontend/build/ /app/
COPY ./docker/vhost.conf /etc/nginx/conf.d/vhost.conf
EXPOSE 80 8000 8001

CMD ["sh", "-c", "telemetry_core --max-third-party-nodes 1000 & sleep 5 && telemetry_shard & sleep 5 && nginx -g 'daemon off;' -c /etc/nginx/nginx.conf"]
