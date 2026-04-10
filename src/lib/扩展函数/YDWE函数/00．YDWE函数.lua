local ____lualib = require("lualib_bundle")
local __TS__ParseInt = ____lualib.__TS__ParseInt
local __TS__ParseFloat = ____lualib.__TS__ParseFloat
local ____exports = {}
--- YDWE JAPI 单元操作函数封装
-- 
-- YDWE 插件原生函数（存在于 japi，不在 jass.common）：
-- - EXSetUnitFacing         : 设置单位面向角度
-- - EXPauseUnit            : 暂停/恢复单位
-- - EXSetUnitCollisionType : 设置单位碰撞类型
-- - EXSetUnitMoveType      : 设置单位移动类型
local japi = require("jass.japi")
local jass = require("jass.common")
local jglobals = require("jass.globals")
____exports.ABILITY_STATE_COOLDOWN = 1
____exports.ABILITY_DATA_TARGS = 100
____exports.ABILITY_DATA_CAST = 101
____exports.ABILITY_DATA_DUR = 102
____exports.ABILITY_DATA_HERODUR = 103
____exports.ABILITY_DATA_COST = 104
____exports.ABILITY_DATA_COOL = 105
____exports.ABILITY_DATA_AREA = 106
____exports.ABILITY_DATA_RNG = 107
____exports.ABILITY_DATA_DATA_A = 108
____exports.ABILITY_DATA_DATA_B = 109
____exports.ABILITY_DATA_DATA_C = 110
____exports.ABILITY_DATA_DATA_D = 111
____exports.ABILITY_DATA_DATA_E = 112
____exports.ABILITY_DATA_DATA_F = 113
____exports.ABILITY_DATA_DATA_G = 114
____exports.ABILITY_DATA_DATA_H = 115
____exports.ABILITY_DATA_DATA_I = 116
____exports.ABILITY_DATA_UNITID = 117
____exports.ABILITY_DATA_HOTKET = 200
____exports.ABILITY_DATA_UNHOTKET = 201
____exports.ABILITY_DATA_RESEARCH_HOTKEY = 202
____exports.ABILITY_DATA_NAME = 203
____exports.ABILITY_DATA_ART = 204
____exports.ABILITY_DATA_TARGET_ART = 205
____exports.ABILITY_DATA_CASTER_ART = 206
____exports.ABILITY_DATA_EFFECT_ART = 207
____exports.ABILITY_DATA_AREAEFFECT_ART = 208
____exports.ABILITY_DATA_MISSILE_ART = 209
____exports.ABILITY_DATA_SPECIAL_ART = 210
____exports.ABILITY_DATA_LIGHTNING_EFFECT = 211
____exports.ABILITY_DATA_BUFF_TIP = 212
____exports.ABILITY_DATA_BUFF_UBERTIP = 213
____exports.ABILITY_DATA_RESEARCH_TIP = 214
____exports.ABILITY_DATA_TIP = 215
____exports.ABILITY_DATA_UNTIP = 216
____exports.ABILITY_DATA_RESEARCH_UBERTIP = 217
____exports.ABILITY_DATA_UBERTIP = 218
____exports.ABILITY_DATA_UNUBERTIP = 219
____exports.ABILITY_DATA_UNART = 220
function ____exports.EXGetUnitAbility(self, u, abilcode)
    return japi.EXGetUnitAbility(u, abilcode)
end
function ____exports.EXGetUnitAbilityByIndex(self, u, index)
    return japi.EXGetUnitAbilityByIndex(u, index)
end
function ____exports.EXGetAbilityId(self, abil)
    return japi.EXGetAbilityId(abil)
end
function ____exports.EXGetAbilityState(self, abil, state_type)
    return japi.EXGetAbilityState(abil, state_type)
end
function ____exports.EXSetAbilityState(self, abil, state_type, value)
    return japi.EXSetAbilityState(abil, state_type, value)
end
function ____exports.EXGetAbilityDataReal(self, abil, level, data_type)
    return japi.EXGetAbilityDataReal(abil, level, data_type)
end
function ____exports.EXSetAbilityDataReal(self, abil, level, data_type, value)
    return japi.EXSetAbilityDataReal(abil, level, data_type, value)
