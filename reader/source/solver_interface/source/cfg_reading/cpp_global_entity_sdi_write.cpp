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
#include <dll_settings.h>

using namespace std;

extern "C" 
{

CDECL void cpp_global_entity_sdi_write_(int *is_dyna)
{
    GlobalEntitySDIWrite(is_dyna);
}

CDECL void CPP_GLOBAL_ENTITY_SDI_WRITE(int *is_dyna)
{cpp_global_entity_sdi_write_ (is_dyna);}

CDECL void cpp_global_entity_sdi_write__(int *is_dyna)
{cpp_global_entity_sdi_write_ (is_dyna);}

CDECL void cpp_global_entity_sdi_write(int *is_dyna)
{cpp_global_entity_sdi_write_ (is_dyna);}


}
