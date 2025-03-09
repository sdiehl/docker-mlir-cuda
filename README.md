# Dev Environment for MLIR

Installs the necessary dependencies for building:

1. LLVM 20
2. MLIR (With CUDA support)
3. nvcc
4. cuDNN & cuBLAS

CUDA binaries are installed to `/usr/local/cuda/bin/` and the CUDA libraries are installed to `/usr/local/cuda/lib64/`.

To append to your paths add the following to `~/.bashrc`:

```bash
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```

## Downloading

```bash
docker pull ghcr.io/sdiehl/docker-mlir-cuda:main
docker run -it ghcr.io/sdiehl/docker-mlir-cuda:main bash
```

Or in your Dockerfile:

```Dockerfile
FROM ghcr.io/sdiehl/docker-mlir-cuda:main
```

## Building

To build the image locally:

```bash
git clone git@github.com:sdiehl/docker-mlir-cuda.git
cd docker-mlir-cuda
docker build -t mlir-dev .
docker run -it mlir-dev bash
```
