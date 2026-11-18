# Copyright>        OpenCourant
# Copyright>        Copyright (C) 2026 OpenCourant contributors
# Copyright>
# Copyright>        This program is free software: you can redistribute it and/or modify
# Copyright>        it under the terms of the GNU Affero General Public License as published by
# Copyright>        the Free Software Foundation, either version 3 of the License, or
# Copyright>        (at your option) any later version.
# Copyright>
# Copyright>        This program is distributed in the hope that it will be useful,
# Copyright>        but WITHOUT ANY WARRANTY; without even the implied warranty of
# Copyright>        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# Copyright>        GNU Affero General Public License for more details.
# Copyright>
# Copyright>        You should have received a copy of the GNU Affero General Public License
# Copyright>        along with this program.  If not, see <https://www.gnu.org/licenses/>.
# Copyright>
# Copyright>
# Copyright>        This file is part of OpenCourant, a fork of OpenRadioss.
# Copyright>        See COPYRIGHT.md at the root of the repository for the full
# Copyright>        copyright and attribution statement.

<#
.SYNOPSIS
    Windows counterpart of get_and_build_mumps.sh: fetch and verify MUMPS for the
    OpenCourant Engine, then (optionally) build Starter and Engine with the implicit
    direct solver and run a small implicit check.

.DESCRIPTION
    On Linux, get_and_build_mumps.sh builds reference LAPACK, ScaLAPACK and MUMPS as
    separate libraries for gfortran + OpenMPI.

    On Windows the Engine is built with Intel oneAPI (ifx + icx), Intel MPI and oneMKL
    (engine/CMake_Compilers/cmake_win64.txt). In that configuration engine/CMakeLists.txt
    compiles MUMPS from source together with the Engine as soon as it finds
    engine/extlib/MUMPS_5.5.1, and takes BLAS, LAPACK, ScaLAPACK and BLACS from oneMKL and
    MPI from Intel MPI. PORD (shipped inside MUMPS) is the ordering. So on Windows nothing
    has to be built in advance: this script puts a verified copy of the MUMPS source where
    the CMake looks for it, and can then drive the existing build_windows.bat scripts.

    Steps:
      1. download MUMPS_<Version>.tar.gz (the PETSc mirror used by get_mumps.sh, then the
         official MUMPS site), check its SHA-256, unpack it with the tar.exe built into
         Windows 10/11, and check the files the Engine build needs;
      2. with -Build: load Intel oneAPI (setvars.bat), check the tools, fetch extlib, and
         run engine\build_windows.bat -arch=win64 -mpi=impi -release (MUMPS needs the
         double-precision MPI Engine; double precision is the default); with -Starter
         also the Starter;
      3. with -Test: run qa-tests\implicit_mumps_check (a 40-brick bar in tension, one
         implicit linear step with the direct solver) on 2 MPI processes and compare the
         displacements with the exact answer.

    Works in Windows PowerShell 5.1 and PowerShell 7.

.PARAMETER Version
    MUMPS version. engine/CMakeLists.txt expects 5.5.1 (MUMPS_VERSION).
.PARAMETER Sha256
    Expected SHA-256 of the archive. Known for 5.5.1; required for any other version.
.PARAMETER Force
    Replace an existing engine\extlib\MUMPS_<Version> folder.
.PARAMETER Build
    Build the Engine (exec\engine_win64_impi.exe) after the source is in place.
.PARAMETER Starter
    With -Build: build the Starter (exec\starter_win64.exe) first.
.PARAMETER Test
    Run the implicit MUMPS check with the executables in exec\.
.PARAMETER Jobs
    Parallel compile jobs passed to build_windows.bat -nt (a number, or "all").
.PARAMETER SetvarsPath
    Path to Intel oneAPI setvars.bat (default: the standard install folder).

.EXAMPLE
    powershell -ExecutionPolicy Bypass -File engine\extlib\get_and_build_mumps.ps1
.EXAMPLE
    powershell -ExecutionPolicy Bypass -File engine\extlib\get_and_build_mumps.ps1 -Build -Starter -Test -Jobs 8
