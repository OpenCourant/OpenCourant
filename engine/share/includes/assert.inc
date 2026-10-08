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
#ifdef WITH_ASSERT
#define ASSERT(COND) IF(.NOT. (COND)) write(6,*) "Assertion " , #COND, " failed at ",__FILE__,":",__LINE__ 
#define PRINTIF(COND,VAL) IF(COND) write(6,*)  #COND, "at ",__FILE__,":",__LINE__,#VAL,VAL
#else
#define ASSERT(COND)
#define PRINTIF(COND,VAL)
#endif
#ifdef D_EM
#define DEBUG_E2E(COND,VAL) IF(COND) write(6,*) __FILE__,__LINE__,#VAL,VAL 
#else
#define DEBUG_E2E(COND,VAL)            
#endif
