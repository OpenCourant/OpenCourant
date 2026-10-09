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
C NTHMAX defini dans scr05_c.inc
C.../TIMERR/
      INTEGER NTIMAX,LTIMERR
      PARAMETER(NTIMAX = 68)

C 68 timers et au plus NTHMAX taches smp
      COMMON /TIMERR/TIMER(4,NTIMAX,NTHMAX),CPUTIME(NTIMAX,NTHMAX),
     .               REALTIME(NTIMAX,NTHMAX),
     .               CLOCKINI(NTIMAX,NTHMAX),OMP_STARTING_TIME,
     .               OMP_INITIME(NTIMAX,NTHMAX)
      REAL TIMER,CPUTIME,REALTIME
      REAL(KIND=8) :: OMP_STARTING_TIME,OMP_INITIME
      INTEGER CLOCKINI
