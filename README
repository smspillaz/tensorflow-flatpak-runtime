TensorFlow Flatpak Runtime
==========================

A Flatpak Runtime for TensorFlow (Google's Machine Learning Library).

This includes Java, Bazel, NumPy and TensorFlow (including the C++
bindings).

Caveats
------

### Build System
TensorFlow's C++ bindings are not installable in the usual sense. C++
projects need to be included in TensorFlow's buildsystem as a target
and TensorFlow will need to be rebuilt. In order to make this happen
the TensorFlow source distribution was included at /usr/src/tensorflow
and the build directory is at /usr/build/tensorflow

### Dependencies
`flatpak-builder` closes network connectivity during the build system
execution phase of the project. This breaks the Bazel buildsystem which
tries to do reproducible builds in its own way by downloading its own
artifacts. Unfortunately, it isn't very clear on how to get Bazel to
prefer the dependencies we downloaded to what seem like its cache
dirs (it seems that Bazel just wipes them). So we have to patch the
workspace.bzl file to fetch the dependencies from a local location
and copy them there in the sandbox instead.

### No debuginfo stripping
Bazel's binary is compressed, attempting to strip it causes all
sorts of problems. Unfortunately, "no-debuginfo" applies to
all the modules, so we don't get debuginfo stripping for any of them,
which means that this flatpak is going to be rather large since it
will include all the debug information.
