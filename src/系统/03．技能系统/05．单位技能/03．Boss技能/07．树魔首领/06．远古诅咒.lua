--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local stringToFourCC, _____5355_4F4D_6709_6548, _____8DDD_79BB_5E73_65B9XY, _____53D6_6709_6548_73A9_5BB6_4EBA_6570, _____53D6_8BC5_5492_76EE_6807, _____542F_52A8_8DDF_968F_5206_644A_63D0_793A_5708, _____64AD_653E_70B9_540D_7279_6548, _____6536_96C6_5206_644A_76EE_6807, _____6CBB_7597_5168_90E8_73A9_5BB6, _____53D6_73A9_5BB6_4E2D_5FC3, _____6267_884C_8FDC_53E4_8BC5_5492_540E_7EED_7206_53D1, _____8C03_5EA6_8FDC_53E4_8BC5_5492_540E_7EED_7206_53D1, _____6267_884C_8FDC_53E4_8BC5_5492_7B2C_4E00_6BB5, ____on_6811_9B54_9996_9886_8FDC_53E4_8BC5_5492_751F_6548, _____9020_6210AOE_6280_80FD_4F24_5BB3, GetUnitTypeId, GetSpellTargetUnit, GetUnitX, GetUnitY, GetUnitState, IsUnitType, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, UNIT_TYPE_DEAD, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MIND, DAMAGE_TYPE_ENHANCED, WEAPON_TYPE_WHOKNOWS, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, addDelayedCallback, addPeriodicCallback, removePeriodicCallback, registerManualBuff, _____6811_9B54_9996_9886BuffID, doHeal, _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570, createTimedEffect, _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID, _____8FDC_53E4_8BC5_5492_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.00．配置")
local _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["树魔首领单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建树魔首领上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.02．数值与表现配置")
local _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领数值与表现配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.07．树魔首领.08．台词播放")
local _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放树魔首领台词"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function stringToFourCC(s)
    return (string.byte(s, 1) or 0 / 0) * 16777216 + (string.byte(s, 2) or 0 / 0) * 65536 + (string.byte(s, 3) or 0 / 0) * 256 + (string.byte(s, 4) or 0 / 0)
end
function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
function _____8DDD_79BB_5E73_65B9XY(x1, y1, x2, y2)
    local dx = x1 - x2
    local dy = y1 - y2
    return dx * dx + dy * dy
end
function _____53D6_6709_6548_73A9_5BB6_4EBA_6570()
    local count = _____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570()
    return count > 0 and count or 1
end
function _____53D6_8BC5_5492_76EE_6807(boss)
    local spellTarget = GetSpellTargetUnit()
    if _____5355_4F4D_6709_6548(spellTarget) then
        return spellTarget
    end
    local highest = _____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807(boss)
    if highest ~= nil and _____5355_4F4D_6709_6548(highest.targetRef) then
        return highest.targetRef
    end
    return _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss)
