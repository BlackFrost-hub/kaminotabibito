local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____06_FF0E_673A_5236_6E05_7406 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.index")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____06_FF0E_673A_5236_6E05_7406["创建机制清理篮子"]
local ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.15．单位技能壳提示")
local _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A = ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A["设置单位技能壳普通提示"]
local ____01_FF0E_573A_5730_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.01．场地配置")
local _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E = ____01_FF0E_573A_5730_914D_7F6E["菲尼克斯尔场地配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.06．双重凤凰菲尼克斯尔.00．配置")
local _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲尼克斯尔单位技能配置"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local GetHandleId = jass.GetHandleId
local _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_8868 = {}
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["获取菲尼克斯尔上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    local ____temp_1
    if id == 0 then
        ____temp_1 = nil
    else
        ____temp_1 = _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_8868[id]
    end
    return ____temp_1
end
____exports["获取或创建菲尼克斯尔上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return nil
    end
    local context = _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_8868[id]
    if context ~= nil then
        return context
    end
    context = {
        Boss = boss,
        ["当前形态"] = "第一形态",
        ["开战时间Ms"] = getServerTime(),
        ["清理"] = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50("菲尼克斯尔"),
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
    _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A(boss, _____83F2_5C3C_514B_65AF_5C14_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"])
    _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_8868[id] = context
    return context
end
____exports["创建菲尼克斯尔运行时上下文"] = function(boss)
    local context = ____exports["获取或创建菲尼克斯尔上下文"](boss)
    return context
end
____exports["清理菲尼克斯尔上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return
    end
    local context = _____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_8868[id]
    if context == nil then
        return
    end
    local ____self_2 = context["清理"]
    ____self_2["清理全部"](____self_2)
    __TS__Delete(_____83F2_5C3C_514B_65AF_5C14_4E0A_4E0B_6587_8868, id)
end
____exports["取菲尼克斯尔战场中心"] = function()
    return {x = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"].x, y = _____83F2_5C3C_514B_65AF_5C14_573A_5730_914D_7F6E["中心点"].y}
end
____exports["注册菲尼克斯尔运行时"] = function()
end
return ____exports
