--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.00．配置")
local _____585E_62C9_65AF_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["塞拉斯技能配置"]
local ____01_FF0E_72B6_6001_8868 = require("系统.03．技能系统.05．单位技能.04．英雄技能.16．塞拉斯.01．状态表")
local _____83B7_53D6_6216_521B_5EFA_585E_62C9_65AF_9B54_6CD5_72B6_6001 = ____01_FF0E_72B6_6001_8868["获取或创建塞拉斯魔法状态"]
local _____6E05_7406_585E_62C9_65AF_9B54_6CD5_72B6_6001 = ____01_FF0E_72B6_6001_8868["清理塞拉斯魔法状态"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("平台扩展API动作")
local _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4 = ____require_result_2["技能_设置技能冷却时间"]
local GetOwningPlayer = jass.GetOwningPlayer
local SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local SetUnitAbilityLevel = jass.SetUnitAbilityLevel
local GetUnitTypeId = jass.GetUnitTypeId
local _____914D_7F6E = _____585E_62C9_65AF_6280_80FD_914D_7F6E
local _____82F1_96C4_5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____Q_5165_53E3_7C7B_578BID = _____914D_7F6E["Q入口"]["技能类型ID"]
local _____5173_95ED_5165_53E3_7C7B_578BID = _____914D_7F6E["关闭入口"]["技能类型ID"]
local _____706B_7130_7C7B_578BID = _____914D_7F6E["元素魔法"]["火焰技能类型ID"]
local _____51B0_51BB_7C7B_578BID = _____914D_7F6E["元素魔法"]["冰冻技能类型ID"]
local _____96F7_51FB_7C7B_578BID = _____914D_7F6E["元素魔法"]["雷击技能类型ID"]
local ____W_7C7B_578BID = _____914D_7F6E.W["技能类型ID"]
local ____E_7C7B_578BID = _____914D_7F6E.E["技能类型ID"]
local ____R_7C7B_578BID = _____914D_7F6E.R["技能类型ID"]
local _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = false
local function _____786E_4FDD_585E_62C9_65AF_5143_7D20_6280_80FD_5B58_5728(caster)
    UnitAddAbility(caster, _____5173_95ED_5165_53E3_7C7B_578BID)
    UnitAddAbility(caster, _____706B_7130_7C7B_578BID)
    UnitAddAbility(caster, _____51B0_51BB_7C7B_578BID)
    UnitAddAbility(caster, _____96F7_51FB_7C7B_578BID)
end
local function _____6267_884C_5F00_542F_5207_6362(variable)
    local caster = variable
    if caster == nil or caster == 0 then
        return
    end
    local state = _____83B7_53D6_6216_521B_5EFA_585E_62C9_65AF_9B54_6CD5_72B6_6001(caster)
    if state ~= nil then
        state["开启回调ID"] = 0
    end
    local player = GetOwningPlayer(caster)
    if player == nil or player == 0 then
        return
    end
    _____786E_4FDD_585E_62C9_65AF_5143_7D20_6280_80FD_5B58_5728(caster)
    local _____5165_53E3_7B49_7EA7 = GetUnitAbilityLevel(caster, ____Q_5165_53E3_7C7B_578BID)
    if _____5165_53E3_7B49_7EA7 > 0 then
        SetUnitAbilityLevel(caster, _____706B_7130_7C7B_578BID, _____5165_53E3_7B49_7EA7)
        SetUnitAbilityLevel(caster, _____51B0_51BB_7C7B_578BID, _____5165_53E3_7B49_7EA7)
        SetUnitAbilityLevel(caster, _____96F7_51FB_7C7B_578BID, _____5165_53E3_7B49_7EA7)
    end
    SetPlayerAbilityAvailable(player, _____706B_7130_7C7B_578BID, true)
    SetPlayerAbilityAvailable(player, _____51B0_51BB_7C7B_578BID, true)
    SetPlayerAbilityAvailable(player, _____96F7_51FB_7C7B_578BID, true)
    SetPlayerAbilityAvailable(player, ____Q_5165_53E3_7C7B_578BID, false)
    SetPlayerAbilityAvailable(player, ____W_7C7B_578BID, false)
    SetPlayerAbilityAvailable(player, ____E_7C7B_578BID, false)
    SetPlayerAbilityAvailable(player, ____R_7C7B_578BID, false)
    if state ~= nil then
        state["普通魔法已开启"] = true
        state["普通魔法技能等级"] = _____5165_53E3_7B49_7EA7
    end
end
local function _____6267_884C_5173_95ED_5207_6362(variable)
    local caster = variable
    if caster == nil or caster == 0 then
        return
    end
    local state = _____83B7_53D6_6216_521B_5EFA_585E_62C9_65AF_9B54_6CD5_72B6_6001(caster)
    if state ~= nil then
        state["关闭回调ID"] = 0
    end
    local player = GetOwningPlayer(caster)
    if player == nil or player == 0 then
        return
    end
    UnitRemoveAbility(caster, _____5173_95ED_5165_53E3_7C7B_578BID)
    SetPlayerAbilityAvailable(player, _____706B_7130_7C7B_578BID, false)
    SetPlayerAbilityAvailable(player, _____51B0_51BB_7C7B_578BID, false)
    SetPlayerAbilityAvailable(player, _____96F7_51FB_7C7B_578BID, false)
    SetPlayerAbilityAvailable(player, ____Q_5165_53E3_7C7B_578BID, true)
    SetPlayerAbilityAvailable(player, ____W_7C7B_578BID, true)
    SetPlayerAbilityAvailable(player, ____E_7C7B_578BID, true)
    SetPlayerAbilityAvailable(player, ____R_7C7B_578BID, true)
    if state ~= nil then
        state["普通魔法已开启"] = false
        state["当前元素"] = ""
    end
end
local function _____8BF7_6C42_5F00_542F_666E_901A_9B54_6CD5(caster)
    local state = _____83B7_53D6_6216_521B_5EFA_585E_62C9_65AF_9B54_6CD5_72B6_6001(caster)
    if state == nil then
        return
    end
    if state["开启回调ID"] ~= 0 then
        removeDelayedCallback(state["开启回调ID"])
    end
    if state["关闭回调ID"] ~= 0 then
        removeDelayedCallback(state["关闭回调ID"])
        state["关闭回调ID"] = 0
    end
    state["开启回调ID"] = addDelayedCallback(_____914D_7F6E["Q入口"]["切换延迟秒"] * 1000, _____6267_884C_5F00_542F_5207_6362, caster)
end
local function _____8BF7_6C42_5173_95ED_666E_901A_9B54_6CD5(caster, _____91CD_7F6EQ_51B7_5374)
    local state = _____83B7_53D6_6216_521B_5EFA_585E_62C9_65AF_9B54_6CD5_72B6_6001(caster)
    if state == nil then
        return
    end
    if state["关闭回调ID"] ~= 0 then
        removeDelayedCallback(state["关闭回调ID"])
    end
    if state["开启回调ID"] ~= 0 then
        removeDelayedCallback(state["开启回调ID"])
        state["开启回调ID"] = 0
    end
    if _____91CD_7F6EQ_51B7_5374 then
        _____6280_80FD__8BBE_7F6E_6280_80FD_51B7_5374_65F6_95F4(caster, ____Q_5165_53E3_7C7B_578BID, 0, _____914D_7F6E["Q入口"]["技能类型ID"] > 0 and 0.01 or 0.01)
    end
    state["关闭回调ID"] = addDelayedCallback(_____914D_7F6E["关闭入口"]["切换延迟秒"] * 1000, _____6267_884C_5173_95ED_5207_6362, caster)
end
--- 元素魔法施放后调用：0.15 秒后自动关闭面板（源 JASS 行为，大魔法二连击在同一次施法内结算，不受影响）
____exports["塞拉斯元素施法后自动关闭"] = function(caster)
    _____8BF7_6C42_5173_95ED_666E_901A_9B54_6CD5(caster, false)
end
local function ____Q_5165_53E3_4E0A_4E0B_6587(unit)
    if unit == nil or unit == 0 then
        return nil
    end
    return {["施法者"] = unit}
end
local function _____91CA_653EQ_5165_53E3(context, caster)
    _____8BF7_6C42_5F00_542F_666E_901A_9B54_6CD5(caster)
end
local function _____91CA_653E_5173_95ED_5165_53E3(context, caster)
    _____8BF7_6C42_5173_95ED_666E_901A_9B54_6CD5(caster, _____914D_7F6E["关闭入口"]["重置Q入口冷却"])
end
local function _____585E_62C9_65AF_5165_53E3_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    if dyingUnit == nil or dyingUnit == 0 then
        return
    end
    if GetUnitTypeId(dyingUnit) ~= _____82F1_96C4_5355_4F4D_7C7B_578BID then
        return
    end
    _____6E05_7406_585E_62C9_65AF_9B54_6CD5_72B6_6001(dyingUnit)
end
____exports["注册塞拉斯技能入口"] = function()
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞拉斯-魔法知识（Q入口）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E["Q入口"]["技能ID"],
        ["获取或创建上下文"] = ____Q_5165_53E3_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653EQ_5165_53E3,
        ["创建独立技能实例"] = false
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "塞拉斯-魔法知识关闭（A0JV）",
        ["单位类型ID"] = _____82F1_96C4_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____914D_7F6E["关闭入口"]["技能ID"],
        ["获取或创建上下文"] = ____Q_5165_53E3_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5173_95ED_5165_53E3,
        ["创建独立技能实例"] = false
    })
    if not _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C then
        _____6B7B_4EA1_76D1_542C_5DF2_6CE8_518C = true
        registerDeathListener(_____585E_62C9_65AF_5165_53E3_5355_4F4D_6B7B_4EA1)
    end
end
____exports["注册塞拉斯技能入口"]()
return ____exports
