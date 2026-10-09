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
!||    velvec      ../starter/source/output/anim/velvec.F
!||--- called by ------------------------------------------------------
!||    genani1     ../starter/source/output/anim/genani1.F
!||--- calls      -----------------------------------------------------
!||====================================================================
      SUBROUTINE VELVEC(V,NNWL,NNSRG)                                   
C-----------------------------s------------------                       
C   I m p l i c i t   T y p e s                                         
C-----------------------------------------------                        
#include      "implicit_f.inc"                                          
C-----------------------------------------------                        
C   C o m m o n   B l o c k s                                           
C-----------------------------------------------                        
#include      "com04_c.inc"                                             
C-----------------------------------------------                        
C   D u m m y   A r g u m e n t s                                       
C-----------------------------------------------                        
C     REAL                                                    
      my_real                                                           
     .   V(3,*)                                                         
C     REAL                                                    
      my_real                                                           
     .   S3000                                                        
      REAL R4                                                           
      INTEGER I, NNWL
      INTEGER NNSRG                                                     
C-----------------------------------------------                        
      S3000 = 3000.                                                     
C                                                                       
      DO I=1,NUMNOD                                                     
        R4 = V(1,I)                                                     
        CALL WRITE_R_C(R4,1)                                            
        R4 = V(2,I)                                                     
        CALL WRITE_R_C(R4,1)                                            
        R4 = V(3,I)                                                     
        CALL WRITE_R_C(R4,1)                                            
      ENDDO                                                             
C                                                                       
      R4 = 0.                                                           
      DO I=1,NSECT+NRWALL+NNWL+NNSRG                                    
       CALL WRITE_R_C(R4,1)                                             
       CALL WRITE_R_C(R4,1)                                             
       CALL WRITE_R_C(R4,1)                                             
      ENDDO                                                             
C                                                                       
      RETURN                                                            
      END                                                               
