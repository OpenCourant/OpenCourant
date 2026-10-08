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
#include "my_real.inc"
c-----------------------------------------------------------------------
!||====================================================================
!||    domdec_load_mod   ../common_source/modules/loads/domdec_load_mod.F
!||--- called by ------------------------------------------------------
!||    loads_mod         ../common_source/modules/loads/loads_mod.F90
!||====================================================================
      MODULE DOMDEC_LOAD_MOD
c-----------------------------------------------------------------------
        TYPE DOMDEC_PROC_LOAD_
          INTEGER :: LOCAL_SEGMENT_NUMBER ! number of segment on the proc I
          INTEGER :: S_LOCAL_SEGMENT ! size of LOCAL_SEGMENT array
          INTEGER ,DIMENSION(:) ,ALLOCATABLE :: LOCAL_SEGMENT ! list of segments defined on the proc I
        END TYPE DOMDEC_PROC_LOAD_
        TYPE DOMDEC_LOAD_
          ! ---------
          INTEGER, DIMENSION(:), ALLOCATABLE :: SEGMENT_TO_PROC ! processor where the segment is defined
          TYPE(DOMDEC_PROC_LOAD_) ,DIMENSION(:) ,ALLOCATABLE :: PROC ! data structure to save the segment per proc
          ! ---------
        END TYPE DOMDEC_LOAD_
c-----------------------------------------------------------------------
      END MODULE DOMDEC_LOAD_MOD
