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
git apply ../*.patch || true
popd

# Configure Graphviz build
cmake -S "$source_dir" -B "$build_dir" \
  -DENABLE_SWIG=true \
  -DENABLE_SHARP=true

# Build Graphviz library
cmake --build "$build_dir"

# Install built SO and CSharp files into prefix
cmake --install "$build_dir" --prefix "$prefix_dir"

# Copy generated CSharp code and glue library into project directory
echo "Copying generated files into: $output_dir"
mkdir -p "$output_src_dir" "$output_lib_dir"
cp "$prefix_dir/lib/graphviz/sharp/"*.cs "$output_src_dir"
cp "$prefix_dir/lib/graphviz/sharp/"*.so "$output_lib_dir"
