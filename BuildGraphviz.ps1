$ErrorActionPreference = "Stop"

$SourceDir = "$PSScriptRoot\graphviz"
$BuildDir = "$SourceDir\build"
$PrefixDir = "$SourceDir\install"
$OutputDir = "$PSScriptRoot\dist"
$OutputLibDir = "$OutputDir\lib"

# Set up Graphviz Windows build utilities
Set-ExecutionPolicy Bypass -Force -Scope Process
. $SourceDir\windows\bin\setup-build-utilities.ps1

pushd "$SourceDir"
# Apply patches
git apply ( Get-Item ..\*.patch )
popd

# Configure Graphviz build
# Options copied from https://gitlab.com/graphviz/graphviz/-/blob/5b4763bc71b78037a1628c5280104e66c8bf007a/ci/windows_build.py
cmake -S "$SourceDir" -B "$BuildDir" `
    -DENABLE_SWIG=true `
    -DENABLE_SHARP=true `
    -DENABLE_LTDL=ON `
    -DWITH_EXPAT=ON `
    -DWITH_GVEDIT=OFF `
    -DWITH_ZLIB=ON 


# Build Graphviz library
cmake --build "$BuildDir" --config Release

# Install built DLL and CSharp files into prefix
cmake --install "$BuildDir" --prefix "$PrefixDir"

# Copy generated CSharp code and glue library into project directory
Write-Output "Copying generated files into: $OutputDir"
md "$OutputLibDir" -ea 0 | Out-Null
copy -Path "$PrefixDir\lib\graphviz\sharp\*.dll" -Destination "$OutputLibDir"
