#!/bin/sh
echo 'Please select the version of TensorFlow to install:'
nl tf_conda.list
count="$(wc -l tf_conda.list | cut -f 1 -d' ')"
n=""
while true; do
    read -p 'Select option: ' n
    # If $n is an integer between one and $count...
    if [ "$n" -eq "$n" ] && [ "$n" -gt 0 ] && [ "$n" -le "$count" ]; then
        break
    fi
done
value="$(sed -n "${n}p" tf_conda.list)"
echo "TensorFlow $value will now be installed in a GPU enabled conda environment."

TF_VER=`cut -d ' ' -f 1 <<< $value`
CUDNN_VER=`cut -d ' ' -f 3 <<< $value`
CUDA_VER=`cut -d ' ' -f 5 <<< $value`
PY_VER=`cut -d ' ' -f 7 <<< $value`

cat << EOF > tf${TF_VER//./}conda_env.yaml
name: tf${TF_VER//./}gpu_conda
channels:
  - conda-forge
  - nvidia
dependencies:
  - python=${PY_VER}.*
  - libblas=*=*blis
  - numpy
  - scipy
  - pandas
  - hdf5=*=*openmpi*
  - h5py=*=*openmpi*
  - ucx
  - cuda-nvcc
  - tensorflow=${TF_VER}.*=cuda${CUDA_VER//./}*
  - cudnn>=${CUDNN_VER}.*
  - keras-tuner
EOF
# Leave out cudatoolkit so that TF cuda spec within package is used
#  - cudatoolkit=${CUDA_VER}.*

module load conda

CONDA_OVERRIDE_CUDA=$CUDA_VER mamba env create -f tf${TF_VER//./}conda_env.yaml

conda activate tf${TF_VER//./}gpu_conda

mkdir -p $CONDA_PREFIX/etc/conda/activate.d
mkdir -p $CONDA_PREFIX/etc/conda/deactivate.d

cp activate_env_vars.sh $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
cp deactivate_env_vars.sh $CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh

conda deactivate
