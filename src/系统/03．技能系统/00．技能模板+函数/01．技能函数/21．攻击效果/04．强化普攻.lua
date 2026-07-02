local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getGameTime = ____require_result_0.getGameTime
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local DzSetUnitMissileModel = japi.DzSetUnitMissileModel
local DzSetUnitMissileArc = japi.DzSetUnitMissileArc
local DzSetUnitMissileSpeed = japi.DzSetUnitMissileSpeed
local DzSetUnitMissileHoming = japi.DzSetUnitMissileHoming
local _____9ED8_8BA4_5F3A_5316_666E_653B_540D_79F0 = "默认强化普攻"
local _____5F3A_5316_666E_653B_72B6_6001_8868 = {}
local _____5DF2_6CE8_518C_5F3A_5316_666E_653B_4F24_5BB3_4FEE_6B63 = false
local _____5F3A_5316_666E_653B_6E05_7406_8BA1_65F6_5668ID = 0
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
local function _____53D6_72B6_6001_540D_79F0(_____540D_79F0)
    return _____540D_79F0 ~= nil and _____540D_79F0 ~= "" and _____540D_79F0 or _____9ED8_8BA4_5F3A_5316_666E_653B_540D_79F0
end
local function _____53D6_72B6_6001_952E(unit, _____540D_79F0)
    local id = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if id <= 0 then
        return ""
    end
    return (tostring(id) .. ":") .. _____53D6_72B6_6001_540D_79F0(_____540D_79F0)
end
local function _____5E94_7528_5F39_9053_914D_7F6E(unit, _____914D_7F6E)
    if not _____5355_4F4D_6709_6548(unit) or _____914D_7F6E == nil then
        return
    end
    if _____914D_7F6E["模型"] ~= nil and DzSetUnitMissileModel ~= nil then
        DzSetUnitMissileModel(unit, _____914D_7F6E["模型"])
    end
    if _____914D_7F6E["弧度"] ~= nil and DzSetUnitMissileArc ~= nil then
        DzSetUnitMissileArc(unit, _____914D_7F6E["弧度"])
    end
    if _____914D_7F6E["速度"] ~= nil and DzSetUnitMissileSpeed ~= nil then
        DzSetUnitMissileSpeed(unit, _____914D_7F6E["速度"])
    end
    if _____914D_7F6E["自导"] ~= nil and DzSetUnitMissileHoming ~= nil then
        DzSetUnitMissileHoming(unit, _____914D_7F6E["自导"])
    end
end
local function _____662F_5426_6709_5F3A_5316_666E_653B_72B6_6001()
    for key in pairs(_____5F3A_5316_666E_653B_72B6_6001_8868) do
        if _____5F3A_5316_666E_653B_72B6_6001_8868[key] ~= nil then
            return true
        end
    end
    return false
end
local function _____505C_6B62_5F3A_5316_666E_653B_6E05_7406()
    if _____5F3A_5316_666E_653B_6E05_7406_8BA1_65F6_5668ID == 0 then
        return
    end
    if _____662F_5426_6709_5F3A_5316_666E_653B_72B6_6001() then
        return
    end
    removePeriodicCallback(_____5F3A_5316_666E_653B_6E05_7406_8BA1_65F6_5668ID)
    _____5F3A_5316_666E_653B_6E05_7406_8BA1_65F6_5668ID = 0
end
local function _____7ED3_675F_5F3A_5316_666E_653B_72B6_6001(key, _____539F_56E0)
    local _____72B6_6001 = _____5F3A_5316_666E_653B_72B6_6001_8868[key]
    if _____72B6_6001 == nil then
        return
    end
    __TS__Delete(_____5F3A_5316_666E_653B_72B6_6001_8868, key)
    _____5E94_7528_5F39_9053_914D_7F6E(_____72B6_6001["单位"], _____72B6_6001["恢复弹道"])
    if _____72B6_6001["on结束"] ~= nil then
        _____72B6_6001["on结束"]({["单位"] = _____72B6_6001["单位"], ["状态名称"] = _____72B6_6001["名称"], ["剩余次数"] = _____72B6_6001["剩余次数"], ["原因"] = _____539F_56E0})
    end
    _____505C_6B62_5F3A_5316_666E_653B_6E05_7406()
end
local function _____6E05_7406_8FC7_671F_5F3A_5316_666E_653B()
    local now = getGameTime()
    for key in pairs(_____5F3A_5316_666E_653B_72B6_6001_8868) do
        do
            local _____72B6_6001 = _____5F3A_5316_666E_653B_72B6_6001_8868[key]
            if _____72B6_6001 == nil then
                goto __continue25
            end
            if not _____5355_4F4D_6709_6548(_____72B6_6001["单位"]) then
                _____7ED3_675F_5F3A_5316_666E_653B_72B6_6001(key, "单位死亡")
            elseif _____72B6_6001["过期时间"] > 0 and now >= _____72B6_6001["过期时间"] then
                _____7ED3_675F_5F3A_5316_666E_653B_72B6_6001(key, "超时")
            end
        end
        ::__continue25::
    end
    _____505C_6B62_5F3A_5316_666E_653B_6E05_7406()
end
local function _____786E_4FDD_5F3A_5316_666E_653B_6E05_7406()
    if _____5F3A_5316_666E_653B_6E05_7406_8BA1_65F6_5668ID ~= 0 then
        return
    end
    _____5F3A_5316_666E_653B_6E05_7406_8BA1_65F6_5668ID = addPeriodicCallback(250, _____6E05_7406_8FC7_671F_5F3A_5316_666E_653B)
end
local function _____5F3A_5316_666E_653B_6761_4EF6_901A_8FC7(_____72B6_6001, context)
    if context == nil or context.isNormalAttack ~= true then
        return false
    end
    if not _____72B6_6001["允许技能普攻"] and (context.isSkillAttack == true or context.isSkillDamage == true) then
        return false
    end
    if context.attacker ~= _____72B6_6001["单位"] then
        return false
    end
    if not _____5355_4F4D_6709_6548(_____72B6_6001["单位"]) or not _____5355_4F4D_6709_6548(context.target) then
        return false
    end
    if _____72B6_6001["仅远程"] and context.isRangedAttack ~= true then
        return false
    end
    if _____72B6_6001["仅近战"] and context.isRangedAttack == true then
        return false
    end
    if not (_____72B6_6001["剩余次数"] > 0) then
        return false
    end
    local now = getGameTime()
    if _____72B6_6001["过期时间"] > 0 and now >= _____72B6_6001["过期时间"] then
        return false
    end
    return true
end
local function ____on_5F3A_5316_666E_653B_4F24_5BB3_4FEE_6B63(context)
    local _____5F53_524D_4F24_5BB3 = context.currentDamage
    for key in pairs(_____5F3A_5316_666E_653B_72B6_6001_8868) do
        do
            local _____72B6_6001 = _____5F3A_5316_666E_653B_72B6_6001_8868[key]
            if _____72B6_6001 == nil then
                goto __continue42
            end
            if not _____5F3A_5316_666E_653B_6761_4EF6_901A_8FC7(_____72B6_6001, context) then
                goto __continue42
            end
            local _____539F_4F24_5BB3 = _____5F53_524D_4F24_5BB3
            _____5F53_524D_4F24_5BB3 = _____5F53_524D_4F24_5BB3 * _____72B6_6001["伤害倍率"] + _____72B6_6001["额外伤害"]
            _____72B6_6001["剩余次数"] = _____72B6_6001["剩余次数"] - 1
            if _____72B6_6001["on命中"] ~= nil then
                _____72B6_6001["on命中"]({
                    ["单位"] = _____72B6_6001["单位"],
                    ["目标"] = context.target,
                    ["原伤害"] = _____539F_4F24_5BB3,
                    ["当前伤害"] = context.currentDamage,
                    ["修正后伤害"] = _____5F53_524D_4F24_5BB3,
                    ["剩余次数"] = _____72B6_6001["剩余次数"],
                    ["状态名称"] = _____72B6_6001["名称"],
                    ["伤害上下文"] = context
                })
            end
            if _____72B6_6001["剩余次数"] <= 0 then
                _____7ED3_675F_5F3A_5316_666E_653B_72B6_6001(key, "次数耗尽")
            end
        end
        ::__continue42::
    end
    return _____5F53_524D_4F24_5BB3
