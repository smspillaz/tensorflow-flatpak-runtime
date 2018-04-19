#!/bin/bash
#
# Wrapper script for bazel build, setting necessary environment
# variables and action_env parameters

# Set HOME so that python doesn't freak out whne trying to find
# user site packages (our UID won't exist in /etc/passwd
export HOME=$(mktemp -d)
export PYTHONNOUSERSITE=1

# Set JAVA_HOME so bazel knows where to find javac
export JAVA_HOME=$FLATPAK_DEST/lib/jvm/java-1.8.0-openjdk-amd64/

TARGET=$1
OUTPUT_BASE=$2

bazel --output_base=${OUTPUT_BASE} build \
  ${TARGET} \
  --action_env=HOME \
  --action_env=PYTHONNOUSERSITE \
  --verbose_failures
