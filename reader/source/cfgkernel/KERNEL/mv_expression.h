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
#ifndef MV_EXPRESSION_H
#define MV_EXPRESSION_H


#include <UTILS/mv_iostream.h>


#include <HCDI/hcdi.h>
class MvDescriptor_t;


/// Logical expression
class HC_DATA_DLL_API MvExpression_t {


public: /** @name Constructors and destructors */
  //@{
  /// Constructor
  MvExpression_t(expression_t *expr_p,bool do_delete=true);
  /// Destructor
  virtual ~MvExpression_t();
  //@}


public: /** @name Logical evaluation */
  //@{

  //@}

public:
  inline void          setDelete(bool do_delete) { myDoDelete=do_delete; }
  inline expression_t *getExpressionPtr() const { return myExpressionPtr; }
  ostream             &display(ostream &os,const MvDescriptor_t &descr) const;

protected:
  
  bool          myDoDelete;
  expression_t *myExpressionPtr;
  

};

#endif //MV_EXPRESSION_H




