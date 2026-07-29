--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____9020_6210_4F24_5BB3, _____64AD_653E_70B9_540D_7279_6548, _____8BA9_5355_4F4D_9762_5411_76EE_6807, _____6302Buff, _____53D6_8C61_9650_540D_79F0, _____53D6_8C61_9650_6CD5_9635_989C_8272, _____64AD_653E_65BD_6CD5_6CD5_9635, _____7ED3_7B97_5468_671F_4F24_5BB3, ____on_745F_5170_8FEA_5C14_7F6A_4E0E_7F5A_751F_6548, addDelayedCallback, registerManualBuff, _____5F00_59CB_786C_76F4, _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761, _____5173_95ED_541F_5531_6761, _____521B_5EFA_70B9_7279_6548, createTimedUnitEffect, _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B, _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807, _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4, _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3, Sound3DII_CooPlayReuse, jass, GetUnitStateJapi, GetRandomInt, GetUnitTypeId, GetSpellTargetUnit, GetUnitName, GetUnitState, GetUnitX, GetUnitY, SetUnitFacing, Atan2, R2I, UNIT_STATE_MAX_LIFE, UNIT_STATE_MAX_MANA, UNIT_STATE_MANA, BJ_RADTODEG, _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID, _____7F6A_4E0E_7F5A_6280_80FDID
local ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.03．运行时上下文")
local _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587 = ____03_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建瑟兰迪尔上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.02．数值与表现配置")
local _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["瑟兰迪尔数值与表现配置"]
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.00．配置")
local _____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["瑟兰迪尔单位技能配置"]
local ____15_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.02．瑟兰迪尔.15．台词播放")
local _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD = ____15_FF0E_53F0_8BCD_64AD_653E["播放瑟兰迪尔台词"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位存活"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
function _____9020_6210_4F24_5BB3(boss, target, amount, damageType)
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or amount <= 0 then
        return
    end
    _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
        ["技能ID"] = _____7F6A_4E0E_7F5A_6280_80FDID,
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害"] = amount,
        attack = false,
        ranged = false,
        attackType = jass.ATTACK_TYPE_NORMAL,
        ["伤害类型"] = damageType,
        weaponType = jass.WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "Boss技能"
    })
end
function _____64AD_653E_70B9_540D_7279_6548(target, duration)
    createTimedUnitEffect(target, "origin", "Common\\Effect\\Element\\Light\\protectionaura.mdx", duration)
end
function _____8BA9_5355_4F4D_9762_5411_76EE_6807(caster, target)
    if not _____5355_4F4D_6709_6548(caster) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local angle = Atan2(
        GetUnitY(target) - GetUnitY(caster),
        GetUnitX(target) - GetUnitX(caster)
    ) * BJ_RADTODEG
    SetUnitFacing(caster, angle)
end
function _____6302Buff(boss, target, buffID, duration, value, icon, effect)
    registerManualBuff(
        target,
        buffID,
        duration,
        value,
        {
            sourceName = GetUnitName(boss),
            iconOverride = icon,
            effectModelOverride = effect
        }
    )
end
function _____53D6_8C61_9650_540D_79F0(____type)
    if ____type == 1 then
        return "红"
    end
    if ____type == 2 then
        return "蓝"
    end
    if ____type == 3 then
        return "绿"
    end
    return "金"
end
function _____53D6_8C61_9650_6CD5_9635_989C_8272(____type, config)
    if ____type == 1 then
        return config["施法法阵红色"]
    end
    if ____type == 2 then
        return config["施法法阵蓝色"]
    end
    if ____type == 3 then
        return config["施法法阵绿色"]
    end
    return config["施法法阵金色"]
end
function _____64AD_653E_65BD_6CD5_6CD5_9635(boss, ____type, config)
    if not _____5355_4F4D_6709_6548(boss) then
        return
    end
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = config["施法法阵特效"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["缩放"] = config["施法法阵缩放"],
        ["顶点颜色"] = _____53D6_8C61_9650_6CD5_9635_989C_8272(____type, config),
        ["持续秒"] = config["施法硬直秒"] + 0.5
    })
end
function _____7ED3_7B97_5468_671F_4F24_5BB3(boss, target, times, damage, damageType)
    do
        local i = 1
        while i <= times do
            addDelayedCallback(
                i * 1000,
                function()
                    _____9020_6210_4F24_5BB3(boss, target, damage, damageType)
                end
            )
            i = i + 1
        end
    end
