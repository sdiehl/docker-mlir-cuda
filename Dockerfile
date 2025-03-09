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
RUN sudo apt-get -y update
RUN sudo apt-get -y install build-essential
RUN sudo apt-get -y install cuda-toolkit-12-8
# RUN sudo apt-get -y install libcudnn8 libcudnn8-dev libcublas-dev

# Install CUDA Drivers
# RUN sudo apt-get install -y cuda-drivers

# Install Nanobind
RUN git clone https://github.com/wjakob/nanobind && \
  cd nanobind && \
  git submodule update --init --recursive && \
  cmake \
    -G Ninja \
    -B build \
    -DCMAKE_CXX_COMPILER=clang++ \
    -DCMAKE_C_COMPILER=clang \
    -DCMAKE_INSTALL_PREFIX=$HOME/usr && \
  cmake --build build --target install && \
  cd

# Build MLIR (from snapshot)
RUN wget https://github.com/llvm/llvm-project/archive/refs/tags/llvmorg-20.1.0.tar.gz && \
  tar -xvf llvmorg-20.1.0.tar.gz && \
  mv llvm-project-llvmorg-20.1.0 llvm-project

# Build MLIR (from git)
# RUN git clone https://github.com/llvm/llvm-project.git
# RUN mkdir llvm-project/build

WORKDIR llvm-project/build
RUN cmake -G Ninja ../llvm \
   -DCMAKE_C_COMPILER=clang \
   -DCMAKE_CXX_COMPILER=clang++ \
   -DCMAKE_CUDA_COMPILER=nvcc \
   -DLLVM_ENABLE_PROJECTS=mlir \
   -DLLVM_BUILD_EXAMPLES=ON \
   -DLLVM_TARGETS_TO_BUILD="Native;NVPTX;AMDGPU" \
   -DCMAKE_BUILD_TYPE=Release \
   # -DMLIR_ENABLE_BINDINGS_PYTHON=On \
   -DLLVM_ENABLE_ASSERTIONS=ON \
   -DLLVM_CCACHE_BUILD=ON \
   -DMLIR_ENABLE_CUDA_RUNNER=ON \
   -DMLIR_ENABLE_CUDA_CONVERSIONS=ON \
   -DMLIR_ENABLE_NVPTXCOMPILER=ON

# Install MLIR
# RUN cmake --build build -t mlir-opt mlir-translate mlir-transform-opt mlir-cpu-runner check-mlir || true
RUN cmake --build build -t mlir-opt mlir-translate mlir-transform-opt mlir-cpu-runner || true
COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv
