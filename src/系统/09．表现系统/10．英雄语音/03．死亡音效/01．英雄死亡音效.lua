--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.09．表现系统.10．英雄语音.03．死亡音效.00．配置")
local _____82F1_96C4_6B7B_4EA1_97F3_6548_51B7_5374 = ____00_FF0E_914D_7F6E["英雄死亡音效冷却"]
local _____53D6_82F1_96C4_6B7B_4EA1_97F3_6548_914D_7F6E = ____00_FF0E_914D_7F6E["取英雄死亡音效配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_0.YDUserDataSetSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.01．单位系统.00．单位初始化创建.01．玩家英雄.03．玩家英雄别名")
local _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_5168_90E8_540D_79F0 = ____require_result_3["获取单位玩家英雄全部名称"]
local PlaySoundBJ = jass.PlaySoundBJ
local GetRandomInt = jass.GetRandomInt
local GetOwningPlayer = jass.GetOwningPlayer
local GetHandleId = jass.GetHandleId
local _____82F1_96C4_6B7B_4EA1_97F3_6548_5DF2_521D_59CB_5316 = false
local _____6B7B_4EA1_97F3_6548_51B7_5374_7ED3_675F_5355_4F4D_961F_5217 = {}
local function _____5141_8BB8_64AD_653E(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local owner = GetOwningPlayer(unit)
    if owner == nil or owner == 0 then
        return false
    end
    local hero = YDUserDataGetSafe("player", owner, "英雄", "unit")
    if hero == nil or hero == 0 then
        return false
    end
    if hero ~= unit and GetHandleId(hero) ~= GetHandleId(unit) then
        return false
    end
    return true
end
local function _____53D6_6B7B_4EA1_97F3_6548(unit)
    local _____540D_79F0_5217_8868 = _____83B7_53D6_5355_4F4D_73A9_5BB6_82F1_96C4_5168_90E8_540D_79F0(unit)
    do
        local i = 0
        while i < #_____540D_79F0_5217_8868 do
            do
                local _____914D_7F6E = _____53D6_82F1_96C4_6B7B_4EA1_97F3_6548_914D_7F6E(_____540D_79F0_5217_8868[i + 1])
                if _____914D_7F6E == nil or #_____914D_7F6E["音效列表"] == 0 then
                    goto __continue9
                end
                local _____7D22_5F15 = GetRandomInt(1, #_____914D_7F6E["音效列表"]) - 1
                local ____914D_7F6E__97F3_6548_5217_8868_index_4 = _____914D_7F6E["音效列表"][_____7D22_5F15 + 1]
                if ____914D_7F6E__97F3_6548_5217_8868_index_4 == nil then
                    ____914D_7F6E__97F3_6548_5217_8868_index_4 = nil
                end
                return ____914D_7F6E__97F3_6548_5217_8868_index_4
            end
            ::__continue9::
            i = i + 1
        end
    end
    return nil
end
local function _____6B7B_4EA1_97F3_6548_51B7_5374_7ED3_675F()
    local target = table.remove(_____6B7B_4EA1_97F3_6548_51B7_5374_7ED3_675F_5355_4F4D_961F_5217, 1)
    if target ~= nil and target ~= 0 then
        YDUserDataSetSafe(
            "unit",
            target,
            "死亡音效",
            "boolean",
            false
        )
    end
end
local function _____5904_7406_6B7B_4EA1_8BED_97F3(target)
    if not _____5141_8BB8_64AD_653E(target) then
        return
    end
    if YDUserDataGetSafe("unit", target, "死亡音效", "boolean") then
        return
    end
    local soundHandle = _____53D6_6B7B_4EA1_97F3_6548(target)
    if soundHandle == nil then
        return
    end
    YDUserDataSetSafe(
        "unit",
        target,
        "死亡音效",
        "boolean",
        true
    )
    PlaySoundBJ(soundHandle)
    _____6B7B_4EA1_97F3_6548_51B7_5374_7ED3_675F_5355_4F4D_961F_5217[#_____6B7B_4EA1_97F3_6548_51B7_5374_7ED3_675F_5355_4F4D_961F_5217 + 1] = target
    addDelayedCallback(_____82F1_96C4_6B7B_4EA1_97F3_6548_51B7_5374 * 1000, _____6B7B_4EA1_97F3_6548_51B7_5374_7ED3_675F)
end
local function _____6B7B_4EA1_56DE_8C03(dyingUnit, _killer)
    _____5904_7406_6B7B_4EA1_8BED_97F3(dyingUnit)
end
____exports["init英雄死亡音效系统"] = function()
    if _____82F1_96C4_6B7B_4EA1_97F3_6548_5DF2_521D_59CB_5316 then
        return
    end
    _____82F1_96C4_6B7B_4EA1_97F3_6548_5DF2_521D_59CB_5316 = true
    registerDeathListener(_____6B7B_4EA1_56DE_8C03)
end
return ____exports
