--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_56DB_91CD_98CE_5203_76EE_6807, _____7ED3_7B97_8DF3_5288, _____8C03_5EA6_9F99_5377_98CE_9636_6BB5_6539_5411, _____53D1_5C04_5355_4E2A_9F99_5377_98CE, _____53D1_5C04_56DB_91CD_9F99_5377_98CE, ____on_91CC_79D1_7279_56DB_91CD_98CE_5203_751F_6548, GetUnitTypeId, GetUnitX, GetUnitY, GetSpellTargetUnit, GetOwningPlayer, UnitDamageTarget, ATTACK_TYPE_MAGIC, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_MAGIC, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____65BD_52A0_5FEB_901F_51CF_901FBuff, _____521B_5EFA_539F_751F_5F39_5E55, _____83B7_53D6_539F_751F_5F39_5E55, _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868, addDelayedCallback, _____91CC_79D1_7279_5355_4F4D_7C7B_578BID, _____56DB_91CD_98CE_5203_6280_80FDID
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.00．配置")
local _____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["里科特单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.01．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建里科特上下文"]
local _____5237_65B0_91CC_79D1_7279_9636_6BB5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["刷新里科特阶段"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.02．数值与表现配置")
local _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["里科特数值与表现配置"]
local ____10_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.10．台词播放")
local _____64AD_653E_91CC_79D1_7279_53F0_8BCD = ____10_FF0E_53F0_8BCD_64AD_653E["播放里科特台词"]
local ____13_FF0E_516C_5171_5DE5_5177 = require("系统.03．技能系统.05．单位技能.03．Boss技能.09．里科特.13．公共工具")
local _____5355_4F4D_6709_6548 = ____13_FF0E_516C_5171_5DE5_5177["单位有效"]
local stringToFourCC = ____13_FF0E_516C_5171_5DE5_5177.stringToFourCC
local _____53D6_5355_4F4D_95F4_89D2_5EA6 = ____13_FF0E_516C_5171_5DE5_5177["取单位间角度"]
function _____53D6_56DB_91CD_98CE_5203_76EE_6807(boss)
    local target = GetSpellTargetUnit()
    local _____5355_4F4D_6709_6548_result_9
    if _____5355_4F4D_6709_6548(target) then
        _____5355_4F4D_6709_6548_result_9 = target
    else
        _____5355_4F4D_6709_6548_result_9 = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["四重风刃"]["施法距离"] + 300)
    end
    return _____5355_4F4D_6709_6548_result_9
end
function _____7ED3_7B97_8DF3_5288(boss, target)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["四重风刃"]
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    local cx = GetUnitX(target)
    local cy = GetUnitY(target)
    local radius2 = cfg["跳劈半径"] * cfg["跳劈半径"]
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["跳劈Boss攻击力比例"]
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(hero) then
                    goto __continue5
                end
                local dx = GetUnitX(hero) - cx
                local dy = GetUnitY(hero) - cy
                if dx * dx + dy * dy > radius2 then
                    goto __continue5
                end
                UnitDamageTarget(
                    boss,
                    hero,
                    damage,
                    false,
                    false,
                    ATTACK_TYPE_NORMAL,
                    DAMAGE_TYPE_NORMAL,
                    WEAPON_TYPE_WHOKNOWS
                )
                _____65BD_52A0_5FEB_901F_51CF_901FBuff(
                    boss,
                    hero,
                    cfg["跳劈减速比例"],
                    cfg["跳劈减速比例"],
                    cfg["跳劈减速秒"]
                )
            end
            ::__continue5::
            i = i + 1
        end
    end
end
function _____8C03_5EA6_9F99_5377_98CE_9636_6BB5_6539_5411(context, _____5F39_5E55ID)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["四重风刃"]
    local stage = _____5237_65B0_91CC_79D1_7279_9636_6BB5(context)
    if stage == 1 then
        return
    end
    local id = addDelayedCallback(
        (stage >= 3 and cfg["P3追踪延迟秒"] or cfg["P2回转延迟秒"]) * 1000,
        function()
            local boss = context["Boss单位"]
            if not _____5355_4F4D_6709_6548(boss) then
                return
            end
            local bullet = _____83B7_53D6_539F_751F_5F39_5E55(_____5F39_5E55ID)
            if bullet == nil or not _____5355_4F4D_6709_6548(bullet["弹幕单位"]) then
                return
            end
            if _____5237_65B0_91CC_79D1_7279_9636_6BB5(context) >= 3 then
                local target = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, 2000)
                if _____5355_4F4D_6709_6548(target) then
                    _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C(
                        _____5F39_5E55ID,
                        _____53D6_5355_4F4D_95F4_89D2_5EA6(bullet["弹幕单位"], target),
                        cfg["龙卷风速度"]
                    )
                end
                return
            end
            _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C(
                _____5F39_5E55ID,
                _____53D6_5355_4F4D_95F4_89D2_5EA6(bullet["弹幕单位"], boss),
                cfg["龙卷风速度"]
            )
        end
    )
    local ____self_10 = context["清理"]
    ____self_10["登记延迟回调"](____self_10, "里科特-龙卷风改向", id)
