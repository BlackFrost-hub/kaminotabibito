--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____03_FF0E_653B_51FB_6548_679C_8DF3_8FC7_914D_7F6E_8868 = require("系统.02．物品系统.15．装备技能.08．攻击效果.00．公共.03．攻击效果跳过配置表")
local _____653B_51FB_6548_679C_8DF3_8FC7_914D_7F6E_8868 = ____03_FF0E_653B_51FB_6548_679C_8DF3_8FC7_914D_7F6E_8868["攻击效果跳过配置表"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.02．物品系统.13．物品名反查")
local _____6309_540D_5B57_53CD_67E5_7269_54C1ID = ____require_result_0["按名字反查物品ID"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_1.stringToFourCCSafe
local ____require_result_2 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_2.UnitHasItemOfTypeBJ
local ____require_result_3 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_3.getUnitsInRange
local ____require_result_4 = require("lib.扩展函数.自定义扩展函数.02．条件判断函数")
local isUnitEnemy = ____require_result_4.isUnitEnemy
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.03．快速Buff")
local _____5FEB_901F_51CF_901FBuff = ____require_result_5["快速减速Buff"]
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_6["施加扩展控制"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.02．原地击飞系统")
local _____5F00_59CB_539F_5730_51FB_98DE = ____require_result_7["开始原地击飞"]
local ____require_result_8 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_8.doHeal
local ____require_result_9 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_751F_547D_503C = ____require_result_9["减少生命值"]
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_9["减少魔法值"]
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_10.SGSS_SetState
local ____require_result_11 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.06．精英单位判断")
local _____662F_5426_7CBE_82F1_5355_4F4D = ____require_result_11["是否精英单位"]
local ____require_result_12 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.07．武器类型")
local _____83B7_53D6_5355_4F4D_82F1_96C4_6B66_5668_7C7B_578B = ____require_result_12["获取单位英雄武器类型"]
local ____require_result_13 = require("lib.扩展函数.封装函数.06．伤害函数.index")
local YDWEIsEventDamageType = ____require_result_13.YDWEIsEventDamageType
local YDWEIsEventAttackType = ____require_result_13.YDWEIsEventAttackType
local ____require_result_14 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____require_result_14["装备触发概率通过"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local IsUnitType = jass.IsUnitType
local GetUnitTypeId = jass.GetUnitTypeId
local GetHeroStr = jass.GetHeroStr
local UnitDamageTarget = jass.UnitDamageTarget
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local EXSetEffectSize = japi.EXSetEffectSize
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local UNIT_TYPE_MELEE_ATTACKER = jass.UNIT_TYPE_MELEE_ATTACKER
local UNIT_TYPE_RANGED_ATTACKER = jass.UNIT_TYPE_RANGED_ATTACKER
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local ____jass_DAMAGE_TYPE_DIVINE_15 = jass.DAMAGE_TYPE_DIVINE
if ____jass_DAMAGE_TYPE_DIVINE_15 == nil then
    ____jass_DAMAGE_TYPE_DIVINE_15 = jass.DAMAGE_TYPE_UNIVERSAL
end
local DAMAGE_TYPE_DIVINE = ____jass_DAMAGE_TYPE_DIVINE_15
local DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
local DAMAGE_TYPE_UNIVERSAL = jass.DAMAGE_TYPE_UNIVERSAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____88C5_5907ID_7F13_5B58 = {}
local _____8DF3_8FC7_5355_4F4DID_7F13_5B58 = {}
local function _____83B7_53D6_8DF3_8FC7_5355_4F4DID(unitId)
    local cached = _____8DF3_8FC7_5355_4F4DID_7F13_5B58[unitId]
    if cached ~= nil then
        return cached
    end
    local id = stringToFourCCSafe(unitId)
    _____8DF3_8FC7_5355_4F4DID_7F13_5B58[unitId] = id
    return id
end
local function _____4F24_5BB3_5FEB_7167_662F_795E_5723_4F24_5BB3(snapshot)
    if snapshot ~= nil and snapshot.rawDamageType ~= nil then
        return snapshot.rawDamageType == DAMAGE_TYPE_DIVINE
    end
    return YDWEIsEventDamageType(DAMAGE_TYPE_DIVINE) == true
end
local function _____4F24_5BB3_5FEB_7167_662F_666E_901A_653B_51FB_7C7B_578B(snapshot)
    if snapshot ~= nil and snapshot.rawAttackType ~= nil then
        return snapshot.rawAttackType == ATTACK_TYPE_NORMAL
    end
    return YDWEIsEventAttackType(ATTACK_TYPE_NORMAL) == true
end
--- 按装备名反查物品 FourCC（数字）
-- 注意：按名字反查物品ID 返回的是 string raw id（如"I021"），
-- 需要经 stringToFourCCSafe 转为数字才能传给 UnitHasItemOfTypeBJ。
____exports["获取攻击效果装备ID"] = function(_____88C5_5907_540D)
    local cached = _____88C5_5907ID_7F13_5B58[_____88C5_5907_540D]
    if cached ~= nil then
        return cached
    end
    local rawId = _____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D)
    local id = type(rawId) == "string" and stringToFourCCSafe(rawId) or 0
    _____88C5_5907ID_7F13_5B58[_____88C5_5907_540D] = id
    return id
end
____exports["单位持有攻击效果装备"] = function(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local id = ____exports["获取攻击效果装备ID"](_____88C5_5907_540D)
    if id == 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(unit, id) == true
end
____exports["是否攻击效果全局跳过"] = function(source, snapshot)
    if source == nil or source == 0 then
        return false
    end
    local sourceTypeId = GetUnitTypeId(source)
    do
        local i = 0
        while i < #_____653B_51FB_6548_679C_8DF3_8FC7_914D_7F6E_8868 do
            do
                local _____914D_7F6E = _____653B_51FB_6548_679C_8DF3_8FC7_914D_7F6E_8868[i + 1]
                if _____914D_7F6E == nil then
                    goto __continue16
                end
                if _____914D_7F6E["来源单位ID"] ~= nil then
                    local unitTypeId = _____83B7_53D6_8DF3_8FC7_5355_4F4DID(_____914D_7F6E["来源单位ID"])
                    if unitTypeId == 0 or sourceTypeId ~= unitTypeId then
                        goto __continue16
                    end
                end
                if _____914D_7F6E["需要普通攻击类型"] == true and not _____4F24_5BB3_5FEB_7167_662F_666E_901A_653B_51FB_7C7B_578B(snapshot) then
                    goto __continue16
                end
                if _____914D_7F6E["需要神圣伤害"] == true and not _____4F24_5BB3_5FEB_7167_662F_795E_5723_4F24_5BB3(snapshot) then
                    goto __continue16
                end
                return true
            end
            ::__continue16::
            i = i + 1
        end
    end
    return false
end
____exports["单位有效存活"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    return IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
____exports["单位是英雄"] = function(unit)
    if not ____exports["单位有效存活"](unit) then
        return false
    end
    return IsUnitType(unit, UNIT_TYPE_HERO) == true
end
____exports["攻击者类型满足"] = function(unit, ____type)
    if ____type == nil then
        return true
    end
    if not ____exports["单位有效存活"](unit) then
        return false
    end
    if ____type == "近战" then
        return IsUnitType(unit, UNIT_TYPE_MELEE_ATTACKER) == true
    end
    if ____type == "远程" then
        return IsUnitType(unit, UNIT_TYPE_RANGED_ATTACKER) == true
    end
    return true
end
____exports["单位武器类型满足"] = function(unit, ____type)
    if ____type == nil or ____type == "" then
        return true
    end
    if not ____exports["单位是英雄"](unit) then
        return false
    end
    return _____83B7_53D6_5355_4F4D_82F1_96C4_6B66_5668_7C7B_578B(unit) == ____type
end
____exports["单位是精英目标"] = function(unit)
    if not ____exports["单位有效存活"](unit) then
        return false
    end
    return _____662F_5426_7CBE_82F1_5355_4F4D(unit) == true
end
____exports["取单位X"] = function(unit)
    return GetUnitX(unit)
end
____exports["取单位Y"] = function(unit)
    return GetUnitY(unit)
end
____exports["取当前生命"] = function(unit)
    return GetUnitState(unit, UNIT_STATE_LIFE)
end
____exports["取最大生命"] = function(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
end
____exports["取最大魔法"] = function(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA)
end
____exports["取攻击力"] = function(unit)
    return GetUnitStateJapi(
        unit,
        ConvertUnitState(21)
    )
end
____exports["取力量"] = function(unit)
    if not ____exports["单位是英雄"](unit) then
        return 0
    end
    return GetHeroStr(unit, true)
end
____exports["单位距离平方"] = function(a, b)
    local dx = ____exports["取单位X"](a) - ____exports["取单位X"](b)
    local dy = ____exports["取单位Y"](a) - ____exports["取单位Y"](b)
    return dx * dx + dy * dy
end
____exports["距离满足限制"] = function(source, target, minDistance, maxDistance)
    if minDistance == nil and maxDistance == nil then
        return true
    end
    local dist2 = ____exports["单位距离平方"](source, target)
    if minDistance ~= nil and dist2 < minDistance * minDistance then
        return false
    end
    if maxDistance ~= nil and dist2 > maxDistance * maxDistance then
        return false
    end
    return true
end
____exports["命中概率通过"] = function(probability, source)
    if probability == nil then
        return true
    end
    return _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(probability, source)
end
____exports["解析攻击效果伤害类型"] = function(_____7C7B_578B)
    if _____7C7B_578B == "火焰" then
        return DAMAGE_TYPE_FIRE
    end
    if _____7C7B_578B == "毒素" then
        return DAMAGE_TYPE_POISON
    end
    if _____7C7B_578B == "暗影" then
        return DAMAGE_TYPE_SHADOW_STRIKE
    end
    if _____7C7B_578B == "神圣" then
        return DAMAGE_TYPE_DIVINE
    end
    if _____7C7B_578B == "强化" then
        return DAMAGE_TYPE_ENHANCED
    end
    if _____7C7B_578B == "通用" then
        return DAMAGE_TYPE_UNIVERSAL
    end
    return DAMAGE_TYPE_NORMAL
end
____exports["攻击效果造成伤害"] = function(source, target, amount, _____7C7B_578B)
    if not ____exports["单位有效存活"](source) or not ____exports["单位有效存活"](target) or not (amount > 0) then
        return
    end
    UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        ____exports["解析攻击效果伤害类型"](_____7C7B_578B),
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["攻击效果治疗生命魔法"] = function(source, target, lifeAmount, manaAmount)
    if manaAmount == nil then
        manaAmount = 0
    end
    if not ____exports["单位有效存活"](target) then
        return
    end
    if not (lifeAmount > 0) and not (manaAmount > 0) then
        return
    end
    doHeal({
        HealSource = source,
        HealTarget = target,
        HealAmount = lifeAmount > 0 and lifeAmount or 0,
        HealManaAmount = manaAmount > 0 and manaAmount or 0,
        ItemHeal = true,
        HealEffect = lifeAmount > 0,
        ManaEffect = manaAmount > 0,
        ManaShowText = manaAmount > 0
    })
end
____exports["攻击效果减少生命魔法"] = function(target, lifeAmount, manaAmount)
    if not ____exports["单位有效存活"](target) then
        return
    end
    if lifeAmount > 0 then
        _____51CF_5C11_751F_547D_503C(
            target,
            lifeAmount,
            true,
            true,
            nil,
            1
        )
    end
    if manaAmount > 0 then
        _____51CF_5C11_9B54_6CD5_503C(target, manaAmount, true, true)
    end
end
____exports["获取敌方范围单位"] = function(source, center, radius, includeCenter)
    if includeCenter == nil then
        includeCenter = false
    end
    if not ____exports["单位有效存活"](source) or not ____exports["单位有效存活"](center) or not (radius > 0) then
        return {}
    end
    local list = getUnitsInRange(
        ____exports["取单位X"](center),
        ____exports["取单位Y"](center),
        radius
    )
    local result = {}
    do
        local i = 0
        while i < #list do
            do
                local unit = list[i + 1]
                if not ____exports["单位有效存活"](unit) then
                    goto __continue70
                end
                if not includeCenter and unit == center then
                    goto __continue70
                end
                if isUnitEnemy(unit, source) ~= true then
                    goto __continue70
                end
                result[#result + 1] = unit
            end
            ::__continue70::
            i = i + 1
        end
    end
    return result
end
____exports["播放目标特效"] = function(target, model, attach)
    if attach == nil then
        attach = "origin"
    end
    if not ____exports["单位有效存活"](target) or model == "" then
        return
    end
    local effect = AddSpecialEffectTarget(model, target, attach)
    if effect ~= nil and effect ~= 0 then
        DestroyEffect(effect)
    end
end
____exports["播放单位坐标特效"] = function(target, model, scale)
    if not ____exports["单位有效存活"](target) or model == "" then
        return
    end
    local effect = AddSpecialEffect(
        model,
        GetUnitX(target),
        GetUnitY(target)
    )
    if effect == nil or effect == 0 then
        return
    end
    if scale ~= nil and scale > 0 then
        EXSetEffectSize(effect, scale)
    end
    DestroyEffect(effect)
end
____exports["施加攻击效果减速"] = function(source, target, amount, duration)
    if not (amount > 0) or not (duration > 0) then
        return
    end
    _____5FEB_901F_51CF_901FBuff(
        source,
        target,
        amount,
        amount,
        duration
    )
end
____exports["施加攻击效果眩晕"] = function(source, target, duration)
    if not (duration > 0) then
        return
    end
    _____65BD_52A0_6269_5C55_63A7_5236(source, target, "stun", {["持续时间"] = duration})
end
____exports["施加攻击效果击飞"] = function(source, target, duration)
    if not (duration > 0) then
        return
    end
    _____5F00_59CB_539F_5730_51FB_98DE(target, {
        ["持续时间"] = duration,
        ["主单位"] = source,
        ["主单位死亡时中断"] = true,
        ["暂停单位"] = true,
        ["中断已有跳跃"] = true
    })
end
____exports["临时修改攻速"] = function(unit, value)
    if not ____exports["单位有效存活"](unit) or value == 0 then
        return
    end
    SGSS_SetState(unit, 10, value)
end
____exports["临时修改护甲"] = function(unit, value)
    if not ____exports["单位有效存活"](unit) or value == 0 then
        return
    end
    SGSS_SetState(unit, 2, value)
end
return ____exports
