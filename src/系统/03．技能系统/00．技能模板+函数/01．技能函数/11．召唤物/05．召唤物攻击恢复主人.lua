local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_5355_4F4DID, GetHandleId, _____53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_8868
function _____53D6_5355_4F4DID(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["注销召唤物攻击恢复主人"] = function(_____53EC_5524_5355_4F4D)
    local id = _____53D6_5355_4F4DID(_____53EC_5524_5355_4F4D)
    if id ~= 0 then
        __TS__Delete(_____53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_8868, id)
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
GetHandleId = jass.GetHandleId
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_0.registerAppliedFinalDamageListener
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_1.registerDeathListener
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_2.doHeal
_____53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_8868 = {}
local _____53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_76D1_542C_5DF2_6CE8_518C = false
local function _____8BA1_7B97_6062_590D_503C(_____56FA_5B9A_503C, _____6700_5927_503C_6BD4_4F8B, _____6700_5927_503C)
    local amount = (_____56FA_5B9A_503C or 0) + _____6700_5927_503C * (_____6700_5927_503C_6BD4_4F8B or 0)
    return amount > 0 and amount or 0
end
local function ____on_53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA(target, _attacker, applied, snapshot)
    local ____opt_result_5
    if snapshot ~= nil then
        ____opt_result_5 = snapshot.originalAttacker
    end
    local summon = ____opt_result_5
    local _____53C2_6570 = _____53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_8868[_____53D6_5355_4F4DID(summon)]
    if _____53C2_6570 == nil or _____53C2_6570["主人单位"] == nil or _____53C2_6570["主人单位"] == 0 then
        return
    end
    local ____53C2_6570__4EC5_666E_901A_653B_51FB_6 = _____53C2_6570["仅普通攻击"]
    if ____53C2_6570__4EC5_666E_901A_653B_51FB_6 == nil then
        ____53C2_6570__4EC5_666E_901A_653B_51FB_6 = true
    end
    local ____53C2_6570__4EC5_666E_901A_653B_51FB_6_10 = ____53C2_6570__4EC5_666E_901A_653B_51FB_6
    if ____53C2_6570__4EC5_666E_901A_653B_51FB_6_10 then
        local ____opt_result_9
        if snapshot ~= nil then
            ____opt_result_9 = snapshot.isNormalAttack
        end
        ____53C2_6570__4EC5_666E_901A_653B_51FB_6_10 = ____opt_result_9 ~= true
    end
    if ____53C2_6570__4EC5_666E_901A_653B_51FB_6_10 then
        return
    end
    local ____53C2_6570__8981_6C42_5B9E_9645_9020_6210_4F24_5BB3_11 = _____53C2_6570["要求实际造成伤害"]
    if ____53C2_6570__8981_6C42_5B9E_9645_9020_6210_4F24_5BB3_11 == nil then
        ____53C2_6570__8981_6C42_5B9E_9645_9020_6210_4F24_5BB3_11 = true
    end
    if ____53C2_6570__8981_6C42_5B9E_9645_9020_6210_4F24_5BB3_11 and not (applied > 0) then
        return
    end
    local owner = _____53C2_6570["主人单位"]
    local lifeEnabled = _____53C2_6570["生命恢复条件"] == nil or _____53C2_6570["生命恢复条件"](summon, owner, target, snapshot)
    local manaEnabled = _____53C2_6570["魔法恢复条件"] == nil or _____53C2_6570["魔法恢复条件"](summon, owner, target, snapshot)
    local lifeAmount = lifeEnabled and _____8BA1_7B97_6062_590D_503C(
        _____53C2_6570["固定生命恢复"],
        _____53C2_6570["主人最大生命恢复比例"],
        GetUnitStateJapi(owner, UNIT_STATE_MAX_LIFE)
    ) or 0
    local manaAmount = manaEnabled and _____8BA1_7B97_6062_590D_503C(
        _____53C2_6570["固定魔法恢复"],
        _____53C2_6570["主人最大魔法恢复比例"],
        GetUnitStateJapi(owner, UNIT_STATE_MAX_MANA)
    ) or 0
    if not (lifeAmount > 0) and not (manaAmount > 0) then
        return
    end
    local manaBefore = GetUnitState(owner, UNIT_STATE_MANA)
    local ____doHeal_15 = doHeal
    local ____53C2_6570__663E_793A_751F_547D_6062_590D_7279_6548_12 = _____53C2_6570["显示生命恢复特效"]
    if ____53C2_6570__663E_793A_751F_547D_6062_590D_7279_6548_12 == nil then
        ____53C2_6570__663E_793A_751F_547D_6062_590D_7279_6548_12 = false
    end
    local ____53C2_6570__663E_793A_9B54_6CD5_6062_590D_7279_6548_13 = _____53C2_6570["显示魔法恢复特效"]
    if ____53C2_6570__663E_793A_9B54_6CD5_6062_590D_7279_6548_13 == nil then
        ____53C2_6570__663E_793A_9B54_6CD5_6062_590D_7279_6548_13 = false
    end
    local ____53C2_6570__663E_793A_9B54_6CD5_6062_590D_6587_5B57_14 = _____53C2_6570["显示魔法恢复文字"]
    if ____53C2_6570__663E_793A_9B54_6CD5_6062_590D_6587_5B57_14 == nil then
        ____53C2_6570__663E_793A_9B54_6CD5_6062_590D_6587_5B57_14 = false
    end
    local actualLife = ____doHeal_15({
        HealSource = summon,
        HealTarget = owner,
        HealAmount = lifeAmount,
        HealManaAmount = manaAmount,
        ItemHeal = false,
        HealEffect = ____53C2_6570__663E_793A_751F_547D_6062_590D_7279_6548_12,
        ManaEffect = ____53C2_6570__663E_793A_9B54_6CD5_6062_590D_7279_6548_13,
        ManaShowText = ____53C2_6570__663E_793A_9B54_6CD5_6062_590D_6587_5B57_14
    })
    local actualMana = GetUnitState(owner, UNIT_STATE_MANA) - manaBefore
    if _____53C2_6570["on触发"] ~= nil then
        _____53C2_6570["on触发"]({
            ["召唤单位"] = summon,
            ["主人单位"] = owner,
            ["目标单位"] = target,
            ["请求生命恢复"] = lifeAmount,
            ["实际生命恢复"] = actualLife,
            ["请求魔法恢复"] = manaAmount,
            ["实际魔法恢复"] = actualMana > 0 and actualMana or 0,
            snapshot = snapshot
        })
    end
end
local function ____on_53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_5355_4F4D_6B7B_4EA1(dyingUnit, _killingUnit)
    ____exports["注销召唤物攻击恢复主人"](dyingUnit)
end
local function _____786E_4FDD_53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_76D1_542C()
    if _____53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_76D1_542C_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA)
    registerDeathListener(____on_53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_5355_4F4D_6B7B_4EA1)
end
____exports["登记召唤物攻击恢复主人"] = function(_____53C2_6570)
    local id = _____53D6_5355_4F4DID(_____53C2_6570["召唤单位"])
    if id == 0 or _____53C2_6570["主人单位"] == nil or _____53C2_6570["主人单位"] == 0 then
        return
    end
    _____786E_4FDD_53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_76D1_542C()
    _____53EC_5524_7269_653B_51FB_6062_590D_4E3B_4EBA_8868[id] = _____53C2_6570
end
return ____exports
