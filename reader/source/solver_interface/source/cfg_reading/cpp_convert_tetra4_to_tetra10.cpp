//Copyright>        OpenRadioss
//Copyright>        Copyright (C) 2026 Siemens
//Copyright>
//Copyright>        This program is free software: you can redistribute it and/or modify
//Copyright>        it under the terms of the GNU Affero General Public License as published by
//Copyright>        the Free Software Foundation, either version 3 of the License, or
//Copyright>        (at your option) any later version.
//Copyright>
//Copyright>        This program is distributed in the hope that it will be useful,
//Copyright>        but WITHOUT ANY WARRANTY; without even the implied warranty of
//Copyright>        MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//Copyright>        GNU Affero General Public License for more details.
//Copyright>
//Copyright>        You should have received a copy of the GNU Affero General Public License
//Copyright>        along with this program.  If not, see <https://www.gnu.org/licenses/>.
//Copyright>
//Copyright>
//Copyright>        This file is part of OpenCourant, a fork of OpenRadioss.
//Copyright>        See COPYRIGHT.md at the root of the repository for the full
//Copyright>        copyright and attribution statement.

#include "GlobalModelSDI.h"

#include <stdio.h>
#include <string.h>
#include <dll_settings.h>

using namespace std;

extern "C" 
{

CDECL void cpp_convert_tetra4_to_tetra10_(int *Itetra4ToConsider)
{
    GlobalEntitySDIConvertTetra4ToTetra10(Itetra4ToConsider);
}

CDECL void CPP_CONVERT_TETRA4_TO_TETRA10(int *Itetra4ToConsider)
{cpp_convert_tetra4_to_tetra10_(Itetra4ToConsider);}

CDECL void cpp_convert_tetra4_to_tetra10__(int *Itetra4ToConsider)
{cpp_convert_tetra4_to_tetra10_(Itetra4ToConsider);}

CDECL void cpp_convert_tetra4_to_tetra10(int *Itetra4ToConsider)
{cpp_convert_tetra4_to_tetra10_(Itetra4ToConsider);}

}
