--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local function _____521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {["Boss单位"] = boss, ["清理"] = _____6E05_7406, ["正义审判递归锁"] = false, ["检查状态"] = nil}
end
local _____5229_5C14_4F2F_7279_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "利尔·伯特", ["创建上下文"] = _____521B_5EFA_5229_5C14_4F2F_7279_4E0A_4E0B_6587, ["死亡时自动清理"] = true})
____exports["获取或创建利尔伯特上下文"] = function(boss)
    return _____5229_5C14_4F2F_7279_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取利尔伯特上下文"] = function(boss)
    return _____5229_5C14_4F2F_7279_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取全部利尔伯特上下文"] = function()
    return _____5229_5C14_4F2F_7279_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理利尔伯特上下文"] = function(boss)
    _____5229_5C14_4F2F_7279_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["利尔伯特单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
return ____exports
