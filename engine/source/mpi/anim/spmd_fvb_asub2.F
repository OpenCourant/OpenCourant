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
!||    spmd_fvb_asub2   ../engine/source/mpi/anim/spmd_fvb_asub2.F
!||--- called by ------------------------------------------------------
!||    genani           ../engine/source/output/anim/generate/genani.F
!||--- calls      -----------------------------------------------------
!||--- uses       -----------------------------------------------------
!||    fvbag_mod        ../engine/share/modules/fvbag_mod.F
!||    spmd_mod         ../engine/source/mpi/spmd_mod.F90
!||====================================================================
      SUBROUTINE SPMD_FVB_ASUB2()
C-----------------------------------------------
C   M o d u l e s 
C-----------------------------------------------
      USE FVBAG_MOD
C-----------------------------------------------
C   I m p l i c i t   T y p e s
C-----------------------------------------------
        USE SPMD_MOD
#include      "implicit_f.inc"
C-----------------------------------------------
C   M e s s a g e   P a s s i n g
C-----------------------------------------------
#include "spmd.inc"
C-----------------------------------------------
C   C o m m o n   B l o c k s
C-----------------------------------------------
#include      "task_c.inc"
C-----------------------------------------------
C   L o c a l   V a r i a b l e s
C-----------------------------------------------
#ifdef MPI
      INTEGER I, PMAIN, ITAG, TAB(2), MSGOFF
C-----------------------------------------------
      DATA MSGOFF /7052/
C-----------------------------------------------
C
      DO I=1,NFVBAG
         PMAIN=FVSPMD(I)%PMAIN
         IF (ISPMD==0) THEN
            IF (ISPMD/=PMAIN-1) THEN
               ITAG=MSGOFF
               CALL SPMD_RECV(TAB(1:2), 2, IT_SPMD(PMAIN), ITAG)
C
               FVDATA(I)%ID=TAB(1)
               FVDATA(I)%NPOLH_ANIM=TAB(2)
            ENDIF
         ELSE
            IF (ISPMD==PMAIN-1) THEN
               TAB(1)=FVDATA(I)%ID
               TAB(2)=FVDATA(I)%NPOLH_ANIM
C
               ITAG=MSGOFF
               CALL SPMD_SEND(TAB(1:2), 2, IT_SPMD(1), ITAG)
            ENDIF
         ENDIF
      ENDDO  
C
#endif
      RETURN
      END
