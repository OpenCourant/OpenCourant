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
#include <stdarg.h>
#include <map>
#include <dll_settings.h>


extern "C" 
{

CDECL void cpp_set_intv_(char *attrib_key, int *s_attrib_key,int *value_int, bool *AVAILABLE)
{
// Char fortran -> c++
    char *cname;
    int cname_len;
    int i;
    cname_len = *s_attrib_key + 1;
    cname=(char*) malloc(sizeof(char)*cname_len);
    for(i=0;i<*s_attrib_key;i++)  cname[i] = attrib_key[i];
    cname[*s_attrib_key]='\0';
//
    *AVAILABLE = false;
// Set Value
    GlobalEntitySDISetValueInt(cname, value_int, AVAILABLE);
    free(cname);
}

CDECL void CPP_SET_INTV(char *attrib_key, int *s_attrib_key,int *value_int, bool *AVAILABLE)
{cpp_set_intv_ (attrib_key,s_attrib_key,value_int,AVAILABLE);}

CDECL void cpp_set_intv__(char *attrib_key, int *s_attrib_key,int *value_int, bool *AVAILABLE)
{cpp_set_intv_ (attrib_key,s_attrib_key,value_int,AVAILABLE);}

CDECL void cpp_set_intv(char *attrib_key, int *s_attrib_key,int *value_int, bool *AVAILABLE)
{cpp_set_intv_ (attrib_key,s_attrib_key,value_int,AVAILABLE);}


}
