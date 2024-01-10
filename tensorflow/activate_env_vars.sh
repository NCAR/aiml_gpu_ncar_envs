export CONDA_LIB=${CONDA_PREFIX}/lib
export LD_LIBRARY_PATH=${CONDA_LIB}:${LD_LIBRARY_PATH}

# Some install methods require manually specifying cuDNN path. Should be no longer required
#export CUDNN_PATH=$(dirname $(python -c "import nvidia.cudnn;print(nvidia.cudnn.__file__)"))
#export CUDNN_LIB=${CUDNN_PATH}/lib
#export LD_LIBRARY_PATH=${CUDNN_LIB}:${LD_LIBRARY_PATH}

export PY_VER=`python -c 'import sys; version=sys.version_info[:3]; print("{0}.{1}".format(*version))'`
export TENSORRT_PATH=${CONDA_PREFIX}/lib/python${PY_VER}/site-packages/tensorrt_libs
export LD_LIBRARY_PATH=${TENSORRT_PATH}:${LD_LIBRARY_PATH}

export XLA_FLAGS=--xla_gpu_cuda_data_dir=${CONDA_PREFIX}

# For CUDA Aware MPI support
export OMPI_MCA_opal_cuda_support=true

# For TF optimizations, see https://github.com/NVIDIA/DeepLearningExamples/issues/57
export TF_GPU_THREAD_MODE=gpu_private
export TF_GPU_THREAD_COUNT=2 # 2 (default) or sometimes 4 seems a little better
