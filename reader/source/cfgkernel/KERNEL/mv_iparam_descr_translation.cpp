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

//

#include <UTILS/win32_utils.h>

#include "mv_descriptor.h"
#include "mv_iparam_descr_translation.h"


/* --------- Constructors and destructor --------- */

MvIParamDescrTranslation_t::MvIParamDescrTranslation_t(MvIParamAccess_e  access,
						       const string     &name,
						       const string     &comment) :
  MvIParamDescr_t(access,name,comment)
{}


/* --------- Output in an output stream  --------- */

ostream &MvIParamDescrTranslation_t::display(ostream &os,const MvDescriptor_t &,int level) const {
  for(int i=0;i<level;++i) os << "  ";
  os << "INPUT_TRANSLATION(" << getComment() << "\")";
  return os;
}
