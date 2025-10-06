FROM debian:stable-slim AS platform

RUN apt-get update && apt-get install -y \
  binutils-aarch64-linux-gnu \
  build-essential \
  cmake \
  g++-aarch64-linux-gnu \
  gcc-aarch64-linux-gnu \
  git \
  libsdl2-dev \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace