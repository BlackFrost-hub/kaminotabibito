--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.00．伤害事件配置表")
local _____4F24_5BB3_4E8B_4EF6_88C5_5907ID = ____00_FF0E_4F24_5BB3_4E8B_4EF6_914D_7F6E_8868["伤害事件装备ID"]
local ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177 = require("系统.02．物品系统.15．装备技能.04．伤害事件.00．公共.01．伤害事件工具")
local _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["单位持有伤害事件装备"]
local _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3 = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["造成伤害事件伤害"]
local _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B = ____01_FF0E_4F24_5BB3_4E8B_4EF6_5DE5_5177["伤害事件伤害类型"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local _____6708_5149_9501_94FE_62A4_8155_63A7_5236Buff_5217_8868 = {
    "C001",
    "C002",
    "C003",
    "C004",
    "C005",
    "C006",
    "C007",
    "C008",
    "C009",
    "C023"
}
local _____6708_5149_9501_94FE_62A4_8155_63A7_5236BuffID_5217_8868 = {}
local _____6708_5149_9501_94FE_62A4_8155_51B7_5374_8868 = {}
local _____6708_5149_9501_94FE_62A4_8155_51CF_4F24_5230_671F_8868 = {}
local _____6708_5149_9501_94FE_62A4_8155_53CD_4F24_961F_5217 = {}
local function _____521D_59CB_5316_6708_5149_9501_94FE_62A4_8155BuffID()
    if #_____6708_5149_9501_94FE_62A4_8155_63A7_5236BuffID_5217_8868 > 0 then
        return
    end
    do
        local i = 0
        while i < #_____6708_5149_9501_94FE_62A4_8155_63A7_5236Buff_5217_8868 do
            local id = stringToFourCCSafe(_____6708_5149_9501_94FE_62A4_8155_63A7_5236Buff_5217_8868[i + 1])
            if id ~= 0 then
                _____6708_5149_9501_94FE_62A4_8155_63A7_5236BuffID_5217_8868[#_____6708_5149_9501_94FE_62A4_8155_63A7_5236BuffID_5217_8868 + 1] = id
            end
            i = i + 1
        end
    end
end
local function _____5355_4F4D_5904_4E8E_63A7_5236_4E2D(unit)
    if unit == nil or unit == 0 then
        return false
    end
    _____521D_59CB_5316_6708_5149_9501_94FE_62A4_8155BuffID()
    do
        local i = 0
        while i < #_____6708_5149_9501_94FE_62A4_8155_63A7_5236BuffID_5217_8868 do
            if GetUnitAbilityLevel(unit, _____6708_5149_9501_94FE_62A4_8155_63A7_5236BuffID_5217_8868[i + 1]) > 0 then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____6708_5149_9501_94FE_62A4_8155_51B7_5374_901A_8FC7(unitId)
    if unitId == 0 then
        return false
    end
    local now = getServerTime()
    local last = _____6708_5149_9501_94FE_62A4_8155_51B7_5374_8868[unitId]
    if last ~= nil and now - last < 12000 then
        return false
    end
    _____6708_5149_9501_94FE_62A4_8155_51B7_5374_8868[unitId] = now
    _____6708_5149_9501_94FE_62A4_8155_51CF_4F24_5230_671F_8868[unitId] = now + 2000
    return true
end
local function _____6708_5149_9501_94FE_62A4_8155_51CF_4F24_4E2D(unitId)
    if unitId == 0 then
        return false
    end
    local ____end = _____6708_5149_9501_94FE_62A4_8155_51CF_4F24_5230_671F_8868[unitId]
    return ____end ~= nil and getServerTime() < ____end
end
local function _____6267_884C_6708_5149_9501_94FE_62A4_8155_53CD_4F24()
    while #_____6708_5149_9501_94FE_62A4_8155_53CD_4F24_961F_5217 > 0 do
        do
            local item = table.remove(_____6708_5149_9501_94FE_62A4_8155_53CD_4F24_961F_5217, 1)
            if item == nil then
                goto __continue20
            end
            _____9020_6210_4F24_5BB3_4E8B_4EF6_4F24_5BB3(item.source, item.target, item.amount, _____4F24_5BB3_4E8B_4EF6_4F24_5BB3_7C7B_578B["强化"])
        end
        ::__continue20::
    end
end
____exports["处理月光锁链护腕伤害修正"] = function(context)
    local target = context.target
    local attacker = context.attacker
    if target == nil or target == 0 or attacker == nil or attacker == 0 then
        return context.currentDamage
    end
    if not _____5355_4F4D_6301_6709_4F24_5BB3_4E8B_4EF6_88C5_5907(target, _____4F24_5BB3_4E8B_4EF6_88C5_5907ID["月光锁链护腕"]) then
        return context.currentDamage
    end
    local targetId = _____53D6_5355_4F4D_53E5_67C4ID(target)
    if _____5355_4F4D_5904_4E8E_63A7_5236_4E2D(target) and _____6708_5149_9501_94FE_62A4_8155_51B7_5374_901A_8FC7(targetId) then
        _____6708_5149_9501_94FE_62A4_8155_53CD_4F24_961F_5217[#_____6708_5149_9501_94FE_62A4_8155_53CD_4F24_961F_5217 + 1] = {source = target, target = attacker, amount = context.currentDamage * 0.3}
        addDelayedCallback(1, _____6267_884C_6708_5149_9501_94FE_62A4_8155_53CD_4F24)
    end
    if not _____6708_5149_9501_94FE_62A4_8155_51CF_4F24_4E2D(targetId) then
        return context.currentDamage
    end
    return context.currentDamage * 0.7
end
return ____exports
