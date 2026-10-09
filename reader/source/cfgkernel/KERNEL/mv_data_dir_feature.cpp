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
#include <UTILS/win32_utils.h>

#include "mv_descriptor.h"
#include "mv_data_dir_feature.h"


/* --------- Constructors & destructor --------- */

MvDataDirFeature_t::MvDataDirFeature_t(const string &name,int ikeyword) :
  MvDataSingleFeature_t(DFT_DIR,name,ikeyword)
{}

MvDataDirFeature_t::~MvDataDirFeature_t() {
}


/* --------- Output in an output stream --------- */

ostream &MvDataDirFeature_t::display(ostream &os,const MvDescriptor_t &descr,int level) const {
  for(int i=0;i<level;i++) os << "  ";
  display_props(os);
  //
  os << "DIR(TITLE=\"" << getTitle() << "\""
     << ",KEYWORD="     << descr.getSKeyword(getIKeyword()) 
     << ")";
  return os;
}




