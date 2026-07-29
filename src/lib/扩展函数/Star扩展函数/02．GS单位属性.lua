--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitLifePercentBJ = ____require_result_0.SetUnitLifePercentBJ
local SetUnitManaPercentBJ = ____require_result_0.SetUnitManaPercentBJ
local GetUnitLifePercent = ____require_result_0.GetUnitLifePercent
local GetUnitManaPercent = ____require_result_0.GetUnitManaPercent
local ModifyHeroStat = ____require_result_0.ModifyHeroStat
local HS = jass.InitHashtable()
local GetHandleId = jass.GetHandleId
local LoadReal = jass.LoadReal
local SaveReal = jass.SaveReal
local GetUnitState = jass.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local SetUnitState = japi.SetUnitState
local SetUnitMoveSpeed = jass.SetUnitMoveSpeed
local GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local R2I = jass.R2I
local function hid(h)
    return GetHandleId(h) or 0
end
local function loadReal(handle, parent, child)
    if not handle then
        return 0
    end
    return LoadReal(handle, parent, child) or 0
end
local function saveReal(handle, parent, child, value)
    if not handle then
        return
    end
    SaveReal(handle, parent, child, value)
end
function ____exports.GS_LoadUintProperty(u, i)
    if not u then
        return 0
    end
    if i == 0 then
        return GetUnitState(u, jass.UNIT_STATE_LIFE) or 0
    end
    if i == 1 then
        return GetUnitStateJapi(u, jass.UNIT_STATE_MAX_MANA) or 0
    end
    if i == 2 then
        return GetUnitStateJapi(
            u,
            ConvertUnitState(18)
        ) or 0
    end
    if i == 3 then
        return GetUnitStateJapi(
            u,
            ConvertUnitState(32)
        ) or 0
    end
    if i == 4 then
        return GetUnitStateJapi(
            u,
            ConvertUnitState(81)
        ) or 0
    end
    if i == 5 then
        return jass.GetUnitMoveSpeed(u) or 0
    end
    return loadReal(
        HS,
        hid(u),
        i
    )
end
function ____exports.GS_LoadUintProperty_B(u, i)
    return ____exports.GS_LoadUintProperty(u, i)
end
function ____exports.GS_Unit_Pry_change(u, i, r)
    if i == nil or i == false or i == "" then
        i = 0
    end
    if r == nil or r == false or r == "" then
        r = 0
    end
    if not u or r == 0 then
        return
    end
    local uid = hid(u)
    local hp = 0
    if i == 0 then
        hp = GetUnitLifePercent(nil, u) or 0
        SetUnitState(
            u,
            jass.UNIT_STATE_MAX_LIFE,
            GetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE) + r * (1 + loadReal(HS, uid, 15))
        )
        SetUnitLifePercentBJ(nil, u, hp)
        return
    end
    if i == 1 then
        hp = GetUnitManaPercent(nil, u) or 0
        SetUnitState(
            u,
            jass.UNIT_STATE_MAX_MANA,
            GetUnitStateJapi(u, jass.UNIT_STATE_MAX_MANA) + r
        )
        SetUnitManaPercentBJ(nil, u, hp)
        return
    end
    if i == 2 then
        SetUnitState(
            u,
            ConvertUnitState(18),
            GetUnitStateJapi(
                u,
                ConvertUnitState(18)
            ) + r * (1 + loadReal(HS, uid, 16))
        )
        return
    end
    if i == 3 then
        SetUnitState(
            u,
            ConvertUnitState(32),
            GetUnitStateJapi(
                u,
                ConvertUnitState(32)
            ) + r * (1 + loadReal(HS, uid, 17))
        )
        return
    end
    if i == 4 then
        SetUnitState(
            u,
            ConvertUnitState(81),
            GetUnitStateJapi(
                u,
                ConvertUnitState(81)
            ) + r
        )
        return
    end
    if i == 5 then
        local ms = loadReal(HS, uid, i) + r
        saveReal(HS, uid, i, ms)
        SetUnitMoveSpeed(
            u,
            GetUnitDefaultMoveSpeed(u) * (1 + ms)
        )
        return
    end
    if i == 13 then
        hp = GetUnitLifePercent(nil, u) or 0
        SetUnitState(
            u,
            jass.UNIT_STATE_MAX_LIFE,
            GetUnitStateJapi(u, jass.UNIT_STATE_MAX_LIFE) / (1 + loadReal(HS, uid, i)) * (1 + loadReal(HS, uid, i) + r)
        )
        SetUnitLifePercentBJ(nil, u, hp)
        saveReal(
            HS,
            uid,
            i,
            loadReal(HS, uid, i) + r
        )
        return
    end
    if i == 14 then
        if r < 0 then
            SetUnitState(
                u,
                ConvertUnitState(18),
                GetUnitStateJapi(
                    u,
                    ConvertUnitState(18)
                ) / (1 + loadReal(HS, uid, i)) * (1 + loadReal(HS, uid, i) + r)
            )
        else
            SetUnitState(
                u,
                ConvertUnitState(18),
                GetUnitStateJapi(
                    u,
                    ConvertUnitState(18)
                ) / (1 + loadReal(HS, uid, i)) * (1 + loadReal(HS, uid, i) + r) + 1
            )
        end
        saveReal(
            HS,
            uid,
            i,
            loadReal(HS, uid, i) + r
        )
        return
    end
    if i == 15 then
        SetUnitState(
            u,
            ConvertUnitState(32),
            GetUnitStateJapi(
                u,
                ConvertUnitState(32)
            ) / (1 + loadReal(HS, uid, i)) * (1 + loadReal(HS, uid, i) + r)
        )
        saveReal(
            HS,
            uid,
            i,
            loadReal(HS, uid, i) + r
        )
        return
    end
    if i == 16 then
        ModifyHeroStat(
            jglobals.bj_HEROSTAT_STR,
            u,
            jglobals.bj_MODIFYMETHOD_ADD,
            R2I(r)
        )
        ____exports.GS_Unit_Pry_change(u, 0, r * 5)
        return
    end
    if i == 17 then
        ModifyHeroStat(
            jglobals.bj_HEROSTAT_AGI,
            u,
            jglobals.bj_MODIFYMETHOD_ADD,
            R2I(r)
        )
        ____exports.GS_Unit_Pry_change(u, 2, r * 0.3)
        ____exports.GS_Unit_Pry_change(u, 3, r)
        return
    end
    if i == 18 then
        ModifyHeroStat(
            jglobals.bj_HEROSTAT_INT,
            u,
            jglobals.bj_MODIFYMETHOD_ADD,
            R2I(r)
        )
        ____exports.GS_Unit_Pry_change(u, 5, r * 0.5)
        return
    end
    saveReal(
        HS,
        uid,
        i,
        loadReal(HS, uid, i) + r
    )
end
function ____exports.GS_UnitPry(u, change, ptytype, r)
    if change == 1 then
        r = 0 - r
    end
    ____exports.GS_Unit_Pry_change(u, ptytype, r)
end
function ____exports.GS_UnitPryB(u, change, ptytype, r)
    ____exports.GS_UnitPry(u, change, ptytype, r)
end
return ____exports
