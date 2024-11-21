$ErrorActionPreference = "Stop"

$SourceDir = "$PSScriptRoot\graphviz"
$BuildDir = "$SourceDir\build"
$PrefixDir = "$SourceDir\install"
$OutputDir = "$PSScriptRoot\dist"
$OutputSrcDir = "$OutputDir\src"
$OutputLibDir = "$OutputDir\lib"

# Set up Graphviz Windows build utilities
Set-ExecutionPolicy Bypass -Force -Scope Process
. $SourceDir\windows\bin\setup-build-utilities.ps1

pushd "$SourceDir"
# Apply patch to generate CSharp code in GraphVizard.Interop namespace
git apply ..\graphviz-namespace.patch
popd

# Configure Graphviz build
cmake -S "$SourceDir" -B "$BuildDir" `
    -DENABLE_SWIG=true `
    -DENABLE_SHARP=true

# Build Graphviz library
cmake --build "$BuildDir"

# Install built DLL and CSharp files into prefix
cmake --install "$BuildDir" --prefix "$PrefixDir"

# Copy generated CSharp code and glue library into project directory
Write-Output "Copying generated files into: $OutputDir"
md "$OutputDir" -ea 0 | Out-Null
copy "$PrefixDir\lib\graphviz\sharp\*.cs" "$OutputSrcDir"
copy "$PrefixDir\lib\graphviz\sharp\*.dll" "$OutputLibDir"
