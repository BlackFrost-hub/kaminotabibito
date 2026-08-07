--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local CreateGroup = jass.CreateGroup
local DestroyGroup = jass.DestroyGroup
local GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange
local FirstOfGroup = jass.FirstOfGroup
local GroupRemoveUnit = jass.GroupRemoveUnit
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local function _____521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {["Boss单位"] = boss, ["清理"] = _____6E05_7406}
end
local _____5730_7CBE_796D_7940_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "地精祭祀", ["创建上下文"] = _____521B_5EFA_5730_7CBE_796D_7940_4E0A_4E0B_6587, ["死亡时自动清理"] = true})
____exports["获取或创建地精祭祀上下文"] = function(boss)
    return _____5730_7CBE_796D_7940_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["清理地精祭祀上下文"] = function(boss)
    _____5730_7CBE_796D_7940_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["地精祭祀单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
--- 与旧 JASS 相同：敌对、存活、非机械/远古，且飞行高度不超过指定值。
____exports["获取地精祭祀范围目标"] = function(boss, x, y, _____534A_5F84, _____6700_5927_98DE_884C_9AD8_5EA6)
    local _____7ED3_679C = {}
    if not ____exports["地精祭祀单位存活"](boss) then
        return _____7ED3_679C
    end
    local _____654C_5BF9_73A9_5BB6 = GetOwningPlayer(boss)
    local _____5355_4F4D_7EC4 = CreateGroup()
    GroupEnumUnitsInRange(
        _____5355_4F4D_7EC4,
        x,
        y,
        _____534A_5F84,
        nil
    )
    while true do
        local _____76EE_6807 = FirstOfGroup(_____5355_4F4D_7EC4)
        if _____76EE_6807 == nil or _____76EE_6807 == 0 then
            break
        end
        GroupRemoveUnit(_____5355_4F4D_7EC4, _____76EE_6807)
        if ____exports["地精祭祀单位存活"](_____76EE_6807) and IsUnitEnemy(_____76EE_6807, _____654C_5BF9_73A9_5BB6) == true and IsUnitType(_____76EE_6807, UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(_____76EE_6807, UNIT_TYPE_ANCIENT) ~= true and GetUnitFlyHeight(_____76EE_6807) <= _____6700_5927_98DE_884C_9AD8_5EA6 then
            _____7ED3_679C[#_____7ED3_679C + 1] = _____76EE_6807
        end
    end
    DestroyGroup(_____5355_4F4D_7EC4)
    return _____7ED3_679C
end
return ____exports
