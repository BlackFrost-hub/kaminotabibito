--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____83AB_5C14_7279_65AF_5B62_5B50_4E91_5468_671F, _____5B62_5B50_4E91Tick, _____521B_5EFA_5355_56E2_5B62_5B50_4E91, GetUnitX, GetUnitY, GetOwningPlayer, GetRandomReal, IssuePointOrder, UnitDamageTarget, AddSpecialEffect, GetUnitState, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_PLANT, WEAPON_TYPE_WHOKNOWS, UNIT_STATE_MAX_LIFE, addPeriodicCallback, removePeriodicCallback, _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.00．配置")
local _____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["莫尔特斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建莫尔特斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.02．数值与表现配置")
local _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["莫尔特斯数值与表现配置"]
local ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.03．腐败值与根须领域")
local _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C = ____03_FF0E_8150_8D25_503C_4E0E_6839_987B_9886_57DF["应用莫尔特斯腐败值"]
local ____13_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.13．台词播放")
local _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD = ____13_FF0E_53F0_8BCD_64AD_653E["播放莫尔特斯台词"]
local ____16_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.11．古木之蚀莫尔特斯.16．公共工具")
local _____5355_4F4D_6709_6548 = ____16_FF0E_516C_5171_5DE5_5177["单位有效"]
local _____6781_5750_6807X = ____16_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____16_FF0E_516C_5171_5DE5_5177["极坐标Y"]
local stringToFourCC = ____16_FF0E_516C_5171_5DE5_5177.stringToFourCC
function _____83AB_5C14_7279_65AF_5B62_5B50_4E91_5468_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    _____5B62_5B50_4E91Tick(data)
end
function _____5B62_5B50_4E91Tick(data)
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败孢子云"]
    local boss = data.context["Boss单位"]
    local spore = data["孢子单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(spore) or data["剩余跳数"] <= 0 then
        removePeriodicCallback(data["周期ID"])
        return
    end
    data["剩余跳数"] = data["剩余跳数"] - 1
    local angle = GetRandomReal(0, 360)
    IssuePointOrder(
        spore,
        "move",
        _____6781_5750_6807X(
            GetUnitX(spore),
            angle,
            cfg["移动距离"]
        ),
        _____6781_5750_6807Y(
            GetUnitY(spore),
            angle,
            cfg["移动距离"]
        )
    )
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue9
                end
                local dx = GetUnitX(hero) - GetUnitX(spore)
                local dy = GetUnitY(hero) - GetUnitY(spore)
                if dx * dx + dy * dy > cfg["半径"] * cfg["半径"] then
                    goto __continue9
                end
                local damage = GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg["每秒目标最大生命比例"]
                UnitDamageTarget(
                    boss,
                    hero,
                    damage,
                    false,
                    false,
                    ATTACK_TYPE_NORMAL,
                    DAMAGE_TYPE_PLANT,
                    WEAPON_TYPE_WHOKNOWS
                )
                AddSpecialEffect(
                    cfg["命中特效路径"],
                    GetUnitX(hero),
                    GetUnitY(hero)
                )
                _____5E94_7528_83AB_5C14_7279_65AF_8150_8D25_503C(data.context, hero, cfg["每秒腐败值"])
            end
            ::__continue9::
            i = i + 1
        end
    end
end
function _____521B_5EFA_5355_56E2_5B62_5B50_4E91(context)
    local boss = context["Boss单位"]
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败孢子云"]
    local instance = _____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D({
        ["清理"] = context["清理"],
        ["名称"] = "莫尔特斯-腐败孢子云",
        ["主人单位"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        ["单位类型"] = cfg["单位类型"],
        ["模型路径"] = cfg["模型路径"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["朝向"] = GetRandomReal(0, 360),
        ["最大生命"] = cfg["驱散所需伤害"],
        ["生命值受小怪倍率"] = cfg["受小怪倍率生命"],
        ["缩放"] = cfg["缩放"],
        ["持续时间"] = cfg["持续秒"]
    })
    if instance == nil or not _____5355_4F4D_6709_6548(instance["单位"]) then
        return
    end
    local data = {context = context, ["孢子单位"] = instance["单位"], ["剩余跳数"] = cfg["持续秒"], ["周期ID"] = 0}
    data["周期ID"] = addPeriodicCallback(1000, _____83AB_5C14_7279_65AF_5B62_5B50_4E91_5468_671F, data)
    local ____self_4 = context["清理"]
    ____self_4["登记周期回调"](____self_4, "莫尔特斯-腐败孢子云周期", data["周期ID"])
end
local jass = require("jass.common")
local GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetOwningPlayer = jass.GetOwningPlayer
GetRandomReal = jass.GetRandomReal
IssuePointOrder = jass.IssuePointOrder
UnitDamageTarget = jass.UnitDamageTarget
AddSpecialEffect = jass.AddSpecialEffect
GetUnitState = jass.GetUnitState
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_0 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_0.registerSpellEffectListener
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
addPeriodicCallback = ____require_result_1.addPeriodicCallback
removePeriodicCallback = ____require_result_1.removePeriodicCallback
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.05．机制单位.01．可攻击机制单位")
_____521B_5EFA_53EF_653B_51FB_673A_5236_5355_4F4D = ____require_result_2["创建可攻击机制单位"]
local ____require_result_3 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_3["获取Boss技能敌对英雄列表"]
local _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83AB_5C14_7279_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____8150_8D25_5B62_5B50_4E91_6280_80FDID = stringToFourCC(_____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败孢子云"]["技能槽位"])
local _____5DF2_6CE8_518C = false
local function _____83AB_5C14_7279_65AF_5EF6_8FDF_521B_5EFA_5B62_5B50_4E91(variable)
    local context = variable
    if context == nil then
        return
    end
    _____521B_5EFA_5355_56E2_5B62_5B50_4E91(context)
end
local function _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83AB_5C14_7279_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["腐败孢子云"]
    _____64AD_653E_83AB_5C14_7279_65AF_53F0_8BCD(boss, "腐败孢子云")
    do
        local i = 0
        while i < cfg["数量"] do
            local id = addDelayedCallback(i * 1000, _____83AB_5C14_7279_65AF_5EF6_8FDF_521B_5EFA_5B62_5B50_4E91, context)
            local ____self_5 = context["清理"]
            ____self_5["登记延迟回调"](____self_5, "莫尔特斯-创建腐败孢子云", id)
            i = i + 1
        end
    end
end
local function ____on_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91_65BD_6CD5(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8150_8D25_5B62_5B50_4E91_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83AB_5C14_7279_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83AB_5C14_7279_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    _____91CA_653E_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91(context)
end
____exports["注册莫尔特斯腐败孢子云"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_83AB_5C14_7279_65AF_8150_8D25_5B62_5B50_4E91_65BD_6CD5)
end
return ____exports
