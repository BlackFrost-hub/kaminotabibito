local ____lualib = require("lualib_bundle")
local __TS__Number = ____lualib.__TS__Number
local ____exports = {}
---
-- @noSelfInFile
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
local getEnemyUnitsInRange = ____require_result_3.getEnemyUnitsInRange
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_4.getServerTime
local addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_5.doHeal
local getHealRate = ____require_result_5.getHealRate
local setHealRate = ____require_result_5.setHealRate
local getReceivedHealRate = ____require_result_5.getReceivedHealRate
local setReceivedHealRate = ____require_result_5.setReceivedHealRate
local ____require_result_6 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾")
local _____5F00_59CB_62A4_76FE = ____require_result_6["开始护盾"]
local _____62A4_76FE_7C7B_578B = ____require_result_6["护盾类型"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____6E05_9664_5355_4F4D_8D1F_9762Buff = ____require_result_7["清除单位负面Buff"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.22．幸运值.00．幸运值系统")
local _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7 = ____require_result_8["装备触发概率通过"]
local ____require_result_9 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDUserDataGetSafe = ____require_result_9.YDUserDataGetSafe
local YDUserDataSetSafe = ____require_result_9.YDUserDataSetSafe
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitAlly = jass.IsUnitAlly
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitType = jass.IsUnitType
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local UnitDamageTarget = jass.UnitDamageTarget
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local DAMAGE_TYPE_LIGHTNING = jass.DAMAGE_TYPE_LIGHTNING
local DAMAGE_TYPE_COLD = jass.DAMAGE_TYPE_COLD
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON
local DAMAGE_TYPE_FORCE = jass.DAMAGE_TYPE_FORCE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitStateJapi = japi.GetUnitState
____exports["第二章后段Boss战利品装备名"] = {
    ["菲利斯的统御纹章"] = "菲利斯的统御纹章",
    ["剑魂狼牙坠"] = "剑魂狼牙坠",
    ["封印斩护腕"] = "封印斩护腕",
    ["异形化残刃"] = "异形化残刃",
    ["攻城号令圣印"] = "攻城号令圣印",
    ["灵心之碎片"] = "灵心之碎片",
    ["克林姆德风纹法杖"] = "克林姆德风纹法杖",
    ["神风护体披风"] = "神风护体披风",
    ["湮灭之风戒指"] = "湮灭之风戒指",
    ["卡瑟拉深渊法典"] = "卡瑟拉深渊法典",
    ["电鳗共生指环"] = "电鳗共生指环",
    ["触手残片护符"] = "触手残片护符",
    ["墨潮行者长袍"] = "墨潮行者长袍",
    ["高压水脊法杖"] = "高压水脊法杖",
    ["绝缘珊瑚圣瓶"] = "绝缘珊瑚圣瓶",
    ["腐败根须法杖"] = "腐败根须法杖",
    ["古树之心护符"] = "古树之心护符",
    ["荆棘行者披风"] = "荆棘行者披风",
    ["净化者手套"] = "净化者手套",
    ["莫尔特斯树皮盾"] = "莫尔特斯树皮盾",
    ["腐朽孢子秘瓶"] = "腐朽孢子秘瓶",
    ["净土萌芽圣铃"] = "净土萌芽圣铃"
}
____exports["装备小特效"] = {["湿痕"] = "Common\\Effect\\Element\\Water\\WetShockMark.mdx", ["护盾闪光"] = "Common\\Effect\\Form\\Shield\\EquipmentShieldFlash.mdx", ["小风爆"] = "Common\\Effect\\Element\\Wind\\SmallWindBurst.mdx", ["根须"] = "Abilities\\Spells\\NightElf\\EntanglingRoots\\EntanglingRootsTarget.mdl"}
____exports["装备伤害类型"] = {
    ["魔法"] = DAMAGE_TYPE_MAGIC,
    ["闪电"] = DAMAGE_TYPE_LIGHTNING,
    ["水"] = DAMAGE_TYPE_COLD,
    ["暗影"] = DAMAGE_TYPE_SHADOW_STRIKE,
    ["自然"] = DAMAGE_TYPE_POISON,
    ["风"] = DAMAGE_TYPE_FORCE
}
local _____7269_54C1ID_7F13_5B58 = {}
local _____51B7_5374_8868 = {}
____exports["取第二章后段Boss战利品ID"] = function(_____88C5_5907_540D)
    local cached = _____7269_54C1ID_7F13_5B58[_____88C5_5907_540D]
    if cached ~= nil then
        return cached
    end
    local id = stringToFourCCSafe(_____6309_540D_5B57_53CD_67E5_7269_54C1ID(_____88C5_5907_540D))
    _____7269_54C1ID_7F13_5B58[_____88C5_5907_540D] = id
    return id
end
____exports["单位持有第二章后段Boss战利品"] = function(unit, _____88C5_5907_540D)
    if unit == nil or unit == 0 then
        return false
    end
    local id = ____exports["取第二章后段Boss战利品ID"](_____88C5_5907_540D)
    return id ~= 0 and UnitHasItemOfTypeBJ(unit, id) == true
end
____exports["单位存活"] = function(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
____exports["是技能伤害"] = function(snapshot)
    return snapshot ~= nil and (snapshot.isSkillDamage == true or snapshot.isSkillAttack == true)
end
____exports["是纯普攻"] = function(snapshot)
    return snapshot ~= nil and snapshot.isNormalAttack == true and snapshot.isSkillDamage ~= true and snapshot.isSkillAttack ~= true
end
____exports["是元素伤害"] = function(snapshot, damageType)
    return snapshot ~= nil and snapshot.rawDamageType == damageType
end
____exports["取单位ID"] = function(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    return GetHandleId(unit) or 0
end
____exports["取冷却键"] = function(unit, tag)
    local id = ____exports["取单位ID"](unit)
    return id > 0 and (tag .. ":") .. tostring(id) or ""
end
____exports["冷却就绪"] = function(key)
    return key ~= "" and (_____51B7_5374_8868[key] or 0) <= getServerTime()
end
____exports["进入冷却"] = function(key, _____79D2_6570)
    if key == "" then
        return
    end
    _____51B7_5374_8868[key] = getServerTime() + _____79D2_6570 * 1000
end
____exports["概率通过"] = function(unit, chance)
    return chance >= 1 or chance > 0 and _____88C5_5907_89E6_53D1_6982_7387_901A_8FC7(chance, unit) == true
end
____exports["取当前生命"] = function(unit)
    return GetUnitState(unit, UNIT_STATE_LIFE)
end
____exports["取最大生命"] = function(unit)
    return GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE) or GetUnitState(unit, UNIT_STATE_MAX_LIFE) or 0
end
____exports["扣除当前生命比例"] = function(unit, ratio)
    if not ____exports["单位存活"](unit) or not (ratio > 0) then
        return
    end
    local life = ____exports["取当前生命"](unit)
    local cost = life * ratio
    SetUnitState(unit, UNIT_STATE_LIFE, life - cost > 1 and life - cost or 1)
end
____exports["造成装备伤害"] = function(source, target, amount, damageType)
    if not ____exports["单位存活"](source) or not ____exports["单位存活"](target) or not (amount > 0) then
        return
    end
    UnitDamageTarget(
        source,
        target,
        amount,
        false,
        false,
        ATTACK_TYPE_NORMAL,
        damageType,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["恢复生命魔法"] = function(source, target, hp, mp, _____9ED8_8BA4_9B54_6CD5_7279_6548)
    if mp == nil then
        mp = 0
    end
    if _____9ED8_8BA4_9B54_6CD5_7279_6548 == nil then
        _____9ED8_8BA4_9B54_6CD5_7279_6548 = false
    end
    if target == nil or target == 0 then
        return
    end
    doHeal({
        HealSource = source,
        HealTarget = target,
        HealAmount = hp,
        HealManaAmount = mp,
        ItemHeal = true,
        HealEffect = hp > 0,
        UseDefaultHealEffect = hp > 0,
        ManaEffect = _____9ED8_8BA4_9B54_6CD5_7279_6548 or mp > 0,
        UseDefaultManaEffect = _____9ED8_8BA4_9B54_6CD5_7279_6548 or mp > 0,
        ManaShowText = mp > 0
    })
end
____exports["播放点特效"] = function(model, x, y, _____6301_7EED_79D2)
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = 1
    end
    if model == "" then
        return
    end
    local effect = AddSpecialEffect(model, x, y)
    addDelayedCallback(
        _____6301_7EED_79D2 * 1000,
        function()
            if effect ~= nil and effect ~= 0 then
                DestroyEffect(effect)
            end
        end
    )
end
____exports["播放单位特效"] = function(model, unit, attach, _____6301_7EED_79D2)
    if attach == nil then
        attach = "origin"
    end
    if _____6301_7EED_79D2 == nil then
        _____6301_7EED_79D2 = 1
    end
    if unit == nil or unit == 0 or model == "" then
        return
    end
    local effect = AddSpecialEffectTarget(model, unit, attach)
    addDelayedCallback(
        _____6301_7EED_79D2 * 1000,
        function()
            if effect ~= nil and effect ~= 0 then
                DestroyEffect(effect)
            end
        end
    )
end
____exports["取范围友方"] = function(source, radius)
    local result = {}
    if not ____exports["单位存活"](source) then
        return result
    end
    local owner = GetOwningPlayer(source)
    local units = getUnitsInRange(
        GetUnitX(source),
        GetUnitY(source),
        radius
    )
    do
        local i = 0
        while i < #units do
            local unit = units[i + 1]
            if ____exports["单位存活"](unit) and IsUnitAlly(unit, owner) == true then
                result[#result + 1] = unit
            end
            i = i + 1
        end
    end
    return result
end
____exports["取范围敌人"] = function(source, target, radius)
    if not ____exports["单位存活"](source) or target == nil or target == 0 then
        return {}
    end
    return getEnemyUnitsInRange(
        source,
        GetUnitX(target),
        GetUnitY(target),
        radius
    )
end
____exports["开始通用护盾"] = function(source, target, amount, duration, tag)
    if not ____exports["单位存活"](target) or not (amount > 0) then
        return
    end
    _____5F00_59CB_62A4_76FE(target, {
        ["类型"] = _____62A4_76FE_7C7B_578B["通用"],
        ["数值"] = amount,
        ["持续时间"] = duration,
        ["来源单位"] = source,
        ["标签"] = tag,
        ["显示护盾条"] = true,
        ["可驱散"] = true
    })
    ____exports["播放单位特效"](____exports["装备小特效"]["护盾闪光"], target, "origin", 0.8)
end
____exports["临时玩家属性"] = function(unit, attr, delta, duration)
    if unit == nil or unit == 0 or delta == 0 or not (duration > 0) then
        return
    end
    local player = GetOwningPlayer(unit)
    local oldValue = __TS__Number(YDUserDataGetSafe("player", player, attr, "real")) or 0
    YDUserDataSetSafe(
        "player",
        player,
        attr,
        "real",
        oldValue + delta
    )
    addDelayedCallback(
        duration * 1000,
        function()
            local current = __TS__Number(YDUserDataGetSafe("player", player, attr, "real")) or 0
            YDUserDataSetSafe(
                "player",
                player,
                attr,
                "real",
                current - delta
            )
        end
    )
end
____exports["临时治疗率"] = function(unit, delta, duration)
    if unit == nil or unit == 0 or delta == 0 or not (duration > 0) then
        return
    end
    setHealRate(
        unit,
        getHealRate(unit) + delta
    )
    addDelayedCallback(
        duration * 1000,
        function()
            setHealRate(
                unit,
                getHealRate(unit) - delta
            )
        end
    )
end
____exports["临时受到治疗率"] = function(unit, delta, duration)
    if unit == nil or unit == 0 or delta == 0 or not (duration > 0) then
        return
    end
    setReceivedHealRate(
        unit,
        getReceivedHealRate(unit) + delta
    )
    addDelayedCallback(
        duration * 1000,
        function()
            setReceivedHealRate(
                unit,
                getReceivedHealRate(unit) - delta
            )
        end
    )
end
____exports["净化负面"] = function(unit)
    return unit ~= nil and unit ~= 0 and _____6E05_9664_5355_4F4D_8D1F_9762Buff(unit, true) > 0
end
____exports["短暂无敌"] = function(unit, _____79D2_6570)
    if not ____exports["单位存活"](unit) or not (_____79D2_6570 > 0) then
        return
    end
    SetUnitInvulnerable(unit, true)
    addDelayedCallback(
        _____79D2_6570 * 1000,
        function()
            if unit ~= nil and unit ~= 0 then
                SetUnitInvulnerable(unit, false)
            end
        end
    )
end
____exports["是敌对单位"] = function(source, target)
    return source ~= nil and source ~= 0 and target ~= nil and target ~= 0 and IsUnitEnemy(
        target,
        GetOwningPlayer(source)
    ) == true
end
____exports["取单位X"] = function(unit)
    return GetUnitX(unit)
end
____exports["取单位Y"] = function(unit)
    return GetUnitY(unit)
end
return ____exports
