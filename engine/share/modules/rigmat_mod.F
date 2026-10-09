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
!||    rigmat_mod   ../engine/share/modules/rigmat_mod.F
!||--- called by ------------------------------------------------------
!||    resol        ../engine/source/engine/resol.F
!||====================================================================
      MODULE RIGMAT_MOD
C-----------------------------------------------
C   m y _ r e a l
C-----------------------------------------------
#include      "my_real.inc"
C------------------------
C work array
C------------------------
         my_real
     .          , DIMENSION(:), ALLOCATABLE :: 
     .                              VRBYM, VRRBYM,ARBYM,ARRBYM
     .                                          
C
      END MODULE RIGMAT_MOD
