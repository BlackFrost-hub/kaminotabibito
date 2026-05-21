--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_653B_51FB_6548_679C_5DE5_5177 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.01．攻击效果工具")
local _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位持有攻击效果装备"]
local _____5355_4F4D_6709_6548_5B58_6D3B = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["单位有效存活"]
local _____653B_51FB_8005_7C7B_578B_6EE1_8DB3 = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["攻击者类型满足"]
local _____53D6_5F53_524D_751F_547D = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取当前生命"]
local _____53D6_6700_5927_751F_547D = ____01_FF0E_653B_51FB_6548_679C_5DE5_5177["取最大生命"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口")
local SFB_setSlow = ____require_result_2.SFB_setSlow
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____88C5_5907_540D = "|cff993300恶魔王爪|r"
local _____6076_9B54_4F24_5BB3_63D0_9AD8 = 0.15
local _____6495_88C2_6301_7EED_6BEB_79D2 = 3000
local _____6495_88C2_95F4_9694_6BEB_79D2 = 1000
local _____5DF2_635F_5931_751F_547D_771F_5B9E_4F24_5BB3_6BD4_4F8B = 0.02
local _____51CF_901F_6BD4_4F8B = 0.15
local _____51CF_901F_6301_7EED_79D2 = 3
local _____6495_88C2_8BB0_5F55_5217_8868 = {}
local _____6495_88C2Tick_5DF2_6CE8_518C = false
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit)
end
local function _____53D6_6495_88C2_952E(source, target)
    local sourceId = _____53D6_5355_4F4D_53E5_67C4ID(source)
    local targetId = _____53D6_5355_4F4D_53E5_67C4ID(target)
    if sourceId == 0 or targetId == 0 then
        return ""
    end
    return (tostring(sourceId) .. ":") .. tostring(targetId)
end
local function _____8BA1_7B97_5DF2_635F_5931_751F_547D_771F_5B9E_4F24_5BB3(target)
    local maxLife = _____53D6_6700_5927_751F_547D(target)
    local currentLife = _____53D6_5F53_524D_751F_547D(target)
    if not (maxLife > currentLife) then
        return 0
    end
    return (maxLife - currentLife) * _____5DF2_635F_5931_751F_547D_771F_5B9E_4F24_5BB3_6BD4_4F8B
end
local function _____9020_6210_6076_9B54_738B_722A_771F_5B9E_4F24_5BB3(source, target)
    if not _____5355_4F4D_6709_6548_5B58_6D3B(source) or not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    local amount = _____8BA1_7B97_5DF2_635F_5931_751F_547D_771F_5B9E_4F24_5BB3(target)
    if not (amount > 0) then
        return
    end
    UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_MIND,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function ____on_6076_9B54_738B_722A_6495_88C2Tick()
    local now = getServerTime()
    local write = 0
    do
        local i = 0
        while i < #_____6495_88C2_8BB0_5F55_5217_8868 do
            do
                local record = _____6495_88C2_8BB0_5F55_5217_8868[i + 1]
                if record == nil then
                    goto __continue13
                end
                if now >= record.expireTime or not _____5355_4F4D_6709_6548_5B58_6D3B(record.source) or not _____5355_4F4D_6709_6548_5B58_6D3B(record.target) then
                    goto __continue13
                end
                if now >= record.nextTickTime then
                    _____9020_6210_6076_9B54_738B_722A_771F_5B9E_4F24_5BB3(record.source, record.target)
                    record.nextTickTime = now + _____6495_88C2_95F4_9694_6BEB_79D2
                end
                _____6495_88C2_8BB0_5F55_5217_8868[write + 1] = record
                write = write + 1
            end
            ::__continue13::
            i = i + 1
        end
    end
    while #_____6495_88C2_8BB0_5F55_5217_8868 > write do
        table.remove(_____6495_88C2_8BB0_5F55_5217_8868)
    end
end
local function _____786E_4FDD_6CE8_518C_6495_88C2Tick()
    if _____6495_88C2Tick_5DF2_6CE8_518C then
        return
    end
    _____6495_88C2Tick_5DF2_6CE8_518C = true
    addPeriodicCallback(100, ____on_6076_9B54_738B_722A_6495_88C2Tick)
end
local function _____65BD_52A0_6216_5237_65B0_6495_88C2(source, target)
    local key = _____53D6_6495_88C2_952E(source, target)
    if key == "" then
        return
    end
    local now = getServerTime()
    do
        local i = 0
        while i < #_____6495_88C2_8BB0_5F55_5217_8868 do
            do
                local record = _____6495_88C2_8BB0_5F55_5217_8868[i + 1]
                if record == nil or record.key ~= key then
                    goto __continue23
                end
                record.expireTime = now + _____6495_88C2_6301_7EED_6BEB_79D2
                return
            end
            ::__continue23::
            i = i + 1
        end
    end
    _____6495_88C2_8BB0_5F55_5217_8868[#_____6495_88C2_8BB0_5F55_5217_8868 + 1] = {
        key = key,
        source = source,
        target = target,
        expireTime = now + _____6495_88C2_6301_7EED_6BEB_79D2,
        nextTickTime = now + _____6495_88C2_95F4_9694_6BEB_79D2
    }
    _____786E_4FDD_6CE8_518C_6495_88C2Tick()
end
local function ____on_6076_9B54_738B_722A_6700_7EC8_4F24_5BB3(target, attacker, applied, snapshot)
    if not (applied > 0) then
        return
    end
    if snapshot == nil or snapshot.isPhysicalDamage ~= true or snapshot.isTrueDamage == true then
        return
    end
    if not _____5355_4F4D_6709_6548_5B58_6D3B(attacker) or not _____5355_4F4D_6709_6548_5B58_6D3B(target) then
        return
    end
    if not _____5355_4F4D_6301_6709_653B_51FB_6548_679C_88C5_5907(attacker, _____88C5_5907_540D) then
        return
    end
    if not _____653B_51FB_8005_7C7B_578B_6EE1_8DB3(attacker, "近战") then
        return
    end
    SFB_setSlow(
        attacker,
        target,
        0,
        _____51CF_901F_6BD4_4F8B,
        _____51CF_901F_6301_7EED_79D2
    )
    _____65BD_52A0_6216_5237_65B0_6495_88C2(attacker, target)
end
registerAppliedFinalDamageListener(____on_6076_9B54_738B_722A_6700_7EC8_4F24_5BB3)
return ____exports
