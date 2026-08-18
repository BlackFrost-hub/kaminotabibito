--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_539F_751FBuff_6280_80FDID, B015, B018, B019, B017, S005, S007, S006, S008
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.03．阿伦劳特.00．配置")
local _____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["阿伦劳特单位技能配置"]
function _____53D6_539F_751FBuff_6280_80FDID(buffId)
    if buffId == B015 then
        return S005
    end
    if buffId == B018 then
        return S007
    end
    if buffId == B019 then
        return S006
    end
    if buffId == B017 then
        return S008
    end
    return 0
end
local jass = require("jass.common")
local Atan2 = jass.Atan2
local _____5F27_5EA6_8F6C_89D2_5EA6 = 57.29577951308232
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_0.stringToFourCCSafe
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local removeDelayedCallback = ____require_result_1.removeDelayedCallback
local _____5149_5F62_6001_5355_4F4DID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["光形态单位ID"])
local _____6697_5F62_6001_5355_4F4DID = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["暗形态单位ID"])
B015 = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["裁决审判强化BuffID"])
B018 = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["天堂呼唤强化BuffID"])
B019 = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["裁决制裁BuffID"])
B017 = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["切换加攻BuffID"])
S005 = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["裁决审判强化技能ID"])
S007 = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["天堂呼唤强化技能ID"])
S006 = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["裁决制裁技能ID"])
S008 = stringToFourCCSafe(_____963F_4F26_52B3_7279_5355_4F4D_6280_80FD_914D_7F6E["切换加攻技能ID"])
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local UnitAddAbility = jass.UnitAddAbility
local UnitRemoveAbility = jass.UnitRemoveAbility
local IsUnitType = jass.IsUnitType
local GetOwningPlayer = jass.GetOwningPlayer
--- 是否为阿伦劳特（光/暗任一形态）
____exports["是阿伦劳特英雄"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local id = GetUnitTypeId(unit)
    return id == _____5149_5F62_6001_5355_4F4DID or id == _____6697_5F62_6001_5355_4F4DID
end
--- 光形态
____exports["是光形态"] = function(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == _____5149_5F62_6001_5355_4F4DID
end
--- 暗形态
____exports["是暗形态"] = function(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == _____6697_5F62_6001_5355_4F4DID
end
--- 单位是否拥有指定原生 Buff（GetUnitAbilityLevel > 0）
____exports["阿伦劳特拥有原生Buff"] = function(unit, buffId)
    if unit == nil or unit == 0 or buffId == 0 then
        return false
    end
    local abilityId = _____53D6_539F_751FBuff_6280_80FDID(buffId)
    return abilityId ~= 0 and GetUnitAbilityLevel(unit, abilityId) > 0
end
--- 判定：拥有裁决审判（B015）
____exports["拥有裁决审判"] = function(unit)
    return ____exports["阿伦劳特拥有原生Buff"](unit, B015)
end
--- 判定：拥有天堂呼唤（B018）
____exports["拥有天堂呼唤"] = function(unit)
    return ____exports["阿伦劳特拥有原生Buff"](unit, B018)
end
local _____539F_751FBuff_5B9A_65F6_8868 = {}
--- 给单位添加原生 Buff，持续 duration 秒后自动移除；重复添加刷新时长
____exports["添加原生Buff持续"] = function(unit, buffId, duration)
    if unit == nil or unit == 0 or duration <= 0 then
        return
    end
    local abilityId = _____53D6_539F_751FBuff_6280_80FDID(buffId)
    if abilityId == 0 then
        return
    end
    UnitAddAbility(unit, abilityId)
    if GetUnitAbilityLevel(unit, abilityId) <= 0 then
        return
    end
    local unitId = GetHandleId(unit)
    local unitMap = _____539F_751FBuff_5B9A_65F6_8868[unitId]
    if unitMap == nil then
        unitMap = {}
        _____539F_751FBuff_5B9A_65F6_8868[unitId] = unitMap
    end
    local old = unitMap[buffId]
    if old ~= nil and old["定时器ID"] ~= 0 then
        removeDelayedCallback(old["定时器ID"])
    end
    local timerId = addDelayedCallback(
        math.floor(duration * 1000 + 0.5),
        function()
            UnitRemoveAbility(unit, abilityId)
            local map = _____539F_751FBuff_5B9A_65F6_8868[unitId]
            if map ~= nil then
                map[buffId] = nil
            end
        end
    )
    unitMap[buffId] = {["定时器ID"] = timerId}
end
--- 立即移除指定原生 Buff（含定时器清理）
____exports["移除原生Buff"] = function(unit, buffId)
    if unit == nil or unit == 0 then
        return
    end
    local abilityId = _____53D6_539F_751FBuff_6280_80FDID(buffId)
    if abilityId == 0 then
        return
    end
    UnitRemoveAbility(unit, abilityId)
    local unitId = GetHandleId(unit)
    local map = _____539F_751FBuff_5B9A_65F6_8868[unitId]
    if map == nil then
        return
    end
    local record = map[buffId]
    if record ~= nil and record["定时器ID"] ~= 0 then
        removeDelayedCallback(record["定时器ID"])
    end
    map[buffId] = nil
end
--- 目标过滤：排除古树/机械/建筑 + 存活
____exports["是有效目标"] = function(target)
    if target == nil or target == 0 then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_DEAD) then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_ANCIENT) then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_MECHANICAL) then
        return false
    end
    if IsUnitType(target, jass.UNIT_TYPE_STRUCTURE) then
        return false
    end
    return true
end
--- 两点角度（度）
____exports["两点角度"] = function(x1, y1, x2, y2)
    return Atan2(y2 - y1, x2 - x1) * _____5F27_5EA6_8F6C_89D2_5EA6
end
--- 两点距离
____exports["两点距离"] = function(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return math.sqrt(dx * dx + dy * dy)
end
return ____exports
