local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local createDelayedCall = ____require_result_0.createDelayedCall
local cancelDelayedCall = ____require_result_0.cancelDelayedCall
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetHandleId = jass.GetHandleId
local _____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808 = {}
local _____6280_80FD_4F24_5BB3_5B9E_4F8B_8868 = {}
local _____6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C_5217_8868 = {}
local _____5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868 = {}
local _____5355_4F4D_6280_80FD_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868 = {}
local _____6280_80FD_4F24_5BB3_5B9E_4F8B_81EA_589EID = 0
local function _____901A_77E5_6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F(id)
    do
        local i = 0
        while i < #_____6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C_5217_8868 do
            local cb = _____6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C_5217_8868[i + 1]
            if cb ~= nil then
                cb(id)
            end
            i = i + 1
        end
    end
end
local function _____6E05_7406_6280_80FD_4F24_5BB3_5B9E_4F8B(id, cancelTimer)
    local record = _____6280_80FD_4F24_5BB3_5B9E_4F8B_8868[id]
    if record == nil then
        return
    end
    if cancelTimer and record.expireHandle ~= nil then
        cancelDelayedCall(record.expireHandle)
    end
    if record.sourceHandleId ~= nil and _____5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868[record.sourceHandleId] == id then
        __TS__Delete(_____5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868, record.sourceHandleId)
    end
    if record.sourceSkillKey ~= nil and _____5355_4F4D_6280_80FD_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868[record.sourceSkillKey] == id then
        __TS__Delete(_____5355_4F4D_6280_80FD_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868, record.sourceSkillKey)
    end
    __TS__Delete(_____6280_80FD_4F24_5BB3_5B9E_4F8B_8868, id)
    _____901A_77E5_6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F(id)
end
local function _____53D6_6280_80FD_4F24_5BB3_5B9E_4F8B_6301_7EED_79D2(_____53C2_6570)
    if (_____53C2_6570 and _____53C2_6570["持续时间秒"]) ~= nil and _____53C2_6570["持续时间秒"] > 0 then
        return _____53C2_6570["持续时间秒"]
    end
    if (_____53C2_6570 and _____53C2_6570["持续时间Ms"]) ~= nil and _____53C2_6570["持续时间Ms"] > 0 then
        return _____53C2_6570["持续时间Ms"] / 1000
    end
    return 8
end
____exports["创建技能伤害实例"] = function(_____53C2_6570)
    _____6280_80FD_4F24_5BB3_5B9E_4F8B_81EA_589EID = _____6280_80FD_4F24_5BB3_5B9E_4F8B_81EA_589EID + 1
    local id = _____6280_80FD_4F24_5BB3_5B9E_4F8B_81EA_589EID
    local durationSec = _____53D6_6280_80FD_4F24_5BB3_5B9E_4F8B_6301_7EED_79D2(_____53C2_6570)
    local record = {
        id = id,
        abilityId = _____53C2_6570 and _____53C2_6570["技能ID"],
        sourceKind = _____53C2_6570 and _____53C2_6570["来源类型"],
        tag = _____53C2_6570 and _____53C2_6570["标签"],
        hasFirstHit = false
    }
    record.expireHandle = createDelayedCall(
        durationSec,
        function()
            _____6E05_7406_6280_80FD_4F24_5BB3_5B9E_4F8B(id, false)
        end
    )
    _____6280_80FD_4F24_5BB3_5B9E_4F8B_8868[id] = record
    return id
end
____exports["创建独立技能伤害实例"] = function(_____53C2_6570)
    return ____exports["创建技能伤害实例"](_____53C2_6570)
end
____exports["结束技能伤害实例"] = function(id)
    if id == nil or id <= 0 then
        return
    end
    _____6E05_7406_6280_80FD_4F24_5BB3_5B9E_4F8B(id, true)
end
____exports["结束独立技能伤害实例"] = function(id)
    ____exports["结束技能伤害实例"](id)
