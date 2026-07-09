local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
local _____5355_4F4D_6709_6548_5B58_6D3B, ____on_6301_7EED_4F24_5BB3_8C03_5EA6Tick, YDUserDataGetSafe, getServerTime, _____83B7_53D6_4F24_5BB3_5F52_5C5E_5355_4F4D, ATTACK_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, GetOwningPlayer, GetUnitTypeId, GetUnitState, UNIT_STATE_LIFE, _____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868
local ____08_FF0E_6280_80FD_4F24_5BB3_7CFB_7EDF = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6280_80FD_4F24_5BB3 = ____08_FF0E_6280_80FD_4F24_5BB3_7CFB_7EDF["造成技能伤害"]
____exports["读取持续伤害加成"] = function(source)
    if source == nil or source == 0 then
        return 0
    end
    local owner = GetOwningPlayer(source)
    if owner == nil then
        return 0
    end
    local value = __TS__Number(YDUserDataGetSafe("player", owner, ____exports["持续伤害属性名"], "real")) or 0
    return value > -0.95 and value or -0.95
end
____exports["计算持续伤害最终值"] = function(source, amount)
    if not (amount > 0) then
        return 0
    end
    local finalAmount = amount * (1 + ____exports["读取持续伤害加成"](source))
    return finalAmount > 0 and finalAmount or 0
end
function _____5355_4F4D_6709_6548_5B58_6D3B(unit)
    if unit == nil or unit == 0 then
        return false
    end
    if GetUnitTypeId(unit) == 0 then
        return false
    end
    return GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
function ____on_6301_7EED_4F24_5BB3_8C03_5EA6Tick()
    local now = getServerTime()
    local write = 0
    do
        local i = 0
        while i < #_____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868 do
            do
                local record = _____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868[i + 1]
                if record == nil or record["剩余跳数"] <= 0 or not _____5355_4F4D_6709_6548_5B58_6D3B(record["来源"]) or not _____5355_4F4D_6709_6548_5B58_6D3B(record["目标"]) then
                    goto __continue14
                end
                if now >= record["下次跳时刻"] then
                    ____exports["造成持续伤害"](
                        record["来源"],
                        record["目标"],
                        record["每跳伤害"],
                        record["伤害类型"],
                        record.ranged,
                        record.attackType,
                        record.weaponType,
                        record["选项"]
                    )
                    record["剩余跳数"] = record["剩余跳数"] - 1
                    record["下次跳时刻"] = now + record["间隔毫秒"]
                end
                if record["剩余跳数"] > 0 then
                    _____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868[write + 1] = record
                    write = write + 1
                end
            end
            ::__continue14::
            i = i + 1
        end
    end
    while #_____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868 > write do
        table.remove(_____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868)
    end
end
____exports["造成持续伤害"] = function(source, target, amount, damageType, ranged, attackType, weaponType, _____9009_9879)
    if ranged == nil then
        ranged = false
    end
    if attackType == nil then
        attackType = ATTACK_TYPE_NORMAL
    end
    if weaponType == nil then
        weaponType = WEAPON_TYPE_WHOKNOWS
    end
    local mappedSource = _____83B7_53D6_4F24_5BB3_5F52_5C5E_5355_4F4D(source, target)
    local finalAmount = ____exports["计算持续伤害最终值"](mappedSource, amount)
    if not (finalAmount > 0) then
        return false
    end
    return _____9020_6210_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = finalAmount,
        ["伤害类型"] = damageType,
        attack = false,
        ranged = ranged,
        attackType = attackType,
        weaponType = weaponType,
        ["来源类型"] = _____9009_9879 and _____9009_9879["来源类型"] or _____9009_9879 and _____9009_9879["装备技能类型"] or "单位技能",
        ["装备技能类型"] = _____9009_9879 and _____9009_9879["装备技能类型"],
        ["技能ID"] = _____9009_9879 and _____9009_9879["技能ID"],
        ["技能实例ID"] = _____9009_9879 and _____9009_9879["技能实例ID"],
        ["标签"] = _____9009_9879 and _____9009_9879["标签"],
        ["伤害形态"] = _____9009_9879 and _____9009_9879["伤害形态"] or "单体",
        ["参与技能伤害加成"] = _____9009_9879 and _____9009_9879["参与技能伤害加成"]
    })
