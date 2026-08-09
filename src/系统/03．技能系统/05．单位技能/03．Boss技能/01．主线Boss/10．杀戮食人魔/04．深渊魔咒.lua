local ____lualib = require("lualib_bundle")
local __TS__SparseArrayNew = ____lualib.__TS__SparseArrayNew
local __TS__SparseArrayPush = ____lualib.__TS__SparseArrayPush
local __TS__SparseArraySpread = ____lualib.__TS__SparseArraySpread
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.00．配置")
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["杀戮食人魔单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建杀戮食人魔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.10．杀戮食人魔.02．数值与表现配置")
local _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["杀戮食人魔技能配置"]
local ____08_FF0E_98DF_4EBA_9B54 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.08．食人魔")
local _____98DF_4EBA_9B54BuffID = ____08_FF0E_98DF_4EBA_9B54["食人魔BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算Boss单体技能伤害"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_1.registerSpellEffectListener
local ____require_result_2 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local registerHealCallback = ____require_result_2.registerHealCallback
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local getBuffRuntime = ____require_result_3.getBuffRuntime
local ____require_result_4 = require("系统.05．Buff系统.06．负面效果免疫状态")
local _____5355_4F4D_662F_5426_514D_75AB_8D1F_9762_6548_679CBuffID = ____require_result_4["单位是否免疫负面效果BuffID"]
local ____require_result_5 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_5["获取Boss技能随机敌对英雄"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_5["获取Boss技能敌对英雄列表"]
local ____require_result_6 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
local _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_6["取当前有效玩家人数"]
local ____require_result_7 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local getRegisteredPlayerHero = ____require_result_7.getRegisteredPlayerHero
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
local getGameDifficulty = ____require_result_8.getGameDifficulty
local addDelayedCallback = ____require_result_8.addDelayedCallback
local ____require_result_9 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_9["读取单位攻击力"]
local ____require_result_10 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_10.EC_CreateEffect
local ____require_result_11 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_11.stringToFourCCSafe
local ____require_result_12 = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.02．通用物品技能槽位配置")
local _____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868 = ____require_result_12["通用物品技能槽位配置表"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetUnitTypeId = jass.GetUnitTypeId
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local IsUnitType = jass.IsUnitType
local GetRandomInt = jass.GetRandomInt
local GetOwningPlayer = jass.GetOwningPlayer
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____6DF1_6E0A_9B54_5492_6280_80FDID = stringToFourCCSafe(_____6740_622E_98DF_4EBA_9B54_5355_4F4D_6280_80FD_914D_7F6E["技能ID"]["深渊魔咒"])
local _____6DF1_6E0A_9B54_5492_6765_6E90_8868 = {}
local _____6DF1_6E0A_9B54_5492_5DF2_6CE8_518C = false
local _____6DF1_6E0A_9B54_5492_5168_5C40_76D1_542C_5DF2_6CE8_518C = false
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and not IsUnitType(unit, UNIT_TYPE_DEAD) and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____53D6_6DF1_6E0A_9B54_5492_76EE_6807(boss)
    local spellTarget = GetSpellTargetUnit()
    if _____5355_4F4D_5B58_6D3B(spellTarget) then
        return spellTarget
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
end
local function _____6DF1_6E0A_9B54_5492_52A8_4F5C_7ED3_675F()
end
local function ____on_65BD_52A0_6DF1_6E0A_9B54_5492(variable)
    local data = variable
    if data == nil then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(data["Boss单位"]) or not _____5355_4F4D_5B58_6D3B(data["目标单位"]) then
        return
    end
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["深渊魔咒"]
    local playerCount = _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()
    local duration = (playerCount <= 1 and cfg["单人基础持续秒"] or cfg["多人基础持续秒"]) + playerCount * cfg["每名玩家增加秒"]
    local targetImmune = _____5355_4F4D_662F_5426_514D_75AB_8D1F_9762_6548_679CBuffID(data["目标单位"], _____98DF_4EBA_9B54BuffID["深渊魔咒"])
    _____6DF1_6E0A_9B54_5492_6765_6E90_8868[GetHandleId(data["目标单位"])] = data["Boss单位"]
    registerManualBuff(
        data["目标单位"],
        _____98DF_4EBA_9B54BuffID["深渊魔咒"],
        duration,
        1,
        {sourceUnit = data["Boss单位"], sourceName = "杀戮食人魔-深渊魔咒"}
    )
    local runtime = getBuffRuntime(data["目标单位"], _____98DF_4EBA_9B54BuffID["深渊魔咒"])
    local ____debugLogForce_18 = debugLogForce
    local ____array_17 = __TS__SparseArrayNew(
        "杀戮食人魔-深渊魔咒",
        "诅咒Buff施加诊断",
        "bossHid=",
        GetHandleId(data["Boss单位"]),
        "targetHid=",
        GetHandleId(data["目标单位"]),
        "targetTypeId=",
        GetUnitTypeId(data["目标单位"]),
        "targetImmune=",
        targetImmune,
        "runtimeExists=",
        runtime ~= nil,
        "remaining="
    )
    local ____opt_result_15
    if runtime ~= nil then
        ____opt_result_15 = runtime.remaining
    end
    local ____opt_result_15_16 = ____opt_result_15
    if ____opt_result_15_16 == nil then
        ____opt_result_15_16 = 0
    end
    __TS__SparseArrayPush(____array_17, ____opt_result_15_16)
    ____debugLogForce_18(__TS__SparseArraySpread(____array_17))
end
local function _____53D6_968F_673A_8F6C_79FB_76EE_6807(boss, cursedHero)
    if _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570() <= 1 then
        return cursedHero
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local candidates = {}
    do
        local i = 0
        while i < #heroes do
            local hero = heroes[i + 1]
            if hero ~= cursedHero and _____5355_4F4D_5B58_6D3B(hero) and getRegisteredPlayerHero(GetOwningPlayer(hero)) == hero then
                candidates[#candidates + 1] = hero
            end
            i = i + 1
        end
    end
    if #candidates == 0 then
        return cursedHero
    end
    return candidates[GetRandomInt(0, #candidates - 1) + 1]
end
local function _____662F_7269_54C1_6280_80FD(_____6280_80FDID)
    do
        local i = 0
        while i < #_____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868 do
            if stringToFourCCSafe(_____901A_7528_7269_54C1_6280_80FD_69FD_4F4D_914D_7F6E_8868[i + 1]["技能ID"]) == _____6280_80FDID then
                return true
            end
            i = i + 1
        end
    end
    return false
end
local function ____on_6DF1_6E0A_9B54_5492_76EE_6807_65BD_6CD5(castingUnit, _spellAbilityId)
    if not _____5355_4F4D_5B58_6D3B(castingUnit) then
        return
    end
    if _____662F_7269_54C1_6280_80FD(_spellAbilityId) then
        return
    end
    local castingHid = GetHandleId(castingUnit)
    local boss = _____6DF1_6E0A_9B54_5492_6765_6E90_8868[castingHid]
    if boss == nil then
        return
    end
    local runtime = getBuffRuntime(castingUnit, _____98DF_4EBA_9B54BuffID["深渊魔咒"])
    debugLogForce(
        "杀戮食人魔-深渊魔咒",
        "诅咒目标技能生效诊断",
        "castingHid=",
        castingHid,
        "castingTypeId=",
        GetUnitTypeId(castingUnit),
        "abilityId=",
        _spellAbilityId,
        "runtimeExists=",
        runtime ~= nil,
        "bossHid=",
        GetHandleId(boss)
    )
    if runtime == nil then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(boss) or GetUnitTypeId(boss) ~= _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID then
        debugLogForce(
            "杀戮食人魔-深渊魔咒",
            "施法反噬跳过：Boss来源无效",
            "bossAlive=",
            _____5355_4F4D_5B58_6D3B(boss),
            "bossTypeId=",
            _____5355_4F4D_5B58_6D3B(boss) and GetUnitTypeId(boss) or 0
        )
        return
    end
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["深渊魔咒"]
    local difficulty = getGameDifficulty() > 0 and getGameDifficulty() or 1
    local damage = GetUnitStateJapi(castingUnit, UNIT_STATE_MAX_LIFE) * (cfg["最大生命基础比例"] + cfg["最大生命每层难度比例"] * difficulty) + _____8BFB_53D6_5355_4F4D_653B_51FB_529B(castingUnit) * (cfg["攻击力基础比例"] + cfg["攻击力每层难度比例"] * difficulty)
    local receiver = _____53D6_968F_673A_8F6C_79FB_76EE_6807(boss, castingUnit)
    if not _____5355_4F4D_5B58_6D3B(receiver) then
        return
    end
    EC_CreateEffect(
        cfg["反噬特效"],
        GetUnitX(receiver),
        GetUnitY(receiver),
        0,
        270,
        3,
        1,
        1
    )
    _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = receiver,
        ["伤害"] = damage,
        ["技能ID"] = _____6DF1_6E0A_9B54_5492_6280_80FDID,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = "杀戮食人魔·深渊魔咒施法反噬"
    })
end
local function _____6DF1_6E0A_9B54_5492_6CBB_7597_4FEE_6B63(_source, target, amount, isItemHeal)
    if not (amount > 0) or isItemHeal or not _____5355_4F4D_5B58_6D3B(target) or getBuffRuntime(target, _____98DF_4EBA_9B54BuffID["深渊魔咒"]) == nil then
        return amount
    end
    local boss = _____6DF1_6E0A_9B54_5492_6765_6E90_8868[GetHandleId(target)]
    if not _____5355_4F4D_5B58_6D3B(boss) or GetUnitTypeId(boss) ~= _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID then
        return amount
    end
    local cfg = _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["深渊魔咒"]
    local difficulty = getGameDifficulty() > 0 and getGameDifficulty() or 1
    local damage = amount * (cfg["治疗反噬基础比例"] + cfg["治疗反噬每层难度比例"] * difficulty)
    EC_CreateEffect(
        cfg["反噬特效"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        270,
        3,
        1,
        1
    )
    _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害"] = damage,
        ["技能ID"] = _____6DF1_6E0A_9B54_5492_6280_80FDID,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = "杀戮食人魔·深渊魔咒治疗反噬"
    })
    return 0
end
____exports["释放杀戮食人魔深渊魔咒"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_5B58_6D3B(boss) then
        return false
    end
    local target = _____53D6_6DF1_6E0A_9B54_5492_76EE_6807(boss)
    if not _____5355_4F4D_5B58_6D3B(target) then
        return false
    end
    EC_CreateEffect(
        _____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["深渊魔咒"]["生效特效"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        270,
        2,
        1,
        1.5
    )
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["名称"] = "杀戮食人魔-深渊魔咒动作",
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = 0.7,
        ["动画编号"] = 5,
        ["恢复动画编号"] = 1,
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = 0.7,
            ["颜色ID"] = 1,
            ["标题文本"] = "深渊魔咒",
            ["提示文本"] = "治疗与施法将遭到反噬"
        },
        ["on生效"] = _____6DF1_6E0A_9B54_5492_52A8_4F5C_7ED3_675F
    })
    addDelayedCallback(_____6740_622E_98DF_4EBA_9B54_6280_80FD_914D_7F6E["深渊魔咒"]["生效延迟秒"] * 1000, ____on_65BD_52A0_6DF1_6E0A_9B54_5492, {["Boss单位"] = boss, ["目标单位"] = target})
    return true
end
local function ____on_6DF1_6E0A_9B54_5492_6280_80FD_58F3_91CA_653E(context)
    ____exports["释放杀戮食人魔深渊魔咒"](context)
end
____exports["注册杀戮食人魔深渊魔咒"] = function()
    if not _____6DF1_6E0A_9B54_5492_5168_5C40_76D1_542C_5DF2_6CE8_518C then
        _____6DF1_6E0A_9B54_5492_5168_5C40_76D1_542C_5DF2_6CE8_518C = true
        registerSpellEffectListener(____on_6DF1_6E0A_9B54_5492_76EE_6807_65BD_6CD5)
        registerHealCallback(_____6DF1_6E0A_9B54_5492_6CBB_7597_4FEE_6B63)
    end
    if _____6DF1_6E0A_9B54_5492_5DF2_6CE8_518C then
        return
    end
    _____6DF1_6E0A_9B54_5492_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "杀戮食人魔-深渊魔咒",
        ["单位类型ID"] = _____6740_622E_98DF_4EBA_9B54_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____6DF1_6E0A_9B54_5492_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6740_622E_98DF_4EBA_9B54_4E0A_4E0B_6587,
        ["释放技能"] = ____on_6DF1_6E0A_9B54_5492_6280_80FD_58F3_91CA_653E,
        ["技能实例持续时间秒"] = 10
    })
end
return ____exports
