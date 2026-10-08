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
#include "mv_data_dynamic_matrix_feature.h"


/* --------- Constructors & destructor --------- */

MvDataDynamicMatrixFeature_t::MvDataDynamicMatrixFeature_t(const string &name,
							 int           nb_features,
							 int           size_ikw,
							 int           nb_dimensions) :
  MvDataArrayFeature_t(DFT_DYNAMIC_MATRIX,name,nb_features,size_ikw),
  myNbDimensions(nb_dimensions),
  myDimensionIKeywords(new int[nb_dimensions])
{}

MvDataDynamicMatrixFeature_t::~MvDataDynamicMatrixFeature_t() {
  delete [] myDimensionIKeywords;
}


/* --------- Output in an output stream --------- */

ostream &MvDataDynamicMatrixFeature_t::display(ostream &os,const MvDescriptor_t &descr,int level) const {
  int i;
  for(i=0;i<level;i++) os << "  ";
  display_props(os); 
  //
  os << "MATRIX(SIZE=" << descr.getSKeyword(getSizeIKeyword()) 
     << ",TITLE=\""    << getTitle() << "\""
     << ",DIMENSIONS=(";
  //
  int a_nb_dims=getNbDimensions();
  for(i=0;i<a_nb_dims;++i) {
    if(i>0) os << ",";
    os << descr.getSKeyword(getDimensionIKeyword(i));
  }
  os << ")) {"            << endl;
  for(i=0;i<getNumber();++i) {
    const MvDataFeature_t *a_df_p=getDataFeature(i);
    for(int j=0;j<level;j++) os << "  ";
    a_df_p->display(os,descr,level+1) << endl;
  }
  //
  for(i=0;i<level;i++) os << "  ";
  os << "}";
  return os; 
}