end
____exports["注册技能伤害实例结束监听"] = function(cb)
    if cb == nil then
        return
    end
    do
        local i = 0
        while i < #_____6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C_5217_8868 do
            if _____6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C_5217_8868[i + 1] == cb then
                return
            end
            i = i + 1
        end
    end
    _____6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C_5217_8868[#_____6280_80FD_4F24_5BB3_5B9E_4F8B_7ED3_675F_76D1_542C_5217_8868 + 1] = cb
end
____exports["技能伤害实例存在"] = function(id)
    return id ~= nil and id > 0 and _____6280_80FD_4F24_5BB3_5B9E_4F8B_8868[id] ~= nil
end
____exports["绑定单位当前独立技能伤害实例"] = function(_____5355_4F4D, id)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or id == nil or id <= 0 then
        return
    end
    local record = _____6280_80FD_4F24_5BB3_5B9E_4F8B_8868[id]
    if record == nil then
        return
    end
    local handleId = GetHandleId(_____5355_4F4D)
    record.sourceHandleId = handleId
    _____5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868[handleId] = id
    if record.abilityId ~= nil and record.abilityId > 0 then
        local skillKey = (tostring(handleId) .. "#") .. tostring(record.abilityId)
        record.sourceSkillKey = skillKey
        _____5355_4F4D_6280_80FD_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868[skillKey] = id
    end
end
local function _____53D6_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____5355_4F4D, _____6280_80FDID)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return nil
    end
    if _____6280_80FDID == nil or _____6280_80FDID <= 0 then
        return nil
    end
    local handleId = GetHandleId(_____5355_4F4D)
    local id = _____5355_4F4D_6280_80FD_5F53_524D_72EC_7ACB_6280_80FD_5B9E_4F8B_8868[(tostring(handleId) .. "#") .. tostring(_____6280_80FDID)]
    local _____6280_80FD_4F24_5BB3_5B9E_4F8B_5B58_5728_result_11
    if ____exports["技能伤害实例存在"](id) then
        _____6280_80FD_4F24_5BB3_5B9E_4F8B_5B58_5728_result_11 = id
    else
        _____6280_80FD_4F24_5BB3_5B9E_4F8B_5B58_5728_result_11 = nil
    end
    return _____6280_80FD_4F24_5BB3_5B9E_4F8B_5B58_5728_result_11
end
____exports["标记技能伤害实例首次命中"] = function(id)
    if id == nil or id <= 0 then
        return false
    end
    local record = _____6280_80FD_4F24_5BB3_5B9E_4F8B_8868[id]
    if record == nil or record.hasFirstHit then
        return false
    end
    record.hasFirstHit = true
    return true
end
____exports["是独立技能伤害快照"] = function(snapshot)
    return snapshot ~= nil and snapshot.isWrappedSkillDamage == true and snapshot.isEquipmentSkillDamage ~= true and snapshot.isIndependentSkillDamage == true and snapshot.skillInstanceId ~= nil and snapshot.skillInstanceId > 0
end
____exports["是装备技能伤害来源类型"] = function(_____6765_6E90_7C7B_578B)
    return _____6765_6E90_7C7B_578B == "装备技能" or _____6765_6E90_7C7B_578B == "装备主动" or _____6765_6E90_7C7B_578B == "装备被动" or _____6765_6E90_7C7B_578B == "物品技能" or _____6765_6E90_7C7B_578B == "装备持续伤害" or _____6765_6E90_7C7B_578B == "攻击特效" or _____6765_6E90_7C7B_578B == "普攻强化"
end
____exports["获取当前技能伤害上下文"] = function()
    if #_____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808 <= 0 then
        return nil
    end
    return _____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808[#_____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808] or nil
end
local function _____521B_5EFA_6280_80FD_4F24_5BB3_4E0A_4E0B_6587(_____53C2_6570)
    local _____6765_6E90_7C7B_578B = _____53C2_6570["来源类型"] or _____53C2_6570["装备技能类型"] or "单位技能"
    local isEquipmentSkillDamage = ____exports["是装备技能伤害来源类型"](_____6765_6E90_7C7B_578B)
    local equipmentSkillKind = _____53C2_6570["装备技能类型"] or (isEquipmentSkillDamage and _____6765_6E90_7C7B_578B or nil)
    local damageShape = _____53C2_6570["伤害形态"] or "未知"
    local ____isEquipmentSkillDamage_12
    if isEquipmentSkillDamage then
        ____isEquipmentSkillDamage_12 = nil
    else
        ____isEquipmentSkillDamage_12 = _____53C2_6570["技能实例ID"] or _____53D6_5355_4F4D_5F53_524D_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____53C2_6570["来源"], _____53C2_6570["技能ID"])
    end
    local skillInstanceId = ____isEquipmentSkillDamage_12
    return {
        isWrappedSkillDamage = true,
        isEquipmentSkillDamage = isEquipmentSkillDamage,
        isNonEquipmentSkillDamage = not isEquipmentSkillDamage,
        sourceKind = _____6765_6E90_7C7B_578B,
        equipmentSkillKind = equipmentSkillKind,
        itemTypeId = _____53C2_6570["物品ID"],
        itemHandle = _____53C2_6570["物品实例"],
        abilityId = _____53C2_6570["技能ID"],
        skillInstanceId = skillInstanceId,
        tag = _____53C2_6570["标签"],
        damageShape = damageShape,
        isIndependentSkillDamage = skillInstanceId ~= nil and skillInstanceId > 0 and not isEquipmentSkillDamage,
        isSingleTargetSkillDamage = damageShape == "单体",
        isAoeSkillDamage = damageShape == "AOE",
        participatesInSkillDamageBonus = _____53C2_6570["参与技能伤害加成"] ~= false,
        isDamageTransfer = _____53C2_6570.isDamageTransfer == true
    }
