# How to Setup TensorFlow on NCAR HPC Systems

This package provides scripts to setup [Tensorflow using `pip`](setup_pip_tf.sh) or [Tensorflow using `conda`](setup_cond_tf.sh) with GPU support. These install scripts should be relatively portable to any machine that has NVIDIA GPUs but support for NCAR HPC systems is prioritized. The official installation guide for TensorFlow is found [here](https://www.tensorflow.org/install).

The key steps for setting up TensorFlow are to ensure that the correct versions of CUDA and `cudnn` packages are installed alongside TensorFlow. 'tensorrt' must also be installed manually for the `pip` version. These requirements are specified on [TensorFlow's guide on installing from source](https://www.tensorflow.org/install/source#gpu) and defined in [`tf_pip.list`](tf_pip.list)/[`tf_conda.list`](tf_conda.list). Some specifications are modified due to software availability and dependency needs within PyPI and conda-forge. To note, `conda` installs will use the latest available `cudnn` package provided by Conda Forge, provided it is a version release greater than the requirement for the respective TensorFlow release. 

Currently, these scripts leverage pre-built software packages provided either through conda software channels such as Conda Forge or pip's Python Package Index. Optimized TensorFlow installs built from source are not provided at this time due to dependence on the Clang compiler toolchain. However, if you are interested in building TensorFlow from source on Casper or Derecho to achieve greater performance on NCAR systems, please open an issue in this repository or reach out to [cislhelp@ucar.edu](cislhelp@ucar.edu).

The seccond key step for TensorFlow installs is to ensure that environment variables are set correctly to point TensorFlow to the conda-based CUDA installation and associated libraries. These are set during the activation of each conda environment via [`activate_env_vars.sh`](activate_env_vars.sh) and unset via [`deactivate_env_vars.sh`](deactivate_env_vars.sh).

## Setup

1. (Optional) Install [MiniConda](https://docs.conda.io/en/latest/miniconda.html) or [MambaForge](https://github.com/conda-forge/miniforge) to your local machine if not running on NCAR HPC Systems without access to `conda` via `module load conda`. 
2. Choose to install either the `pip` or the `conda` version of TensorFlow. See below section for a comparison.
3. Run `sh setup_pip_tf.sh` or `sh setup_conda_tf.sh`. Respond to the first prompt to select a version to install or to install unattended, run `echo "X" | ./setup_pip_tf.sh` where X is a value 1 to 5 corresponding to TensorFlow version 2.11 to 2.15.
4. Start a batch job on a gpu node. You can start a 60 minute testing job with `qinteractive -l select=1:ncpus=1:mem=20GB:ngpus=1 -q develop -A $PROJECT_ID` on Derecho. 
5. Activate the environment with `module load conda` and `conda activate tfXXXgpu_YYY` where XXX is the version number and YYY is either `conda` or `pip`. 
6. Run `python test_tf_simple_nn.py` to test that the GPU is detected correctly and that a simple neural net will train on the GPU. 

## `pip` vs `nopip`

The `pip` installation method provided in this repository is that recommended by Google which provides TensorFlow. The `conda` installation method is community supported and ditributed primarily through `conda-forge`.

In general, pure installations using `conda` are easier to maintain compared to `pip` based installations. It is relatively easy to break dependency requirements when mixing `pip` and `conda` installs. The `pip` version tends to have support for the latest releases of TensorFlow first vefore `conda` installations are made available. Additionally, the `pip` version includes instruction sets for CPU operations up through AVX while the `conda` version provides only up to SSE3. 

Please consider these differences when choosing to install a version of TensorFlow.

## Additional Considerations and Warning Messages

The below warning and error messages can likely be ignored:

This error shows up for TensorFlow 2.14+ as of January 2024. The issue appears related to the more recent install process using `pip install tensorflow[and-cuda]. CUDA libraries may be conflicting with one another inside the virtual environment created by `pip`. Nonetheless, necessary CUDA libraries are still being loaded but likely in a redundant manner. See [this GitHub issue](https://github.com/tensorflow/tensorflow/issues/62075#issuecomment-1867738824) for more info. Testing shows that performance is not impacted. 
```bash
E tensorflow/compiler/xla/stream_executor/cuda/cuda_dnn.cc:9342] Unable to register cuDNN factory: Attempting to register factory for plugin cuDNN when one has already been registered
E tensorflow/compiler/xla/stream_executor/cuda/cuda_fft.cc:609] Unable to register cuFFT factory: Attempting to register factory for plugin cuFFT when one has already been registered
E tensorflow/compiler/xla/stream_executor/cuda/cuda_blas.cc:1518] Unable to register cuBLAS factory: Attempting to register factory for plugin cuBLAS when one has already been registered
```