end
____exports["释放瑟兰迪尔罪与罚"] = function(context, target)
    local config = _____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["罪与罚"]
    local boss = context["Boss单位"]
    local threatTarget = _____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807(boss)
    local ____target_11 = target
    if ____target_11 == nil then
        ____target_11 = threatTarget and threatTarget.targetRef
    end
    local ____target_11_12 = ____target_11
    if ____target_11_12 == nil then
        ____target_11_12 = _____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4(boss)
    end
    local actualTarget = ____target_11_12
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(actualTarget) then
        return
    end
    local ____type = GetRandomInt(1, 4)
    local _____8C61_9650_540D_79F0 = _____53D6_8C61_9650_540D_79F0(____type)
    if context["罪与罚组合执行器"] == nil then
        context["罪与罚组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "瑟兰迪尔-罪与罚", ["清理"] = context["清理"], ["互斥组"] = "瑟兰迪尔罪与罚"})
    end
    local ____self_13 = context["罪与罚组合执行器"]
    local _____6267_884CID = ____self_13["开始"](
        ____self_13,
        {
            key = "罪与罚",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = R2I((config["施法硬直秒"] + config["延迟秒"]) * 1000) + 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868({
                {
                    ["时点毫秒"] = R2I(config["施法硬直秒"] * 1000),
                    ["名称"] = "罪与罚点名开始",
                    ["执行"] = function()
                        _____5173_95ED_541F_5531_6761("常规技能")
                        if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(actualTarget) then
                            return
                        end
                        _____8BA9_5355_4F4D_9762_5411_76EE_6807(boss, actualTarget)
                        Sound3DII_CooPlayReuse(
                            config["点名音效"],
                            GetUnitX(actualTarget),
                            GetUnitY(actualTarget),
                            0,
                            config["点名音效裁断距离"]
                        )
                        _____64AD_653E_70B9_540D_7279_6548(actualTarget, config["延迟秒"])
                    end
                },
                {
                    ["时点毫秒"] = R2I((config["施法硬直秒"] + config["延迟秒"]) * 1000),
                    ["名称"] = "罪与罚结算",
                    ["执行"] = function()
                        if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(actualTarget) then
                            return
                        end
                        _____8BA9_5355_4F4D_9762_5411_76EE_6807(boss, actualTarget)
                        local maxLife = GetUnitStateJapi(actualTarget, UNIT_STATE_MAX_LIFE)
                        if ____type == 1 then
                            _____6302Buff(
                                boss,
                                actualTarget,
                                config["红惩罚BuffID"],
                                config["惩罚持续秒"],
                                0,
                                "BuffIcon\\Boss\\Thranduil\\lieyanzhuoshao.blp",
                                config["红特效"]
                            )
                            _____6302Buff(
                                boss,
                                actualTarget,
                                config["红增益BuffID"],
                                config["增益持续秒"],
                                0.35,
                                "BuffIcon\\Boss\\Thranduil\\nuhuozhangkong.blp",
                                config["红特效"]
                            )
                            _____7ED3_7B97_5468_671F_4F24_5BB3(
                                boss,
                                actualTarget,
                                config["惩罚持续秒"],
                                maxLife * 0.05,
                                jass.DAMAGE_TYPE_FIRE
                            )
                        elseif ____type == 2 then
                            _____6302Buff(
                                boss,
                                actualTarget,
                                config["蓝惩罚BuffID"],
                                config["惩罚持续秒"],
                                0.7,
                                "BuffIcon\\Boss\\Thranduil\\shendudongjie.blp",
                                config["蓝惩罚特效"]
                            )
                            _____6302Buff(
                                boss,
                                actualTarget,
                                config["蓝增益BuffID"],
                                config["增益持续秒"],
                                0.4,
                                "BuffIcon\\Boss\\Thranduil\\bingshuangbihu.blp",
                                config["蓝增益特效"]
                            )
                        elseif ____type == 3 then
                            _____6302Buff(
                                boss,
                                actualTarget,
                                config["绿惩罚BuffID"],
                                config["惩罚持续秒"],
                                0,
                                "BuffIcon\\Boss\\Thranduil\\zhimingdusu.blp",
                                config["绿惩罚特效"]
                            )
                            _____6302Buff(
                                boss,
                                actualTarget,
                                config["绿增益BuffID"],
                                config["增益持续秒"],
                                0,
                                "BuffIcon\\Boss\\Thranduil\\duyefanzhuan.blp",
                                config["绿增益特效"]
                            )
                            _____7ED3_7B97_5468_671F_4F24_5BB3(
                                boss,
                                actualTarget,
                                config["惩罚持续秒"],
                                maxLife * 0.04,
                                jass.DAMAGE_TYPE_POISON
                            )
                        else
                            local mana = GetUnitState(actualTarget, UNIT_STATE_MANA)
                            local maxMana = GetUnitStateJapi(actualTarget, UNIT_STATE_MAX_MANA)
                            local damage = maxMana > 0 and (maxMana - mana) * 2 or 200
                            _____6302Buff(
                                boss,
                                actualTarget,
                                config["黄惩罚BuffID"],
                                config["惩罚持续秒"],
                                0,
                                "BuffIcon\\Boss\\Thranduil\\molifanshi.blp"
                            )
                            _____6302Buff(
                                boss,
                                actualTarget,
                                config["黄增益BuffID"],
                                config["增益持续秒"],
                                0,
                                "BuffIcon\\Boss\\Thranduil\\aoshuchaozai.blp",
                                config["黄增益特效"]
                            )
                            _____7ED3_7B97_5468_671F_4F24_5BB3(
                                boss,
                                actualTarget,
                                config["惩罚持续秒"],
                                damage,
                                jass.DAMAGE_TYPE_MIND
                            )
                        end
                    end
                }
            }),
            ["结束回调"] = function(event)
                if event["原因"] ~= "完成" then
                    _____5173_95ED_541F_5531_6761("常规技能")
                end
            end
        }
    )
    if _____6267_884CID == 0 then
        return
    end
    _____64AD_653E_745F_5170_8FEA_5C14_53F0_8BCD(boss, "罪与罚")
    _____8BA9_5355_4F4D_9762_5411_76EE_6807(boss, actualTarget)
    _____5F00_59CB_786C_76F4(boss, config["施法硬直秒"])
    _____64AD_653E_65BD_6CD5_6CD5_9635(boss, ____type, config)
    _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761({["总时长"] = config["施法硬直秒"], ["颜色ID"] = config["吟唱条颜色ID"], ["标题文本"] = (config["吟唱条标题文本"] .. "：") .. _____8C61_9650_540D_79F0, ["提示文本"] = ("常规技能：即将赐予" .. _____8C61_9650_540D_79F0) .. "象限"})
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({
        ["单位"] = boss,
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["持续秒"] = config["施法硬直秒"],
        ["重播时点秒列表"] = {config["动画重播延迟Ms"] / 1000},
        ["恢复动画编号"] = config["恢复动画编号"],
        ["恢复动画速度"] = config["恢复动画速度"]
    })
end
function ____on_745F_5170_8FEA_5C14_7F6A_4E0E_7F5A_751F_6548(castingUnit, spellAbilityId)
    if spellAbilityId ~= _____7F6A_4E0E_7F5A_6280_80FDID then
        return
    end
    if not _____5355_4F4D_6709_6548(castingUnit) or GetUnitTypeId(castingUnit) ~= _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID then
        return
    end
    local target = GetSpellTargetUnit()
    local context = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587(castingUnit)
    if context == nil then
        return
    end
    ____exports["释放瑟兰迪尔罪与罚"](context, target)
end
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_1.registerManualBuff
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
_____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
_____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
_____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local ____require_result_4 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
_____521B_5EFA_70B9_7279_6548 = ____require_result_4["创建点特效"]
createTimedUnitEffect = ____require_result_4.createTimedUnitEffect
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
_____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____require_result_5["播放限时单位动画"]
local ____require_result_6 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
_____83B7_53D6Boss_6280_80FD_5E94_653B_51FB_76EE_6807 = ____require_result_6["获取Boss技能应攻击目标"]
_____83B7_53D6Boss_6280_80FD_6700_8FD1_654C_5BF9_82F1_96C4 = ____require_result_6["获取Boss技能最近敌对英雄"]
local ____require_result_7 = require("系统.04．伤害系统.08．技能伤害系统")
_____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_7["造成单体技能伤害"]
local ____require_result_8 = require("lib.扩展函数.封装函数.02．音效系统.index")
Sound3DII_CooPlayReuse = ____require_result_8.Sound3DII_CooPlayReuse
jass = require("jass.common")
local japi = require("jass.japi")
GetUnitStateJapi = japi.GetUnitState
GetRandomInt = jass.GetRandomInt
GetUnitTypeId = jass.GetUnitTypeId
GetSpellTargetUnit = jass.GetSpellTargetUnit
GetUnitName = jass.GetUnitName
GetUnitState = jass.GetUnitState
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
Atan2 = jass.Atan2
local AddSpecialEffect = jass.AddSpecialEffect
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
R2I = jass.R2I
local EXSetEffectSize = japi.EXSetEffectSize
local DzSetEffectVertexColor = japi.DzSetEffectVertexColor
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
UNIT_STATE_MANA = jass.UNIT_STATE_MANA
BJ_RADTODEG = 57.29577951308232
_____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID = stringToFourCC(_____745F_5170_8FEA_5C14_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
_____7F6A_4E0E_7F5A_6280_80FDID = stringToFourCC(_____745F_5170_8FEA_5C14_6570_503C_4E0E_8868_73B0_914D_7F6E["罪与罚"]["技能槽位"])
local _____7F6A_4E0E_7F5A_5DF2_6CE8_518C = false
____exports["注册瑟兰迪尔罪与罚"] = function()
    if _____7F6A_4E0E_7F5A_5DF2_6CE8_518C then
        return
    end
    _____7F6A_4E0E_7F5A_5DF2_6CE8_518C = true
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "瑟兰迪尔罪与罚",
        ["单位类型ID"] = _____745F_5170_8FEA_5C14_5355_4F4D_7C7B_578BID,
        ["技能ID"] = _____7F6A_4E0E_7F5A_6280_80FDID,
        ["获取或创建上下文"] = _____83B7_53D6_6216_521B_5EFA_745F_5170_8FEA_5C14_4E0A_4E0B_6587,
        ["释放技能"] = function(_context, boss)
            ____on_745F_5170_8FEA_5C14_7F6A_4E0E_7F5A_751F_6548(boss, _____7F6A_4E0E_7F5A_6280_80FDID)
        end
    })
end
return ____exports
