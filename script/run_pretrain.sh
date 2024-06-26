#!/bin/bash

# sudo apt update
# sudo apt install -y python3.10-venv
python3.10 -m venv openmoe_venv

source openmoe_venv/bin/activate
python3 -m pip install -U pip setuptools wheel ipython
python3 -m pip install --upgrade pip
python3 -m pip install https://storage.googleapis.com/cloud-tpu-tpuvm-artifacts/wheels/libtpu-nightly/libtpu_nightly-0.1.dev20230724-py3-none-any.whl

pip install git+https://github.com/google-research/jestimator
pip install protobuf==3.20.3
git clone --branch=main https://github.com/rosinality/t5x
cd t5x
git pull
pip install -e .

pip install flax

echo y | python3 -m pip uninstall t5[gcp]
echo y | python3 -m pip uninstall t5
git clone --branch=main https://github.com/rosinality/text-to-text-transfer-transformer.git
cd text-to-text-transfer-transformer
git pull
pip install -e .

echo y | python3 -m pip uninstall seqio
echo y | python3 -m pip uninstall seqio-nightly
git clone  --branch=main https://github.com/rosinality/seqio.git
cd seqio
git pull
pip install -e .

cd ../..
git clone  --branch=main https://github.com/rosinality/flaxformer.git
cd flaxformer
git pull
pip install -e .

python3 -m pip install gast
python3 -m pip install astunparse
python3 -m pip install flatbuffers
python3 -m pip install tensorboard
python3 -m pip install keras
python3 -m pip install tensorflow_estimator
python3 -m pip install libcst
python3 -m pip install portalocker
python3 -m pip install tabulate
python3 -m pip install colorama
python3 -m pip install lxml
python3 -m pip install joblib
python3 -m pip install threadpoolctl
python3 -m pip install tfds-nightly==4.6.0.dev202210040045
# python3 -m pip install tensorflow-datasets==4.3.0
python3 -m pip install h5py

cd ~
git clone https://github.com/google/aqt.git
cd aqt
pip install -e .

pip install --upgrade flax==0.7.5
pip install --upgrade optax==0.1.7
pip install --upgrade jax[tpu]==0.4.16 -f https://storage.googleapis.com/jax-releases/libtpu_releases.html
pip install scipy==1.11.0


cd ~
export GOOGLE_CLOUD_BUCKET_NAME=${BUCKET_NAME} \
export TFDS_DATA_DIR=gs://${BUCKET_NAME} \
export MODEL_DIR=gs://${BUCKET_NAME}/openmoe_8b_ul2/training \
export T5X_DIR="./t5x" \

python3  ${T5X_DIR}/t5x/train.py \
	--gin_file="t5x/examples/t5/t5_1_1/examples/${TRAIN_CONFIG}.gin" \
  --gin.MODEL_DIR=\"${MODEL_DIR}\" \
  --tfds_data_dir=${TFDS_DATA_DIR}
