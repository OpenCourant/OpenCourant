#!/usr/bin/env/bash

if [[ -z "${CC}" ]]; then
   if ! CC="$(command -v gcc 2>/dev/null || command -v clang 2>/dev/null || command -v cc 2>/dev/null)"; then
      echo "No C Compiler found" >&2
      echo "Please install gcc/clang or export the name/path to your preferred compiler" >&2
      exit 1
   fi
fi

#
# create the exec directory if it does not exist
#
mkdir -p ../../../exec

"${CC}" -DLINUX -o ../../../exec/th_to_csv_linuxa64_gf ../src/th_to_csv.c
