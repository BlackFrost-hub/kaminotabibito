--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.04．物品事件中心")
local onItemUse = ____require_result_0.onItemUse
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
local GetLocalPlayer = jass.GetLocalPlayer
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitCurrentOrder = jass.GetUnitCurrentOrder
local GetExpiredTimer = jass.GetExpiredTimer
local CreateTimer = jass.CreateTimer
local GetRandomInt = jass.GetRandomInt
local PlaySoundBJ = jass.PlaySoundBJ
local PlaySoundOnUnitBJ = jass.PlaySoundOnUnitBJ
local ____require_result_5 = require("系统.09．表现系统.10．英雄语音.04．使用物品音效.00．配置")
local _____82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_914D_7F6E_5217_8868 = ____require_result_5["英雄使用物品音效配置列表"]
local _____82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_51B7_5374 = ____require_result_5["英雄使用物品音效冷却"]
local _____82F1_96C4_4F7F_7528_7269_54C1_547D_4EE4_6700_5C0F = ____require_result_5["英雄使用物品命令最小"]
local _____82F1_96C4_4F7F_7528_7269_54C1_547D_4EE4_6700_5927 = ____require_result_5["英雄使用物品命令最大"]
local _____51B7_5374_5355_4F4D_5B57_6BB5 = "使用物品语音"
local _____51B7_5374_8BA1_65F6_5668_5B57_6BB5 = "物品使用音效单位"
local _____82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_5DF2_521D_59CB_5316 = false
local function isUseItemOrder(orderId)
    return orderId >= _____82F1_96C4_4F7F_7528_7269_54C1_547D_4EE4_6700_5C0F and orderId <= _____82F1_96C4_4F7F_7528_7269_54C1_547D_4EE4_6700_5927
end
local function _____53D6_82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_914D_7F6E(unit)
    do
        local i = 0
        while i < #_____82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_914D_7F6E_5217_8868 do
            local config = _____82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_914D_7F6E_5217_8868[i + 1]
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
local function _____7269_54C1_4F7F_7528_97F3_6548_51B7_5374_7ED3_675F()
    local timer = GetExpiredTimer()
    if timer == nil or timer == 0 then
        return
    end
    local unit = YDUserDataGetSafe("timer", timer, _____51B7_5374_8BA1_65F6_5668_5B57_6BB5, "unit")
    if unit ~= nil and unit ~= 0 then
        YDUserDataSetSafe(
            "unit",
            unit,
            _____51B7_5374_5355_4F4D_5B57_6BB5,
            "boolean",
            false
        )
    end
    safeDestroyTimer(timer)
end
local function _____64AD_653E_7269_54C1_4F7F_7528_97F3_6548(unit, config)
    local soundHandle = _____53D6_64AD_653E_97F3_6548(config["音效列表"])
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    if config["是否3D"] then
        PlaySoundOnUnitBJ(soundHandle, 100, unit)
        return
    end
    if GetOwningPlayer(unit) == GetLocalPlayer() then
        PlaySoundBJ(soundHandle)
    end
end
local function _____5904_7406_7269_54C1_4F7F_7528_97F3_6548(unit, item)
    if unit == nil or unit == 0 or item == nil or item == 0 then
        return
    end
    if getRegisteredPlayerHero(GetOwningPlayer(unit)) ~= unit then
        return
    end
    if isUseItemOrder(GetUnitCurrentOrder(unit)) ~= true then
        return
    end
    if YDUserDataGetSafe("unit", unit, _____51B7_5374_5355_4F4D_5B57_6BB5, "boolean") == true then
        return
    end
    local config = _____53D6_82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_914D_7F6E(unit)
    if config == nil then
        return
    end
    _____64AD_653E_7269_54C1_4F7F_7528_97F3_6548(unit, config)
    YDUserDataSetSafe(
        "unit",
        unit,
        _____51B7_5374_5355_4F4D_5B57_6BB5,
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
    safeTimerStart(timer, _____82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_51B7_5374, false, _____7269_54C1_4F7F_7528_97F3_6548_51B7_5374_7ED3_675F)
end
____exports["init英雄使用物品音效"] = function()
    if _____82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_4F7F_7528_7269_54C1_97F3_6548_5DF2_521D_59CB_5316 = true
    onItemUse(_____5904_7406_7269_54C1_4F7F_7528_97F3_6548)
end
return ____exports