end
local function _____786E_4FDD_5F3A_5316_666E_653B_4F24_5BB3_4FEE_6B63()
    if _____5DF2_6CE8_518C_5F3A_5316_666E_653B_4F24_5BB3_4FEE_6B63 then
        return
    end
    _____5DF2_6CE8_518C_5F3A_5316_666E_653B_4F24_5BB3_4FEE_6B63 = true
    registerDamageModifier(____on_5F3A_5316_666E_653B_4F24_5BB3_4FEE_6B63, 45)
end
____exports["添加强化普攻"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or not _____5355_4F4D_6709_6548(_____53C2_6570["单位"]) then
        return false
    end
    local _____6B21_6570 = _____53C2_6570["次数"] or _____53C2_6570["最多强化次数"] or 1
    if not (_____6B21_6570 > 0) then
        return false
    end
    local _____540D_79F0 = _____53D6_72B6_6001_540D_79F0(_____53C2_6570["名称"])
    local key = _____53D6_72B6_6001_952E(_____53C2_6570["单位"], _____540D_79F0)
    if key == "" then
        return false
    end
    if _____5F3A_5316_666E_653B_72B6_6001_8868[key] ~= nil then
        _____7ED3_675F_5F3A_5316_666E_653B_72B6_6001(key, "刷新覆盖")
    end
    local _____6301_7EED_6BEB_79D2 = _____53C2_6570["持续毫秒"] or (_____53C2_6570["持续时间"] or 0) * 1000
    local now = getGameTime()
    _____5F3A_5316_666E_653B_72B6_6001_8868[key] = {
        ["单位"] = _____53C2_6570["单位"],
        ["名称"] = _____540D_79F0,
        ["剩余次数"] = _____6B21_6570,
        ["过期时间"] = _____6301_7EED_6BEB_79D2 > 0 and now + _____6301_7EED_6BEB_79D2 or 0,
        ["伤害倍率"] = _____53C2_6570["伤害倍率"] ~= nil and _____53C2_6570["伤害倍率"] > 0 and _____53C2_6570["伤害倍率"] or 1,
        ["额外伤害"] = _____53C2_6570["额外伤害"] or 0,
        ["仅远程"] = _____53C2_6570["仅远程"] == true,
        ["仅近战"] = _____53C2_6570["仅近战"] == true,
        ["允许技能普攻"] = _____53C2_6570["允许技能普攻"] == true,
        ["恢复弹道"] = _____53C2_6570["恢复弹道"],
        ["on命中"] = _____53C2_6570["on命中"],
        ["on结束"] = _____53C2_6570["on结束"]
    }
    _____5E94_7528_5F39_9053_914D_7F6E(_____53C2_6570["单位"], _____53C2_6570["弹道"])
    _____786E_4FDD_5F3A_5316_666E_653B_4F24_5BB3_4FEE_6B63()
    _____786E_4FDD_5F3A_5316_666E_653B_6E05_7406()
    return true
end
____exports["清除强化普攻"] = function(_____5355_4F4D, _____540D_79F0)
    local key = _____53D6_72B6_6001_952E(_____5355_4F4D, _____540D_79F0)
    if key == "" then
        return
    end
    _____7ED3_675F_5F3A_5316_666E_653B_72B6_6001(key, "手动清除")
end
____exports["获取强化普攻状态"] = function(_____5355_4F4D, _____540D_79F0)
    local key = _____53D6_72B6_6001_952E(_____5355_4F4D, _____540D_79F0)
    if key == "" then
        return nil
    end
    local _____72B6_6001 = _____5F3A_5316_666E_653B_72B6_6001_8868[key]
    if _____72B6_6001 == nil then
        return nil
    end
    return {
        ["单位"] = _____72B6_6001["单位"],
        ["名称"] = _____72B6_6001["名称"],
        ["剩余次数"] = _____72B6_6001["剩余次数"],
        ["过期时间"] = _____72B6_6001["过期时间"],
        ["伤害倍率"] = _____72B6_6001["伤害倍率"],
        ["额外伤害"] = _____72B6_6001["额外伤害"]
    }
end
____exports["单位拥有强化普攻"] = function(_____5355_4F4D, _____540D_79F0)
    return ____exports["获取强化普攻状态"](_____5355_4F4D, _____540D_79F0) ~= nil
end
return ____exports
