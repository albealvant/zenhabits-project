FROM rust:1.85.1 AS builder

COPY ../Cargo.toml ./app/zenhabits_server/Cargo.toml
COPY ../src ./app/zenhabits_server/src

WORKDIR /app/zenhabits_server

RUN cargo build --release 

FROM ubuntu:22.04

RUN apt-get update && apt-get install -y libssl3 ca-certificates && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY --from=builder /app/zenhabits_server/target/release/zenhabits_server .

EXPOSE 3000

CMD ["./zenhabits_server"]