end
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
YDUserDataGetSafe = ____require_result_0.YDUserDataGetSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.04．伤害系统.04．伤害映射")
_____83B7_53D6_4F24_5BB3_5F52_5C5E_5355_4F4D = ____require_result_2["获取伤害归属单位"]
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
GetOwningPlayer = jass.GetOwningPlayer
GetUnitTypeId = jass.GetUnitTypeId
GetUnitState = jass.GetUnitState
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local R2I = jass.R2I
____exports["持续伤害属性名"] = "持续伤害"
_____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868 = {}
local _____6301_7EED_4F24_5BB3_8C03_5EA6Tick_5DF2_6CE8_518C = false
local function _____6CE8_518C_6301_7EED_4F24_5BB3_8C03_5EA6Tick()
    if _____6301_7EED_4F24_5BB3_8C03_5EA6Tick_5DF2_6CE8_518C then
        return
    end
    _____6301_7EED_4F24_5BB3_8C03_5EA6Tick_5DF2_6CE8_518C = true
    addPeriodicCallback(100, ____on_6301_7EED_4F24_5BB3_8C03_5EA6Tick)
end
____exports["开始持续伤害"] = function(_____53C2_6570)
    if _____53C2_6570 == nil then
        return 0
    end
    local intervalSec = _____53C2_6570["间隔秒数"] or 1
    if not (_____53C2_6570["总伤害"] > 0) or not (_____53C2_6570["持续秒数"] > 0) or not (intervalSec > 0) then
        return 0
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(_____53C2_6570["来源"]) or not _____5355_4F4D_6709_6548_5B58_6D3B(_____53C2_6570["目标"]) then
        return 0
    end
    local ticks = R2I(_____53C2_6570["持续秒数"] / intervalSec)
    if not (ticks > 0) then
        return 0
    end
    local ____53C2_6570__6765_6E90_21 = _____53C2_6570["来源"]
    local ____53C2_6570__76EE_6807_22 = _____53C2_6570["目标"]
    local ____temp_23 = _____53C2_6570["总伤害"] / ticks
    local ____53C2_6570__4F24_5BB3_7C7B_578B_24 = _____53C2_6570["伤害类型"]
    local ____temp_25 = _____53C2_6570.ranged == true
    local ____53C2_6570_attackType_19 = _____53C2_6570.attackType
    if ____53C2_6570_attackType_19 == nil then
        ____53C2_6570_attackType_19 = ATTACK_TYPE_NORMAL
    end
    local ____53C2_6570_weaponType_20 = _____53C2_6570.weaponType
    if ____53C2_6570_weaponType_20 == nil then
        ____53C2_6570_weaponType_20 = WEAPON_TYPE_WHOKNOWS
    end
    _____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868[#_____6301_7EED_4F24_5BB3_8C03_5EA6_5217_8868 + 1] = {
        ["来源"] = ____53C2_6570__6765_6E90_21,
        ["目标"] = ____53C2_6570__76EE_6807_22,
        ["每跳伤害"] = ____temp_23,
        ["伤害类型"] = ____53C2_6570__4F24_5BB3_7C7B_578B_24,
        ranged = ____temp_25,
        attackType = ____53C2_6570_attackType_19,
        weaponType = ____53C2_6570_weaponType_20,
        ["选项"] = _____53C2_6570["选项"],
        ["剩余跳数"] = ticks,
        ["下次跳时刻"] = getServerTime() + intervalSec * 1000,
        ["间隔毫秒"] = intervalSec * 1000
    }
    _____6CE8_518C_6301_7EED_4F24_5BB3_8C03_5EA6Tick()
    return ticks
end
return ____exports
