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
!||    tri11           ../engine/share/modules/tri11_mod.F
!||--- called by ------------------------------------------------------
!||    i11buce_vox     ../engine/source/interfaces/intsort/i11buce.F
!||    i11trivox       ../engine/source/interfaces/intsort/i11trivox.F
!||    i25trivox_edg   ../engine/source/interfaces/intsort/i25trivox_edg.F
!||====================================================================
      MODULE TRI11
#include "my_real.inc"

      INTEGER ::
     .        MIN_IX, MIN_IY, MIN_IZ,            !indice voxel min utilise
     .        MAX_IX, MAX_IY, MAX_IZ             !Voxel Max index uses

      INTEGER, POINTER, DIMENSION(:) :: LCHAIN_ELEM
      INTEGER, POINTER, DIMENSION(:) :: LCHAIN_NEXT
      INTEGER, POINTER, DIMENSION(:) :: LCHAIN_LAST 
      

      !INTEGER INIVOXEL11,VOXEL11(LVOXEL)
      !DATA INIVOXEL11 /1/   
                 
      END MODULE TRI11
