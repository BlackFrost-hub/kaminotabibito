--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.09．购物音效.00．配置")
local _____82F1_96C4_8D2D_7269_97F3_6548_51B7_5374 = ____00_FF0E_914D_7F6E["英雄购物音效冷却"]
local _____82F1_96C4_8D2D_7269_97F3_6548_8303_56F4 = ____00_FF0E_914D_7F6E["英雄购物音效范围"]
local _____82F1_96C4_8D2D_7269_97F3_6548_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["英雄购物音效配置列表"]
local _____8D2D_7269_5546_5E97_5224_5B9A_80FD_529BId = ____00_FF0E_914D_7F6E["购物商店判定能力Id"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.05．玩家选中单位事件中心")
local addSelectionListener = ____require_result_0.addSelectionListener
local ____require_result_1 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_1.getRegisteredPlayerHero
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名")
local _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0 = ____require_result_2["单位是否匹配玩家英雄名称"]
local ____require_result_3 = require("lib.扩展函数.BJ函数.14．音效函数")
local PlaySoundBJ = ____require_result_3.PlaySoundBJ
local ____require_result_4 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_4.safeTimerStart
local safeDestroyTimer = ____require_result_4.safeDestroyTimer
local GetLocalPlayer = jass.GetLocalPlayer
local IsUnitType = jass.IsUnitType
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local IsUnitInRange = jass.IsUnitInRange
local GetRandomInt = jass.GetRandomInt
local CreateTimer = jass.CreateTimer
local GetExpiredTimer = jass.GetExpiredTimer
local _____82F1_96C4_8D2D_7269_97F3_6548_5DF2_521D_59CB_5316 = false
local _____8D2D_7269_97F3_6548_51B7_5374_4E2D = false
local function _____662F_8D2D_7269_5546_5E97(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if not IsUnitType(unit, jass.UNIT_TYPE_TOWNHALL) then
        return false
    end
    return GetUnitAbilityLevel(unit, _____8D2D_7269_5546_5E97_5224_5B9A_80FD_529BId) == 1
end
local function _____53D6_82F1_96C4_8D2D_7269_97F3_6548_914D_7F6E(unit)
    do
        local i = 0
        while i < #_____82F1_96C4_8D2D_7269_97F3_6548_914D_7F6E_5217_8868 do
            local config = _____82F1_96C4_8D2D_7269_97F3_6548_914D_7F6E_5217_8868[i + 1]
            if _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0(unit, config["英雄名"]) then
                return config
            end
            i = i + 1
        end
    end
    return nil
end
local function _____53D6_968F_673A_8D2D_7269_97F3_6548(soundList)
    if #soundList <= 0 then
        return nil
    end
    if #soundList == 1 then
        return soundList[1]
    end
    local index = GetRandomInt(1, #soundList) - 1
    return soundList[index + 1]
end
local function _____8D2D_7269_97F3_6548_51B7_5374_7ED3_675F()
    _____8D2D_7269_97F3_6548_51B7_5374_4E2D = false
    local timer = GetExpiredTimer()
    if timer ~= nil and timer ~= 0 then
        safeDestroyTimer(timer)
    end
end
local function _____5F00_59CB_8D2D_7269_97F3_6548_51B7_5374()
    _____8D2D_7269_97F3_6548_51B7_5374_4E2D = true
    local timer = CreateTimer()
    safeTimerStart(timer, _____82F1_96C4_8D2D_7269_97F3_6548_51B7_5374, false, _____8D2D_7269_97F3_6548_51B7_5374_7ED3_675F)
end
local function _____672C_5730_64AD_653E_8D2D_7269_97F3_6548(whichPlayer, soundHandle)
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    if GetLocalPlayer() ~= whichPlayer then
        return
    end
    PlaySoundBJ(soundHandle)
end
local function _____5904_7406_8D2D_7269_97F3_6548(whichPlayer, _playerId, selectedUnit, isSelected)
    if isSelected ~= true then
        return
    end
    if _____8D2D_7269_97F3_6548_51B7_5374_4E2D then
        return
    end
    if not _____662F_8D2D_7269_5546_5E97(selectedUnit) then
        return
    end
    local hero = getRegisteredPlayerHero(whichPlayer)
    if hero == nil or hero == 0 then
        return
    end
    if IsUnitType(hero, jass.UNIT_TYPE_DEAD) then
        return
    end
    if IsUnitType(hero, jass.UNIT_TYPE_SUMMONED) then
        return
    end
    if not IsUnitInRange(hero, selectedUnit, _____82F1_96C4_8D2D_7269_97F3_6548_8303_56F4) then
        return
    end
    local config = _____53D6_82F1_96C4_8D2D_7269_97F3_6548_914D_7F6E(hero)
    if config == nil then
        return
    end
    local soundHandle = _____53D6_968F_673A_8D2D_7269_97F3_6548(config["音效列表"])
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    _____672C_5730_64AD_653E_8D2D_7269_97F3_6548(whichPlayer, soundHandle)
    _____5F00_59CB_8D2D_7269_97F3_6548_51B7_5374()
end
____exports["init英雄购物音效"] = function()
    if _____82F1_96C4_8D2D_7269_97F3_6548_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_8D2D_7269_97F3_6548_5DF2_521D_59CB_5316 = true
    addSelectionListener(_____5904_7406_8D2D_7269_97F3_6548)
end
return ____exports
