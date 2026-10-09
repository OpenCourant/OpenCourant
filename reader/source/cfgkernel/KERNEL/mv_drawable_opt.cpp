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
#include "mv_drawable_opt.h"


typedef  vector<const MvDrawable_t *> LocVectDraw_t; 

double MvDrawableOpt_t::evaluate(const hwCFGDrawableInf* hwcfg_draw_inf) const {
    double a_opt = 0.0;
    if (myIsDrawableAttributeArray)
        a_opt = evaluateArrayAttribute(hwcfg_draw_inf);
    else
        a_opt = evaluateSingleAttribute(hwcfg_draw_inf);
    return a_opt;
}

double MvDrawableOpt_t::evaluateArrayAttribute(const hwCFGDrawableInf* hwcfg_draw_inf) const
{
    double a_opt = 0.0;

    std::vector<double> a_val;
    if (myArrayAttributeIkeyword <= 0)
        return a_opt;
    hwcfg_draw_inf->GetFloatArrayAttribute(myArrayAttributeIkeyword, a_val);
    size_t a_nb_val = a_val.size();
    if (a_nb_val > 0)
        a_opt = a_val[0];
    for (int i = 1; i < a_nb_val; i++)
        if (compare(a_val[i], a_opt)) a_opt = a_val[i];
    return a_opt;
}

double MvDrawableOpt_t::evaluateSingleAttribute(const hwCFGDrawableInf* hwcfg_draw_inf) const
{
    bool   a_first = true;
    double a_opt = 0.;
    //
    
    LocVectDraw_t::const_iterator a_it_begin = myDrawablePtrArray.begin();
    LocVectDraw_t::const_iterator a_it_end = myDrawablePtrArray.end();
    LocVectDraw_t::const_iterator a_it;
    
    for (a_it = a_it_begin; a_it != a_it_end; ++a_it) {
        const MvDrawable_t* a_drawable_p = (*a_it);
        //
        if (a_first) {
            a_opt = a_drawable_p->evaluate(hwcfg_draw_inf);
            a_first = false;
        }
        else {
            double a_value = a_drawable_p->evaluate(hwcfg_draw_inf);
            if (compare(a_value, a_opt)) a_opt = a_value;
        }
    }
    //
    return a_opt;
}




