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




////////////////////////////////////////////////////////////////////////////////////

#include <sdiEntity.h>
#include <_private/sdiModelViewPrivate.h>
#include <_private/sdiEntityData.h>


using namespace sdi;

sdiString sdi::EMPTYSTRING;


// *********************************************************************************
//   EntityRead
// *********************************************************************************

// The result of this function provides access to a permanent DB entity.
EntityRead::EntityRead(const ModelViewRead* pModelView,
                       const HandleRead&    handle)
    : EntityBaseRead()
{
    assert(handle.IsValid());                  //! assume that coming in with valid entity
    p_pData = static_cast<const SDIModelViewPrivate*>(pModelView)->Objectify(handle);
}


EntityRead::EntityRead(const EntityRead& other)
    : EntityBaseRead()
{
    p_pData = other.p_pData ? other.p_pData->Clone() : 0;
}


// = operator assigns clone of source as temporary entity in target
EntityRead& EntityRead::operator=(const EntityRead& other)
{
    if (other.p_pData == p_pData)
    {
        return *this;    //! copy onto itself does leaves things as they are
    }
    if (p_pData)
    {
        p_pData->Destroy();    //! remove its current data
    }
    p_pData = other.p_pData ? other.p_pData->Clone() : 0;
    return *this;
}


HandleRead EntityRead::GetHandle() const
{
    return p_pData ? p_pData->GetHandle() : HandleRead();
}


EntityType EntityRead::GetType() const
{
    return p_pData ? p_pData->GetType() : ENTITY_TYPE_NONE;
}


const sdiString& EntityRead::GetKeyword() const
{
    return p_pData ? p_pData->GetKeyword() : EMPTYSTRING;
}


EntityRead::~EntityRead()
{
    if (p_pData)
    {
        p_pData->Destroy();
    }
}




// *********************************************************************************
//   EntityEdit
// *********************************************************************************

// The result of this function provides access to a permanent DB entity.
EntityEdit::EntityEdit(const ModelViewEdit* pModelView,
                       const HandleEdit&    handle)
    : EntityBaseEdit(), EntityRead()
{
    //Added condition for includeFile id 0
    assert(handle.IsValid());                  //! assume that coming in with valid entity
    p_pData = static_cast<const SDIModelViewPrivate*>(pModelView)->Objectify(handle);
}



EntityEdit::EntityEdit(const EntityEdit& other)
    : EntityBaseEdit(), EntityRead()
{
    p_pData = other.p_pData ? other.p_pData->Clone() : 0;
}

EntityEdit::EntityEdit(EntityEdit&& other)
    : EntityBaseEdit(), EntityRead()
{
    p_pData = other.p_pData;
    other.p_pData = nullptr;
}


// = operator assigns clone of source as temporary entity in target
EntityEdit& EntityEdit::operator=(const EntityEdit& other)
{
    if (other.p_pData == p_pData)
    {
        return *this;    //! copy onto itself does leaves things as they are
    }
    if (p_pData)
    {
        p_pData->Destroy();    //! remove its current data
    }
    p_pData = other.p_pData ? other.p_pData->Clone() : 0;
    return *this;
}

// move assignment operator
EntityEdit& EntityEdit::operator=(EntityEdit&& other)
{
    if (other.p_pData == p_pData)
    {
        return *this;    //! copy onto itself does leaves things as they are
    }
    if (p_pData)
    {
        p_pData->Destroy();    //! remove its current data
    }
    p_pData = other.p_pData;
    other.p_pData = nullptr;
    return *this;
}


HandleEdit EntityEdit::GetHandle() const
{
    return p_pData ? p_pData->GetHandle() : HandleEdit();
}

