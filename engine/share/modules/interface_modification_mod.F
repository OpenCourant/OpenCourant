Copyright>        OpenRadioss
Copyright>        Copyright (C) 2026 Siemens
Copyright>
Copyright>        This program is free software: you can redistribute it and/or modify
Copyright>        it under the terms of the GNU Affero General Public License as published by
Copyright>        the Free Software Foundation, either version 3 of the License, or
Copyright>        (at your option) any later version.
Copyright>
Copyright>        This program is distributed in the hope that it will be useful,
Copyright>        but WITHOUT ANY WARRANTY; without even the implied warranty of
Copyright>        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
Copyright>        GNU Affero General Public License for more details.
Copyright>
Copyright>        You should have received a copy of the GNU Affero General Public License
Copyright>        along with this program.  If not, see <https://www.gnu.org/licenses/>.
Copyright>
Copyright>
Copyright>        This file is part of OpenCourant, a fork of OpenRadioss.
Copyright>        See COPYRIGHT.md at the root of the repository for the full
Copyright>        copyright and attribution statement.
!||====================================================================
!||    interface_modification_mod   ../engine/share/modules/interface_modification_mod.F
!||--- called by ------------------------------------------------------
!||    intcrit                      ../engine/source/interfaces/intsort/intcrit.F
!||    mpp_init                     ../engine/source/mpi/interfaces/spmd_i7tool.F
!||    spmd_initfi                  ../engine/source/mpi/interfaces/spmd_i7tool.F
!||    spmd_savefi                  ../engine/source/mpi/interfaces/spmd_i7tool.F
!||--- uses       -----------------------------------------------------
!||    pointerdef                   ../engine/share/modules/pointerdef_mod.F
!||====================================================================
        MODULE INTERFACE_MODIFICATION_MOD
            USE POINTERDEF
            TYPE(int_pointer), DIMENSION(:), ALLOCATABLE :: NSNSI_SAV
        END MODULE INTERFACE_MODIFICATION_MOD
