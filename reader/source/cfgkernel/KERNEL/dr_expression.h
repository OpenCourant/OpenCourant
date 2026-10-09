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
#ifndef DR_EXPRESSION_H
#define DR_EXPRESSION_H


#include <UTILS/mv_iostream.h> 


#include <HCDI/hcdi_drawableinf.h>
/// Logical expression
class DrExpression_t {

public: /** @name Constructors and destructor */
  //@{
  /// Constructor
  inline DrExpression_t() {}
  /// Destructor
  virtual inline ~DrExpression_t() {}
  //@}

public: /** @name Logical evaluation */
  //@{
        /// Evaluation
    virtual double evaluate(const hwCFGDrawableInf* hwcfg_draw_inf) const = 0;
  //@}

public:
  virtual ostream &display(ostream &os) const=0;

};


inline ostream &operator<<(ostream &os,const DrExpression_t &expr) { return (&expr)->display(os); }


#endif //DR_EXPRESSION_H




