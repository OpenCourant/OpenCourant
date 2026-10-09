!Copyright>        OpenRadioss
!Copyright>        Copyright (C) 2026 Siemens
!Copyright>
!Copyright>        This program is free software: you can redistribute it and/or modify
!Copyright>        it under the terms of the GNU Affero General Public License as published by
!Copyright>        the Free Software Foundation, either version 3 of the License, or
!Copyright>        (at your option) any later version.
!Copyright>
!Copyright>        This program is distributed in the hope that it will be useful,
!Copyright>        but WITHOUT ANY WARRANTY; without even the implied warranty of
!Copyright>        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!Copyright>        GNU Affero General Public License for more details.
!Copyright>
!Copyright>        You should have received a copy of the GNU Affero General Public License
!Copyright>        along with this program.  If not, see <https://www.gnu.org/licenses/>.
!Copyright>
!Copyright>
!Copyright>        This file is part of OpenCourant, a fork of OpenRadioss.
!Copyright>        See COPYRIGHT.md at the root of the repository for the full
!Copyright>        copyright and attribution statement.

!! \brief Write line in text outut file, file given by its descriptor.
!! \details This routine will be used in C file (C calls Fortran).
!||====================================================================
!||    write_out_file   ../common_source/output/write_out_file.F90
!||====================================================================
      subroutine write_out_file(fd,line,len1)
!----------------------------------------------
!   i m p l i c i t   t y p e s
!-----------------------------------------------
        implicit none
!-----------------------------------------------
!   d u m m y   a r g u m e n t s
!-----------------------------------------------
        integer, intent(in) :: fd  ! File descriptor
        integer :: len1               ! Length of line to write
        character(len=len1)  :: line  ! Line to write
!-----------------------------------------------
        write(fd,"(a)") line(1:len1)
      end subroutine write_out_file