end
function ____exports.EXGetAbilityDataInteger(self, abil, level, data_type)
    return japi.EXGetAbilityDataInteger(abil, level, data_type)
end
function ____exports.EXSetAbilityDataInteger(self, abil, level, data_type, value)
    return japi.EXSetAbilityDataInteger(abil, level, data_type, value)
end
function ____exports.EXGetAbilityDataString(self, abil, level, data_type)
    return japi.EXGetAbilityDataString(abil, level, data_type)
end
function ____exports.EXSetAbilityDataString(self, abil, level, data_type, value)
    return japi.EXSetAbilityDataString(abil, level, data_type, value)
end
function ____exports.YDWEGetUnitAbilityState(self, u, abilcode, state_type)
    return ____exports.EXGetAbilityState(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        state_type
    )
end
function ____exports.YDWEGetUnitAbilityDataInteger(self, u, abilcode, level, data_type)
    return ____exports.EXGetAbilityDataInteger(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        level,
        data_type
    )
end
function ____exports.YDWEGetUnitAbilityDataReal(self, u, abilcode, level, data_type)
    return ____exports.EXGetAbilityDataReal(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        level,
        data_type
    )
end
function ____exports.YDWEGetUnitAbilityDataString(self, u, abilcode, level, data_type)
    return ____exports.EXGetAbilityDataString(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        level,
        data_type
    )
end
function ____exports.YDWESetUnitAbilityState(self, u, abilcode, state_type, value)
    return ____exports.EXSetAbilityState(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        state_type,
        value
    )
end
function ____exports.YDWESetUnitAbilityDataInteger(self, u, abilcode, level, data_type, value)
    return ____exports.EXSetAbilityDataInteger(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        level,
        data_type,
        value
    )
end
function ____exports.YDWESetUnitAbilityDataReal(self, u, abilcode, level, data_type, value)
    return ____exports.EXSetAbilityDataReal(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        level,
        data_type,
        value
    )
end
function ____exports.YDWESetUnitAbilityDataString(self, u, abilcode, level, data_type, value)
    return ____exports.EXSetAbilityDataString(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        level,
        data_type,
        value
    )
end
function ____exports.EXSetAbilityAEmeDataA(self, abil, unitid)
    return japi.EXSetAbilityAEmeDataA(abil, unitid)
end
function ____exports.YDWEUnitTransform(self, u, abilcode, targetid)
    jass.UnitAddAbility(u, abilcode)
    ____exports.EXSetAbilityDataInteger(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        1,
        ____exports.ABILITY_DATA_UNITID,
        jass.GetUnitTypeId(u)
    )
    ____exports.EXSetAbilityAEmeDataA(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        jass.GetUnitTypeId(u)
    )
    jass.UnitRemoveAbility(u, abilcode)
    jass.UnitAddAbility(u, abilcode)
    ____exports.EXSetAbilityAEmeDataA(
        nil,
        ____exports.EXGetUnitAbility(nil, u, abilcode),
        targetid
    )
    jass.UnitRemoveAbility(u, abilcode)
end
function ____exports.EXGetItemDataString(self, itemcode, data_type)
    return japi.EXGetItemDataString(itemcode, data_type)
end
function ____exports.EXSetItemDataString(self, itemcode, data_type, value)
    return japi.EXSetItemDataString(itemcode, data_type, value)
end
function ____exports.YDWEGetItemDataString(self, itemcode, data_type)
    return ____exports.EXGetItemDataString(nil, itemcode, data_type)
end
function ____exports.YDWESetItemDataString(self, itemcode, data_type, value)
    return ____exports.EXSetItemDataString(nil, itemcode, data_type, value)
end
function ____exports.EXSetUnitFacing(self, u, angle)
    japi.EXSetUnitFacing(u, angle)
end
function ____exports.EXPauseUnit(self, u, flag)
    japi.EXPauseUnit(u, flag)
end
function ____exports.EXSetUnitCollisionType(self, enable, u, t)
    japi.EXSetUnitCollisionType(enable, u, t)
