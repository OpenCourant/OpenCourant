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

#ifndef MU_UNIT_CONVERTER_H
#define MU_UNIT_CONVERTER_H


#include <MUNITS/mu_dimension.h>
#include <MUNITS/mu_unit_map.h>



/**@name Class for converting units */
//@{

/// Unit converter
class MuUnitConverter_t {

public:
  MuUnitConverter_t(const MuUnitMap_t &input_units,const MuUnitMap_t &output_units);

public:
  double convert(MuDimension_e dimension,double value) const; 

private:
  typedef vector<MuUnit_t> MyUnitArray_t; 

private:
  MyUnitArray_t myInputUnits,myOutputUnits;

};

//@}


#endif //MU_UNIT_CONVERTER_H




