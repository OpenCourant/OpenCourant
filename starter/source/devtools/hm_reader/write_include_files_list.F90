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
!Copyright>        Commercial Alternative: Simcenter Radioss Software
!Copyright>
!Copyright>        As an alternative to this open-source version, Siemens also offers Simcenter(TM) Radioss(R)
!Copyright>        software under a commercial license.  Contact Siemens to discuss further if the
!Copyright>        commercial version may interest you: 
!Copyright>        https://www.siemens.com/en-us/products/simcenter/mechanical-simulation/radioss/.

module write_include_files_list_mod

! ----------------------------------------------------------------------------------------------------------------------
!                                                   MODULES
! ----------------------------------------------------------------------------------------------------------------------
  use NAMES_AND_TITLES_MOD, only : NCHARLINE
  use, intrinsic :: iso_c_binding, only : c_char, c_int, c_bool

! ----------------------------------------------------------------------------------------------------------------------
!                                                   IMPLICIT NONE
! ----------------------------------------------------------------------------------------------------------------------
  implicit none

  private
  public :: write_include_files_list

  interface
#ifdef HM_READER_LEGACY_INCLUDE_API
    subroutine cpp_option_count(entity_type, type_size, count) bind(C, name='cpp_option_count')
      import :: c_char, c_int
      character(kind=c_char), intent(in) :: entity_type(*)
      integer(c_int), intent(in) :: type_size
      integer(c_int), intent(out) :: count
    end subroutine cpp_option_count

    subroutine cpp_option_start(entity_type, type_size) bind(C, name='cpp_option_start')
      import :: c_char, c_int
      character(kind=c_char), intent(in) :: entity_type(*)
      integer(c_int), intent(in) :: type_size
    end subroutine cpp_option_start

    subroutine cpp_option_next() bind(C, name='cpp_option_next')
    end subroutine cpp_option_next

    subroutine cpp_get_string(attribute, attribute_size, value, value_size, available) &
      bind(C, name='cpp_get_string')
      import :: c_char, c_int, c_bool
      character(kind=c_char), intent(in) :: attribute(*)
      integer(c_int), intent(in) :: attribute_size, value_size
      character(kind=c_char), intent(out) :: value(*)
      logical(c_bool), intent(out) :: available
    end subroutine cpp_get_string
#else
    subroutine cpp_get_number_of_include_files(is_dyna, num_includes) &
      bind(C, name='cpp_get_number_of_include_files')
      import :: c_int
      integer(c_int), intent(in)  :: is_dyna
      integer(c_int), intent(out) :: num_includes
    end subroutine cpp_get_number_of_include_files

    subroutine cpp_get_include_file_by_index(is_dyna, include_index, file_name, bufsize) &
      bind(C, name='cpp_get_include_file_by_index')
      import :: c_char, c_int
      integer(c_int), intent(in)  :: is_dyna
      integer(c_int), intent(in)  :: include_index
      character(kind=c_char), intent(out) :: file_name(*)
      integer(c_int), intent(in)  :: bufsize
    end subroutine cpp_get_include_file_by_index
#endif
  end interface

contains

! ======================================================================================================================
!                                                   PROCEDURES
! ======================================================================================================================

!! \brief Writes the input deck and its included files to the starter output.
subroutine write_include_files_list(fname, cwd, is_dyna, iout)

! ----------------------------------------------------------------------------------------------------------------------
!                                                   ARGUMENTS
! ----------------------------------------------------------------------------------------------------------------------
  character(len=2048), intent(in) :: fname
  character(len=NCHARLINE), intent(in) :: cwd
  integer(c_int),      intent(in) :: is_dyna
  integer,             intent(in) :: iout

! ----------------------------------------------------------------------------------------------------------------------
!                                                   LOCAL VARIABLES
! ----------------------------------------------------------------------------------------------------------------------
  integer(c_int)             :: bufsize, include_index, num_includes
  character(kind=c_char)     :: c_file_name(2048)
  character(len=2048)        :: file_name
#ifdef HM_READER_LEGACY_INCLUDE_API
  logical(c_bool)            :: available
#endif

! ----------------------------------------------------------------------------------------------------------------------
!                                                   BODY
! ----------------------------------------------------------------------------------------------------------------------
  num_includes = 0
#ifdef HM_READER_LEGACY_INCLUDE_API
  ! The selection API is shared by earlier readers. It enumerates the loaded
  ! Radioss model, including the model produced by keyword conversion.
  call cpp_option_count('#include', 8_c_int, num_includes)
  call cpp_option_start('#include', 8_c_int)
#else
  call cpp_get_number_of_include_files(is_dyna, num_includes)
#endif

  write(iout,'(A)') '* INPUT DECK'
  write(iout,'(A)') '************************************************************************'
  write(iout,'(1X)')
  write(iout,'(1X,A)') ' MAIN DECK  : '
  write(iout,'(1X)')
  if (fname(1:1) == '/') then
    write(iout,'(6X,A)') trim(fname)
  else
    write(iout,'(6X,A)') trim(cwd)//'/'//trim(fname)
  end if
  if(num_includes > 0) THEN
    write(iout,'(1X)')
#ifdef HM_READER_LEGACY_INCLUDE_API
    if(is_dyna /= 0) then
      write(iout,'(1X,A,I0,A)') ' CONVERTED MODEL INCLUDE NAMES (', num_includes, ' include(s)):'
    else
      write(iout,'(1X,A,I0,A)') ' INCLUDE FILES IN THE READER MODEL (', num_includes, ' file(s)):'
    endif
#else
    write(iout,'(1X,A,I0,A)') ' INCLUDE FILES USED BY THE DECK (', num_includes, ' file(s)):'
#endif
    write(iout,'(1X)')
  end if
#ifdef HM_READER_LEGACY_INCLUDE_API
  if(is_dyna /= 0) then
    write(iout,'(1X,A)') ' Original keyword include paths are not available through this reader API.'
  endif
#endif

  bufsize = size(c_file_name, kind=c_int)
  do include_index = 1, num_includes
    c_file_name = ' '
#ifdef HM_READER_LEGACY_INCLUDE_API
    call cpp_option_next()
    call cpp_get_string('name', 4_c_int, c_file_name, bufsize, available)
#else
    call cpp_get_include_file_by_index(is_dyna, include_index, c_file_name, bufsize)
#endif
    file_name = transfer(c_file_name, file_name)
    if(len_trim(file_name) == len(file_name)) then
      write(iout,'(6X,A,A)') file_name, ' [path may be truncated]'
    else
      write(iout,'(6X,A)') trim(file_name)
    endif
  end do
  write(iout,'(1X)')

end subroutine write_include_files_list

end module write_include_files_list_mod
