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
C.../SCR19/
      INTEGER BGEOSIZE,MAXFUNC,MAXLAW,MAXTAB,MAXFAIL
      PARAMETER (BGEOSIZE = 1000)
      PARAMETER (MAXFUNC  = 100)
      PARAMETER (MAXTAB   = 100)
      PARAMETER (MAXLAW   = 1000)
      PARAMETER (MAXFAIL  = 100)
      INTEGER JFUNC, JTAB
      INTEGER NJFUNC, NJTAB
c
      my_real BUFGEO0
      COMMON /SCR19/ JFUNC(MAXFUNC), JTAB(MAXTAB), NJFUNC, NJTAB
      COMMON /SCR19R/ BUFGEO0(BGEOSIZE)
