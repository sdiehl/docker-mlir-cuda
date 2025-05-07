# FROM ubuntu:24.10
FROM nvidia/cuda:12.8.0-cudnn-devel-ubuntu24.04

# Update Linux
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y sudo

# Install Build Tools
RUN sudo apt-get install -y \
  bash-completion \
  ca-certificates \
  ccache \
  clang \
  cmake \
  cmake-curses-gui \
  git \
  curl \
  lld \
  man-db \
  ninja-build \
  pybind11-dev \
  python3 \
  python3-numpy \
  python3-pip \
  python3-pybind11 \
  python3-yaml \
  unzip \
  wget \
  xz-utils \
  gnupg \
  software-properties-common

# Install LLVM 20 and MLIR tools
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc
RUN add-apt-repository "deb http://apt.llvm.org/noble/ llvm-toolchain-noble-20 main"
RUN add-apt-repository "deb-src http://apt.llvm.org/noble/ llvm-toolchain-noble-20 main"
RUN apt-get update
RUN apt-get install -y llvm-20 llvm-20-dev llvm-20-tools mlir-20-tools
RUN ln -s /usr/bin/llc-20 /usr/bin/llc
RUN ln -s /usr/bin/mlir-translate-20 /usr/bin/mlir-translate
RUN ln -s /usr/bin/mlir-opt-20 /usr/bin/mlir-opt

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv