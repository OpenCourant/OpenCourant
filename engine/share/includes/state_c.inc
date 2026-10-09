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
C.../STATE/
      COMMON /STATE/    IS_STAT_SHELL, IS_STAT_BRICK, IS_STAT_SPRING, IS_STAT_BEAM, IS_STAT_TRUSS,
     .                  IS_STAT_INIMAP1D, IS_STAT_INIMAP2D, IS_STAT_DT, IS_STAT_STRF, IS_STAT_NODE,
     .                  IS_STAT_NO_DE, IS_STAT

      LOGICAL        :: IS_STAT_SHELL, IS_STAT_BRICK, IS_STAT_SPRING, IS_STAT_BEAM, IS_STAT_TRUSS,
     .                  IS_STAT_INIMAP1D, IS_STAT_INIMAP2D, IS_STAT_DT, IS_STAT_STRF, IS_STAT_NODE,
     .                  IS_STAT_NO_DE, IS_STAT

C.../DYNAIN/
      COMMON /DYNAIN/   IS_DYNAIN_SHELL, IS_DYNAIN, IS_DYNAIN_DT

      LOGICAL        :: IS_DYNAIN_SHELL,  IS_DYNAIN, IS_DYNAIN_DT
