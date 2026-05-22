--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.06．击杀音效.00．配置")
local _____82F1_96C4_51FB_6740_97F3_6548_914D_7F6E_5217_8868 = ____00_FF0E_914D_7F6E["英雄击杀音效配置列表"]
local _____82F1_96C4_51FB_6740_97F3_6548_51B7_5374 = ____00_FF0E_914D_7F6E["英雄击杀音效冷却"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_0.registerDeathListener
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名")
local _____5355_4F4D_662F_5426_5339_914D_73A9_5BB6_82F1_96C4_540D_79F0 = ____require_result_1["单位是否匹配玩家英雄名称"]
local ____require_result_2 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_2.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_2.YDUserDataSetSafe
local ____require_result_3 = require("系统.00．核心系统.07．联机安全工具")
local safeTimerStart = ____require_result_3.safeTimerStart
local safeDestroyTimer = ____require_result_3.safeDestroyTimer
local IsUnitType = jass.IsUnitType
local CreateTimer = jass.CreateTimer
local GetExpiredTimer = jass.GetExpiredTimer
local GetRandomInt = jass.GetRandomInt
local PlaySoundOnUnitBJ = jass.PlaySoundOnUnitBJ
local _____51B7_5374_5B57_6BB5 = "战斗胜利语音"
local _____51B7_5374_8BA1_65F6_5668_5B57_6BB5 = "击杀音效单位"
local _____82F1_96C4_51FB_6740_97F3_6548_5DF2_521D_59CB_5316 = false
local function _____6B7B_4EA1_5355_4F4D_6EE1_8DB3_51FB_6740_97F3_6548_524D_7F6E(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_STRUCTURE) then
        return false
    end
    return true
end
local function _____53D6_51FB_6740_97F3_6548_914D_7F6E(unit)
    do
        local i = 0
        while i < #_____82F1_96C4_51FB_6740_97F3_6548_914D_7F6E_5217_8868 do
            local config = _____82F1_96C4_51FB_6740_97F3_6548_914D_7F6E_5217_8868[i + 1]
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
local function _____51FB_6740_97F3_6548_51B7_5374_7ED3_675F()
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
local function _____8FDB_5165_51FB_6740_97F3_6548_51B7_5374(unit)
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
    safeTimerStart(timer, _____82F1_96C4_51FB_6740_97F3_6548_51B7_5374, false, _____51FB_6740_97F3_6548_51B7_5374_7ED3_675F)
end
local function _____5904_7406_82F1_96C4_51FB_6740_97F3_6548(dyingUnit, killingUnit)
    if not _____6B7B_4EA1_5355_4F4D_6EE1_8DB3_51FB_6740_97F3_6548_524D_7F6E(dyingUnit) then
        return
    end
    if killingUnit == nil or killingUnit == 0 then
        return
    end
    if not IsUnitType(killingUnit, jass.UNIT_TYPE_HERO) then
        return
    end
    if YDUserDataGetSafe("unit", killingUnit, _____51B7_5374_5B57_6BB5, "boolean") == true then
        return
    end
    local config = _____53D6_51FB_6740_97F3_6548_914D_7F6E(killingUnit)
    if config == nil then
        return
    end
    local soundHandle = _____53D6_64AD_653E_97F3_6548(config["音效列表"])
    if soundHandle == nil or soundHandle == 0 then
        return
    end
    PlaySoundOnUnitBJ(soundHandle, 100, killingUnit)
    _____8FDB_5165_51FB_6740_97F3_6548_51B7_5374(killingUnit)
end
____exports["init英雄击杀音效"] = function()
    if _____82F1_96C4_51FB_6740_97F3_6548_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_51FB_6740_97F3_6548_5DF2_521D_59CB_5316 = true
    registerDeathListener(_____5904_7406_82F1_96C4_51FB_6740_97F3_6548)
end
return ____exports
