ARG BASE_IMAGE=ubuntu:24.04
ARG MLIR_VERSION=20
ARG CUDA_ENABLED=false

FROM ${BASE_IMAGE}

# Re-declare build arguments after FROM
ARG MLIR_VERSION
ARG CUDA_ENABLED

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC

# Update Linux and install tzdata first
RUN DEBIAN_FRONTEND=noninteractive TZ=UTC apt-get update && \
    apt-get install -y --no-install-recommends tzdata && \
    ln -fs /usr/share/zoneinfo/UTC /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

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
  python3-full \
  python3-numpy \
  python3-pip \
  python3-pybind11 \
  python3-yaml \
  unzip \
  wget \
  xz-utils \
  gnupg \
  software-properties-common

# Install LLVM and MLIR tools
RUN wget -qO- https://apt.llvm.org/llvm-snapshot.gpg.key | tee /etc/apt/trusted.gpg.d/apt.llvm.org.asc

# Set LLVM repository based on Ubuntu version
RUN if [ "$(lsb_release -cs)" = "jammy" ]; then \
      add-apt-repository "deb http://apt.llvm.org/jammy/ llvm-toolchain-jammy-${MLIR_VERSION} main" && \
      add-apt-repository "deb-src http://apt.llvm.org/jammy/ llvm-toolchain-jammy-${MLIR_VERSION} main"; \
    else \
      add-apt-repository "deb http://apt.llvm.org/noble/ llvm-toolchain-noble-${MLIR_VERSION} main" && \
      add-apt-repository "deb-src http://apt.llvm.org/noble/ llvm-toolchain-noble-${MLIR_VERSION} main"; \
    fi

RUN apt-get update
RUN apt-get install -y llvm-${MLIR_VERSION} llvm-${MLIR_VERSION}-dev llvm-${MLIR_VERSION}-tools mlir-${MLIR_VERSION}-tools
RUN ln -s /usr/bin/llc-${MLIR_VERSION} /usr/bin/llc
RUN ln -s /usr/bin/mlir-translate-${MLIR_VERSION} /usr/bin/mlir-translate
RUN ln -s /usr/bin/mlir-opt-${MLIR_VERSION} /usr/bin/mlir-opt

# Install uv for Python package management
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Install MLIR Python bindings
RUN pip install --break-system-packages mlir-python-bindings -f https://github.com/makslevental/mlir-wheels/releases/expanded_assets/latest

# Set environment variables
ENV MLIR_VERSION=${MLIR_VERSION}
ENV CUDA_ENABLED=${CUDA_ENABLED}