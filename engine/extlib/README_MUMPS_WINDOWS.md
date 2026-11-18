# MUMPS (implicit direct solver) on Windows

`get_and_build_mumps.ps1` is the Windows counterpart of `get_and_build_mumps.sh`.

## Why it is simpler than the Linux script

On Linux, `get_and_build_mumps.sh` builds reference LAPACK, ScaLAPACK and MUMPS as
separate libraries for gfortran and OpenMPI.

On Windows the Engine is built with Intel oneAPI (ifx, icx), Intel MPI and oneMKL
(`CMake_Compilers/cmake_win64.txt`). With that toolchain `engine/CMakeLists.txt` compiles
MUMPS from source together with the Engine as soon as `engine/extlib/MUMPS_5.5.1` exists:

| Needed by MUMPS | Comes from |
|---|---|
| MUMPS 5.5.1 (double precision) and PORD ordering | source in `engine/extlib/MUMPS_5.5.1`, compiled with the Engine |
| BLAS, LAPACK, ScaLAPACK, BLACS | oneMKL (`mkl_scalapack_lp64`, `mkl_blacs_intelmpi_lp64`, ...) |
| MPI | Intel MPI (`impi.lib`) |
| METIS | not used (PORD is the ordering) |

So nothing needs to be built in advance. The script puts a verified copy of the MUMPS
source where the CMake looks for it, and can then drive the existing `build_windows.bat`
scripts and a small check run.

MUMPS requires the double-precision MPI Engine: `-mpi=impi -prec=dp`. An SMP build
(`-mpi=smp`) stops at configure time with "cannot use MUMPS without -mpi=impi".

## Prerequisites

Everything below is free, and none of it needs an account.

* Windows 10 (1803 or later) or Windows 11: `tar.exe` and `curl.exe` are built in.
* Intel oneAPI Base Toolkit (icx, oneMKL) and HPC Toolkit (ifx, Intel MPI), as in
  [HOWTO.md](../../HOWTO.md#build-environment-on-windows).
* Visual Studio 2022 or Build Tools for Visual Studio 2022, with the
  "Desktop development with C++" workload. The workload provides the MSVC linker and
  Windows SDK that ifx and icx need, plus the "C++ CMake tools for Windows" component
  (`cmake`, `ninja`).
* Python 3 on `PATH`. The build uses it to fetch `extlib`, and the check run uses it.

## Usage

Run these from the OpenCourant root in PowerShell. Use the `-ExecutionPolicy Bypass` form
because scripts from a clone are not signed.

```powershell
# 1. MUMPS source only (download, SHA-256 check, unpack into engine\extlib\MUMPS_5.5.1)
powershell -ExecutionPolicy Bypass -File engine\extlib\get_and_build_mumps.ps1

# 2. ... and build Starter + MPI Engine, then run the implicit check on 2 MPI processes
powershell -ExecutionPolicy Bypass -File engine\extlib\get_and_build_mumps.ps1 -Build -Starter -Test
```

Options:

| Option | Meaning |
|---|---|
| `-Build` | fetch `extlib` (`load_extlib.py`), then build `exec\engine_win64_impi.exe` (`build_windows.bat -arch=win64 -mpi=impi -release`; double precision is the default) |
| `-Starter` | with `-Build`: also build `exec\starter_win64.exe` |
| `-Test` | run `qa-tests\implicit_mumps_check` |
| `-Jobs N` | compile jobs (default `all`) |
| `-Force` | replace an existing `engine\extlib\MUMPS_5.5.1`. The old copy is kept if the new download fails its check. |
| `-SetvarsPath` | location of oneAPI `setvars.bat`, if it is not the default |
| `-Version`, `-Sha256` | another MUMPS version. `engine/CMakeLists.txt` uses 5.5.1. |

What the script checks:

* The archive's SHA-256 must match. 5.5.1:
  `1abff294fa47ee4cfd50dfd5c595942b72ebfcedce08142a75a99ab35014fa15`. The official site
  and the PETSc mirror serve the same file.
* The unpacked tree must contain the files the Engine build needs.
* Before building, `ifx`, `icx`, `cmake`, `ninja`, `python` and `mpiexec` must be found,
  and `I_MPI_ROOT` and `MKLROOT` must be set after `setvars.bat`.
* After building, the executable must be newer than the run's start, and the Engine
  configure log must say "MUMPS is enabled".
* With `-Test`, the check run's displacements must match the exact answer.

Downloads try the official site (`mumps-solver.org`) first, then the PETSc mirror used by
`get_mumps.sh`. The mirror answers 403 to browser-like clients, including PowerShell's
own downloader, so the script uses `curl.exe` whenever it is present.

## The check case: `qa-tests/implicit_mumps_check`

`make_deck.py` writes a steel bar, 100 x 10 x 10 mm, meshed with 40 fully integrated
bricks. The supports are symmetry planes, so the bar stretches freely, and a 1000 N pull
acts on its end (units Mg, mm, s). The Engine runs one implicit linear step with
`/IMPL/SOLVER/2`, the direct solver (MUMPS). `check_result.py` reads the ASCII
displacement output and compares it with the exact uniform-stress answer:

* end displacement u_x = F L / (E A) = 4.761905e-3 mm
* lateral contraction u_y = u_z = -1.428571e-4 mm at the outer faces

It also requires that the Engine output names MUMPS as the linear solver. The script exits
non-zero if any check fails.
