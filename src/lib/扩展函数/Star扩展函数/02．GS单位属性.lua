--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass = require("jass.common")
local jglobals = require("jass.globals")
local ____require_result_0 = require("lib.扩展函数.BJ函数.02．单位与英雄")
local SetUnitLifePercentBJ = ____require_result_0.SetUnitLifePercentBJ
local SetUnitManaPercentBJ = ____require_result_0.SetUnitManaPercentBJ
local GetUnitLifePercent = ____require_result_0.GetUnitLifePercent
local GetUnitManaPercent = ____require_result_0.GetUnitManaPercent
local ModifyHeroStat = ____require_result_0.ModifyHeroStat
local HS = jass.InitHashtable()
local function hid(self, h)
    return jass.GetHandleId(h) or 0
end
local function loadReal(self, handle, parent, child)
    if not handle then
        return 0
    end
    return jass.LoadReal(handle, parent, child) or 0
end
local function saveReal(self, handle, parent, child, value)
    if not handle then
        return
    end
    jass.SaveReal(handle, parent, child, value)
end
function ____exports.GS_LoadUintProperty(self, u, i)
    if not u then
        return 0
    end
    if i == 0 then
        return jass.GetUnitState(u, jass.UNIT_STATE_LIFE) or 0
    end
    if i == 1 then
        return jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) or 0
    end
    if i == 2 then
        return jass.GetUnitState(
            u,
            jass.ConvertUnitState(18)
        ) or 0
    end
    if i == 3 then
        return jass.GetUnitState(
            u,
            jass.ConvertUnitState(32)
        ) or 0
    end
    if i == 4 then
        return jass.GetUnitState(
            u,
            jass.ConvertUnitState(81)
        ) or 0
    end
    if i == 5 then
        return jass.GetUnitMoveSpeed(u) or 0
    end
    return loadReal(
        nil,
        HS,
        hid(nil, u),
        i
    )
end
function ____exports.GS_LoadUintProperty_B(self, u, i)
    return ____exports.GS_LoadUintProperty(nil, u, i)
end
function ____exports.GS_Unit_Pry_change(self, u, i, r)
    if not u or r == 0 then
        return
    end
    local uid = hid(nil, u)
    local hp = 0
    if i == 0 then
        hp = GetUnitLifePercent(nil, u) or 0
        jass.SetUnitState(
            u,
            jass.UNIT_STATE_MAX_LIFE,
            jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) + r * (1 + loadReal(nil, HS, uid, 15))
        )
        SetUnitLifePercentBJ(nil, u, hp)
        return
    end
    if i == 1 then
        hp = GetUnitManaPercent(nil, u) or 0
        jass.SetUnitState(
            u,
            jass.UNIT_STATE_MAX_MANA,
            jass.GetUnitState(u, jass.UNIT_STATE_MAX_MANA) + r
        )
        SetUnitManaPercentBJ(nil, u, hp)
        return
    end
    if i == 2 then
        jass.SetUnitState(
            u,
            jass.ConvertUnitState(18),
            jass.GetUnitState(
                u,
                jass.ConvertUnitState(18)
            ) + r * (1 + loadReal(nil, HS, uid, 16))
        )
        return
    end
    if i == 3 then
        jass.SetUnitState(
            u,
            jass.ConvertUnitState(32),
            jass.GetUnitState(
                u,
                jass.ConvertUnitState(32)
            ) + r * (1 + loadReal(nil, HS, uid, 17))
        )
        return
    end
    if i == 4 then
        jass.SetUnitState(
            u,
            jass.ConvertUnitState(81),
            jass.GetUnitState(
                u,
                jass.ConvertUnitState(81)
            ) + r
        )
        return
    end
    if i == 5 then
        local ms = loadReal(nil, HS, uid, i) + r
        saveReal(
            nil,
            HS,
            uid,
            i,
            ms
        )
        jass.SetUnitMoveSpeed(
            u,
            jass.GetUnitDefaultMoveSpeed(u) * (1 + ms)
        )
        return
    end
    if i == 13 then
        hp = GetUnitLifePercent(nil, u) or 0
        jass.SetUnitState(
            u,
            jass.UNIT_STATE_MAX_LIFE,
            jass.GetUnitState(u, jass.UNIT_STATE_MAX_LIFE) / (1 + loadReal(nil, HS, uid, i)) * (1 + loadReal(nil, HS, uid, i) + r)
        )
        SetUnitLifePercentBJ(nil, u, hp)
        saveReal(
            nil,
            HS,
            uid,
            i,
            loadReal(nil, HS, uid, i) + r
        )
        return
    end
    if i == 14 then
        if r < 0 then
            jass.SetUnitState(
                u,
                jass.ConvertUnitState(18),
                jass.GetUnitState(
                    u,
                    jass.ConvertUnitState(18)
                ) / (1 + loadReal(nil, HS, uid, i)) * (1 + loadReal(nil, HS, uid, i) + r)
            )
        else
            jass.SetUnitState(
                u,
                jass.ConvertUnitState(18),
                jass.GetUnitState(
                    u,
                    jass.ConvertUnitState(18)
                ) / (1 + loadReal(nil, HS, uid, i)) * (1 + loadReal(nil, HS, uid, i) + r) + 1
            )
        end
        saveReal(
            nil,
            HS,
            uid,
            i,
            loadReal(nil, HS, uid, i) + r
        )
        return
    end
    if i == 15 then
        jass.SetUnitState(
            u,
            jass.ConvertUnitState(32),
            jass.GetUnitState(
                u,
                jass.ConvertUnitState(32)
            ) / (1 + loadReal(nil, HS, uid, i)) * (1 + loadReal(nil, HS, uid, i) + r)
        )
        saveReal(
            nil,
            HS,
            uid,
            i,
            loadReal(nil, HS, uid, i) + r
        )
        return
    end
    if i == 16 then
        ModifyHeroStat(
            nil,
            jglobals.bj_HEROSTAT_STR,
            u,
            jglobals.bj_MODIFYMETHOD_ADD,
            jass.R2I(r)
        )
        ____exports.GS_Unit_Pry_change(nil, u, 0, r * 5)
        return
    end
    if i == 17 then
        ModifyHeroStat(
            nil,
            jglobals.bj_HEROSTAT_AGI,
            u,
            jglobals.bj_MODIFYMETHOD_ADD,
            jass.R2I(r)
        )
        ____exports.GS_Unit_Pry_change(nil, u, 2, r * 0.3)
        ____exports.GS_Unit_Pry_change(nil, u, 3, r)
        return
    end
    if i == 18 then
        ModifyHeroStat(
            nil,
            jglobals.bj_HEROSTAT_INT,
            u,
            jglobals.bj_MODIFYMETHOD_ADD,
            jass.R2I(r)
        )
        ____exports.GS_Unit_Pry_change(nil, u, 5, r * 0.5)
        return
    end
    saveReal(
        nil,
        HS,
        uid,
        i,
        loadReal(nil, HS, uid, i) + r
    )
end
function ____exports.GS_UnitPry(self, u, change, ptytype, r)
    if change == 1 then
        r = 0 - r
    end
    ____exports.GS_Unit_Pry_change(nil, u, ptytype, r)
end
function ____exports.GS_UnitPryB(self, u, change, ptytype, r)
    ____exports.GS_UnitPry(
        nil,
        u,
        change,
        ptytype,
        r
    )
end
return ____exports
