--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local function ____on_6E05_7406_6559_6D3E_5251_58EB_8FD0_884C_65F6_72B6_6001(variable)
    local _____4E0A_4E0B_6587 = variable
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    if _____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"] ~= 0 then
        removeDelayedCallback(_____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"])
    end
    _____4E0A_4E0B_6587["黑魔法侵蚀递归锁"] = false
    _____4E0A_4E0B_6587["黑洞强化普攻就绪"] = false
    _____4E0A_4E0B_6587["黑洞强化普攻清除回调ID"] = 0
    _____4E0A_4E0B_6587["旋风状态"] = nil
    _____4E0A_4E0B_6587["黑洞状态"] = nil
    _____4E0A_4E0B_6587["魔祭状态"] = nil
    _____4E0A_4E0B_6587["分身状态"] = nil
end
local function _____521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587(boss, _____6E05_7406)
    local _____4E0A_4E0B_6587 = {
        ["Boss单位"] = boss,
        ["清理"] = _____6E05_7406,
        ["黑魔法侵蚀递归锁"] = false,
        ["黑洞强化普攻就绪"] = false,
        ["黑洞强化普攻清除回调ID"] = 0,
        ["旋风状态"] = nil,
        ["黑洞状态"] = nil,
        ["魔祭状态"] = nil,
        ["分身状态"] = nil
    }
    _____6E05_7406["登记清理"](_____6E05_7406, "教派剑士运行时状态", ____on_6E05_7406_6559_6D3E_5251_58EB_8FD0_884C_65F6_72B6_6001, _____4E0A_4E0B_6587)
    return _____4E0A_4E0B_6587
end
local _____6559_6D3E_5251_58EB_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "教派剑士", ["创建上下文"] = _____521B_5EFA_6559_6D3E_5251_58EB_4E0A_4E0B_6587, ["死亡时自动清理"] = true})
____exports["获取或创建教派剑士上下文"] = function(boss)
    return _____6559_6D3E_5251_58EB_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取教派剑士上下文"] = function(boss)
    return _____6559_6D3E_5251_58EB_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取全部教派剑士上下文"] = function()
    return _____6559_6D3E_5251_58EB_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理教派剑士上下文"] = function(boss)
    _____6559_6D3E_5251_58EB_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["教派剑士单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
return ____exports
