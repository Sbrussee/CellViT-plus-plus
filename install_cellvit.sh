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


# Step 1: Create the Conda Environment using the provided environment file
if [ -d "$ENV_DIR" ]; then
    echo "✅ Conda environment already exists at: $ENV_DIR"
else
    echo "🔹 Creating Conda environment..."
    echo "🔹 The Conda environment will be created at: $ENV_DIR"
    conda env create -f "$SCRIPT_DIR/environment_verbose.yaml" --prefix "$ENV_DIR"
fi

# Step 2: Activate the newly created Conda Environment
echo "🔹 Activating environment..."
# Check if slurm job
if [ -z "$SLURM_JOB_ID" ]; then

    # If not running in a SLURM job, activate the environment directly
    conda activate "$ENV_DIR"
else
    # If running in a SLURM job, use the full path to the conda binary
    module load tools/miniconda/python3.9/4.12.0
    source "/share/software/tools/miniconda/3.9/4.12.0/etc/profile.d/conda.sh"
    conda activate "$ENV_DIR"
fi

echo "✅ Conda environment activated."

#Install and upgrade wheels, setuptools and pip
pip install --upgrade pip setuptools wheel

echo "✅ Wheels, setuptools and pip installed and upgraded."

# Step 3: Install additional pip dependencies from requirements.txt
echo "🔹 Installing pip packages from requirements.txt..."
pip install -r "$SCRIPT_DIR/requirements.txt"

echo "✅ Pip packages installed."

echo "🔹 Installing PyTorch for CUDA $CUDA_VERSION..."
pip3 install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu118

# Step 5: Verify the PyTorch installation
echo "🔹 Verifying PyTorch installation..."
python -c "import torch; print(f'✅ PyTorch version: {torch.__version__}')" || echo "⚠️ PyTorch installation failed."

echo "🎉 Installation of CellViT-plus-plus completed successfully!"
