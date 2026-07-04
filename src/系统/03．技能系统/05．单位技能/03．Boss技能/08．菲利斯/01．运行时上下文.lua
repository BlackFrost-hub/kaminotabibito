local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.15．单位运行时上下文工厂")
local _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382 = ____15_FF0E_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382["创建单位运行时上下文工厂"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.00．配置")
local _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲利斯单位技能配置"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local _____83F2_5229_65AF_5251_9B42_72FC_8868 = {}
local _____83F2_5229_65AF_6B7B_4EA1_6E05_7406_5DF2_6CE8_518C = false
local function _____521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587(boss, _____6E05_7406)
    return {
        ["Boss单位"] = boss,
        ["阶段"] = 1,
        ["开战时间Ms"] = getServerTime(),
        ["清理"] = _____6E05_7406,
        ["当前魔法充能"] = 0,
        ["当前领袖光环低血"] = false,
        ["异形化中"] = false,
        ["异形化结束Ms"] = 0,
        ["已初始化"] = false
    }
end
local _____83F2_5229_65AF_4E0A_4E0B_6587_5DE5_5382 = _____521B_5EFA_5355_4F4D_8FD0_884C_65F6_4E0A_4E0B_6587_5DE5_5382({["名称"] = "菲利斯", ["主动技能提示"] = _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E["主动技能提示"], ["创建上下文"] = _____521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587})
local function _____53D6_5355_4F4DID(unit)
    return _____83F2_5229_65AF_4E0A_4E0B_6587_5DE5_5382["取单位ID"](unit)
end
____exports["获取菲利斯上下文"] = function(boss)
    return _____83F2_5229_65AF_4E0A_4E0B_6587_5DE5_5382["获取"](boss)
end
____exports["获取或创建菲利斯上下文"] = function(boss)
    return _____83F2_5229_65AF_4E0A_4E0B_6587_5DE5_5382["获取或创建"](boss)
end
____exports["清理菲利斯上下文"] = function(boss)
    _____83F2_5229_65AF_4E0A_4E0B_6587_5DE5_5382["清理上下文"](boss)
end
____exports["获取全部菲利斯上下文"] = function()
    return _____83F2_5229_65AF_4E0A_4E0B_6587_5DE5_5382["获取全部"]()
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
    local ____temp_2
    if id == 0 then
        ____temp_2 = nil
    else
        ____temp_2 = _____83F2_5229_65AF_5251_9B42_72FC_8868[id]
    end
    return ____temp_2
end
local function ____on_83F2_5229_65AF_5355_4F4D_6B7B_4EA1(dyingUnit)
    local id = _____53D6_5355_4F4DID(dyingUnit)
    if id == 0 then
        return
    end
    if _____83F2_5229_65AF_4E0A_4E0B_6587_5DE5_5382["获取"](dyingUnit) ~= nil then
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