end
function _____53D1_5C04_5355_4E2A_9F99_5377_98CE(context, angle)
    local boss = context["Boss单位"]
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["四重风刃"]
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["龙卷风Boss攻击力比例"]
    local bullet = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["方向角"] = angle,
        ["速度"] = cfg["龙卷风速度"],
        ["最大距离"] = cfg["龙卷风射程"],
        ["命中半径"] = cfg["龙卷风命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = false,
        ["每单位最大命中次数"] = 1,
        ["模型"] = cfg["龙卷风模型路径"],
        ["缩放"] = cfg["龙卷风缩放"],
        ["飞行高度"] = cfg["龙卷风飞行高度"],
        ["on命中"] = function(target)
            if not _____5355_4F4D_6709_6548(target) then
                return
            end
            UnitDamageTarget(
                boss,
                target,
                damage,
                false,
                false,
                ATTACK_TYPE_MAGIC,
                DAMAGE_TYPE_MAGIC,
                WEAPON_TYPE_WHOKNOWS
            )
        end
    })
    _____8C03_5EA6_9F99_5377_98CE_9636_6BB5_6539_5411(context, bullet["弹幕ID"])
end
function _____53D1_5C04_56DB_91CD_9F99_5377_98CE(context)
    do
        local i = 0
        while i < 4 do
            _____53D1_5C04_5355_4E2A_9F99_5377_98CE(context, i * 90 + 45)
            i = i + 1
        end
    end
end
____exports["释放里科特四重风刃"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____53D6_56DB_91CD_98CE_5203_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["四重风刃"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "圆形",
        X = GetUnitX(target),
        Y = GetUnitY(target),
        ["半径"] = cfg["跳劈半径"],
        ["持续时间"] = cfg["前摇秒"],
        ["来源单位"] = boss
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标单位"] = target,
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
            _____64AD_653E_91CC_79D1_7279_53F0_8BCD(boss, "四重风刃")
        end,
        ["on生效"] = function()
            _____7ED3_7B97_8DF3_5288(boss, target)
            local id = addDelayedCallback(
                cfg["龙卷风延迟秒"] * 1000,
                function()
                    _____53D1_5C04_56DB_91CD_9F99_5377_98CE(context)
                end
            )
            local ____self_11 = context["清理"]
            ____self_11["登记延迟回调"](____self_11, "里科特-四重龙卷风", id)
        end
    })
end
function ____on_91CC_79D1_7279_56DB_91CD_98CE_5203_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____56DB_91CD_98CE_5203_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____91CC_79D1_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放里科特四重风刃"](context)
end
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetSpellTargetUnit = jass.GetSpellTargetUnit
GetOwningPlayer = jass.GetOwningPlayer
UnitDamageTarget = jass.UnitDamageTarget
ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____65BD_52A0_5FEB_901F_51CF_901FBuff = ____require_result_3["施加快速减速Buff"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
_____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_4["创建原生弹幕"]
_____83B7_53D6_539F_751F_5F39_5E55 = ____require_result_4["获取原生弹幕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.06．改向与反弹.00．弹幕改向")
_____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C = ____require_result_5["设置原生弹幕指定角度飞行"]
local ____require_result_6 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_6["获取Boss技能随机敌对英雄"]
_____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_6["获取Boss技能敌对英雄列表"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.08．技能事件中心")
local registerSpellEffectListener = ____require_result_7.registerSpellEffectListener
local ____require_result_8 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_8.addDelayedCallback
_____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____56DB_91CD_98CE_5203_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["四重风刃"]["技能槽位"])
local _____5DF2_6CE8_518C = false
____exports["注册里科特四重风刃"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    registerSpellEffectListener(____on_91CC_79D1_7279_56DB_91CD_98CE_5203_751F_6548)
end
return ____exports
