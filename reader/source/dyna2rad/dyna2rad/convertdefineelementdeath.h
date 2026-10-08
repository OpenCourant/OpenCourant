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

#ifndef SDID2R_CONVERTDEFINEELEMENTDEATH_H
#define SDID2R_CONVERTDEFINEELEMENTDEATH_H

#include <dyna2rad/convertentities.h>
#include <dyna2rad/convertutils.h>
#include <typedef.h>

namespace sdiD2R
{
    class ConvertDefineElementDeath : private ConvertEntity
    {
    public:
        ConvertDefineElementDeath(sdi::ModelViewRead* lsdynaModel, sdi::ModelViewEdit* radiossModel) :
            ConvertEntity(
                "*DEFINE_ELEMENT_DEATH",
                "/ACTIV",
                lsdynaModel->GetEntityType("*DEFINE_ELEMENT_DEATH"),
                radiossModel->GetEntityType("/ACTIV"),
                lsdynaModel,
                radiossModel
            ),
            p_ConvertUtils(lsdynaModel, radiossModel)
        {
        }
        void ConvertSelectedDefineElementDeath();

        ~ConvertDefineElementDeath() {}

    private:

        ConvertUtils p_ConvertUtils;

        void ConvertEntities() override;

        void ConvertElementDeathSolid();

        // void ConvertElementDeathSolid();
    };
}

#endif // !SDID2R_CONVERTDEFINEELEMENTDEATH_H
