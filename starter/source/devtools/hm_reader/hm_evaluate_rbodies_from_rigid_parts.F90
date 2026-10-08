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
!||====================================================================
!||    hm_evaluate_rbodies_from_rigid_parts_mod   ../starter/source/devtools/hm_reader/hm_evaluate_rbodies_from_rigid_parts.F90
!||--- called by ------------------------------------------------------
!||    starter0                                   ../starter/source/starter/starter0.F
!||====================================================================
      module hm_evaluate_rbodies_from_rigid_parts_mod
        implicit none
      contains
! ======================================================================================================================
!                                                   procedures
! ======================================================================================================================
!! \brief create /RBODY for RIGID parts (/PART with Irigid)
!! \details This routine create a /RBODY for each /PART with Irigid .
!||====================================================================
!||    hm_evaluate_rbodies_from_rigid_parts           ../starter/source/devtools/hm_reader/hm_evaluate_rbodies_from_rigid_parts.F90
!||--- called by ------------------------------------------------------
!||    starter0                                       ../starter/source/starter/starter0.F
!||--- calls      -----------------------------------------------------
!||====================================================================
        subroutine hm_evaluate_rbodies_from_rigid_parts(NPART,NBRBODIES_PER_PART)
! ----------------------------------------------------------------------------------------------------------------------
!                                                   Modules
! ----------------------------------------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------------------------------------
!                                                   Implicit none
! ----------------------------------------------------------------------------------------------------------------------
          implicit none
! ----------------------------------------------------------------------------------------------------------------------
!                                                   Arguments
! ----------------------------------------------------------------------------------------------------------------------
          integer, intent(in) :: NPART
          integer, dimension(NPART), intent(out) :: NBRBODIES_PER_PART
! ----------------------------------------------------------------------------------------------------------------------
! ----------------------------------------------------------------------------------------------------------------------
!                                                   Body
! ----------------------------------------------------------------------------------------------------------------------
#ifdef HM_READER_NO_RBODIES_FROM_RIGID_PARTS
          ! This compatibility reader lacks cpp_evaluate_rbodies_number_from_rigid_parts;
          ! /PART Irigid to /RBODY conversion is unavailable and counts are forced to zero.
          write(*,'(A)') ' WARNING: /PART Irigid RBODY conversion is not supported by this input reader'
          NBRBODIES_PER_PART(1:NPART) = 0
#else
          call cpp_evaluate_rbodies_number_from_rigid_parts(NBRBODIES_PER_PART)
#endif
! ----------------------------------------------------------------------------------------------------------------------
        end subroutine hm_evaluate_rbodies_from_rigid_parts
      end module hm_evaluate_rbodies_from_rigid_parts_mod