end
function ____exports.EXSetUnitMoveType(self, u, t)
    japi.EXSetUnitMoveType(u, t)
end
function ____exports.YDWEUnitAddStun(self, u)
    ____exports.EXPauseUnit(nil, u, true)
end
function ____exports.YDWEUnitRemoveStun(self, u)
    ____exports.EXPauseUnit(nil, u, false)
end
function ____exports.YDWEUnitAddStunBatch(self, units)
    for ____, u in ipairs(units) do
        ____exports.YDWEUnitAddStun(nil, u)
    end
end
function ____exports.YDWEUnitRemoveStunBatch(self, units)
    for ____, u in ipairs(units) do
        ____exports.YDWEUnitRemoveStun(nil, u)
    end
end
function ____exports.EXDisableUnitCollision(self, u, t)
    if t == nil then
        t = 0
    end
    ____exports.EXSetUnitCollisionType(nil, false, u, t)
end
function ____exports.EXEnableUnitCollision(self, u, t)
    if t == nil then
        t = 0
    end
    ____exports.EXSetUnitCollisionType(nil, true, u, t)
end
____exports.ObjectType = {
    ABILITY = 0,
    BUFF = 1,
    UNIT = 2,
    ITEM = 3,
    UPGRADE = 4,
    DOODAD = 5,
    DESTRUCTABLE = 6
}
local typeNames = {
    "ability",
    "buff",
    "unit",
    "item",
    "upgrade",
    "doodad",
    "destructable"
}
--- 读取物体编辑器数据（SLK）
-- 
-- @param objectType 物体类型（0-6），使用 ObjectType 常量
-- @param objectId 物体ID，传字符串四字码（如 'Hamg'）或 FourCC 整数
-- @param property 属性名（如 "Name", "Primary"）
function ____exports.getObjectProperty(self, objectType, objectId, property)
    local script = ((((("(function() local _t=(require'jass.slk')." .. typeNames[objectType + 1]) .. "; local _u=_t and _t['") .. tostring(objectId)) .. "']; if _u then return _u.") .. property) .. " else return '' end end)()"
    local result = japi.EXExecuteScript(script)
    return result or ""
end
function ____exports.getObjectPropertyInteger(self, objectType, objectId, property)
    local str = ____exports.getObjectProperty(nil, objectType, objectId, property)
    return __TS__ParseInt(str) or 0
end
function ____exports.getObjectPropertyReal(self, objectType, objectId, property)
    local str = ____exports.getObjectProperty(nil, objectType, objectId, property)
    return __TS__ParseFloat(str) or 0
end
function ____exports.getAbilityName(self, abilityId)
    return ____exports.getObjectProperty(nil, ____exports.ObjectType.ABILITY, abilityId, "Name")
end
function ____exports.getUnitName(self, unitId)
    return ____exports.getObjectProperty(nil, ____exports.ObjectType.UNIT, unitId, "Name")
end
function ____exports.getItemName(self, itemId)
    return ____exports.getObjectProperty(nil, ____exports.ObjectType.ITEM, itemId, "Name")
end
function ____exports.getAbilityData(self, abilityId, field, level)
    return ____exports.getObjectPropertyInteger(
        nil,
        ____exports.ObjectType.ABILITY,
        abilityId,
        ("Data" .. field) .. tostring(level)
    )
end
function ____exports.getAbilityDataA(self, abilityId, level)
    return ____exports.getAbilityData(nil, abilityId, "A", level)
end
function ____exports.EXExecuteScript(self, script)
    return japi.EXExecuteScript(script)
end
function ____exports.YDWEDistanceBetweenUnits(self, a, b)
    local dx = jass.GetUnitX(a) - jass.GetUnitX(b)
    local dy = jass.GetUnitY(a) - jass.GetUnitY(b)
    return jass.SquareRoot(dx * dx + dy * dy)
end
function ____exports.YDWEAngleBetweenUnits(self, fromUnit, toUnit)
    return jglobals.bj_RADTODEG * jass.Atan2(
        jass.GetUnitY(toUnit) - jass.GetUnitY(fromUnit),
        jass.GetUnitX(toUnit) - jass.GetUnitX(fromUnit)
    )
end
return ____exports
