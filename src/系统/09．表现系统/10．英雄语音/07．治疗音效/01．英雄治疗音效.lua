--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.07．治疗音效.00．配置")
local _____82F1_96C4_6CBB_7597_97F3_6548_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["英雄治疗音效配置列表"]
local _____82F1_96C4_6CBB_7597_97F3_6548_51B7_5374 = ____00_FF0E_914D_7F6E["英雄治疗音效冷却"]
local _____6CBB_7597_97F3_6548_6392_9664_6765_6E90Rawcode_5217_8868 = ____00_FF0E_914D_7F6E["治疗音效排除来源Rawcode列表"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerAppliedFinalHealListener = ____require_result_0.registerAppliedFinalHealListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名")
local _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0 = ____require_result_2["单位是否匹配玩家英雄名称"]
local ____require_result_3 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_3.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_3.YDUserDataSetSafe
local ____require_result_4 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_4.safeTimerStart
local safeDestroyTimer = ____require_result_4.safeDestroyTimer
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_5.stringToFourCC
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitTypeId = jass.GetUnitTypeId
local IsUnitAlly = jass.IsUnitAlly
local CreateTimer = jass.CreateTimer
local GetExpiredTimer = jass.GetExpiredTimer
local GetRandomInt = jass.GetRandomInt
local PlaySoundOnUnitBJ = jass.PlaySoundOnUnitBJ
local _____51B7_5374_5B57_6BB5 = "受到帮助语音"
local _____51B7_5374_8BA1_65F6_5668_5B57_6BB5 = "治疗音效单位"
local _____82F1_96C4_6CBB_7597_97F3_6548_5DF2_521D_59CB_5316 = false
local function _____662F_6CE8_518C_73A9_5BB6_82F1_96C4(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    return getRegisteredPlayerHero(owner) == unit
end
local function _____6765_6E90_9700_8981_6392_9664(source)
    if source == nil or source == 0 then
        return false
    end
    local typeId = GetUnitTypeId(source)
    do
        local i = 0
        while i < #_____6CBB_7597_97F3_6548_6392_9664_6765_6E90Rawcode_5217_8868 do
            if typeId == stringToFourCC(_____6CBB_7597_97F3_6548_6392_9664_6765_6E90Rawcode_5217_8868[i + 1]) then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____53D6_6CBB_7597_97F3_6548_914D_7F6E(unit)
    do
        local i = 0
        while i < #_____82F1_96C4_6CBB_7597_97F3_6548_914D_7F6E_5217_8868 do
            local config = _____82F1_96C4_6CBB_7597_97F3_6548_914D_7F6E_5217_8868[i + 1]
            if _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0(unit, config["英雄名"]) then
                return config
            end
            i = i + 1
        end
    end
    return nil
end
local function _____53D6_64AD_653E_97F3_6548(soundList)
    if #soundList <= 0 then
        return nil
    end
    if #soundList == 1 then
        return soundList[1]
    end
    local index = GetRandomInt(1, #soundList) - 1
    return soundList[index + 1]
end
local function _____6CBB_7597_97F3_6548_51B7_5374_7ED3_675F()
    local timer = GetExpiredTimer()
    if timer == nil or timer == 0 then
        return
    end
    local unit = YDUserDataGetSafe("timer", timer, _____51B7_5374_8BA1_65F6_5668_5B57_6BB5, "unit")
    if unit ~= nil and unit ~= 0 then
        YDUserDataSetSafe(
            "unit",
            unit,
            _____51B7_5374_5B57_6BB5,
            "boolean",
            false
        )
    end
    safeDestroyTimer(timer)
end
local function _____8FDB_5165_6CBB_7597_97F3_6548_51B7_5374(unit)
    YDUserDataSetSafe(
        "unit",
        unit,
        _____51B7_5374_5B57_6BB5,
        "boolean",
        true
    )
    local timer = CreateTimer()
    YDUserDataSetSafe(
        "timer",
        timer,
        _____51B7_5374_8BA1_65F6_5668_5B57_6BB5,
        "unit",
        unit
    )
    safeTimerStart(timer, _____82F1_96C4_6CBB_7597_97F3_6548_51B7_5374, false, _____6CBB_7597_97F3_6548_51B7_5374_7ED3_675F)
end
local function _____6EE1_8DB3_6CBB_7597_97F3_6548_5173_7CFB(source, target)
    if source == nil or source == 0 or target == nil or target == 0 then
        return false
    end
    if _____6765_6E90_9700_8981_6392_9664(source) then
        return false
    end
    if not _____662F_6CE8_518C_73A9_5BB6_82F1_96C4(target) then
        return false
    end
    local sourcePlayer = GetOwningPlayer(source)
    local targetPlayer = GetOwningPlayer(target)
    if sourcePlayer == nil or sourcePlayer == 0 or targetPlayer == nil or targetPlayer == 0 then
        return false
    end
    if sourcePlayer == targetPlayer then
        return false
    end
    return IsUnitAlly(target, sourcePlayer)
end
local function _____5904_7406_82F1_96C4_6CBB_7597_97F3_6548(source, target, actualHeal, _isItemHeal)
    if actualHeal <= 0 then
        return
    end
    if not _____6EE1_8DB3_6CBB_7597_97F3_6548_5173_7CFB(source, target) then
        return
    end
    if YDUserDataGetSafe("unit", target, _____51B7_5374_5B57_6BB5, "boolean") == true then
        return
    end
    local config = _____53D6_6CBB_7597_97F3_6548_914D_7F6E(target)
    if config == nil then
        return
    end
    local soundHandle = _____53D6_64AD_653E_97F3_6548(config["音效列表"])
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    PlaySoundOnUnitBJ(soundHandle, 100, target)
    _____8FDB_5165_6CBB_7597_97F3_6548_51B7_5374(target)
end
____exports["init英雄治疗音效"] = function()
    if _____82F1_96C4_6CBB_7597_97F3_6548_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_6CBB_7597_97F3_6548_5DF2_521D_59CB_5316 = true
    registerAppliedFinalHealListener(_____5904_7406_82F1_96C4_6CBB_7597_97F3_6548)
end
return ____exports
