# OpenCourant

## What is OpenCourant?

**OpenCourant** is an open-source explicit finite element solver for simulating crashes, impacts, explosions, and other highly nonlinear dynamic events. It is the community continuation of OpenRadioss, carrying forward a code base with decades of engineering behind it — licensed under the GNU AGPL v3 and developed, tested, and released entirely in the open.

The solver covers established crash and safety workflows: a large library of material laws, element formulations and contact interfaces, multiphysics capabilities such as ALE and SPH, and single- and double-precision builds for SMP and MPI execution on Linux (x86-64 and arm64) and Windows. Every release is gated on a regression suite and ships as ready-to-run packages, SIF images, and multi-arch containers.

For more information on the OpenCourant project, please visit [opencourant.org](https://opencourant.org)

If you have any questions about OpenCourant, please feel free to contact <hello@opencourant.org>.

## How to Use OpenCourant

* [Quick Start guide](doc/Getting_started.md)
* [How to Build OpenCourant](HOWTO.md)
* [How to Run OpenCourant](INSTALL.md)
* [OpenCourant Stable Releases](RELEASES.md)

## Community and Ways to Participate

`git` and `git-lfs` are needed to clone the OpenCourant repository.

* [How to contribute](CONTRIBUTING.md)
* [How to access the stable version of the code](Stable_code.md)
* [Code of conduct](CODE_OF_CONDUCT.md)

Contact
<hello@opencourant.org>  

## OpenCourant GUI

Launch OpenCourant using the [openradioss_gui](doc/openradioss_gui.md) tool

## Input Deck Support

* .rad file native Radioss format, read in Starter
* .k, .key LS-Dyna format. Native support in Starter.
* .inp : Abaqus and other solver. Converter with [.inp format to Radioss (.rad) format converter](https://github.com/OpenCourant/Tools/tree/main/input_converters/inp2rad)

## Post Processing tools

Tools are available to convert Radioss formats to VTK, CSV or d3plot

* [Animation files to VTK](https://github.com/OpenCourant/Tools/tree/main/output_converters/anim_to_vtk)
* [Time History file](https://github.com/OpenCourant/Tools/tree/main/output_converters/th_to_csv)
* Animation to d3plot converter can be found on [Vortex-CAE GitHub repository](https://github.com/Vortex-CAE/Vortex-Radioss)

## Resources

Online Help Documentation:

* [Radioss online help](https://help.altair.com/hwsolvers/rad/index.htm)

Help Documentation in pdf form:

* [reference guide](https://2022.help.altair.com/2022/simulation/pdfs/radopen/AltairRadioss_2022_ReferenceGuide.pdf)  
* [user guide](https://2022.help.altair.com/2022/simulation/pdfs/radopen/AltairRadioss_2022_UserGuide.pdf)  
* [theory manual](https://2022.help.altair.com/2022/simulation/pdfs/radopen/AltairRadioss_2022_TheoryManual.pdf)  

[![Current status](https://github.com/OpenCourant/OpenCourant/actions/workflows/prmerge_ci_main.yml/badge.svg)](https://github.com/OpenCourant/OpenCourant/actions/workflows/prmerge_ci_main.yml)

Help for contributors:

* [Developer documentation](doc/)
* [Community forum](https://github.com/orgs/OpenCourant/discussions)