end
function _____542F_52A8_8DDF_968F_5206_644A_63D0_793A_5708(context, target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["远古诅咒"]
    local elapsed = 0
    _____521B_5EFA_6280_80FD_63D0_793A_5708({["类型"] = "圆形", ["锚点单位"] = target, ["半径"] = cfg["分摊半径"], ["持续时间"] = cfg["跟随提示圈刷新毫秒"] / 1000 + 0.05})
    local id
    id = addPeriodicCallback(
        cfg["跟随提示圈刷新毫秒"],
        function()
            elapsed = elapsed + cfg["跟随提示圈刷新毫秒"]
            if not _____5355_4F4D_6709_6548(target) or elapsed > cfg["延迟秒"] * 1000 then
                removePeriodicCallback(id)
                return
            end
            _____521B_5EFA_6280_80FD_63D0_793A_5708({["类型"] = "圆形", ["锚点单位"] = target, ["半径"] = cfg["分摊半径"], ["持续时间"] = cfg["跟随提示圈刷新毫秒"] / 1000 + 0.05})
        end
    )
    local ____self_11 = context["清理"]
    ____self_11["登记周期回调"](____self_11, "树魔首领-远古诅咒分摊提示", id)
end
function _____64AD_653E_70B9_540D_7279_6548(target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["远古诅咒"]
    createTimedEffect(
        cfg["点名特效路径"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        cfg["点名特效持续秒"]
    )
    createTimedEffect(
        cfg["点名叠加特效路径"],
        GetUnitX(target),
        GetUnitY(target),
        0,
        cfg["点名特效持续秒"]
    )
end
function _____6536_96C6_5206_644A_76EE_6807(boss, target)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["远古诅咒"]
    local result = {}
    local radius2 = cfg["分摊半径"] * cfg["分摊半径"]
    local targetX = GetUnitX(target)
    local targetY = GetUnitY(target)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue15
                end
                if _____8DDD_79BB_5E73_65B9XY(
                    targetX,
                    targetY,
                    GetUnitX(hero),
                    GetUnitY(hero)
                ) <= radius2 then
                    result[#result + 1] = hero
                end
            end
            ::__continue15::
            i = i + 1
        end
    end
    return result
end
function _____6CBB_7597_5168_90E8_73A9_5BB6(boss, amount)
    if not (amount > 0) then
        return
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue21
                end
                doHeal({
                    HealSource = boss,
                    HealTarget = hero,
                    HealAmount = amount,
                    ItemHeal = false,
                    HealEffect = true
                })
            end
            ::__continue21::
            i = i + 1
        end
    end
end
function _____53D6_73A9_5BB6_4E2D_5FC3(boss)
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local sx = 0
    local sy = 0
    local count = 0
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue25
                end
                sx = sx + GetUnitX(hero)
                sy = sy + GetUnitY(hero)
                count = count + 1
            end
            ::__continue25::
            i = i + 1
        end
    end
    if count <= 0 then
        return {
            x = GetUnitX(boss),
            y = GetUnitY(boss),
            count = 0
        }
    end
    return {x = sx / count, y = sy / count, count = count}
end
function _____6267_884C_8FDC_53E4_8BC5_5492_540E_7EED_7206_53D1(context, centerX, centerY)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["远古诅咒"]
    createTimedEffect(
        cfg["后续爆发特效路径"],
        centerX,
        centerY,
        0,
        cfg["后续爆发特效持续秒"]
    )
    local radius2 = cfg["后续爆发半径"] * cfg["后续爆发半径"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue31
                end
                if _____8DDD_79BB_5E73_65B9XY(
                    centerX,
                    centerY,
                    GetUnitX(hero),
                    GetUnitY(hero)
                ) > radius2 then
                    goto __continue31
                end
                local damage = GetUnitState(hero, UNIT_STATE_MAX_LIFE) * cfg["后续爆发目标最大生命比例"] + _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["后续爆发Boss攻击力比例"]
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = hero,
                    ["伤害"] = damage,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_ENHANCED,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
            end
            ::__continue31::
            i = i + 1
        end
    end
end
function _____8C03_5EA6_8FDC_53E4_8BC5_5492_540E_7EED_7206_53D1(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or _____53D6_6709_6548_73A9_5BB6_4EBA_6570() <= 1 then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["远古诅咒"]
    local center = _____53D6_73A9_5BB6_4E2D_5FC3(boss)
    if center.count <= 1 then
        return
    end
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "渐变圆形",
        X = center.x,
        Y = center.y,
        ["半径"] = cfg["后续爆发半径"],
        ["持续时间"] = cfg["后续爆发延迟秒"],
        ["来源单位"] = boss
    })
    local delayedID = addDelayedCallback(
        cfg["后续爆发延迟秒"] * 1000,
        function()
            _____6267_884C_8FDC_53E4_8BC5_5492_540E_7EED_7206_53D1(context, center.x, center.y)
        end
    )
    local ____self_12 = context["清理"]
    ____self_12["登记延迟回调"](____self_12, "树魔首领-远古诅咒二段", delayedID)
end
function _____6267_884C_8FDC_53E4_8BC5_5492_7B2C_4E00_6BB5(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["远古诅咒"]
    local playerCount = _____53D6_6709_6548_73A9_5BB6_4EBA_6570()
    local baseDamage = GetUnitState(target, UNIT_STATE_LIFE) * (cfg["当前生命基础比例"] + cfg["每名玩家当前生命追加比例"] * playerCount)
    local splitTargets = _____6536_96C6_5206_644A_76EE_6807(boss, target)
    local count = #splitTargets >= 2 and #splitTargets or 1
    local damagePerTarget = baseDamage / count
    if #splitTargets >= 2 then
        do
            local i = 0
            while i < #splitTargets do
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = splitTargets[i + 1],
                    ["伤害"] = damagePerTarget,
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_MIND,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能"
                })
                i = i + 1
            end
        end
    else
        _____9020_6210AOE_6280_80FD_4F24_5BB3({
            ["来源"] = boss,
            ["目标"] = target,
            ["伤害"] = baseDamage,
            attack = false,
            ranged = false,
            attackType = ATTACK_TYPE_NORMAL,
            ["伤害类型"] = DAMAGE_TYPE_MIND,
            weaponType = WEAPON_TYPE_WHOKNOWS,
            ["来源类型"] = "Boss技能"
        })
    end
    _____6CBB_7597_5168_90E8_73A9_5BB6(boss, baseDamage)
    _____8C03_5EA6_8FDC_53E4_8BC5_5492_540E_7EED_7206_53D1(context)
end
____exports["释放树魔首领远古诅咒"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____53D6_8BC5_5492_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["远古诅咒"]
    registerManualBuff(
        target,
        _____6811_9B54_9996_9886BuffID["远古诅咒"],
        cfg["延迟秒"],
        0,
        {sourceName = "树魔首领-远古诅咒"}
    )
    _____64AD_653E_70B9_540D_7279_6548(target)
    _____542F_52A8_8DDF_968F_5206_644A_63D0_793A_5708(context, target)
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = cfg["延迟秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = cfg["延迟秒"],
            ["颜色ID"] = cfg["吟唱条颜色ID"],
            ["标题文本"] = cfg["吟唱条标题文本"],
            ["提示文本"] = cfg["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD(boss, "远古诅咒")
        end,
        ["on生效"] = function()
            _____6267_884C_8FDC_53E4_8BC5_5492_7B2C_4E00_6BB5(context, target)
        end
    })
end
function ____on_6811_9B54_9996_9886_8FDC_53E4_8BC5_5492_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8FDC_53E4_8BC5_5492_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放树魔首领远古诅咒"](context)
end
local ____require_result_0 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_0["造成AOE技能伤害"]
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
IsUnitType = jass.IsUnitType
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
DAMAGE_TYPE_ENHANCED = jass.DAMAGE_TYPE_ENHANCED
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_1 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_1["读取单位攻击力"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_2["启动基础施法时间线"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_3["创建技能提示圈"]
local ____require_result_4 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_6700_9AD8_4EC7_6068_76EE_6807 = ____require_result_4["获取Boss技能最高仇恨目标"]
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_4["获取Boss技能随机敌对英雄"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_4["获取Boss技能敌对英雄列表"]
local ____require_result_5 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_5.addDelayedCallback
addPeriodicCallback = ____require_result_5.addPeriodicCallback
removePeriodicCallback = ____require_result_5.removePeriodicCallback
local ____require_result_6 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_6.registerManualBuff
local ____require_result_7 = require("系统.05．Buff系统.03．Buff表.01．Boss.05．树魔首领")
_____6811_9B54_9996_9886BuffID = ____require_result_7["树魔首领BuffID"]
local ____require_result_8 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
doHeal = ____require_result_8.doHeal
local ____require_result_9 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.06．玩家人数")
_____53D6_5F53_524D_6709_6548_73A9_5BB6_4EBA_6570 = ____require_result_9["取当前有效玩家人数"]
local ____require_result_10 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
createTimedEffect = ____require_result_10.createTimedEffect
local _____521B_5EFA_70B9_7279_6548 = ____require_result_10["创建点特效"]
_____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____8FDC_53E4_8BC5_5492_6280_80FDID = stringToFourCC(_____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["远古诅咒"]["技能槽位"])
local _____8FDC_53E4_8BC5_5492_5DF2_6CE8_518C = false
____exports["注册树魔首领远古诅咒"] = function()
    if _____8FDC_53E4_8BC5_5492_5DF2_6CE8_518C then
        return
    end
    _____8FDC_53E4_8BC5_5492_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "树魔首领-远古诅咒",
        ["单位类型ID"] = _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8FDC_53E4_8BC5_5492_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_6811_9B54_9996_9886_8FDC_53E4_8BC5_5492_751F_6548(boss, _____8FDC_53E4_8BC5_5492_6280_80FDID)
        end
    })
end
return ____exports
