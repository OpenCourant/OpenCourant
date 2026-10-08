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
#ifndef MV_MAP_H
#define MV_MAP_H


#if defined _WIN32 || defined WIN32 
#pragma once
#ifdef SHOW_PRAGMA
#pragma message("passage ds "__FILE__"\n")
#endif //SHOW_PRAGMA
#endif // defined _WIN32 ||defined WIN32


#if defined _WIN32 || defined WIN32 
#pragma warning(disable:4503)   
#pragma warning(disable:4786)   
#endif // defined _WIN32 || defined WIN32

#include <map>



#if defined _WIN32 || defined WIN32
using std::map;
using std::multimap;
#else  // defined _WIN32 || defined WIN32
#ifdef USE_NAMESPACE
using namespace std;
#endif // USE_NAMESPACE
#endif // defined _WIN32 || defined WIN32 

#endif // MV_MAP_H




