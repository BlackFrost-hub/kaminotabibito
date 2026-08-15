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
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
local _____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_7["调整玩家属性"]
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_8.stringToFourCCSafe
local GetSpellTargetUnit = jass.GetSpellTargetUnit
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitAbilityLevel = jass.GetUnitAbilityLevel
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local _____914D_7F6E = _____857E_7C73_8389_4E9A_5355_4F4D_6280_80FD_914D_7F6E
local ____Q_914D_7F6E = _____914D_7F6E.Q
local ____stringToFourCCSafe_10 = stringToFourCCSafe
local ____Q_914D_7F6E__6280_80FDID_9 = ____Q_914D_7F6E["技能ID"]
if ____Q_914D_7F6E__6280_80FDID_9 == nil then
    ____Q_914D_7F6E__6280_80FDID_9 = "0003"
end
local ____Q_6280_80FDID = ____stringToFourCCSafe_10(____Q_914D_7F6E__6280_80FDID_9)
local ____stringToFourCCSafe_12 = stringToFourCCSafe
local ____Q_914D_7F6E__517C_5BB9_6280_80FDID_11 = ____Q_914D_7F6E["兼容技能ID"]
if ____Q_914D_7F6E__517C_5BB9_6280_80FDID_11 == nil then
    ____Q_914D_7F6E__517C_5BB9_6280_80FDID_11 = "A0LG"
end
local ____Q_517C_5BB9_6280_80FDID = ____stringToFourCCSafe_12(____Q_914D_7F6E__517C_5BB9_6280_80FDID_11)
local _____5355_4F4D_7C7B_578BID = _____914D_7F6E["单位类型ID"]
local ____stringToFourCCSafe_16 = stringToFourCCSafe
local ____opt_13 = _____914D_7F6E.E
if ____opt_13 ~= nil then
    ____opt_13 = ____opt_13["替身单位ID"]
end
local ____opt_13_15 = ____opt_13
if ____opt_13_15 == nil then
    ____opt_13_15 = "e08O"
