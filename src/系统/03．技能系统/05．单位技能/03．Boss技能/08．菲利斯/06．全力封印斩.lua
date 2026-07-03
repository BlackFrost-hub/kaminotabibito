--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____9009_62E9_5C01_5370_76EE_6807, _____6807_8BB0_5C01_5370_76EE_6807, _____6267_884C_5C01_5370_60E9_7F5A, _____77AC_79FB_5230_5C01_5370_76EE_6807, ____on_83F2_5229_65AF_5168_529B_5C01_5370_65A9_751F_6548, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitState, SetUnitState, SetUnitX, SetUnitY, SetUnitInvulnerable, GetRandomInt, UnitDamageTarget, UNIT_STATE_MANA, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, addDelayedCallback, registerManualBuff, _____83F2_5229_65AFBuffID, _____547D_4EE4_5361_6280_80FD_662F_5426_5168_90E8_51B7_5374_4E2D, _____65BD_52A0_5FEB_901F_63A7_5236Buff, _____521B_5EFA_70B9_7279_6548, createUnitEffect, _____5FEB_901F_63A7_5236__51FB_6655, _____83F2_5229_65AF_5355_4F4D_7C7B_578BID, _____5168_529B_5C01_5370_65A9_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.00．配置")
local _____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["菲利斯单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建菲利斯上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.02．数值与表现配置")
local _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["菲利斯数值与表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.08．台词播放")
local _____64AD_653E_83F2_5229_65AF_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放菲利斯台词"]
local ____11_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.08．菲利斯.11．公共工具")
local _____5355_4F4D_6709_6548 = ____11_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____11_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_96BE_5EA6 = ____11_FF0E_516C_5171_5DE5_5177["取难度"]
local _____53D6_5355_4F4D_95F4_89D2_5EA6 = ____11_FF0E_516C_5171_5DE5_5177["取单位间角度"]
local _____6781_5750_6807X = ____11_FF0E_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____11_FF0E_516C_5171_5DE5_5177["极坐标Y"]
function _____9009_62E9_5C01_5370_76EE_6807(boss)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local result = {}
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue4
                end
                if _____547D_4EE4_5361_6280_80FD_662F_5426_5168_90E8_51B7_5374_4E2D(hero, {"Q", "W", "E", "R"}) then
                    result[#result + 1] = hero
                end
            end
            ::__continue4::
            i = i + 1
        end
    end
    return result
end
function _____6807_8BB0_5C01_5370_76EE_6807(boss, targets)
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["全力封印斩"]
    do
        local i = 0
        while i < #targets do
            local target = targets[i + 1]
            registerManualBuff(
                target,
                _____83F2_5229_65AFBuffID["封印标记"],
                cfg["前摇秒"] + 0.5,
                0,
                {sourceName = "菲利斯-全力封印斩"}
            )
            _____521B_5EFA_6280_80FD_63D0_793A_5708({
                ["类型"] = "渐变圆形",
                X = GetUnitX(target),
                Y = GetUnitY(target),
                ["半径"] = 220,
                ["持续时间"] = cfg["前摇秒"],
                ["来源单位"] = boss
            })
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["玩家封印特效路径"],
                X = GetUnitX(target),
                Y = GetUnitY(target),
                ["缩放"] = 1,
                ["持续秒"] = cfg["前摇秒"] + 0.2
            })
            i = i + 1
        end
    end
end
function _____6267_884C_5C01_5370_60E9_7F5A(boss, target)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["全力封印斩"]
    local n = _____53D6_96BE_5EA6()
    local mana = GetUnitState(target, UNIT_STATE_MANA)
    local manaLoss = mana * (cfg["魔法扣除基础比例"] + cfg["魔法扣除每难度追加比例"] * n)
    if manaLoss > 0 then
        SetUnitState(target, UNIT_STATE_MANA, mana - manaLoss)
        UnitDamageTarget(
            boss,
            target,
            manaLoss,
            false,
            false,
            ATTACK_TYPE_NORMAL,
            DAMAGE_TYPE_MAGIC,
            WEAPON_TYPE_WHOKNOWS
        )
    end
    _____65BD_52A0_5FEB_901F_63A7_5236Buff(boss, target, _____5FEB_901F_63A7_5236__51FB_6655, cfg["基础眩晕秒"] + cfg["每难度眩晕追加秒"] * n)
    createUnitEffect(
        target,
        "origin",
        cfg["命中特效路径"],
        cfg["特效持续秒"],
        "菲利斯-封印命中"
    )
