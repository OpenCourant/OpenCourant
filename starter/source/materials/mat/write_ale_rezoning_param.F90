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
! ==================================================================================================
!                                                   PROCEDURES
! ==================================================================================================
!! \brief write ale rezoning data structure in restart file
!! \details
!||====================================================================
!||    write_ale_rezoning_param_mod   ../starter/source/materials/mat/write_ale_rezoning_param.F90
!||--- called by ------------------------------------------------------
!||    write_matparam                 ../starter/source/materials/mat/write_matparam.F
!||====================================================================
      module write_ale_rezoning_param_mod
        implicit none
      contains

!||====================================================================
!||    write_ale_rezoning_param   ../starter/source/materials/mat/write_ale_rezoning_param.F90
!||--- called by ------------------------------------------------------
!||    write_matparam             ../starter/source/materials/mat/write_matparam.F
!||--- calls      -----------------------------------------------------
!||--- uses       -----------------------------------------------------
!||====================================================================
        subroutine write_ale_rezoning_param(rezon)
! --------------------------------------------------------------------------------------------------
!                                                   Modules
! --------------------------------------------------------------------------------------------------
          use ale_mod , only : ale_rezon_
          use MY_ALLOC_MOD, only : my_alloc
          use my_dealloc_mod, only : my_dealloc
! --------------------------------------------------------------------------------------------------
!                                                   Implicit none
! --------------------------------------------------------------------------------------------------
          implicit none
! --------------------------------------------------------------------------------------------------
!                                                   Included files
! --------------------------------------------------------------------------------------------------
! --------------------------------------------------------------------------------------------------
!                                                   Arguments
! --------------------------------------------------------------------------------------------------
          type(ale_rezon_) ,intent(in)    :: rezon
! --------------------------------------------------------------------------------------------------
!                                                   Local variables
! --------------------------------------------------------------------------------------------------
          integer :: iad,ifix
          integer ,dimension(:) ,allocatable :: ibuf
! --------------------------------------------------------------------------------------------------
!                                                   Body
! --------------------------------------------------------------------------------------------------
          ! write integer parameters
          ifix = 2
          call my_alloc(ibuf, ifix, "ibuf")
!
          iad = 1
          ibuf(iad) = rezon%num_nuvar_mat
          iad = iad+1
          ibuf(iad) = rezon%num_nuvar_eos
!
          call write_i_c(ibuf,ifix)
          call my_dealloc(ibuf)

!-----------
          return
        end subroutine write_ale_rezoning_param

      end module write_ale_rezoning_param_mod
