#!/bin/bash
#
# Wrapper script for ./configure which automates all of
# the questions that get asked to the user.

# Some general configuration parameters - we need to set
# these to their defaults otherwise we'll get an interactive
# prompt from configure
export PATH=$PATH:/usr/lib/sdk/openjdk9/bin
export PYTHON_BIN_PATH=/usr/bin/python3
export PYTHON_LIB_PATH=\"/usr/lib/python3.5/site-packages\"
export CC_OPT_FLAGS=\"-march=native\"

# No CUDA support at the moment
export CLANG_CUDA_COMPILER_PATH=\"\"
export TF_CUDA_VERSION=\"9.0\"
export CUDA_TOOLKIT_PATH=\"/opt/cuda\"
export TF_CUDNN_VERSION=\"7\"
export CUDNN_INSTALL_PATH=\"/opt/cuda\" 

# TensorRuntime
export TENSORRT_INSTALL_PATH=\"/usr/lib\"

# NCCL
export TF_NCCL_VERSION=\"1.3\"
export NCCL_INSTALL_PATH=\"/opt/cuda\"

# CUDA Capabilities
export TF_CUDA_COMPUTE_CAPABILITIES=\"3.5,5.2\"

# TriSYCL (CL on a CPU)
TRISYCL_INCLUDE_DIR=\"/usr/local/triSYCL\"

# Optional features, turn them all off
export TF_NEED_JEMALLOC=0
export TF_NEED_GCP=0
export TF_NEED_HDFS=0
export TF_NEED_S3=0
export TF_NEED_KAFKA=0
export TF_NEED_OPENCL_SYSCL=0
export TF_NEED_COMPUTECPP=0
export TF_NEED_OPENCL=0
export TF_CUDA_CLANG=0
export TF_NEED_TENSORRT=0
export TF_DOWNLOAD_CLANG=0
export TF_NEED_CUDA=0
export TF_NEED_MPI=0
export TF_ENABLE_XLA=0
export TF_NEED_GDR=0
export TF_NEED_VERBS=0
export TF_NEED_OPENCL_SYCL=0
export TF_SET_ANDROID_WORKSPACE=0

# Set HOME so that python doesn't freak out whne trying to find
# user site packages (our UID won't exist in /etc/passwd
export HOME=$(mktemp -d)
export PYTHONNOUSERSITE=1

# Set JAVA_HOME so that bazel knows where to find javac
export JAVA_HOME=$FLATPAK_DEST/lib/jvm/java-1.8.0-openjdk-amd64/

exec $@
