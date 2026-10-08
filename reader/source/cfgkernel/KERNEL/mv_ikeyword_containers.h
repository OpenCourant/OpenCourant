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
#ifndef MV_IKEYWORD_CONTAINERS_H
#define MV_IKEYWORD_CONTAINERS_H


#include <UTILS/mv_stl_various.h>
#include <UTILS/mv_string.h>



/// Set of integer keywords
typedef set<int> MvIKeywordSet_t;

/// Set of string keywords
typedef set<string> MvSKeywordSet_t;    

/// List of integer keywords
typedef vector<int> MvIKeywordList_t;	


typedef map< int, int >   MvIntIdentifierMap_t;

typedef vector< vector<MvIKeywordList_t> > MvAtypeVtypeList_t;

#endif //MV_IKEYWORD_CONTAINERS_H




