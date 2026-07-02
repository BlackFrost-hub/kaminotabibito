--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.05．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.00．公共")
local _____683C_9C81_59C6_516C_5171 = ____00_FF0E_516C_5171["格鲁姆公共"]
local ____683C_9C81_59C6_516C_5171_0 = _____683C_9C81_59C6_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____683C_9C81_59C6_516C_5171_0["巴尔扎罗斯技能数值配置"]
local _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD = ____683C_9C81_59C6_516C_5171_0["播放巴尔扎罗斯台词"]
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____683C_9C81_59C6_516C_5171_0["施加巴尔扎罗斯灼热"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____683C_9C81_59C6_516C_5171_0["读取单位攻击力"]
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____683C_9C81_59C6_516C_5171_0["启动基础施法时间线"]
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____683C_9C81_59C6_516C_5171_0["创建技能提示圈"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____683C_9C81_59C6_516C_5171_0["获取Boss技能敌对英雄列表"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____683C_9C81_59C6_516C_5171_0["施加快速控制Buff"]
local GetUnitX = ____683C_9C81_59C6_516C_5171_0.GetUnitX
local GetUnitY = ____683C_9C81_59C6_516C_5171_0.GetUnitY
local GetUnitState = ____683C_9C81_59C6_516C_5171_0.GetUnitState
local UnitDamageTarget = ____683C_9C81_59C6_516C_5171_0.UnitDamageTarget
local UNIT_STATE_MAX_LIFE = ____683C_9C81_59C6_516C_5171_0.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_CHAOS = ____683C_9C81_59C6_516C_5171_0.ATTACK_TYPE_CHAOS
local DAMAGE_TYPE_FIRE = ____683C_9C81_59C6_516C_5171_0.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = ____683C_9C81_59C6_516C_5171_0.WEAPON_TYPE_WHOKNOWS
local _____5FEB_901F_63A7_5236__51FB_6655 = ____683C_9C81_59C6_516C_5171_0["快速控制_击晕"]
local _____5355_4F4D_6709_6548 = ____683C_9C81_59C6_516C_5171_0["单位有效"]
local _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9 = ____683C_9C81_59C6_516C_5171_0["点到单位距离平方"]
local _____53D6_65B9_5411_89D2 = ____683C_9C81_59C6_516C_5171_0["取方向角"]
local _____89D2_5EA6_5DEE_7EDD_5BF9_503C = ____683C_9C81_59C6_516C_5171_0["角度差绝对值"]
local _____64AD_653E_70B9_7279_6548 = ____683C_9C81_59C6_516C_5171_0["播放点特效"]
local function _____76EE_6807_5728_91CD_9524_6247_5F62_5185(grum, target, facing)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    if not _____5355_4F4D_6709_6548(grum) or not _____5355_4F4D_6709_6548(target) then
        return false
    end
    if _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9(
        target,
        GetUnitX(grum),
        GetUnitY(grum)
    ) > config["扇形半径"] * config["扇形半径"] then
        return false
    end
    local angle = _____53D6_65B9_5411_89D2(grum, target)
    return _____89D2_5EA6_5DEE_7EDD_5BF9_503C(angle, facing) <= config["扇形角度"] * 0.5
end
local function _____8BA1_7B97_91CD_9524_4F24_5BB3(grum, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    return (_____8BFB_53D6_5355_4F4D_653B_51FB_529B(grum) * config["伤害攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * config["伤害目标最大生命比例"]) * config["伤害总倍率"]
end
local function _____521B_5EFA_91CD_9524_63D0_793A(grum, angle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "红色扇形",
        X = GetUnitX(grum),
        Y = GetUnitY(grum),
        ["朝向"] = angle,
        ["扇形模型尺寸"] = config["扇形半径"] / 512,
        ["持续时间"] = config["施法硬直秒"]
    })
end
local function _____7ED3_7B97_91CD_9524(context, angle)
    local grum = context["格鲁姆"]
    if not _____5355_4F4D_6709_6548(grum) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    _____64AD_653E_70B9_7279_6548(
        config["冲击波特效路径"],
        GetUnitX(grum),
        GetUnitY(grum),
        config["冲击波特效高度"],
        config["冲击波特效缩放"],
        config["特效持续秒"],
        angle
    )
    _____64AD_653E_70B9_7279_6548(
        config["爆炸特效路径"],
        GetUnitX(grum),
        GetUnitY(grum),
        config["爆炸特效高度"],
        config["爆炸特效缩放"],
        config["特效持续秒"],
        angle
    )
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
    do
        local i = 0
        while i < #heroes do
            do
                local hero = heroes[i + 1]
                if not _____76EE_6807_5728_91CD_9524_6247_5F62_5185(grum, hero, angle) then
                    goto __continue10
                end
                UnitDamageTarget(
                    grum,
                    hero,
                    _____8BA1_7B97_91CD_9524_4F24_5BB3(grum, hero),
                    false,
                    true,
                    ATTACK_TYPE_CHAOS,
                    DAMAGE_TYPE_FIRE,
                    WEAPON_TYPE_WHOKNOWS
                )
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(grum, hero, _____5FEB_901F_63A7_5236__51FB_6655, config["眩晕秒"])
                _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(hero, config["灼热层数"])
            end
            ::__continue10::
            i = i + 1
        end
    end
end
____exports["释放格鲁姆重锤"] = function(context, target)
    local grum = context["格鲁姆"]
    if not _____5355_4F4D_6709_6548(grum) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    local angle = _____53D6_65B9_5411_89D2(grum, target)
    _____521B_5EFA_91CD_9524_63D0_793A(grum, angle)
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = grum,
        ["目标单位"] = target,
        ["硬直秒"] = config["施法硬直秒"],
        ["动画编号"] = config["动画编号"],
        ["动画速度"] = config["动画速度"],
        ["吟唱条"] = {
            ["通道"] = "常规技能",
            ["总时长"] = config["施法硬直秒"],
            ["颜色ID"] = config["吟唱条颜色ID"],
            ["标题文本"] = config["吟唱条标题文本"],
            ["提示文本"] = config["吟唱条提示文本"]
        },
        ["播放台词"] = function()
            _____64AD_653E_5DF4_5C14_624E_7F57_65AF_53F0_8BCD(context["Boss单位"], "熔岩重锤")
        end,
        ["on生效"] = function()
            _____7ED3_7B97_91CD_9524(context, angle)
        end
    })
end
return ____exports
