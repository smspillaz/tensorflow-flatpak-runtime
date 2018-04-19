#!/bin/bash
#
# Run this script to regenerate the tensorflow build dependencies
# flatpak manifest json file. It should be written to
# org.tensorglow.TensorGlow.Dependencies.json in the source directory.

TOPLEVEL_DIRECTORY=$(readlink -f $(dirname ${BASH_SOURCE})/..)/

python3 \
  gen-flatpak-builder-json-workspace-bzl.py \
  ${TOPLEVEL_DIRECTORY}/reference/original/tensorflow/workspace.bzl > ${TOPLEVEL_DIRECTORY}/org.tensorglow.TensorGlow.Dependencies.json