end
local _____8840_96FE_66FF_8EAB_5355_4F4D_7C7B_578BID = ____stringToFourCCSafe_16(____opt_13_15)
local ____require_result_17 = require("系统.03．技能系统.05．单位技能.04．英雄技能.02．蕾米莉亚.04．E技能")
local _____83B7_53D6_8840_96FE_672C_4F53 = ____require_result_17["获取血雾本体"]
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
    local ____temp_19 = targetMaxLife > 0
    if ____temp_19 then
        local ____Q_914D_7F6E__4F4E_8840_7EBF_18 = ____Q_914D_7F6E["低血线"]
        if ____Q_914D_7F6E__4F4E_8840_7EBF_18 == nil then
            ____Q_914D_7F6E__4F4E_8840_7EBF_18 = 0.5
        end
        ____temp_19 = targetLife < targetMaxLife * ____Q_914D_7F6E__4F4E_8840_7EBF_18
    end
    local belowHalf = ____temp_19
    local ____context__4F24_5BB3_653B_51FB_529B_22 = context["伤害攻击力"]
    local ____belowHalf_21
    if belowHalf then
        local ____Q_914D_7F6E__4F4E_8840_989D_5916_4F24_5BB3_500D_7387_20 = ____Q_914D_7F6E["低血额外伤害倍率"]
        if ____Q_914D_7F6E__4F4E_8840_989D_5916_4F24_5BB3_500D_7387_20 == nil then
            ____Q_914D_7F6E__4F4E_8840_989D_5916_4F24_5BB3_500D_7387_20 = 1.5
        end
        ____belowHalf_21 = ____Q_914D_7F6E__4F4E_8840_989D_5916_4F24_5BB3_500D_7387_20
    else
        ____belowHalf_21 = 1
    end
    local ____temp_28 = ____context__4F24_5BB3_653B_51FB_529B_22 * ____belowHalf_21
    local ____context__4F24_5BB3_6700_5927_751F_547D_27 = context["伤害最大生命"]
    local ____belowHalf_26
    if belowHalf then
        local ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_23 = ____Q_914D_7F6E["低血最大生命倍率"]
        if ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_23 == nil then
            ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_23 = ____Q_914D_7F6E["最大生命倍率"]
        end
        local ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_23_24 = ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_23
        if ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_23_24 == nil then
            ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_23_24 = 0.1
        end
        ____belowHalf_26 = ____Q_914D_7F6E__4F4E_8840_6700_5927_751F_547D_500D_7387_23_24
    else
        local ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_25 = ____Q_914D_7F6E["最大生命倍率"]
        if ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_25 == nil then
            ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_25 = 0.1
        end
        ____belowHalf_26 = ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_25
    end
    local damage = ____temp_28 + ____context__4F24_5BB3_6700_5927_751F_547D_27 * ____belowHalf_26
    if not (damage > 0) then
        return
    end
    local ____5F00_59CB_51FB_9000_33 = _____5F00_59CB_51FB_9000
    local ____4E24_70B9_89D2_5EA6_result_31 = _____4E24_70B9_89D2_5EA6(
        GetUnitX(context["施法者"]),
        GetUnitY(context["施法者"]),
        GetUnitX(target),
        GetUnitY(target)
    )
    local ____context__65BD_6CD5_8005_32 = context["施法者"]
    local ____Q_914D_7F6E__51FB_9000_8DDD_79BB_29 = ____Q_914D_7F6E["击退距离"]
    if ____Q_914D_7F6E__51FB_9000_8DDD_79BB_29 == nil then
        ____Q_914D_7F6E__51FB_9000_8DDD_79BB_29 = 250
    end
    local ____Q_914D_7F6E__51FB_9000_6301_7EED_79D2_30 = ____Q_914D_7F6E["击退持续秒"]
    if ____Q_914D_7F6E__51FB_9000_6301_7EED_79D2_30 == nil then
        ____Q_914D_7F6E__51FB_9000_6301_7EED_79D2_30 = 0.25
    end
    ____5F00_59CB_51FB_9000_33(target, {
        ["角度"] = ____4E24_70B9_89D2_5EA6_result_31,
        ["主单位"] = ____context__65BD_6CD5_8005_32,
        ["距离"] = ____Q_914D_7F6E__51FB_9000_8DDD_79BB_29,
        ["持续时间"] = ____Q_914D_7F6E__51FB_9000_6301_7EED_79D2_30,
        ["检查地形"] = true,
        ["禁用碰撞"] = true,
        ["暂停单位"] = false
    })
    local ____65BD_52A0_7729_6655_36 = _____65BD_52A0_7729_6655
    local ____context__65BD_6CD5_8005_35 = context["施法者"]
    local ____Q_914D_7F6E__7729_6655_79D2_34 = ____Q_914D_7F6E["眩晕秒"]
    if ____Q_914D_7F6E__7729_6655_79D2_34 == nil then
        ____Q_914D_7F6E__7729_6655_79D2_34 = 0.6
    end
    ____65BD_52A0_7729_6655_36(
        ____context__65BD_6CD5_8005_35,
        target,
        ____Q_914D_7F6E__7729_6655_79D2_34,
        "蕾米莉亚-冈格尼尔",
        "技能"
    )
    _____8C03_6574_73A9_5BB6_5C5E_6027(context["施法者"], "护甲穿透", 0.5)
    _____8C03_6574_73A9_5BB6_5C5E_6027(context["施法者"], "命中率", 1)
    do
        local ____try, ____error = pcall(function()
            _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                ["来源"] = context["施法者"],
                ["目标"] = target,
                ["伤害"] = damage,
                ["伤害类型"] = DAMAGE_TYPE_NORMAL,
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
        end)
        do
            _____8C03_6574_73A9_5BB6_5C5E_6027(context["施法者"], "命中率", -1)
            _____8C03_6574_73A9_5BB6_5C5E_6027(context["施法者"], "护甲穿透", -0.5)
        end
        if not ____try then
            error(____error, 0)
        end
    end
    local lifeAfterDamage = GetUnitState(target, UNIT_STATE_LIFE) or 0
    local ____temp_38 = _____5355_4F4D_5B58_6D3B(target) and targetMaxLife > 0
    if ____temp_38 then
        local ____Q_914D_7F6E__65A9_6740_7EBF_37 = ____Q_914D_7F6E["斩杀线"]
        if ____Q_914D_7F6E__65A9_6740_7EBF_37 == nil then
            ____Q_914D_7F6E__65A9_6740_7EBF_37 = 0.1
        end
        ____temp_38 = lifeAfterDamage < targetMaxLife * ____Q_914D_7F6E__65A9_6740_7EBF_37
    end
    if ____temp_38 then
        SetUnitState(target, UNIT_STATE_LIFE, 0)
    end