end
function _____77AC_79FB_5230_5C01_5370_76EE_6807(boss, target)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["全力封印斩"]
    local angle = _____53D6_5355_4F4D_95F4_89D2_5EA6(target, boss)
    SetUnitX(
        boss,
        _____6781_5750_6807X(
            GetUnitX(target),
            angle,
            cfg["瞬移距离"]
        )
    )
    SetUnitY(
        boss,
        _____6781_5750_6807Y(
            GetUnitY(target),
            angle,
            cfg["瞬移距离"]
        )
    )
end
____exports["释放菲利斯全力封印斩"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["全力封印斩"]
    local targets = _____9009_62E9_5C01_5370_76EE_6807(boss)
    _____6807_8BB0_5C01_5370_76EE_6807(boss, targets)
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["Boss起手特效路径"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["缩放"] = 1.2,
        ["持续秒"] = cfg["特效持续秒"]
    })
    createUnitEffect(
        boss,
        "origin",
        cfg["Boss附身特效路径"],
        cfg["特效持续秒"],
        "菲利斯-全力封印斩附身"
    )
    SetUnitInvulnerable(boss, true)
    local invulID = addDelayedCallback(
        (cfg["前摇秒"] + 0.2) * 1000,
        function()
            if _____5355_4F4D_6709_6548(boss) then
                SetUnitInvulnerable(boss, false)
            end
        end
    )
    local ____self_10 = context["清理"]
    ____self_10["登记延迟回调"](____self_10, "菲利斯-封印无敌结束", invulID)
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标X"] = GetUnitX(boss),
        ["目标Y"] = GetUnitY(boss),
        ["硬直秒"] = cfg["前摇秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["前摇秒"],
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_83F2_5229_65AF_53F0_8BCD(boss, "全力封印斩")
        end,
        ["on生效"] = function()
            if #targets <= 0 then
                return
            end
            do
                local i = 0
                while i < #targets do
                    _____6267_884C_5C01_5370_60E9_7F5A(boss, targets[i + 1])
                    i = i + 1
                end
            end
            local teleportTarget = targets[GetRandomInt(0, #targets - 1) + 1]
            _____77AC_79FB_5230_5C01_5370_76EE_6807(boss, teleportTarget)
        end
    })
end
function ____on_83F2_5229_65AF_5168_529B_5C01_5370_65A9_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____5168_529B_5C01_5370_65A9_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____83F2_5229_65AF_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_83F2_5229_65AF_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放菲利斯全力封印斩"](context)
end
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
SetUnitState = jass.SetUnitState
SetUnitX = jass.SetUnitX
SetUnitY = jass.SetUnitY
SetUnitInvulnerable = jass.SetUnitInvulnerable
GetRandomInt = jass.GetRandomInt
UnitDamageTarget = jass.UnitDamageTarget
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_0["启动基础施法时间线"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_1["创建技能提示圈"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_3.registerSpellEffectListener
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_4.addDelayedCallback
local ____require_result_5 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_5.registerManualBuff
local ____require_result_6 = require("系统.05．Buff系统.03．Buff表.01．Boss.06．菲利斯")
_____83F2_5229_65AFBuffID = ____require_result_6["菲利斯BuffID"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.14．命令卡技能冷却查询")
_____547D_4EE4_5361_6280_80FD_662F_5426_5168_90E8_51B7_5374_4E2D = ____require_result_7["命令卡技能是否全部冷却中"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_63A7_5236Buff = ____require_result_8["施加快速控制Buff"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_9["创建点特效"]
createUnitEffect = ____require_result_9.createUnitEffect
_____5FEB_901F_63A7_5236__51FB_6655 = 0
_____83F2_5229_65AF_5355_4F4D_7C7B_578BID = stringToFourCC(_____83F2_5229_65AF_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____5168_529B_5C01_5370_65A9_6280_80FDID = stringToFourCC(_____83F2_5229_65AF_6570_503C_4E0E_8868_73B0_914D_7F6E["全力封印斩"]["技能槽位"])
local _____5168_529B_5C01_5370_65A9_5DF2_6CE8_518C = false
____exports["注册菲利斯全力封印斩"] = function()
    if _____5168_529B_5C01_5370_65A9_5DF2_6CE8_518C then
        return
    end
    _____5168_529B_5C01_5370_65A9_5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_83F2_5229_65AF_5168_529B_5C01_5370_65A9_751F_6548)
end
return ____exports
