#!/usr/bin/env bash

set -e

source_dir="$PWD/graphviz"
build_dir="$source_dir/build"
prefix_dir="$source_dir/install"
output_dir="$PWD/dist"
output_src_dir="$output_dir/gen"
output_lib_dir="$output_dir/lib"

# Apply patches
pushd "$source_dir"
git apply ../*.patch
popd

# Configure Graphviz build
cmake -S "$source_dir" -B "$build_dir" \
  -DENABLE_SWIG=ON \
  -DENABLE_SHARP=ON \
  -DWITH_SMYRNA=OFF \
  -DWITH_GVEDIT=OFF \
  -DWITH_SMYRNA=OFF \
  -DENABLE_TCL=OFF \
  -DENABLE_D=OFF \
  -DENABLE_GO=OFF \
  -DENABLE_GUILE=OFF \
  -DENABLE_JAVA=OFF \
  -DENABLE_JAVASCRIPT=OFF \
  -DENABLE_LUA=OFF \
  -DENABLE_PERL=OFF \
  -DENABLE_PHP=OFF \
  -DENABLE_PYTHON=OFF \
  '-DCMAKE_INSTALL_RPATH=$ORIGIN'

# Build Graphviz library
cmake --build "$build_dir"

# Install built SO and CSharp files into prefix
cmake --install "$build_dir" --prefix "$prefix_dir"

# Copy generated CSharp code and glue library into project directory
echo "Copying generated files into: $output_dir"
mkdir -p "$output_src_dir" "$output_lib_dir/graphviz"

# Copy generated CSharp code to gen source directory
cp "$prefix_dir/lib/graphviz/sharp/"*.cs "$output_src_dir"

shopt -s extglob

# Copy built graphviz binaries into lib directory
# Only include version libs, eg. libgvc.so.6
cp "$prefix_dir/lib/"*.so.+([0-9]) "$output_lib_dir"
cp "$prefix_dir/lib/graphviz/"*.so.+([0-9]) "$output_lib_dir/graphviz"
cp "$prefix_dir/lib/graphviz/"config* "$output_lib_dir/graphviz"

# Copy glue library up into root lib directory
cp "$prefix_dir/lib/graphviz/sharp/"*.so "$output_lib_dir"
