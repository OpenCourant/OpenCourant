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
! SPDX-License-Identifier: AGPL-3.0-or-later
! C ABI for independent Python verification; not part of the user library.
subroutine defaults(c) bind(C,name='defaults')
  use rht_material_mod
  use iso_c_binding, only: c_double
  implicit none
  real(c_double), intent(out) :: c(nparam)
  call rht_defaults(c)
end subroutine

subroutine validate(c,status) bind(C,name='validate')
  use rht_material_mod
  use iso_c_binding, only: c_double, c_int
  implicit none
  real(c_double), intent(in) :: c(nparam)
  integer(c_int), intent(out) :: status
  call rht_validate(c,status)
end subroutine

subroutine eos(c,rho,e,oldalpha,p,alpha,bulk,status) bind(C,name='eos')
  use rht_material_mod
  use iso_c_binding, only: c_double, c_int
  implicit none
  real(c_double), intent(in) :: c(nparam),rho,e,oldalpha
  real(c_double), intent(out) :: p,alpha,bulk
  integer(c_int), intent(out) :: status
  call rht_eos(c,rho,e,oldalpha,p,alpha,bulk,status)
end subroutine

subroutine surfaces(c,p,s,alpha,ep,rate,oldep,d0,f0,out) bind(C,name='surfaces')
  use rht_material_mod
  use iso_c_binding, only: c_double
  implicit none
  real(c_double), intent(in) :: c(nparam),p,s(6),alpha,ep,rate,oldep,d0,f0
  real(c_double), intent(out) :: out(6)
  call rht_surfaces(c,p,s,alpha,ep,rate,oldep,d0,f0,out(1),out(2),out(3),out(4),out(5),out(6))
end subroutine

subroutine failure(c,p,fr,s,y,pt,r3) bind(C,name='failure')
  use rht_material_mod
  use iso_c_binding, only: c_double
  implicit none
  real(c_double), intent(in) :: c(nparam),p,fr,s(6)
  real(c_double), intent(out) :: y,pt,r3
  call rht_failure(c,p,fr,y,pt)
  r3=rht_lode(c,p,s)
end subroutine

subroutine rates(c,rate,p,out) bind(C,name='rates')
  use rht_material_mod
  use iso_c_binding, only: c_double
  implicit none
  real(c_double), intent(in) :: c(nparam),rate,p
  real(c_double), intent(out) :: out(4)
  call rht_rates(c,rate,p,out(1),out(2),out(3),out(4))
end subroutine

subroutine update(c,dt,rho,e,de,sig,state,sound,status) bind(C,name='update')
  use rht_material_mod
  use iso_c_binding, only: c_double, c_int
  implicit none
  real(c_double), intent(in) :: c(nparam),dt,rho,e,de(6)
  real(c_double), intent(inout) :: sig(6),state(nstate)
  real(c_double), intent(out) :: sound
  integer(c_int), intent(out) :: status
  call rht_update(c,dt,rho,e,de,sig,state,sound,status)
end subroutine
