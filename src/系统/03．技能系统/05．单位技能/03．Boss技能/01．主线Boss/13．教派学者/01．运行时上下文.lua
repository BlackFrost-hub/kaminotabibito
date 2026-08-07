--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.13．教派学者.00．配置")
local _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["教派学者单位技能配置"]
local jass = require("jass.common")
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local function ____on_6E05_7406_6559_6D3E_5B66_8005_8FD0_884C_65F6_72B6_6001(variable)
    local _____4E0A_4E0B_6587 = variable
    if _____4E0A_4E0B_6587 == nil then
        return
    end
    _____4E0A_4E0B_6587["暗影弹幕ID表"] = {}
    _____4E0A_4E0B_6587["深渊之牢状态"] = nil
    _____4E0A_4E0B_6587["冥神魔门状态"] = nil
    _____4E0A_4E0B_6587["冥之念欲状态"] = nil
    _____4E0A_4E0B_6587["邪狱追魂状态"] = nil
end
local function _____521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587(boss, _____6E05_7406)
    local _____4E0A_4E0B_6587 = {
        ["Boss单位"] = boss,
        ["清理"] = _____6E05_7406,
        ["暗影弹幕ID表"] = {},
        ["深渊之牢状态"] = nil,
        ["冥神魔门状态"] = nil,
        ["冥之念欲状态"] = nil,
        ["邪狱追魂状态"] = nil,
        ["魔门反噬生效"] = false,
        ["魔门反噬原魔抗"] = 0,
        ["魔门反噬结束回调ID"] = 0
    }
    _____6E05_7406["登记清理"](_____6E05_7406, "教派学者运行时状态", ____on_6E05_7406_6559_6D3E_5B66_8005_8FD0_884C_65F6_72B6_6001, _____4E0A_4E0B_6587)
    return _____4E0A_4E0B_6587
end
local _____6559_6D3E_5B66_8005_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "教派学者", ["主动技能提示"] = _____6559_6D3E_5B66_8005_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_6559_6D3E_5B66_8005_4E0A_4E0B_6587, ["死亡时自动清理"] = true})
____exports["获取或创建教派学者上下文"] = function(boss)
    return _____6559_6D3E_5B66_8005_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["获取教派学者上下文"] = function(boss)
    return _____6559_6D3E_5B66_8005_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取全部教派学者上下文"] = function()
    return _____6559_6D3E_5B66_8005_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
end
____exports["清理教派学者上下文"] = function(boss)
    _____6559_6D3E_5B66_8005_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["教派学者单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
return ____exports
