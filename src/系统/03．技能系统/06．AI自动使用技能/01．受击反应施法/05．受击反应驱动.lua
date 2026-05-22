local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local ____01_FF0E_5355_4F4D_540D_53CD_67E5 = require("系统.03．技能系统.06．AI自动使用技能.01．受击反应施法.01．单位名反查")
local _____6309_540D_5B57_53CD_67E5_4EFB_610F_5355_4F4DID = ____01_FF0E_5355_4F4D_540D_53CD_67E5["按名字反查任意单位ID"]
local ____02_FF0E_53D7_51FB_53CD_5E94_914D_7F6E_8868 = require("系统.03．技能系统.06．AI自动使用技能.01．受击反应施法.02．受击反应配置表")
local _____53D7_51FB_53CD_5E94_914D_7F6E_8868 = ____02_FF0E_53D7_51FB_53CD_5E94_914D_7F6E_8868["受击反应配置表"]
local ____03_FF0E_53D7_51FB_53CD_5E94_7279_6B8A_903B_8F91 = require("系统.03．技能系统.06．AI自动使用技能.01．受击反应施法.03．受击反应特殊逻辑")
local _____6267_884C_53D7_51FB_53CD_5E94_7279_6B8A_903B_8F91 = ____03_FF0E_53D7_51FB_53CD_5E94_7279_6B8A_903B_8F91["执行受击反应特殊逻辑"]
local ____04_FF0E_53D7_51FB_53CD_5E94_6267_884C = require("系统.03．技能系统.06．AI自动使用技能.01．受击反应施法.04．受击反应执行")
local _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD = ____04_FF0E_53D7_51FB_53CD_5E94_6267_884C["尝试执行受击技能"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换")
local stringToFourCC = ____require_result_0.stringToFourCC
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_3.registerAppliedFinalDamageListener
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitTypeId = jass.GetUnitTypeId
local _____5DF2_521D_59CB_5316 = false
local _____53D7_51FB_53CD_5E94_914D_7F6E_7D22_5F15 = {}
local _____5355_4F4D_72EC_7ACB_51B7_5374_8868 = {}
local function _____6784_5EFA_914D_7F6E_7D22_5F15()
    local _____5217_8868 = _____53D7_51FB_53CD_5E94_914D_7F6E_8868
    do
        local i = 0
        while i < #_____5217_8868 do
            do
                local _____914D_7F6E = _____5217_8868[i + 1]
                local rawcode = _____6309_540D_5B57_53CD_67E5_4EFB_610F_5355_4F4DID(_____914D_7F6E["单位名"])
                if rawcode == nil or rawcode == "" then
                    goto __continue4
                end
                local typeId = stringToFourCC(rawcode)
                local _____89E3_6790_914D_7F6E = __TS__ObjectAssign({}, _____914D_7F6E, {["单位类型ID"] = typeId})
                if _____53D7_51FB_53CD_5E94_914D_7F6E_7D22_5F15[typeId] == nil then
                    _____53D7_51FB_53CD_5E94_914D_7F6E_7D22_5F15[typeId] = {}
                end
                local ____53D7_51FB_53CD_5E94_914D_7F6E_7D22_5F15_typeId_4 = _____53D7_51FB_53CD_5E94_914D_7F6E_7D22_5F15[typeId]
                ____53D7_51FB_53CD_5E94_914D_7F6E_7D22_5F15_typeId_4[#____53D7_51FB_53CD_5E94_914D_7F6E_7D22_5F15_typeId_4 + 1] = _____89E3_6790_914D_7F6E
            end
            ::__continue4::
            i = i + 1
        end
    end
end
local function _____4F24_5BB3_6765_6E90_662F_5426_6CE8_518C_73A9_5BB6_82F1_96C4(attacker)
    if attacker == nil or attacker == 0 then
        return false
    end
    local owner = GetOwningPlayer(attacker)
    if owner == nil or owner == 0 then
        return false
    end
    return getRegisteredPlayerHero(owner) == attacker
end
local function _____5904_4E8E_5355_4F4D_72EC_7ACB_51B7_5374_4E2D(unit)
    local handleId = GetHandleId(unit)
    local dueTime = _____5355_4F4D_72EC_7ACB_51B7_5374_8868[handleId] or 0
    return dueTime > getServerTime()
end
local function _____5237_65B0_5355_4F4D_72EC_7ACB_51B7_5374(unit, cooldownMs)
    local handleId = GetHandleId(unit)
    _____5355_4F4D_72EC_7ACB_51B7_5374_8868[handleId] = getServerTime() + cooldownMs
end
local function _____6267_884C_8868_9A71_52A8_53D7_51FB_53CD_5E94(config, target, attacker)
    local skills = config["技能列表"]
    if skills == nil or #skills <= 0 then
        return false
    end
    local executed = false
    do
        local i = 0
        while i < #skills do
            if _____5C1D_8BD5_6267_884C_53D7_51FB_6280_80FD(skills[i + 1], target, attacker) then
                executed = true
            end
            i = i + 1
        end
    end
    return executed
end
local function onAppliedFinalDamage(target, attacker, applied, _snapshot)
    if target == nil or target == 0 or attacker == nil or attacker == 0 then
        return
    end
    if applied < 1 then
        return
    end
    if not _____4F24_5BB3_6765_6E90_662F_5426_6CE8_518C_73A9_5BB6_82F1_96C4(attacker) then
        return
    end
    local typeId = GetUnitTypeId(target)
    local configs = _____53D7_51FB_53CD_5E94_914D_7F6E_7D22_5F15[typeId]
    if configs == nil or #configs <= 0 then
        return
    end
    if _____5904_4E8E_5355_4F4D_72EC_7ACB_51B7_5374_4E2D(target) then
        return
    end
    do
        local i = 0
        while i < #configs do
            do
                local config = configs[i + 1]
                if (config["最小受伤值"] or 1) > applied then
                    goto __continue24
                end
                if config["要求伤害来源为注册玩家英雄"] ~= false and not _____4F24_5BB3_6765_6E90_662F_5426_6CE8_518C_73A9_5BB6_82F1_96C4(attacker) then
                    goto __continue24
                end
                local executed = false
                if config["特殊逻辑名"] ~= nil and config["特殊逻辑名"] ~= "" then
                    executed = _____6267_884C_53D7_51FB_53CD_5E94_7279_6B8A_903B_8F91(config, target, attacker)
                else
                    executed = _____6267_884C_8868_9A71_52A8_53D7_51FB_53CD_5E94(config, target, attacker)
                end
                if executed then
                    _____5237_65B0_5355_4F4D_72EC_7ACB_51B7_5374(target, config["单位独立冷却Ms"] or 1050)
                    return
                end
            end
            ::__continue24::
            i = i + 1
        end
    end
end
____exports["init受击反应施法"] = function()
    if _____5DF2_521D_59CB_5316 then
        return
    end
    _____5DF2_521D_59CB_5316 = true
    _____6784_5EFA_914D_7F6E_7D22_5F15()
    registerAppliedFinalDamageListener(onAppliedFinalDamage)
end
return ____exports
