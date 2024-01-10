#!/bin/sh
echo 'Please select the version of TensorFlow to install:'
nl tf_pip.list
count="$(wc -l tf_pip.list | cut -f 1 -d' ')"
n=""
while true; do
    read -p 'Select option: ' n
    # If $n is an integer between one and $count...
    if [ "$n" -eq "$n" ] && [ "$n" -gt 0 ] && [ "$n" -le "$count" ]; then
        break
    fi
done
value="$(sed -n "${n}p" tf_pip.list)"
echo "TensorFlow $value will now be installed in a GPU enabled conda environment."

TF_VER=`cut -d ' ' -f 1 <<< $value`
CUDNN_VER=`cut -d ' ' -f 3 <<< $value`
CUDA_VER=`cut -d ' ' -f 5 <<< $value`
PY_VER=`cut -d ' ' -f 7 <<< $value`

if (( $(bc <<< "$TF_VER < 2.14") )); then
	cat << EOF > tf${TF_VER//./}pip_env.yaml
name: tf${TF_VER//./}gpu_pip
channels:
  - conda-forge
  - nvidia
dependencies:
  - python=${PY_VER}.*
  - libblas=*=*blis
  - numpy=1.24.3
  - scipy
  - pandas
  - hdf5=*=*openmpi*
  - h5py=*=*openmpi*
  - typing-extensions=4.5.0
  - urllib3=1.26.15
  - cudatoolkit=${CUDA_VER}.*
  - cuda-nvcc
  - cudnn>=${CUDNN_VER}.*
  - pip
  - pip:
    - tensorrt
    - tensorflow==${TF_VER}.*
    - keras-tuner
EOF
else
	cat << EOF > tf${TF_VER//./}pip_env.yaml
name: tf${TF_VER//./}gpu_pip
channels:
  - conda-forge
  - nvidia
dependencies:
  - python=${PY_VER}.*
  - libblas=*=*blis
  - numpy<2.0.0
  - scipy
  - pandas
  - ucx
  - hdf5=*=*openmpi*
  - h5py=*=*openmpi*
  - pip
  - pip:
    - --extra-index-url https://pypi.nvidia.com
    - tensorrt
    - tensorrt-bindings
    - tensorrt-libs
    - tensorflow[and-cuda]==${TF_VER}.*
    - keras-tuner
EOF
fi

module load conda

CONDA_OVERRIDE_CUDA=$CUDA_VER mamba env create -f tf${TF_VER//./}pip_env.yaml

conda activate tf${TF_VER//./}gpu_pip

mkdir -p $CONDA_PREFIX/etc/conda/activate.d
mkdir -p $CONDA_PREFIX/etc/conda/deactivate.d

cp activate_env_vars.sh $CONDA_PREFIX/etc/conda/activate.d/env_vars.sh
cp deactivate_env_vars.sh $CONDA_PREFIX/etc/conda/deactivate.d/env_vars.sh

# See https://github.com/tensorflow/tensorflow/issues/61468#issuecomment-1880972316
pushd ${CONDA_PREFIX}/lib/python${PY_VER}/site-packages/tensorrt_libs &> /dev/null
ln -s libnvinfer_plugin.so.8 libnvinfer_plugin.so.7
ln -s libnvinfer.so.8 libnvinfer.so.7
ln -s libnvinfer_plugin.so.8 libnvinfer_plugin.so.8.6.1
ln -s libnvinfer.so.8 libnvinfer.so.8.6.1
popd &> /dev/null

conda deactivate
