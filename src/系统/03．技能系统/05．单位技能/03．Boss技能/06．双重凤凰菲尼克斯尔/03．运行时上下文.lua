--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["菲尼克斯尔场地配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local function _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {
        Boss = boss,
        ["Boss单位"] = boss,
        ["当前形态"] = "第一形态",
        ["开战时间Ms"] = getServerTime(),
        ["清理"] = _____6E05_7406,
        ["已摧毁导管数"] = 0,
        ["导管列表"] = {},
        ["凤凰蛋列表"] = {},
        ["怨火核心"] = nil,
        ["永恒冰核"] = nil,
        ["怨火锚点"] = nil,
        ["P1机制已初始化"] = false,
        ["P2机制已初始化"] = false,
        ["元素爆发已初始化"] = false,
        ["怨火核心暴露已初始化"] = false,
        ["永恒轮回已触发"] = false,
        ["怨火核心暴露中"] = false,
        ["当前主导元素"] = "火"
    }
end
local _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "菲尼克斯尔", ["主动技能提示"] = _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587})
____exports["获取菲尼克斯尔上下文"] = function(boss)
    return _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建菲尼克斯尔上下文"] = function(boss)
    return _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["创建菲尼克斯尔运行时上下文"] = function(boss)
    local context = ____exports["获取或创建菲尼克斯尔上下文"](boss)
    return context
end
____exports["清理菲尼克斯尔上下文"] = function(boss)
    _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["取菲尼克斯尔战场中心"] = function()
    return {x = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"].x, y = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"].y}
end
____exports["注册菲尼克斯尔运行时"] = function()
end
return ____exports
