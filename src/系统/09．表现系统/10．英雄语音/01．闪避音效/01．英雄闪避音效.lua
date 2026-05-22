local ____lualib = require("lualib_bundle")
local __TS__StringTrim = ____lualib.__TS__StringTrim
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.01．闪避音效.00．配置")
local _____82F1_96C4_95EA_907F_97F3_6548_51B7_5374 = ____00_FF0E_914D_7F6E["英雄闪避音效冷却"]
local _____53D6_82F1_96C4_95EA_907F_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["取英雄闪避音效配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.01A．玩家英雄判定")
local _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D = ____require_result_0["是玩家英雄组单位"]
local ____require_result_1 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.01．玩家英雄配置工具")
local _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_914D_7F6E = ____require_result_1["获取单位玩家英雄配置"]
local ____require_result_2 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名")
local _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_5168_90E8_540D_79F0 = ____require_result_2["获取单位玩家英雄全部名称"]
local ____require_result_3 = require("系统.04．伤害系统.05．闪避系统.01．闪避核心")
local registerDodgeAppliedFinalDamageListener = ____require_result_3.registerDodgeAppliedFinalDamageListener
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_4.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_4.YDUserDataSetSafe
local GetLocalPlayer = jass.GetLocalPlayer
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitType = jass.IsUnitType
local PlaySoundOnUnitBJ = jass.PlaySoundOnUnitBJ
local GetRandomInt = jass.GetRandomInt
local _____5DF2_521D_59CB_5316_82F1_96C4_95EA_907F_8BED_97F3 = false
local function _____53D6_82F1_96C4_540D(unit)
    local _____5168_90E8_540D_79F0 = _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_5168_90E8_540D_79F0(unit)
    if #_____5168_90E8_540D_79F0 > 0 then
        return _____5168_90E8_540D_79F0[1]
    end
    local config = _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_914D_7F6E(unit)
    if config == nil then
        return ""
    end
    local ____config_Name_5 = config.Name
    if ____config_Name_5 == nil then
        ____config_Name_5 = ""
    end
    local _____540D_79F0 = __TS__StringTrim(tostring(____config_Name_5))
    if _____540D_79F0 ~= "" then
        return _____540D_79F0
    end
    local ____config_Propernames_6 = config.Propernames
    if ____config_Propernames_6 == nil then
        ____config_Propernames_6 = ""
    end
    return __TS__StringTrim(tostring(____config_Propernames_6))
end
local function _____53D6_95EA_907F_97F3_6548(unit)
    local _____540D_79F0_5217_8868 = _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_5168_90E8_540D_79F0(unit)
    if #_____540D_79F0_5217_8868 <= 0 then
        local _____82F1_96C4_540D = _____53D6_82F1_96C4_540D(unit)
        local _____914D_7F6E = _____53D6_82F1_96C4_95EA_907F_97F3_6548_914D_7F6E(_____82F1_96C4_540D)
        if _____914D_7F6E == nil or #_____914D_7F6E["音效列表"] == 0 then
            return nil
        end
        local _____7D22_5F15 = GetRandomInt(1, #_____914D_7F6E["音效列表"]) - 1
        local ____914D_7F6E__97F3_6548_5217_8868_index_7 = _____914D_7F6E["音效列表"][_____7D22_5F15 + 1]
        if ____914D_7F6E__97F3_6548_5217_8868_index_7 == nil then
            ____914D_7F6E__97F3_6548_5217_8868_index_7 = nil
        end
        return ____914D_7F6E__97F3_6548_5217_8868_index_7
    end
    do
        local i = 0
        while i < #_____540D_79F0_5217_8868 do
            do
                local _____914D_7F6E = _____53D6_82F1_96C4_95EA_907F_97F3_6548_914D_7F6E(_____540D_79F0_5217_8868[i + 1])
                if _____914D_7F6E == nil or #_____914D_7F6E["音效列表"] == 0 then
                    goto __continue10
                end
                local _____7D22_5F15 = GetRandomInt(1, #_____914D_7F6E["音效列表"]) - 1
                local ____914D_7F6E__97F3_6548_5217_8868_index_8 = _____914D_7F6E["音效列表"][_____7D22_5F15 + 1]
                if ____914D_7F6E__97F3_6548_5217_8868_index_8 == nil then
                    ____914D_7F6E__97F3_6548_5217_8868_index_8 = nil
                end
                return ____914D_7F6E__97F3_6548_5217_8868_index_8
            end
            ::__continue10::
            i = i + 1
        end
    end
    return nil
end
local function _____5141_8BB8_64AD_653E(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if not _____662F_73A9_5BB6_82F1_96C4_7EC4_5355_4F4D(unit) then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_DEAD) then
        return false
    end
    if IsUnitType(unit, jass.UNIT_TYPE_SUMMONED) then
        return false
    end
    return true
end
local function _____672C_5730_73A9_5BB6_64AD_653E(unit, soundHandle)
    if soundHandle == nil then
        return
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return
    end
    if GetLocalPlayer() ~= owner then
        return
    end
    PlaySoundOnUnitBJ(soundHandle, 100, unit)
end
local function _____82F1_96C4_95EA_907F_8BED_97F3_51B7_5374_7ED3_675F()
    local timer = jass.GetExpiredTimer()
    local target = YDUserDataGetSafe("timer", timer, "英雄闪避语音单位", "unit")
    if target ~= nil and target ~= 0 then
        YDUserDataSetSafe(
            "unit",
            target,
            "闪避语音",
            "boolean",
            false
        )
    end
    jass.DestroyTimer(timer)
end
local function _____5904_7406_95EA_907F_8BED_97F3(_source, target)
    if not _____5141_8BB8_64AD_653E(target) then
        return
    end
    if YDUserDataGetSafe("unit", target, "闪避语音", "boolean") then
        return
    end
    local soundHandle = _____53D6_95EA_907F_97F3_6548(target)
    if soundHandle == nil then
        return
    end
    YDUserDataSetSafe(
        "unit",
        target,
        "闪避语音",
        "boolean",
        true
    )
    _____672C_5730_73A9_5BB6_64AD_653E(target, soundHandle)
    local timer = jass.CreateTimer()
    YDUserDataSetSafe(
        "timer",
        timer,
        "英雄闪避语音单位",
        "unit",
        target
    )
    jass.TimerStart(timer, _____82F1_96C4_95EA_907F_97F3_6548_51B7_5374, false, _____82F1_96C4_95EA_907F_8BED_97F3_51B7_5374_7ED3_675F)
end
local function _____95EA_907F_6210_529F_56DE_8C03(source, target, _damage)
    _____5904_7406_95EA_907F_8BED_97F3(source, target)
end
____exports["init英雄闪避音效系统"] = function()
    if _____5DF2_521D_59CB_5316_82F1_96C4_95EA_907F_8BED_97F3 then
        return
    end
    _____5DF2_521D_59CB_5316_82F1_96C4_95EA_907F_8BED_97F3 = true
    registerDodgeAppliedFinalDamageListener(_____95EA_907F_6210_529F_56DE_8C03)
end
return ____exports
