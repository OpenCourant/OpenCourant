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
!||    i7i10splitmod      ../starter/share/modules1/i710split_mod.F
!||--- called by ------------------------------------------------------
!||    i24setnodes        ../starter/source/interfaces/inter3d1/i24setnodes.F
!||    prepare_split_i7   ../starter/source/restart/ddsplit/inter_tools.F
!||    w_fi               ../starter/source/restart/ddsplit/w_fi.F
!||====================================================================
      MODULE I7I10SPLITMOD


      TYPE ptri7int
        INTEGER, DIMENSION(:), POINTER :: P
      END TYPE ptri7int

      TYPE(ptri7int), DIMENSION(:), ALLOCATABLE :: I710SAV
      TYPE(ptri7int), DIMENSION(:), ALLOCATABLE :: I24FRONT

!$OMP THREADPRIVATE(I710SAV)

      END
