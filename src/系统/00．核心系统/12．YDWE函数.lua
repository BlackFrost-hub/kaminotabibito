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
    local script = (((("(require'jass.slk')." .. typeNames[objectType + 1]) .. "['") .. tostring(objectId)) .. "'].") .. property
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
return ____exports
