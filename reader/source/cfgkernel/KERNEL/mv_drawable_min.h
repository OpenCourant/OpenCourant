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
#ifndef MV_DRAWABLE_MIN_H
#define MV_DRAWABLE_MIN_H

#include <UTILS/mv_stl_various.h>  

#include "mv_drawable_opt.h"


/// Minimum drawable class
class MvDrawableMin_t : public MvDrawableOpt_t {

public: /** @name Constructors and destructor */
  //@{
  /// Constructor
    inline MvDrawableMin_t(const string& name, MvDrawableAccess_e access, bool isAttributeArray, int arrayAttIkey) : MvDrawableOpt_t(name, access, isAttributeArray, arrayAttIkey) {}
  //@}
  
public: /** @name Accessors */
  //@{
  /// Gets the type
  virtual inline MvDrawableType_e getType() const{ return DRT_MIN; }
  //@}
  
protected:
  virtual inline bool compare(double value0,double value1) const { return value0<value1; }

};


#endif //MV_DRAWABLE_MIN_H




