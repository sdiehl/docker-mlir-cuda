FROM ubuntu:24.10

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
  lld \
  man-db \
  ninja-build \
  pybind11-dev \
  python3 \
  python3-numpy \
  python3-pybind11 \
  python3-yaml \
  unzip \
  wget \
  xz-utils

# Install CUDA
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.0-1_all.deb
RUN sudo dpkg -i cuda-keyring_1.0-1_all.deb
RUN sudo apt-get update
RUN sudo apt-get install build-essential
RUN sudo apt-get -y install cuda-toolkit-12-x

# Build MLIR
RUN git clone https://github.com/llvm/llvm-project.git
RUN mkdir llvm-project/build
WORKDIR llvm-project/build
RUN cmake -G Ninja ../llvm \
   -DLLVM_ENABLE_PROJECTS=mlir \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
   -DCMAKE_BUILD_TYPE=Release \
   -DMLIR_ENABLE_BINDINGS_PYTHON=On \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DLLVM_CCACHE_BUILD=ON \
   -DMLIR_ENABLE_CUDA_RUNNER=ON \
   -DMLIR_ENABLE_NVPTXCOMPILER=ON

# Install MLIR
RUN cmake --build build -t mlir-opt mlir-translate mlir-transform-opt mlir-cpu-runner check-mlir || true
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
