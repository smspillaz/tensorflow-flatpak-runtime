#!/bin/bash
#
# Regenerate the workspace.bzl patch from the files in reference/

TOPLEVEL=$(readlink -f $(dirname $BASH_SOURCE)/..)
PATCHES=${TOPLEVEL}/patches

pushd ${TOPLEVEL}/reference
  diff -pruN original/tensorflow/workspace.bzl patched/tensorflow/workspace.bzl > ${PATCHES}/tensorflow-build-dependencies.patch
popd

