#!/usr/bin/env bash
# Build the GNU double-precision SMP solver with the recovered Linux reader.
# This reader cannot generate /ALE/STRUCTURED_MESH; Starter rejects that keyword.
set -euo pipefail

root=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
jobs=${1:-$(getconf _NPROCESSORS_ONLN)}
if ! [[ "$jobs" =~ ^[1-9][0-9]*$ ]]; then
    printf 'Usage: bash build_linux.sh [positive number of build jobs]\n' >&2
    exit 1
fi

case "$(uname -m)" in
    x86_64) arch=linux64_gf ;;
    aarch64 | arm64) arch=linuxa64_gf ;;
    *)
        printf 'Unsupported machine architecture: %s\n' "$(uname -m)" >&2
        exit 1
        ;;
esac

python3 "$root/Compiling_tools/script/load_extlib.py"

cmake -S "$root/starter" -B "$root/starter/cbuild_$arch" \
    -Darch="$arch" -Dprecision=dp -Ddebug=0 \
    -DEXEC_NAME="starter_$arch" -DUSE_OPEN_READER=0 \
    -DHM_READER_LEGACY_INCLUDE_API=ON -DHM_READER_LEGACY_PART_API=ON \
    -DHM_READER_NO_STRUCTURED_ALE=ON
cmake --build "$root/starter/cbuild_$arch" --parallel "$jobs"

cmake -S "$root/engine" -B "$root/engine/cbuild_$arch" \
    -Darch="$arch" -Dprecision=dp -Ddebug=0 -DMPI=smp \
    -DEXEC_NAME="engine_$arch"
cmake --build "$root/engine/cbuild_$arch" --parallel "$jobs"

printf '\nExecutables are in %s/exec\n' "$root"
printf 'Reader limitation: /ALE/STRUCTURED_MESH is not supported by this Linux build.\n'
