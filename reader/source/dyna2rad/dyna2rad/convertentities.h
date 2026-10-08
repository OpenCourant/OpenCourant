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

#ifndef SDID2R_CONVERTENTITIES_H
#define SDID2R_CONVERTENTITIES_H

#include <typedef.h>
#include <string>

namespace sdiD2R
{
    class ConvertEntity
    {
    protected:
        std::string srcCard;
        std::string destCard;
        unsigned int srcEntityType;
        unsigned int destEntityType;
        sdi::ModelViewRead* p_lsdynaModel;
        sdi::ModelViewEdit* p_radiossModel;

    public:
        ConvertEntity(std::string source, std::string dest, sdi::EntityType srcEntity, sdi::EntityType destEntity,
            sdi::ModelViewRead* lsdynaModel, sdi::ModelViewEdit* radiossModel) :
            srcCard(source),
            destCard(dest),
            srcEntityType(srcEntity),
            destEntityType(destEntity),
            p_lsdynaModel(lsdynaModel),
            p_radiossModel(radiossModel)
        {
        }
        virtual void ConvertEntities() = 0;

        virtual ~ConvertEntity() {}
    };
}

#endif // !SDID2R_CONVERTENTITIES_H