end
local function ____Q_5F39_5E55Tick(instance, _delta)
    local ____instance_40 = instance
    local ____instance__857E_7C73_8389_4E9AQ_8868_73B0_7D2F_8BA1_79D2_39 = instance["蕾米莉亚Q表现累计秒"]
    if ____instance__857E_7C73_8389_4E9AQ_8868_73B0_7D2F_8BA1_79D2_39 == nil then
        ____instance__857E_7C73_8389_4E9AQ_8868_73B0_7D2F_8BA1_79D2_39 = 0
    end
    ____instance_40["蕾米莉亚Q表现累计秒"] = ____instance__857E_7C73_8389_4E9AQ_8868_73B0_7D2F_8BA1_79D2_39 + _delta
    if instance["蕾米莉亚Q表现累计秒"] < 0.04 then
        return
    end
    instance["蕾米莉亚Q表现累计秒"] = instance["蕾米莉亚Q表现累计秒"] - 0.04
    local ____521B_5EFA_70B9_7279_6548_53 = _____521B_5EFA_70B9_7279_6548
    local ____opt_41 = ____Q_914D_7F6E["飞行表现"]
    if ____opt_41 ~= nil then
        ____opt_41 = ____opt_41["模型路径"]
    end
    local ____opt_41_43 = ____opt_41
    if ____opt_41_43 == nil then
        ____opt_41_43 = "war3mapImported\\Shockwave_Fire.mdl"
    end
    local ____instance__5F53_524DX_51 = instance["当前X"]
    local ____instance__5F53_524DY_52 = instance["当前Y"]
    local ____opt_44 = ____Q_914D_7F6E["飞行表现"]
    if ____opt_44 ~= nil then
        ____opt_44 = ____opt_44["缩放"]
    end
    local ____opt_44_46 = ____opt_44
    if ____opt_44_46 == nil then
        ____opt_44_46 = 0.15
    end
    local ____opt_47 = ____Q_914D_7F6E["飞行表现"]
    if ____opt_47 ~= nil then
        ____opt_47 = ____opt_47["持续秒"]
    end
    local ____opt_47_49 = ____opt_47
    if ____opt_47_49 == nil then
        ____opt_47_49 = 0.05
    end
    local ____instance__5F53_524D_65B9_5411_89D2_50 = instance["当前方向角"]
    if ____instance__5F53_524D_65B9_5411_89D2_50 == nil then
        ____instance__5F53_524D_65B9_5411_89D2_50 = 0
    end
    ____521B_5EFA_70B9_7279_6548_53({
        ["模型路径"] = ____opt_41_43,
        X = ____instance__5F53_524DX_51,
        Y = ____instance__5F53_524DY_52,
        ["缩放"] = ____opt_44_46,
        ["持续秒"] = ____opt_47_49,
        ["Z轴角度"] = ____instance__5F53_524D_65B9_5411_89D2_50 + 270
    })
