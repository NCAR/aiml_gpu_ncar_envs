# How to Setup PyTorch on NCAR HPC Systems

This package provides scripts to setup [PyTorch using `conda`](setup_conda_pt.sh) with GPU support. These install scripts should be relatively portable to any machine that has NVIDIA GPUs but support for NCAR HPC systems is prioritized. The official installation guide for PyTorch is found [here](https://pytorch.org/get-started/locally).

## Setup

1. (Optional) Install [MiniConda](https://docs.conda.io/en/latest/miniconda.html) or [MambaForge](https://github.com/conda-forge/miniforge) to your local machine if not running on NCAR HPC Systems without access to `conda` via `module load conda`. 
2. Run `sh setup_conda_pt.sh`. Respond to the prompt to select a version to install or to install unattended, run `echo "X" | ./setup_conda_pt.sh` where X is a value 1 to 3 corresponding to PyTorch versiond 1.13.1, 2.0.1, or 2.1.2 respectively.
4. Start a batch job on a gpu node. You can start a 60 minute testing job with `qinteractive -l select=1:ncpus=1:mem=20GB:ngpus=1 -q develop -A $PROJECT_ID` on Derecho. 
5. Activate the environment with `module load conda` and `conda activate ptXXXgpu_conda` where XXX is the version number. 
6. Run `python test_pytorch_gpu.py` to test that the GPU is detected correctly. 
