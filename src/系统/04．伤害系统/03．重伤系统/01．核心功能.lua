--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5E38_91CF_5B9A_4E49 = require("系统.04．伤害系统.03．重伤系统.00．常量定义")
local _____91CD_4F24_7CFB_7EDF_5F00_5173 = ____00_FF0E_5E38_91CF_5B9A_4E49["重伤系统开关"]
local _____91CD_4F24_4E0A_9650 = ____00_FF0E_5E38_91CF_5B9A_4E49["重伤上限"]
local _____91CD_4F24_4E0B_9650 = ____00_FF0E_5E38_91CF_5B9A_4E49["重伤下限"]
local _____91CD_4F24BuffID = ____00_FF0E_5E38_91CF_5B9A_4E49["重伤BuffID"]
local _____91CD_4F24_6548_679C_7CFB_6570 = ____00_FF0E_5E38_91CF_5B9A_4E49["重伤效果系数"]
local _____91CD_4F24_9ED8_8BA4_6301_7EED_65F6_95F4 = ____00_FF0E_5E38_91CF_5B9A_4E49["重伤默认持续时间"]
--- 重伤系统 - 核心功能
-- 
-- 1. 玩家1-4的单位从装备读取重伤值（取最高），走YDUserData
-- 2. 造成伤害时，给被伤害的单位添加buffUI重伤（C021），每次造成伤害刷新持续时间
-- 3. 重伤减少目标受到的治疗效果
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerHealCallback = ____require_result_1.registerHealCallback
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local getBuffRuntime = ____require_result_2.getBuffRuntime
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local GetPlayerId = jass.GetPlayerId
local GetOwningPlayer = jass.GetOwningPlayer
local function _____8BFB_53D6YD_7528_6237_6570_636E(tableType, tableKey, attr, valueType)
    return YDUserDataGetSafe(tableType, tableKey, attr, valueType)
end
--- 限制重伤值在有效范围内
local function _____9650_5236_91CD_4F24_503C(value)
    if value < _____91CD_4F24_4E0B_9650 then
        return _____91CD_4F24_4E0B_9650
    end
    if value > _____91CD_4F24_4E0A_9650 then
        return _____91CD_4F24_4E0A_9650
    end
    return value
end
--- 获取单位装备重伤值（所属玩家0-4的单位从玩家读取，其他从单位读取）
local function _____83B7_53D6_88C5_5907_91CD_4F24_503C(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local owner = GetOwningPlayer(unit)
    local playerId = GetPlayerId(owner)
    if playerId >= 0 and playerId <= 3 then
        local v = _____8BFB_53D6YD_7528_6237_6570_636E("player", owner, "重伤", "real")
        return type(v) == "number" and _____9650_5236_91CD_4F24_503C(v) or 0
    end
    local v = _____8BFB_53D6YD_7528_6237_6570_636E("unit", unit, "重伤", "real")
    return type(v) == "number" and _____9650_5236_91CD_4F24_503C(v) or 0
end
--- 获取单位当前受到的重伤值（从buff系统读取）
____exports["获取单位重伤"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local buffRuntime = getBuffRuntime(unit, _____91CD_4F24BuffID)
    if buffRuntime == nil then
        return 0
    end
    return _____9650_5236_91CD_4F24_503C(buffRuntime.effect)
end
--- 给单位施加重伤（buff方式）
-- 
-- @param unit 目标单位
-- @param 重伤值 0-1，如 0.5 = 治疗效果减半
-- @param 持续时间 秒，默认3秒
____exports["施加重伤"] = function(unit, _____91CD_4F24_503C, _____6301_7EED_65F6_95F4, source)
    if _____6301_7EED_65F6_95F4 == nil then
        _____6301_7EED_65F6_95F4 = _____91CD_4F24_9ED8_8BA4_6301_7EED_65F6_95F4
    end
    if unit == nil or unit == 0 then
        return
    end
    if _____6301_7EED_65F6_95F4 <= 0 then
        return
    end
    local _____6700_7EC8_503C = _____9650_5236_91CD_4F24_503C(_____91CD_4F24_503C)
    if _____6700_7EC8_503C <= 0 then
        return
    end
    local ____temp_3
    if source ~= nil and source ~= 0 then
        ____temp_3 = jass:GetUnitName(source)
    else
        ____temp_3 = nil
    end
    local sourceName = ____temp_3
    registerManualBuff(
        unit,
        _____91CD_4F24BuffID,
        _____6301_7EED_65F6_95F4,
        _____6700_7EC8_503C * _____91CD_4F24_6548_679C_7CFB_6570,
        {sourceName = type(sourceName) == "string" and sourceName ~= "" and sourceName or nil}
    )
end
--- 移除单位重伤
____exports["移除单位重伤"] = function(unit)
    if unit == nil or unit == 0 then
        return
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(unit, _____91CD_4F24BuffID)
end
--- 计算重伤后的治疗量
local function _____8BA1_7B97_91CD_4F24_6CBB_7597_91CF(source, target, amount)
    if not _____91CD_4F24_7CFB_7EDF_5F00_5173 then
        return amount
    end
    if amount <= 0 then
        return 0
    end
    local wound = ____exports["获取单位重伤"](target)
    if wound <= 0 then
        return amount
    end
    return amount * (1 - wound)
end
--- 伤害事件回调：来源有装备重伤时，给目标施加重伤
local function ____on_4F24_5BB3_4E8B_4EF6(...)
    local args = {...}
    if not _____91CD_4F24_7CFB_7EDF_5F00_5173 then
        return
    end
    local target
    local source
    if #args >= 6 then
        target = args[2]
        source = args[6]
    else
        target = args[1]
        source = args[5]
    end
    if source == nil or source == 0 then
        return
    end
    if target == nil or target == 0 then
        return
    end
    local _____88C5_5907_91CD_4F24 = _____83B7_53D6_88C5_5907_91CD_4F24_503C(source)
    if _____88C5_5907_91CD_4F24 <= 0 then
        return
    end
    ____exports["施加重伤"](target, _____88C5_5907_91CD_4F24, _____91CD_4F24_9ED8_8BA4_6301_7EED_65F6_95F4, source)
end
--- 注册重伤回调到治疗系统和伤害事件
function ____exports.initWoundSystem()
    if not _____91CD_4F24_7CFB_7EDF_5F00_5173 then
        return
    end
    registerHealCallback(_____8BA1_7B97_91CD_4F24_6CBB_7597_91CF)
    local damageEventModule = require("系统.04．伤害系统.01．伤害事件")
    local regCb = damageEventModule.registerDamageCallback
    regCb(damageEventModule, ____on_4F24_5BB3_4E8B_4EF6, 0)
end
return ____exports
