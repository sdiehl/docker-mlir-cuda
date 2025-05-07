# Dev Environment for MLIR

One click dev environments for MLIR with CUDA support.

To use GitHub Codespaces, just click the button below.

[![Open in Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/sdiehl/docker-mlir-cuda)

## Downloading

Available image variants:

### Ubuntu 24.04
```bash
# With CUDA
docker pull ghcr.io/sdiehl/docker-mlir-cuda:mlir-cuda-ubuntu24.04
docker pull ghcr.io/sdiehl/docker-mlir-cuda:mlir19-cuda-ubuntu24.04

# Without CUDA
docker pull ghcr.io/sdiehl/docker-mlir-cuda:mlir-ubuntu24.04
docker pull ghcr.io/sdiehl/docker-mlir-cuda:mlir19-ubuntu24.04
```

### Ubuntu 22.04
```bash
# With CUDA
docker pull ghcr.io/sdiehl/docker-mlir-cuda:mlir-cuda-ubuntu22.04
docker pull ghcr.io/sdiehl/docker-mlir-cuda:mlir19-cuda-ubuntu22.04

# Without CUDA
docker pull ghcr.io/sdiehl/docker-mlir-cuda:mlir-ubuntu22.04
docker pull ghcr.io/sdiehl/docker-mlir-cuda:mlir19-ubuntu22.04
```

To run any of these images:
```bash
docker run -it ghcr.io/sdiehl/docker-mlir-cuda:<tag> bash
```

Or in your Dockerfile:
```Dockerfile
FROM ghcr.io/sdiehl/docker-mlir-cuda:<tag>
```

## Building

To build the image locally:

```bash
git clone git@github.com:sdiehl/docker-mlir-cuda.git
cd docker-mlir-cuda
docker build -t mlir-dev .
docker run -it mlir-dev bash
```

## Using the Devcontainer with Visual Studio Code

This repository includes a `devcontainer.json` file in the `.devcontainer` directory. This allows you to use Visual Studio Code's Remote - Containers extension to develop inside a container.

### Steps to use the devcontainer:

1. Install Visual Studio Code.
2. Install the Remote - Containers extension.
3. Clone this repository.
4. Open the repository in Visual Studio Code.
5. When prompted, reopen the repository in a container.

This will build and start a development container using the settings specified in the `devcontainer.json` file.

## Using with GitHub Codespaces

You can use this development environment directly in GitHub Codespaces:

1. Navigate to the repository on GitHub
2. Click the "Code" button
3. Select the "Codespaces" tab
4. Click "Create codespace on main"
5. In the options dialog, select "MLIR CUDA Dev Container" as the base image
6. Wait for the codespace to build and start

## Notes

CUDA binaries are installed to `/usr/local/cuda/bin/` and the CUDA libraries are installed to `/usr/local/cuda/lib64/`.

To append to your paths add the following to `~/.bashrc`:

```bash
export PATH=/usr/local/cuda/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda/lib64:$LD_LIBRARY_PATH
```
