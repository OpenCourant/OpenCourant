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
#ifndef MV_COMPARATOR_H
#define MV_COMPARATOR_H


#include <UTILS/mv_string.h> 
#include <KERNEL_BASE/Structure_expression.h>





// Comparator
//enum MvComparator_s {
//  /** Unknown */ CMPT_UNKNOWN,
//  /** >       */ CMPT_GT,
//  /** >=      */ CMPT_GE,
//  /** <       */ CMPT_LT,
//  /** <=      */ CMPT_LE,
//  /** ==      */ CMPT_EQ,
//  /** !=      */ CMPT_NE,
//  /** Last    */ CMPT_LAST
//};

// Comparator
//typedef enum MvComparator_s MvComparator_e;

/// Comparator
typedef comparator_e MvComparator_e;



/// Get comparator from string
MvComparator_e MV_get_comparator(const string &cmp);
/// Get string from comparator
const string &MV_get_comparator(MvComparator_e cmp);

#endif //MV_COMPARATOR_H