end
local function ____Q_5F39_5E55_7ED3_675F(_reason, _id)
end
local function _____91CA_653E_857E_7C73_8389_4E9AQ(_context, caster, _____6280_80FD_5B9E_4F8BID)
    local ____83B7_53D6_8840_96FE_672C_4F53_result_54 = _____83B7_53D6_8840_96FE_672C_4F53(caster)
    if ____83B7_53D6_8840_96FE_672C_4F53_result_54 == nil then
        ____83B7_53D6_8840_96FE_672C_4F53_result_54 = caster
    end
    local _____771F_5B9E_65BD_6CD5_8005 = ____83B7_53D6_8840_96FE_672C_4F53_result_54
    local targetUnit = GetSpellTargetUnit()
    local targetX = targetUnit ~= nil and targetUnit ~= 0 and GetUnitX(targetUnit) or GetSpellTargetX()
    local targetY = targetUnit ~= nil and targetUnit ~= 0 and GetUnitY(targetUnit) or GetSpellTargetY()
    local level = GetUnitAbilityLevel(_____771F_5B9E_65BD_6CD5_8005, ____Q_6280_80FDID) or GetUnitAbilityLevel(caster, ____Q_6280_80FDID) or 1
    local skillInstanceId = _____6280_80FD_5B9E_4F8BID or _____521B_5EFA_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B({["技能ID"] = ____Q_6280_80FDID, ["来源类型"] = "单位技能", ["持续时间秒"] = 1.2})
    local ____8BFB_53D6_5355_4F4D_653B_51FB_529B_result_57 = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    local ____Q_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_55 = ____Q_914D_7F6E["攻击力基础倍率"]
    if ____Q_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_55 == nil then
        ____Q_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_55 = 1
    end
    local ____Q_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_56 = ____Q_914D_7F6E["攻击力每级倍率"]
    if ____Q_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_56 == nil then
        ____Q_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_56 = 0.1
    end
    local ____temp_60 = ____8BFB_53D6_5355_4F4D_653B_51FB_529B_result_57 * (____Q_914D_7F6E__653B_51FB_529B_57FA_7840_500D_7387_55 + ____Q_914D_7F6E__653B_51FB_529B_6BCF_7EA7_500D_7387_56 * level)
    local ____8BFB_53D6_5355_4F4D_6700_5927_751F_547D_result_59 = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(caster)
    local ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_58 = ____Q_914D_7F6E["最大生命倍率"]
    if ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_58 == nil then
        ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_58 = 0.1
    end
    local context = {["施法者"] = _____771F_5B9E_65BD_6CD5_8005, ["技能实例ID"] = skillInstanceId, ["伤害攻击力"] = ____temp_60, ["伤害最大生命"] = ____8BFB_53D6_5355_4F4D_6700_5927_751F_547D_result_59 * ____Q_914D_7F6E__6700_5927_751F_547D_500D_7387_58}
    local ____Sound3DII_UnitPlayReuse_67 = Sound3DII_UnitPlayReuse
    local ____opt_61 = ____Q_914D_7F6E["音效"]
    if ____opt_61 ~= nil then
        ____opt_61 = ____opt_61["路径"]
    end
    local ____opt_61_63 = ____opt_61
    if ____opt_61_63 == nil then
        ____opt_61_63 = "HeroVoice\\REmilia\\REmiliaQ.mp3"
    end
    local ____opt_64 = ____Q_914D_7F6E["音效"]
    if ____opt_64 ~= nil then
        ____opt_64 = ____opt_64["裁断距离"]
    end
    local ____opt_64_66 = ____opt_64
    if ____opt_64_66 == nil then
        ____opt_64_66 = 1250
    end
    ____Sound3DII_UnitPlayReuse_67(____opt_61_63, _____771F_5B9E_65BD_6CD5_8005, ____opt_64_66)
    local angle = _____4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        targetX,
        targetY
    )
    local ____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55_79 = _____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55
    local ____Q_547D_4E2D_77 = ____Q_547D_4E2D
    local ____Q_5F39_5E55_7ED3_675F_78 = ____Q_5F39_5E55_7ED3_675F
    local ____GetUnitX_result_75 = GetUnitX(caster)
    local ____GetUnitY_result_76 = GetUnitY(caster)
    local ____Q_914D_7F6E__901F_5EA6_68 = ____Q_914D_7F6E["速度"]
    if ____Q_914D_7F6E__901F_5EA6_68 == nil then
        ____Q_914D_7F6E__901F_5EA6_68 = 1320
    end
    local ____Q_914D_7F6E__98DE_884C_9AD8_5EA6_69 = ____Q_914D_7F6E["飞行高度"]
    if ____Q_914D_7F6E__98DE_884C_9AD8_5EA6_69 == nil then
        ____Q_914D_7F6E__98DE_884C_9AD8_5EA6_69 = 75
    end
    local ____Q_914D_7F6E__751F_547D_5468_671F_79D2_70 = ____Q_914D_7F6E["生命周期秒"]
    if ____Q_914D_7F6E__751F_547D_5468_671F_79D2_70 == nil then
        ____Q_914D_7F6E__751F_547D_5468_671F_79D2_70 = 0.94
    end
    local ____Q_914D_7F6E__6700_5927_8DDD_79BB_71 = ____Q_914D_7F6E["最大距离"]
    if ____Q_914D_7F6E__6700_5927_8DDD_79BB_71 == nil then
        ____Q_914D_7F6E__6700_5927_8DDD_79BB_71 = 1150
    end
    local ____Q_914D_7F6E__547D_4E2D_534A_5F84_72 = ____Q_914D_7F6E["命中半径"]
    if ____Q_914D_7F6E__547D_4E2D_534A_5F84_72 == nil then
        ____Q_914D_7F6E__547D_4E2D_534A_5F84_72 = 200
    end
    local ____Q_914D_7F6E__6A21_578B_8DEF_5F84_73 = ____Q_914D_7F6E["模型路径"]
    if ____Q_914D_7F6E__6A21_578B_8DEF_5F84_73 == nil then
        ____Q_914D_7F6E__6A21_578B_8DEF_5F84_73 = "war3mapImported\\remiliasq.mdl"
    end
    local ____Q_914D_7F6E__7F29_653E_74 = ____Q_914D_7F6E["缩放"]
    if ____Q_914D_7F6E__7F29_653E_74 == nil then
        ____Q_914D_7F6E__7F29_653E_74 = 2.5
    end
    ____521B_5EFA_5E26_4E0A_4E0B_6587_539F_751F_5F39_5E55_79({
        ["上下文"] = context,
        ["命中后清理"] = false,
        ["on命中"] = ____Q_547D_4E2D_77,
        ["on结束"] = ____Q_5F39_5E55_7ED3_675F_78,
        ["弹幕参数"] = {
            ["所有者"] = _____771F_5B9E_65BD_6CD5_8005,
            X = ____GetUnitX_result_75,
            Y = ____GetUnitY_result_76,
            ["方向角"] = angle,
            ["速度"] = ____Q_914D_7F6E__901F_5EA6_68,
            ["飞行高度"] = ____Q_914D_7F6E__98DE_884C_9AD8_5EA6_69,
            ["生命周期"] = ____Q_914D_7F6E__751F_547D_5468_671F_79D2_70,
            ["最大距离"] = ____Q_914D_7F6E__6700_5927_8DDD_79BB_71,
            ["命中半径"] = ____Q_914D_7F6E__547D_4E2D_534A_5F84_72,
            ["影响目标"] = "敌方",
            ["每单位最大命中次数"] = 1,
            ["模型"] = ____Q_914D_7F6E__6A21_578B_8DEF_5F84_73,
            ["缩放"] = ____Q_914D_7F6E__7F29_653E_74,
            ["禁用碰撞"] = true,
            onTick = ____Q_5F39_5E55Tick
        }
    })
end
local function _____83B7_53D6Q_4E0A_4E0B_6587(unit)
    return {["施法者"] = unit, ["技能实例ID"] = 0, ["伤害攻击力"] = 0, ["伤害最大生命"] = 0}
end
local function _____6CE8_518CQ_76D1_542C(skillId, name, unitTypeId)
    if unitTypeId == nil then
        unitTypeId = _____5355_4F4D_7C7B_578BID
    end
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = name,
        ["单位类型ID"] = unitTypeId,
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
_____6CE8_518CQ_76D1_542C(____Q_517C_5BB9_6280_80FDID, "蕾米莉亚-血雾替身Q", _____8840_96FE_66FF_8EAB_5355_4F4D_7C7B_578BID)
return ____exports