#>
[CmdletBinding()]
param(
    [string]$Version = "5.5.1",
    [string]$Sha256 = "",
    [switch]$Force,
    [switch]$Build,
    [switch]$Starter,
    [switch]$Test,
    [string]$Jobs = "all",
    [string]$SetvarsPath = "C:\Program Files (x86)\Intel\oneAPI\setvars.bat"
)

$ErrorActionPreference = "Stop"
$ProgressPreference = "SilentlyContinue"   # Windows PowerShell 5.1 downloads slowly with the bar

$KnownSha256 = @{
    "5.5.1" = "1abff294fa47ee4cfd50dfd5c595942b72ebfcedce08142a75a99ab35014fa15"
}
$ExtlibDir = $PSScriptRoot
$EngineDir = Split-Path -Parent $ExtlibDir
$RootDir = Split-Path -Parent $EngineDir

function Write-Step([string]$Text) { Write-Host ""; Write-Host "== $Text" -ForegroundColor Cyan }
function Stop-WithError([string]$Text) { Write-Host "ERROR: $Text" -ForegroundColor Red; exit 1 }

# ---------------------------------------------------------------- 1. MUMPS source
function Get-MumpsSource {
    $target = Join-Path $ExtlibDir "MUMPS_$Version"
    $needed = @("src\dfac_driver.F", "src\mumps_c.c", "include\dmumps_struc.h",
                "PORD\include\space.h", "PORD\lib\ddcreate.c", "LICENSE")
    $expected = $Sha256
    if (-not $expected) { $expected = $KnownSha256[$Version] }
    if (-not $expected) { Stop-WithError "no known SHA-256 for MUMPS ${Version}; pass -Sha256 <hash>." }
    if ($Version -ne "5.5.1") {
        Write-Host "WARNING: engine/CMakeLists.txt looks for MUMPS_5.5.1; MUMPS_$Version is unpacked but not used unless MUMPS_VERSION is changed there." -ForegroundColor Yellow
    }

    if (Test-Path $target) {
        if (-not $Force) {
            $missing = @($needed | Where-Object { -not (Test-Path (Join-Path $target $_)) })
            if ($missing.Count -eq 0) {
                Write-Host "MUMPS $Version already present in $target (use -Force to replace it)."
                return
            }
            Stop-WithError "$target exists but lacks: $($missing -join ', '). Re-run with -Force."
        }
        # With -Force the old folder is replaced only after the new copy is verified.
    }

    $archive = Join-Path $ExtlibDir "MUMPS_$Version.tar.gz"
    # The official MUMPS site first, then the PETSc mirror that get_mumps.sh uses. The mirror
    # answers 403 to browser-like User-Agents (PowerShell's included), so downloads go
    # through curl.exe (shipped with Windows 10 1803 and later) when it is available.
    $urls = @("https://mumps-solver.org/MUMPS_$Version.tar.gz",
              "https://ftp.mcs.anl.gov/pub/petsc/externalpackages/MUMPS_$Version.tar.gz")
    $curl = Get-Command curl.exe -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $curl) { $curl = Get-Command curl -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1 }
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    } catch { }
    $ok = $false
    foreach ($url in $urls) {
        Write-Host "Downloading $url"
        if (Test-Path $archive) { Remove-Item -Force $archive }
        if ($curl) {
            & $curl.Source -fsSL --retry 2 -o $archive $url
            if ($LASTEXITCODE -ne 0 -or -not (Test-Path $archive)) {
                Write-Host "  download failed (curl exit $LASTEXITCODE)" -ForegroundColor Yellow
                continue
            }
        } else {
            try {
                Invoke-WebRequest -Uri $url -OutFile $archive -UseBasicParsing
            } catch {
                Write-Host "  download failed: $($_.Exception.Message)" -ForegroundColor Yellow
                continue
            }
        }
        $actual = (Get-FileHash -Algorithm SHA256 -Path $archive).Hash.ToLower()
        if ($actual -eq $expected.ToLower()) { $ok = $true; Write-Host "  SHA-256 verified: $actual"; break }
        Write-Host "  SHA-256 mismatch: expected $expected, got $actual" -ForegroundColor Yellow
        Remove-Item -Force $archive
    }
    if (-not $ok) { Stop-WithError "could not download a verified MUMPS_$Version.tar.gz." }

    # Unpack into a scratch folder first, so an interrupted run never leaves a folder the
    # Engine CMake would take for a complete source tree.
    $tar = "tar"
    if ($env:SystemRoot -and (Test-Path (Join-Path $env:SystemRoot "System32\tar.exe"))) {
        $tar = Join-Path $env:SystemRoot "System32\tar.exe"
    }
    $scratch = Join-Path $ExtlibDir "_mumps_unpack"
    if (Test-Path $scratch) { Remove-Item -Recurse -Force $scratch }
    New-Item -ItemType Directory -Path $scratch | Out-Null
    & $tar -xzf $archive -C $scratch
    if ($LASTEXITCODE -ne 0) { Stop-WithError "tar could not unpack $archive." }
    $unpacked = Join-Path $scratch "MUMPS_$Version"
    $missing = @($needed | Where-Object { -not (Test-Path (Join-Path $unpacked $_)) })
    if ($missing.Count -gt 0) { Stop-WithError "unpacked tree lacks: $($missing -join ', ')." }
    if (Test-Path $target) { Remove-Item -Recurse -Force $target }
    Move-Item $unpacked $target
    Remove-Item -Recurse -Force $scratch
    Remove-Item -Force $archive
    Write-Host "MUMPS $Version source ready in $target"
}

