local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____06_FF0E_673A_5236_6E05_7406 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.06．机制清理.index")
local _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50 = ____06_FF0E_673A_5236_6E05_7406["创建机制清理篮子"]
local ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.15．单位技能壳提示")
local _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A = ____15_FF0E_5355_4F4D_6280_80FD_58F3_63D0_793A["设置单位技能壳普通提示"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.00．配置")
local _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲利斯单位技能配置"]
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local _____83F2_5229_65AF_4E0A_4E0B_6587_8868 = {}
local _____83F2_5229_65AF_5251_9B42_72FC_8868 = {}
local _____83F2_5229_65AF_6B7B_4EA1_6E05_7406_5DF2_6CE8_518C = false
local function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["获取菲利斯上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    local ____temp_2
    if id == 0 then
        ____temp_2 = nil
    else
        ____temp_2 = _____83F2_5229_65AF_4E0A_4E0B_6587_8868[id]
    end
    return ____temp_2
end
____exports["获取或创建菲利斯上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return nil
    end
    local context = _____83F2_5229_65AF_4E0A_4E0B_6587_8868[id]
    if context ~= nil then
        return context
    end
    context = {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["开战时间Ms"] = getServerTime(),
        ["清理"] = _____521B_5EFA_673A_5236_6E05_7406_7BEE_5B50("菲利斯"),
        ["当前魔法充能"] = 0,
        ["当前领袖光环低血"] = false,
        ["异形化中"] = false,
        ["异形化结束Ms"] = 0,
        ["已初始化"] = false
    }
    _____8BBE_7F6E_5355_4F4D_6280_80FD_58F3_666E_901A_63D0_793A(boss, _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"])
    _____83F2_5229_65AF_4E0A_4E0B_6587_8868[id] = context
    return context
end
____exports["清理菲利斯上下文"] = function(boss)
    local id = _____53D6_5355_4F4DID(boss)
    if id == 0 then
        return
    end
    local context = _____83F2_5229_65AF_4E0A_4E0B_6587_8868[id]
    if context == nil then
        return
    end
    local ____self_3 = context["清理"]
    ____self_3["清理全部"](____self_3)
    __TS__Delete(_____83F2_5229_65AF_4E0A_4E0B_6587_8868, id)
end
____exports["获取全部菲利斯上下文"] = function()
    local list = {}
    for key in pairs(_____83F2_5229_65AF_4E0A_4E0B_6587_8868) do
        local context = _____83F2_5229_65AF_4E0A_4E0B_6587_8868[key]
        if context ~= nil then
            list[#list + 1] = context
        end
    end
    return list
end
____exports["登记菲利斯剑魂狼"] = function(wolf, record)
    local id = _____53D6_5355_4F4DID(wolf)
    if id == 0 then
        return
    end
    _____83F2_5229_65AF_5251_9B42_72FC_8868[id] = record
end
____exports["注销菲利斯剑魂狼"] = function(wolf)
    local id = _____53D6_5355_4F4DID(wolf)
    if id ~= 0 then
        __TS__Delete(_____83F2_5229_65AF_5251_9B42_72FC_8868, id)
    end
end
____exports["获取菲利斯剑魂狼记录"] = function(wolf)
    local id = _____53D6_5355_4F4DID(wolf)
    local ____temp_4
    if id == 0 then
        ____temp_4 = nil
    else
        ____temp_4 = _____83F2_5229_65AF_5251_9B42_72FC_8868[id]
    end
    return ____temp_4
end
local function ____on_83F2_5229_65AF_5355_4F4D_6B7B_4EA1(dyingUnit)
    local id = _____53D6_5355_4F4DID(dyingUnit)
    if id == 0 then
        return
    end
    if _____83F2_5229_65AF_4E0A_4E0B_6587_8868[id] ~= nil then
        ____exports["清理菲利斯上下文"](dyingUnit)
    end
    if _____83F2_5229_65AF_5251_9B42_72FC_8868[id] ~= nil then
        __TS__Delete(_____83F2_5229_65AF_5251_9B42_72FC_8868, id)
    end
end
____exports["注册菲利斯运行时"] = function()
    if _____83F2_5229_65AF_6B7B_4EA1_6E05_7406_5DF2_6CE8_518C then
        return
    end
    _____83F2_5229_65AF_6B7B_4EA1_6E05_7406_5DF2_6CE8_518C = true
    registerDeathListener(____on_83F2_5229_65AF_5355_4F4D_6B7B_4EA1)
end
return ____exports
