#!/usr/bin/env bash

if [[ -z "${CXX}" ]]; then
   if ! CXX="$(command -v g++ 2>/dev/null || command -v clang++ 2>/dev/null || command -v c++ 2>/dev/null)"; then
      echo "No C++ Compiler found" >&2
      echo "Please install g++/clang++ or export the name/path to your preferred compiler" >&2
      exit 1
   fi
fi

#
# create the exec directory if it does not exist
#
mkdir -p ../../../exec

"${CXX}" -DLINUX -o ../../../exec/anim_to_vtk_linux64_gf ../src/anim_to_vtk.cpp
