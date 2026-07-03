--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____53D6_8FFD_51FB_76EE_6807, _____8C03_5EA6_8FFD_51FB_98CE_5203_9636_6BB5_6539_5411, _____53D1_5C04_8FFD_51FB_98CE_5203, ____on_91CC_79D1_7279_8FFD_51FB_98CE_5203_751F_6548, GetUnitTypeId, GetUnitX, GetUnitY, GetSpellTargetUnit, GetOwningPlayer, UnitDamageTarget, ATTACK_TYPE_MAGIC, DAMAGE_TYPE_MAGIC, WEAPON_TYPE_WHOKNOWS, _____8BFB_53D6_5355_4F4D_653B_51FB_529B, _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF, _____521B_5EFA_6280_80FD_63D0_793A_5708, _____521B_5EFA_539F_751F_5F39_5E55, _____83B7_53D6_539F_751F_5F39_5E55, _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C, _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4, addDelayedCallback, _____91CC_79D1_7279_5355_4F4D_7C7B_578BID, _____8FFD_51FB_98CE_5203_6280_80FDID
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
local ____16_FF0EBoss_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．Boss技能壳监听注册器")
local _____6CE8_518CBoss_6280_80FD_58F3_76D1_542C = ____16_FF0EBoss_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册Boss技能壳监听"]
function _____53D6_8FFD_51FB_76EE_6807(boss)
    local target = GetSpellTargetUnit()
    local _____5355_4F4D_6709_6548_result_8
    if _____5355_4F4D_6709_6548(target) then
        _____5355_4F4D_6709_6548_result_8 = target
    else
        _____5355_4F4D_6709_6548_result_8 = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, boss, _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["追击风刃"]["施法距离"] + 300)
    end
    return _____5355_4F4D_6709_6548_result_8
end
function _____8C03_5EA6_8FFD_51FB_98CE_5203_9636_6BB5_6539_5411(context, _____5F39_5E55ID)
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["追击风刃"]
    local boss = context["Boss单位"]
    local stage = _____5237_65B0_91CC_79D1_7279_9636_6BB5(context)
    if stage == 1 then
        return
    end
    local delay = stage >= 3 and cfg["P3追踪延迟秒"] or cfg["P2回转延迟秒"]
    local id = addDelayedCallback(
        delay * 1000,
        function()
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
                        cfg["速度"]
                    )
                end
                return
            end
            _____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C(
                _____5F39_5E55ID,
                _____53D6_5355_4F4D_95F4_89D2_5EA6(bullet["弹幕单位"], boss),
                cfg["速度"]
            )
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "里科特-追击风刃改向", id)
end
function _____53D1_5C04_8FFD_51FB_98CE_5203(context, angle)
    local boss = context["Boss单位"]
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["追击风刃"]
    local damage = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(boss) * cfg["Boss攻击力比例"]
    local bullet = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        ["所属玩家"] = GetOwningPlayer(boss),
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["方向角"] = angle,
        ["速度"] = cfg["速度"],
        ["最大距离"] = cfg["射程"],
        ["命中半径"] = cfg["命中半径"],
        ["影响目标"] = "敌方",
        ["碰撞消失"] = false,
        ["每单位最大命中次数"] = 1,
        ["模型"] = cfg["模型路径"],
        ["缩放"] = cfg["缩放"],
        ["飞行高度"] = cfg["飞行高度"],
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
    _____8C03_5EA6_8FFD_51FB_98CE_5203_9636_6BB5_6539_5411(context, bullet["弹幕ID"])
end
____exports["释放里科特追击风刃"] = function(context)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    local target = _____53D6_8FFD_51FB_76EE_6807(boss)
    if not _____5355_4F4D_6709_6548(target) then
        return
    end
    local cfg = _____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["追击风刃"]
    local angle = _____53D6_5355_4F4D_95F4_89D2_5EA6(boss, target)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["宽度"] = cfg["命中半径"] * 2,
        ["长度"] = cfg["射程"],
        ["朝向"] = angle,
        ["持续时间"] = cfg["前摇秒"],
        ["来源单位"] = boss
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["目标单位"] = target,
        ["硬直秒"] = cfg["前摇秒"],
        ["动画编号"] = cfg["动画编号"],
        ["动画速度"] = cfg["动画速度"],
        ["吟唱条"] = {["通道"] = "常规技能", ["总时长"] = cfg["前摇秒"], ["颜色ID"] = cfg["吟唱条颜色ID"], ["标题文本"] = cfg["吟唱条标题文本"]},
        ["播放台词"] = function()
            _____64AD_653E_91CC_79D1_7279_53F0_8BCD(boss, "追击风刃")
        end,
        ["on生效"] = function()
            _____53D1_5C04_8FFD_51FB_98CE_5203(context, angle)
        end
    })
end
function ____on_91CC_79D1_7279_8FFD_51FB_98CE_5203_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____8FFD_51FB_98CE_5203_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____91CC_79D1_7279_5355_4F4D_7C7B_578BID then
        return
    end
    local context = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放里科特追击风刃"](context)
end
local jass = require("jass.common")
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetSpellTargetUnit = jass.GetSpellTargetUnit
GetOwningPlayer = jass.GetOwningPlayer
UnitDamageTarget = jass.UnitDamageTarget
ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____require_result_0 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
_____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_0["读取单位攻击力"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
_____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
_____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_2["创建技能提示圈"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
_____521B_5EFA_539F_751F_5F39_5E55 = ____require_result_3["创建原生弹幕"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
_____83B7_53D6_539F_751F_5F39_5E55 = ____require_result_4["获取原生弹幕"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.06．改向与反弹.00．弹幕改向")
_____8BBE_7F6E_539F_751F_5F39_5E55_6307_5B9A_89D2_5EA6_98DE_884C = ____require_result_5["设置原生弹幕指定角度飞行"]
local ____require_result_6 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_6["获取Boss技能随机敌对英雄"]
local ____require_result_7 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_7.addDelayedCallback
_____91CC_79D1_7279_5355_4F4D_7C7B_578BID = stringToFourCC(_____91CC_79D1_7279_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____8FFD_51FB_98CE_5203_6280_80FDID = stringToFourCC(_____91CC_79D1_7279_6570_503C_4E0E_8868_73B0_914D_7F6E["追击风刃"]["技能槽位"])
local _____5DF2_6CE8_518C = false
____exports["注册里科特追击风刃"] = function()
    if _____5DF2_6CE8_518C then
        return
    end
    _____5DF2_6CE8_518C = true
    _____6CE8_518CBoss_6280_80FD_58F3_76D1_542C({
        ["名称"] = "05．追击风刃",
        ["Boss单位类型ID"] = _____91CC_79D1_7279_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____8FFD_51FB_98CE_5203_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_91CC_79D1_7279_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_91CC_79D1_7279_8FFD_51FB_98CE_5203_751F_6548(boss, _____8FFD_51FB_98CE_5203_6280_80FDID)
        end
    })
end
return ____exports
