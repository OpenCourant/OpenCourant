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
#ifndef __STRUCTURE_CONTAINER_H_
#define __STRUCTURE_CONTAINER_H_
typedef enum flag_sort_s
{
  NOT_SORTED,
  SORT_ID,
  SORT_IDGLOB_SUBMODEL,
  SORT_IDLOC,
  SORT_PTR,
  SORT_SMP_P_SMP,
  SORT_NODE_SMP_P_SMP,
  SORT_SEG,
  SORT_DEL,
  SORT_TITLE,
  SORT_TITLE_POS,
  SORT_TITLE_HEADER,
  SORT_GGENE_ID,       
  SORT_GGENE,          
  SORT_SEG_LEX,        
  SORT_OPTIMA_TH,       
  SORT_CONNEC_BY_PART,  
  SORT_NB_HPATH,        
  SORT_NB_HPATH_NEG,        
  SORT_INCLUDE_FULL_PATH,        
  SORT_SUBTYPE,
  SORT_ATTRIB
} flag_sort_e ;

#endif /* __STRUCTURE_CONTAINER_H_ */



