#!/bin/bash
set -e
set -x
rm -rf files var metadata export build

flatpak-builder -v build org.tensorglow.TensorGlow.json
flatpak build-export repo build master
flatpak build-bundle repo org.tensorglow.TensorGlow.flatpak org.tensorglow.TensorGlow
