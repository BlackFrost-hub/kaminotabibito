--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local IsUnitEnemy, jass
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.00．配置")
local _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["蕾米莉亚单位技能配置"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function IsUnitEnemy(unit, player)
    return jass.IsUnitEnemy(unit, player) == true
end
jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.07．上下文弹幕")
local _____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55 = ____require_result_0["创建带上下文原生弹幕"]
local ____require_result_1 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_1["造成单体技能伤害"]
local _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_1["创建独立技能伤害实例"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_1["结束独立技能伤害实例"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.15．表现控制与环境")
local _____65BD_52A0_7729_6655 = ____require_result_2["施加眩晕"]
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51FB_9000 = ____require_result_3["开始击退"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_4["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_4["读取单位最大生命"]
local _____5355_4F4D_5B58_6D3B = ____require_result_4["单位存活"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_4["两点角度"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local ____require_result_6 = require("lib.扩展函数.封装函数.02．音效系统.03．3D音效播放")
local Sound3DII_UnitPlayReuse = ____require_result_6.Sound3DII_UnitPlayReuse
local ____require_result_7 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_7.stringToFourCCSafe
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitState = jass.GetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local _____914D_7F6E = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E
local ____Q_914D_7F6E = _____914D_7F6E.Q
local ____stringToFourCCSafe_9 = stringToFourCCSafe
local ____Q_914D_7F6E__6280_80FDID_8 = ____Q_914D_7F6E["技能ID"]
if ____Q_914D_7F6E__6280_80FDID_8 == nil then
    ____Q_914D_7F6E__6280_80FDID_8 = "0003"
end
local ____Q_6280_80FDID = ____stringToFourCCSafe_9(____Q_914D_7F6E__6280_80FDID_8)
local ____stringToFourCCSafe_11 = stringToFourCCSafe
local ____Q_914D_7F6E__517C_5BB9_6280_80FDID_10 = ____Q_914D_7F6E["兼容技能ID"]
if ____Q_914D_7F6E__517C_5BB9_6280_80FDID_10 == nil then
    ____Q_914D_7F6E__517C_5BB9_6280_80FDID_10 = "A0LG"
end
local ____Q_517C_5BB9_6280_80FDID = ____stringToFourCCSafe_11(____Q_914D_7F6E__517C_5BB9_6280_80FDID_10)
local _____5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local function ____Q_76EE_6807_5141_8BB8(caster, target)
    return target ~= nil and target ~= 0 and target ~= caster and _____5355_4F4D_5B58_6D3B(target) and IsUnitEnemy(
        target,
        GetOwningPlayer(caster)
    ) and jass.IsUnitType(target, UNIT_TYPE_ANCIENT) ~= true and jass.IsUnitType(target, UNIT_TYPE_MECHANICAL) ~= true and jass.IsUnitType(target, UNIT_TYPE_STRUCTURE) ~= true
end
local function ____Q_547D_4E2D(event)
    local context = event["上下文"]
    local target = event["命中单位"]
    if not ____Q_76EE_6807_5141_8BB8(context["施法者"], target) then
        return
    end
    local targetLife = GetUnitState(target, UNIT_STATE_LIFE) or 0
    local targetMaxLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(target)
    local ____temp_13 = targetMaxLife > 0
    if ____temp_13 then
        local ____Q_914D_7F6E__4F4E_8840_7EBF_12 = ____Q_914D_7F6E["低血线"]
        if ____Q_914D_7F6E__4F4E_8840_7EBF_12 == nil then
            ____Q_914D_7F6E__4F4E_8840_7EBF_12 = 0.5
        end
        ____temp_13 = targetLife < targetMaxLife * ____Q_914D_7F6E__4F4E_8840_7EBF_12
    end
    local belowHalf = ____temp_13
    local ____temp_15 = targetMaxLife > 0
    if ____temp_15 then
        local ____Q_914D_7F6E__65A9_6740_7EBF_14 = ____Q_914D_7F6E["斩杀线"]
        if ____Q_914D_7F6E__65A9_6740_7EBF_14 == nil then
            ____Q_914D_7F6E__65A9_6740_7EBF_14 = 0.1
        end
        ____temp_15 = targetLife < targetMaxLife * ____Q_914D_7F6E__65A9_6740_7EBF_14
    end
    local belowExecute = ____temp_15
    local ____belowExecute_26
    if belowExecute then
        local ____Q_914D_7F6E__4F4E_4E8E_65A9_6740_7EBF_4F24_5BB3_500D_7387_16 = ____Q_914D_7F6E["低于斩杀线伤害倍率"]
        if ____Q_914D_7F6E__4F4E_4E8E_65A9_6740_7EBF_4F24_5BB3_500D_7387_16 == nil then
            ____Q_914D_7F6E__4F4E_4E8E_65A9_6740_7EBF_4F24_5BB3_500D_7387_16 = 1.5
        end
        ____belowExecute_26 = targetLife * ____Q_914D_7F6E__4F4E_4E8E_65A9_6740_7EBF_4F24_5BB3_500D_7387_16
    else
        local ____context__4F24_5BB3_653B_51FB_529B_19 = context["伤害攻击力"]
        local ____belowHalf_18
        if belowHalf then
            local ____Q_914D_7F6E__4F4E_8840_989D_5916_4F24_5BB3_500D_7387_17 = ____Q_914D_7F6E["低血额外伤害倍率"]
            if ____Q_914D_7F6E__4F4E_8840_989D_5916_4F24_5BB3_500D_7387_17 == nil then
                ____Q_914D_7F6E__4F4E_8840_989D_5916_4F24_5BB3_500D_7387_17 = 1.5
            end
            ____belowHalf_18 = ____Q_914D_7F6E__4F4E_8840_989D_5916_4F24_5BB3_500D_7387_17
        else
            ____belowHalf_18 = 1
        end
        local ____temp_25 = ____context__4F24_5BB3_653B_51FB_529B_19 * ____belowHalf_18
        local ____context__4F24_5BB3_6700_5927_751F_547D_24 = context["伤害最大生命"]
        local ____belowHalf_23
        if belowHalf then
            local ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_20 = ____Q_914D_7F6E["低血最大生命倍率"]
            if ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_20 == nil then
                ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_20 = ____Q_914D_7F6E["最大生命倍率"]
            end
            local ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_20_21 = ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_20
            if ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_20_21 == nil then
                ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_20_21 = 0.1
            end
            ____belowHalf_23 = ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_20_21
        else
            local ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_22 = ____Q_914D_7F6E["最大生命倍率"]
            if ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_22 == nil then
                ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_22 = 0.1
            end
            ____belowHalf_23 = ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_22
        end
        ____belowExecute_26 = ____temp_25 + ____context__4F24_5BB3_6700_5927_751F_547D_24 * ____belowHalf_23
    end
    local damage = ____belowExecute_26
    if not (damage > 0) then
        return
    end
    local ____5F00_59CB_51FB_9000_31 = _____5F00_59CB_51FB_9000
    local ____context__65BD_6CD5_8005_29 = context["施法者"]
    local ____context__65BD_6CD5_8005_30 = context["施法者"]
    local ____Q_914D_7F6E__51FB_9000_8DDD_79BB_27 = ____Q_914D_7F6E["击退距离"]
    if ____Q_914D_7F6E__51FB_9000_8DDD_79BB_27 == nil then
        ____Q_914D_7F6E__51FB_9000_8DDD_79BB_27 = 250
    end
    local ____Q_914D_7F6E__51FB_9000_6301_7EED_79D2_28 = ____Q_914D_7F6E["击退持续秒"]
    if ____Q_914D_7F6E__51FB_9000_6301_7EED_79D2_28 == nil then
        ____Q_914D_7F6E__51FB_9000_6301_7EED_79D2_28 = 0.25
    end
    ____5F00_59CB_51FB_9000_31(target, {
        ["来源单位"] = ____context__65BD_6CD5_8005_29,
        ["主单位"] = ____context__65BD_6CD5_8005_30,
        ["距离"] = ____Q_914D_7F6E__51FB_9000_8DDD_79BB_27,
        ["持续时间"] = ____Q_914D_7F6E__51FB_9000_6301_7EED_79D2_28,
        ["检查地形"] = true,
        ["禁用碰撞"] = true,
        ["暂停单位"] = false
    })
    local ____65BD_52A0_7729_6655_34 = _____65BD_52A0_7729_6655
    local ____context__65BD_6CD5_8005_33 = context["施法者"]
    local ____Q_914D_7F6E__7729_6655_79D2_32 = ____Q_914D_7F6E["眩晕秒"]
    if ____Q_914D_7F6E__7729_6655_79D2_32 == nil then
        ____Q_914D_7F6E__7729_6655_79D2_32 = 0.6
    end
    ____65BD_52A0_7729_6655_34(
        ____context__65BD_6CD5_8005_33,
        target,
        ____Q_914D_7F6E__7729_6655_79D2_32,
        "蕾米莉亚-冈格尼尔",
        "技能"
    )
    local ____9020_6210_5355_4F53_6280_80FD_4F24_5BB3_37 = _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3
    local ____context__65BD_6CD5_8005_36 = context["施法者"]
    local ____belowExecute_35
    if belowExecute then
        ____belowExecute_35 = DAMAGE_TYPE_MIND
    else
        ____belowExecute_35 = DAMAGE_TYPE_NORMAL
    end
    ____9020_6210_5355_4F53_6280_80FD_4F24_5BB3_37({
        ["来源"] = ____context__65BD_6CD5_8005_36,
        ["目标"] = target,
        ["伤害"] = damage,
        ["伤害类型"] = ____belowExecute_35,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "单位技能",
        ["技能ID"] = ____Q_6280_80FDID,
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "蕾米莉亚-神枪·冈格尼尔之枪",
        ["参与技能伤害加成"] = true
    })
end
local function ____Q_5F39_5E55Tick(instance, _delta)
    local ____521B_5EFA_70B9_7279_6548_49 = _____521B_5EFA_70B9_7279_6548
    local ____opt_38 = ____Q_914D_7F6E["飞行表现"]
    if ____opt_38 ~= nil then
        ____opt_38 = ____opt_38["模型路径"]
    end
    local ____opt_38_40 = ____opt_38
    if ____opt_38_40 == nil then
        ____opt_38_40 = "war3mapImported\\Shockwave_Fire.mdl"
    end
    local ____instance__5F53_524DX_47 = instance["当前X"]
    local ____instance__5F53_524DY_48 = instance["当前Y"]
    local ____opt_41 = ____Q_914D_7F6E["飞行表现"]
    if ____opt_41 ~= nil then
        ____opt_41 = ____opt_41["缩放"]
    end
    local ____opt_41_43 = ____opt_41
    if ____opt_41_43 == nil then
        ____opt_41_43 = 0.15
    end
    local ____opt_44 = ____Q_914D_7F6E["飞行表现"]
    if ____opt_44 ~= nil then
        ____opt_44 = ____opt_44["持续秒"]
    end
    local ____opt_44_46 = ____opt_44
    if ____opt_44_46 == nil then
        ____opt_44_46 = 0.05
    end
    ____521B_5EFA_70B9_7279_6548_49({
        ["模型路径"] = ____opt_38_40,
        X = ____instance__5F53_524DX_47,
        Y = ____instance__5F53_524DY_48,
        ["缩放"] = ____opt_41_43,
        ["持续秒"] = ____opt_44_46,
        ["Z轴角度"] = 270
    })
end
local function ____Q_5F39_5E55_7ED3_675F(_reason, _id)
end
local function _____91CA_653E_857E_7C73_8389_4E9AQ(_context, caster, _____6280_80FD_5B9E_4F8BID)
    local targetUnit = GetSpellTargetUnit()
    local targetX = targetUnit ~= nil and targetUnit ~= 0 and GetUnitX(targetUnit) or GetSpellTargetX()
    local targetY = targetUnit ~= nil and targetUnit ~= 0 and GetUnitY(targetUnit) or GetSpellTargetY()
    local level = GetUnitAbilityLevel(caster, ____Q_6280_80FDID) or 1
    local skillInstanceId = _____6280_80FD_5B9E_4F8BID or _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["技能ID"] = ____Q_6280_80FDID, ["来源类型"] = "单位技能", ["持续时间秒"] = 1.2})
    local ____caster_55 = caster
    local ____8BFB_53D6_5355_4F4D_653B_51FB_529B_result_52 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    local ____Q_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_50 = ____Q_914D_7F6E["攻击力基础倍率"]
    if ____Q_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_50 == nil then
        ____Q_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_50 = 1
    end
    local ____Q_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_51 = ____Q_914D_7F6E["攻击力每级倍率"]
    if ____Q_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_51 == nil then
        ____Q_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_51 = 0.1
    end
    local ____temp_56 = ____8BFB_53D6_5355_4F4D_653B_51FB_529B_result_52 * (____Q_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_50 + ____Q_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_51 * level)
    local ____8BFB_53D6_5355_4F4D_6700_5927_751F_547D_result_54 = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(caster)
    local ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_53 = ____Q_914D_7F6E["最大生命倍率"]
    if ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_53 == nil then
        ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_53 = 0.1
    end
    local context = {["施法者"] = ____caster_55, ["技能实例ID"] = skillInstanceId, ["伤害攻击力"] = ____temp_56, ["伤害最大生命"] = ____8BFB_53D6_5355_4F4D_6700_5927_751F_547D_result_54 * ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_53}
    local ____Sound3DII_UnitPlayReuse_64 = Sound3DII_UnitPlayReuse
    local ____opt_57 = ____Q_914D_7F6E["音效"]
    if ____opt_57 ~= nil then
        ____opt_57 = ____opt_57["路径"]
    end
    local ____opt_57_59 = ____opt_57
    if ____opt_57_59 == nil then
        ____opt_57_59 = "HeroVoice\\REmilia\\REmiliaQ.mp3"
    end
    local ____caster_63 = caster
    local ____opt_60 = ____Q_914D_7F6E["音效"]
    if ____opt_60 ~= nil then
        ____opt_60 = ____opt_60["裁断距离"]
    end
    local ____opt_60_62 = ____opt_60
    if ____opt_60_62 == nil then
        ____opt_60_62 = 1250
    end
    ____Sound3DII_UnitPlayReuse_64(____opt_57_59, ____caster_63, ____opt_60_62)
    local angle = _____4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        targetX,
        targetY
    )
    local ____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55_76 = _____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55
    local ____Q_547D_4E2D_74 = ____Q_547D_4E2D
    local ____Q_5F39_5E55_7ED3_675F_75 = ____Q_5F39_5E55_7ED3_675F
    local ____caster_71 = caster
    local ____GetUnitX_result_72 = GetUnitX(caster)
    local ____GetUnitY_result_73 = GetUnitY(caster)
    local ____Q_914D_7F6E__901F_5EA6_65 = ____Q_914D_7F6E["速度"]
    if ____Q_914D_7F6E__901F_5EA6_65 == nil then
        ____Q_914D_7F6E__901F_5EA6_65 = 1200
    end
    local ____Q_914D_7F6E__751F_547D_5468_671F_79D2_66 = ____Q_914D_7F6E["生命周期秒"]
    if ____Q_914D_7F6E__751F_547D_5468_671F_79D2_66 == nil then
        ____Q_914D_7F6E__751F_547D_5468_671F_79D2_66 = 0.94
    end
    local ____Q_914D_7F6E__6700_5927_8DDD_79BB_67 = ____Q_914D_7F6E["最大距离"]
    if ____Q_914D_7F6E__6700_5927_8DDD_79BB_67 == nil then
        ____Q_914D_7F6E__6700_5927_8DDD_79BB_67 = 1150
    end
    local ____Q_914D_7F6E__547D_4E2D_534A_5F84_68 = ____Q_914D_7F6E["命中半径"]
    if ____Q_914D_7F6E__547D_4E2D_534A_5F84_68 == nil then
        ____Q_914D_7F6E__547D_4E2D_534A_5F84_68 = 200
    end
    local ____Q_914D_7F6E__6A21_578B_8DEF_5F84_69 = ____Q_914D_7F6E["模型路径"]
    if ____Q_914D_7F6E__6A21_578B_8DEF_5F84_69 == nil then
        ____Q_914D_7F6E__6A21_578B_8DEF_5F84_69 = "war3mapImported\\remiliasq.mdl"
    end
    local ____Q_914D_7F6E__7F29_653E_70 = ____Q_914D_7F6E["缩放"]
    if ____Q_914D_7F6E__7F29_653E_70 == nil then
        ____Q_914D_7F6E__7F29_653E_70 = 2.5
    end
    ____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55_76({
        ["上下文"] = context,
        ["命中后清理"] = false,
        ["on命中"] = ____Q_547D_4E2D_74,
        ["on结束"] = ____Q_5F39_5E55_7ED3_675F_75,
        ["弹幕参数"] = {
            ["所有者"] = ____caster_71,
            X = ____GetUnitX_result_72,
            Y = ____GetUnitY_result_73,
            ["方向角"] = angle,
            ["速度"] = ____Q_914D_7F6E__901F_5EA6_65,
            ["生命周期"] = ____Q_914D_7F6E__751F_547D_5468_671F_79D2_66,
            ["最大距离"] = ____Q_914D_7F6E__6700_5927_8DDD_79BB_67,
            ["命中半径"] = ____Q_914D_7F6E__547D_4E2D_534A_5F84_68,
            ["影响目标"] = "敌方",
            ["每单位最大命中次数"] = 1,
            ["模型"] = ____Q_914D_7F6E__6A21_578B_8DEF_5F84_69,
            ["缩放"] = ____Q_914D_7F6E__7F29_653E_70,
            ["禁用碰撞"] = true,
            onTick = ____Q_5F39_5E55Tick
        }
    })
end
local function _____83B7_53D6Q_4E0A_4E0B_6587(unit)
    return {["施法者"] = unit, ["技能实例ID"] = 0, ["伤害攻击力"] = 0, ["伤害最大生命"] = 0}
end
local function _____6CE8_518CQ_76D1_542C(skillId, name)
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = name,
        ["单位类型ID"] = _____5355_4F4D_7C7B_578BID,
        ["技能ID"] = skillId,
        ["获取或创建上下文"] = _____83B7_53D6Q_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_857E_7C73_8389_4E9AQ,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 1.2
    })
end
_____6CE8_518CQ_76D1_542C(____Q_6280_80FDID, "蕾米莉亚-神枪·冈格尼尔之枪（Q）")
if ____Q_517C_5BB9_6280_80FDID ~= ____Q_6280_80FDID then
    _____6CE8_518CQ_76D1_542C(____Q_517C_5BB9_6280_80FDID, "蕾米莉亚-神枪·冈格尼尔之枪（Q兼容壳）")
end
return ____exports
