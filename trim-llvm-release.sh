#!/usr/bin/env bash

target=$1
if [[ -z ${target} ]]; then
  echo "usage: provide a target, e.g. aarch-macos-none, x86_64-linux-musl, x86_64-windows-gnu"
  exit 1
fi
mv out/${target}-baseline out/llvm-${target}-baseline
cd out/llvm-${target}-baseline
rm -rf share libexec lib
cd bin
EXE=""
if [[ ${target} == *"windows"* ]]; then
  EXE=".exe"
fi
REMOVE_LIST=(
  clang-check
  clang-scan-deps
  opt
  llvm-exegesis
  bugpoint
  llvm-c-test
  llvm-gsymutil
  clang-extdef-mapping
  llvm-jitlink
  clang-refactor
  clang-rename
  clang-offload-bundler
  clang-offload-packager
)
for remove_file in ${REMOVE_LIST[@]}; do
  echo ${remove_file}
  rm ${remove_file}${EXE}
done