end
local function _____7ED3_7B97_6280_80FD_4F24_5BB3(_____6765_6E90, _____76EE_6807, _____4F24_5BB3, _____4F24_5BB3_7C7B_578B, attack, ranged, attackType, weaponType)
    return UnitDamageTarget(
        _____6765_6E90,
        _____76EE_6807,
        _____4F24_5BB3,
        attack,
        ranged,
        attackType,
        _____4F24_5BB3_7C7B_578B,
        weaponType
    )
end
____exports["造成技能伤害"] = function(_____53C2_6570)
    if _____53C2_6570 == nil then
        return false
    end
    local _____6765_6E90 = _____53C2_6570["来源"]
    local _____76EE_6807 = _____53C2_6570["目标"]
    local _____4F24_5BB3 = _____53C2_6570["伤害"]
    if _____6765_6E90 == nil or _____6765_6E90 == 0 or _____76EE_6807 == nil or _____76EE_6807 == 0 or not (_____4F24_5BB3 > 0) then
        return false
    end
    local _____4E0A_4E0B_6587 = _____521B_5EFA_6280_80FD_4F24_5BB3_4E0A_4E0B_6587(_____53C2_6570)
    _____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808[#_____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808 + 1] = _____4E0A_4E0B_6587
    local ____7ED3_7B97_6280_80FD_4F24_5BB3_16 = _____7ED3_7B97_6280_80FD_4F24_5BB3
    local ____array_15 = __TS__SparseArrayNew(
        _____6765_6E90,
        _____76EE_6807,
        _____4F24_5BB3,
        _____53C2_6570["伤害类型"],
        _____53C2_6570.attack == true,
        _____53C2_6570.ranged == true
    )
    local ____53C2_6570_attackType_13 = _____53C2_6570.attackType
    if ____53C2_6570_attackType_13 == nil then
        ____53C2_6570_attackType_13 = ATTACK_TYPE_NORMAL
    end
    __TS__SparseArrayPush(____array_15, ____53C2_6570_attackType_13)
    local ____53C2_6570_weaponType_14 = _____53C2_6570.weaponType
    if ____53C2_6570_weaponType_14 == nil then
        ____53C2_6570_weaponType_14 = WEAPON_TYPE_WHOKNOWS
    end
    __TS__SparseArrayPush(____array_15, ____53C2_6570_weaponType_14)
    local result = ____7ED3_7B97_6280_80FD_4F24_5BB3_16(__TS__SparseArraySpread(____array_15))
    table.remove(_____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808)
    return result
end
____exports["造成装备技能伤害"] = function(_____53C2_6570)
    return ____exports["造成技能伤害"](__TS__ObjectAssign({}, _____53C2_6570, {["来源类型"] = _____53C2_6570["装备技能类型"] or "装备技能"}))
end
____exports["造成单体技能伤害"] = function(_____53C2_6570)
    return ____exports["造成技能伤害"](__TS__ObjectAssign({}, _____53C2_6570, {["伤害形态"] = "单体"}))
end
____exports["造成AOE技能伤害"] = function(_____53C2_6570)
    return ____exports["造成技能伤害"](__TS__ObjectAssign({}, _____53C2_6570, {["伤害形态"] = "AOE"}))
end
--- 在同一个技能伤害上下文中，按目标列表顺序逐个结算AOE伤害。
-- 每目标处理器会在该目标真正受伤前执行，返回 undefined 可跳过该目标。
____exports["造成批量AOE技能伤害"] = function(_____53C2_6570)
    if _____53C2_6570 == nil or _____53C2_6570["来源"] == nil or _____53C2_6570["来源"] == 0 then
        return 0
    end
    if _____53C2_6570["目标列表"] == nil or #_____53C2_6570["目标列表"] == 0 then
        return 0
    end
    local _____4E0A_4E0B_6587 = _____521B_5EFA_6280_80FD_4F24_5BB3_4E0A_4E0B_6587(__TS__ObjectAssign({}, _____53C2_6570, {["伤害形态"] = "AOE"}))
    local _____6BCF_76EE_6807_5904_7406_5668 = _____53C2_6570["每目标处理器"]
    local _____6BCF_76EE_6807_7ED3_7B97_540E_5904_7406_5668 = _____53C2_6570["每目标结算后处理器"]
    local _____57FA_7840_4F24_5BB3 = _____53C2_6570["伤害"] or 0
    local _____57FA_7840_4F24_5BB3_7C7B_578B = _____53C2_6570["伤害类型"]
    local _____6210_529F_6570_91CF = 0
    _____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808[#_____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808 + 1] = _____4E0A_4E0B_6587
    do
        local i = 0
        while i < #_____53C2_6570["目标列表"] do
            do
                local _____76EE_6807 = _____53C2_6570["目标列表"][i + 1]
                if _____76EE_6807 == nil or _____76EE_6807 == 0 then
                    goto __continue52
                end
                local ____temp_17
                if _____6BCF_76EE_6807_5904_7406_5668 ~= nil then
                    ____temp_17 = _____6BCF_76EE_6807_5904_7406_5668(_____76EE_6807, i, _____53C2_6570["变量"])
                else
                    ____temp_17 = nil
                end
                local _____76EE_6807_53C2_6570 = ____temp_17
                if _____6BCF_76EE_6807_5904_7406_5668 ~= nil and _____76EE_6807_53C2_6570 == nil then
                    goto __continue52
                end
                local _____4F24_5BB3 = _____76EE_6807_53C2_6570 and _____76EE_6807_53C2_6570["伤害"] or _____57FA_7840_4F24_5BB3
                local ____temp_22 = _____76EE_6807_53C2_6570 and _____76EE_6807_53C2_6570["伤害类型"]
                if ____temp_22 == nil then
                    ____temp_22 = _____57FA_7840_4F24_5BB3_7C7B_578B
                end
                local _____4F24_5BB3_7C7B_578B = ____temp_22
                if not (_____4F24_5BB3 > 0) or _____4F24_5BB3_7C7B_578B == nil then
                    goto __continue52
                end
                local ____7ED3_7B97_6280_80FD_4F24_5BB3_40 = _____7ED3_7B97_6280_80FD_4F24_5BB3
                local ____53C2_6570__6765_6E90_39 = _____53C2_6570["来源"]
                local ____temp_25 = _____76EE_6807_53C2_6570 and _____76EE_6807_53C2_6570.attack
                if ____temp_25 == nil then
                    ____temp_25 = _____53C2_6570.attack
                end
                local ____temp_25_26 = ____temp_25
                if ____temp_25_26 == nil then
                    ____temp_25_26 = false
                end
                local ____temp_29 = _____76EE_6807_53C2_6570 and _____76EE_6807_53C2_6570.ranged
                if ____temp_29 == nil then
                    ____temp_29 = _____53C2_6570.ranged
                end
                local ____temp_29_30 = ____temp_29
                if ____temp_29_30 == nil then
                    ____temp_29_30 = false
                end
                local ____temp_33 = _____76EE_6807_53C2_6570 and _____76EE_6807_53C2_6570.attackType
                if ____temp_33 == nil then
                    ____temp_33 = _____53C2_6570.attackType
                end
                local ____temp_33_34 = ____temp_33
                if ____temp_33_34 == nil then
                    ____temp_33_34 = ATTACK_TYPE_NORMAL
                end
                local ____temp_37 = _____76EE_6807_53C2_6570 and _____76EE_6807_53C2_6570.weaponType
                if ____temp_37 == nil then
                    ____temp_37 = _____53C2_6570.weaponType
                end
                local ____temp_37_38 = ____temp_37
                if ____temp_37_38 == nil then
                    ____temp_37_38 = WEAPON_TYPE_WHOKNOWS
                end
                local _____6210_529F = ____7ED3_7B97_6280_80FD_4F24_5BB3_40(
                    ____53C2_6570__6765_6E90_39,
                    _____76EE_6807,
                    _____4F24_5BB3,
                    _____4F24_5BB3_7C7B_578B,
                    ____temp_25_26,
                    ____temp_29_30,
                    ____temp_33_34,
                    ____temp_37_38
                )
                if _____6210_529F then
                    _____6210_529F_6570_91CF = _____6210_529F_6570_91CF + 1
                end
                if _____6BCF_76EE_6807_7ED3_7B97_540E_5904_7406_5668 ~= nil then
                    _____6BCF_76EE_6807_7ED3_7B97_540E_5904_7406_5668(_____76EE_6807, i, _____6210_529F, _____53C2_6570["变量"])
                end
            end
            ::__continue52::
            i = i + 1
        end
    end
    table.remove(_____6280_80FD_4F24_5BB3_4E0A_4E0B_6587_6808)
    return _____6210_529F_6570_91CF
end
return ____exports