# ---------------------------------------------------------------- 2. build
# Writes the commands to a temporary .cmd file that first loads Intel oneAPI, runs it, and
# returns its output lines (and, with -LogFile, also shows them and saves them). A .cmd
# file avoids every quoting difference between PowerShell versions and cmd.exe.
function Invoke-InOneApi([string[]]$Lines, [string]$LogFile, [switch]$Quiet) {
    $body = @("@echo off")
    if (-not $env:SETVARS_COMPLETED) {
        if (-not (Test-Path $SetvarsPath)) {
            Stop-WithError "Intel oneAPI setvars.bat not found at '$SetvarsPath'. Install the oneAPI Base + HPC toolkits or pass -SetvarsPath."
        }
        $body += "call `"$SetvarsPath`" intel64 >nul 2>&1"
    }
    foreach ($l in $Lines) { $body += $l; $body += "if errorlevel 1 exit /b 1" }
    $body += "exit /b 0"
    $tmp = Join-Path ([IO.Path]::GetTempPath()) ("oc_mumps_" + [Guid]::NewGuid().ToString("N") + ".cmd")
    Set-Content -Path $tmp -Value $body -Encoding Ascii
    $old = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        if ($LogFile) {
            & cmd.exe /d /c "`"$tmp`" 2>&1" | Tee-Object -FilePath $LogFile | Out-Host
        } elseif ($Quiet) {
            $script:OneApiOutput = @(& cmd.exe /d /c "`"$tmp`" 2>&1")
        } else {
            & cmd.exe /d /c "`"$tmp`" 2>&1" | Out-Host
        }
        $code = $LASTEXITCODE
    } finally {
        $ErrorActionPreference = $old
        Remove-Item -Force $tmp -ErrorAction SilentlyContinue
    }
    return $code
}

function Test-BuildTools {
    Write-Step "Checking the build tools (inside the oneAPI environment)"
    $probe = @("for %%t in (ifx icx cmake ninja python mpiexec) do (where %%t >nul 2>&1 && (echo FOUND %%t) || (echo MISSING %%t))",
               "if defined I_MPI_ROOT (echo FOUND I_MPI_ROOT) else (echo MISSING I_MPI_ROOT)",
               "if defined MKLROOT (echo FOUND MKLROOT) else (echo MISSING MKLROOT)")
    $null = Invoke-InOneApi $probe -Quiet
    $script:OneApiOutput | ForEach-Object { Write-Host "  $_" }
    $missing = @($script:OneApiOutput | Where-Object { "$_" -match '^MISSING ' } | ForEach-Object { ("$_" -split ' ')[1] })
    if ($missing.Count -gt 0) {
        Stop-WithError ("missing: " + ($missing -join ', ') + ". ifx: oneAPI HPC toolkit; icx, MKLROOT: " +
            "oneAPI Base toolkit; mpiexec, I_MPI_ROOT: Intel MPI (HPC toolkit); cmake, ninja: " +
            "'C++ CMake tools for Windows' in Visual Studio Build Tools; python: Python 3.")
    }
}

