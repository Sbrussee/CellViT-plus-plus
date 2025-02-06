#!/bin/bash
# install_cellvit.sh
# This script installs CellViT-plus-plus by creating the Conda environment
# at MyFuGNN/envs/cellvit_env and installing required pip packages and PyTorch.

# Exit immediately if a command exits with a non-zero status.
set -e

echo "🚀 Starting installation of CellViT-plus-plus..."

# Get the absolute directory of this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Compute the environment directory relative to the repository root.
# Our repository structure is:
# MyFuGNN/
#   envs/
#     cellvit_env   <--- target environment directory
#   modules/
#     CellViT-plus-plus/   <--- this script lives here
ENV_DIR="$SCRIPT_DIR/../../envs/cellvit_env"

echo "🔹 The Conda environment will be created at: $ENV_DIR"

# Step 1: Create the Conda Environment using the provided environment file
echo "🔹 Creating Conda environment..."
conda env create -f "$SCRIPT_DIR/environment_verbose.yaml" --prefix "$ENV_DIR"

#Update conda
conda update -n base -c defaults conda

# Step 2: Activate the newly created Conda Environment
echo "🔹 Activating environment..."
# Ensure the conda command is available in this shell
source "$(conda info --base)/etc/profile.d/conda.sh"
conda activate "$ENV_DIR"

#Install and upgrade wheels, setuptools and pip
pip install --upgrade pip setuptools wheel

# Step 3: Install additional pip dependencies from requirements.txt
echo "🔹 Installing pip packages from requirements.txt..."
pip install -r "$SCRIPT_DIR/requirements.txt"

# Step 4: Install PyTorch for your system
echo "🔹 Checking PyTorch installation..."
PYTORCH_VERSION="2.2.2"
TORCHVISION_VERSION="0.17.2"
TORCHAUDIO_VERSION="2.2.2"
CUDA_VERSION="cu121"

if python -c "import torch" &> /dev/null; then
    echo "✅ PyTorch is already installed."
else
    echo "🔹 Installing PyTorch for CUDA $CUDA_VERSION..."
    pip install torch=="$PYTORCH_VERSION" torchvision=="$TORCHVISION_VERSION" torchaudio=="$TORCHAUDIO_VERSION" --index-url https://download.pytorch.org/whl/"$CUDA_VERSION"
fi

# Step 5: Verify the PyTorch installation
echo "🔹 Verifying PyTorch installation..."
python -c "import torch; print(f'✅ PyTorch version: {torch.__version__}')" || echo "⚠️ PyTorch installation failed."

echo "🎉 Installation of CellViT-plus-plus completed successfully!"