function Invoke-Build([string]$Folder, [string]$BatArgs, [string]$Exe) {
    $dir = Join-Path $RootDir $Folder
    $log = Join-Path $dir "build_mumps_windows.log"
    $exePath = Join-Path $RootDir "exec\$Exe"
    $before = $null
    if (Test-Path $exePath) { $before = (Get-Item $exePath).LastWriteTimeUtc }
    Write-Step "Building $Folder ($BatArgs); log: $log"
    $null = Invoke-InOneApi @("cd /d `"$dir`"", "call build_windows.bat $BatArgs") $log
    if (-not (Test-Path $exePath)) { Stop-WithError "$Exe was not produced; see $log." }
    if ($before -and ((Get-Item $exePath).LastWriteTimeUtc -le $before)) {
        Stop-WithError "$Exe was not rebuilt (it is older than this run); see $log."
    }
    if ($Folder -eq "engine" -and -not (Select-String -Path $log -Pattern "MUMPS is enabled" -Quiet)) {
        Stop-WithError "the Engine was built WITHOUT MUMPS (no 'MUMPS is enabled' in $log)."
    }
    Write-Host "Built $exePath"
}

# ---------------------------------------------------------------- 3. check run
function Invoke-Check {
    Write-Step "Implicit MUMPS check (qa-tests\implicit_mumps_check, 2 MPI processes)"
    $case = Join-Path $RootDir "qa-tests\implicit_mumps_check"
    $run = Join-Path $case "run_windows"
    $exec = Join-Path $RootDir "exec"
    foreach ($f in @("$exec\starter_win64.exe", "$exec\engine_win64_impi.exe", "$case\make_deck.py", "$case\check_result.py")) {
        if (-not (Test-Path $f)) { Stop-WithError "$f not found (build with -Build -Starter first)." }
    }
    if (Test-Path $run) { Remove-Item -Recurse -Force $run }
    New-Item -ItemType Directory -Path $run | Out-Null
    $env:OPENCOURANT_PATH = $RootDir
    $env:RAD_CFG_PATH = Join-Path $RootDir "hm_cfg_files"
    $env:RAD_H3D_PATH = Join-Path $RootDir "extlib\h3d\lib\win64"
    $env:KMP_STACKSIZE = "400m"
    $env:OMP_NUM_THREADS = "1"
    $env:PATH = (Join-Path $RootDir "extlib\hm_reader\win64") + ";" + $env:PATH
    $lines = @("cd /d `"$run`"",
               "python `"$case\make_deck.py`" .",
               "`"$exec\starter_win64.exe`" -i mumps_check_0000.rad -np 2",
               "mpiexec -localonly -np 2 `"$exec\engine_win64_impi.exe`" -i mumps_check_0001.rad",
               "python `"$case\check_result.py`" .")
    $code = Invoke-InOneApi $lines (Join-Path $case "check_windows.log")
    if ($code -ne 0) { Stop-WithError "the implicit check FAILED (exit $code); see $case\check_windows.log." }
    Write-Host "Implicit MUMPS check passed." -ForegroundColor Green
}

Write-Step "MUMPS $Version source for the OpenCourant Engine"
Get-MumpsSource
if ($Build) {
    Test-BuildTools
    # The CMake files also call load_extlib.py; running it here first gives a clear error
    # (network, SHA-256) before a long build starts.
    Write-Step "External libraries (Compiling_tools\script\load_extlib.py)"
    $code = Invoke-InOneApi @("cd /d `"$RootDir`"", "python Compiling_tools\script\load_extlib.py") $null
    if ($code -ne 0) { Stop-WithError "load_extlib.py failed (exit $code)." }
    # Double precision is build_windows.bat's default; -prec is not passed because the
    # Engine script keeps a trailing blank in the value it reads.
    if ($Starter) { Invoke-Build "starter" "-arch=win64 -release -nt=$Jobs" "starter_win64.exe" }
    Invoke-Build "engine" "-arch=win64 -mpi=impi -release -nt=$Jobs" "engine_win64_impi.exe"
}
if ($Test) { Invoke-Check }
Write-Host ""
Write-Host "Done."
