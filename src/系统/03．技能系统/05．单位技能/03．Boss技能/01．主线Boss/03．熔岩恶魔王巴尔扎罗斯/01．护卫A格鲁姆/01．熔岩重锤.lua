--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.00．公共")
local _____683C_9C81_59C6_516C_5171 = ____00_FF0E_516C_5171["格鲁姆公共"]
local ____683C_9C81_59C6_516C_5171_0 = _____683C_9C81_59C6_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____683C_9C81_59C6_516C_5171_0["巴尔扎罗斯技能数值配置"]
local _____64AD_653E_683C_9C81_59C6_53F0_8BCD = ____683C_9C81_59C6_516C_5171_0["播放格鲁姆台词"]
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____683C_9C81_59C6_516C_5171_0["施加巴尔扎罗斯灼热"]
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____683C_9C81_59C6_516C_5171_0["启动基础施法时间线"]
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____683C_9C81_59C6_516C_5171_0["创建技能提示圈"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____683C_9C81_59C6_516C_5171_0["获取Boss技能敌对英雄列表"]
local _____65BD_52A0_5FEB_901F_63A7_5236Buff = ____683C_9C81_59C6_516C_5171_0["施加快速控制Buff"]
local GetUnitX = ____683C_9C81_59C6_516C_5171_0.GetUnitX
local GetUnitY = ____683C_9C81_59C6_516C_5171_0.GetUnitY
local CosBJ = ____683C_9C81_59C6_516C_5171_0.CosBJ
local SinBJ = ____683C_9C81_59C6_516C_5171_0.SinBJ
local ATTACK_TYPE_NORMAL = ____683C_9C81_59C6_516C_5171_0.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = ____683C_9C81_59C6_516C_5171_0.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = ____683C_9C81_59C6_516C_5171_0.WEAPON_TYPE_WHOKNOWS
local _____5FEB_901F_63A7_5236__51FB_6655 = ____683C_9C81_59C6_516C_5171_0["快速控制_击晕"]
local _____5355_4F4D_6709_6548 = ____683C_9C81_59C6_516C_5171_0["单位有效"]
local _____70B9_5230_5355_4F4D_8DDD_79BB_5E73_65B9 = ____683C_9C81_59C6_516C_5171_0["点到单位距离平方"]
local _____53D6_65B9_5411_89D2 = ____683C_9C81_59C6_516C_5171_0["取方向角"]
local _____89D2_5EA6_5DEE_7EDD_5BF9_503C = ____683C_9C81_59C6_516C_5171_0["角度差绝对值"]
local _____9020_6210_683C_9C81_59C6Boss_6280_80FD_4F24_5BB3 = ____683C_9C81_59C6_516C_5171_0["造成格鲁姆Boss技能伤害"]
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
local function _____521B_5EFA_91CD_9524_63D0_793A(grum, angle)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩重锤"]
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "红色扇形",
        X = GetUnitX(grum),
        Y = GetUnitY(grum),
        ["朝向"] = angle,
        ["扇形角度"] = config["扇形角度"],
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
    local _____7206_70B8X = GetUnitX(grum) + CosBJ(angle) * config["扇形半径"] * 0.5
    local _____7206_70B8Y = GetUnitY(grum) + SinBJ(angle) * config["扇形半径"] * 0.5
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
        _____7206_70B8X,
        _____7206_70B8Y,
        config["爆炸特效高度"],
        config["爆炸特效缩放"],
        config["特效持续秒"],
        angle
    )
    _____64AD_653E_70B9_7279_6548(
        config["爆炸叠加特效路径"],
        _____7206_70B8X,
        _____7206_70B8Y,
        config["爆炸特效高度"],
        config["爆炸叠加特效缩放"],
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
                    goto __continue9
                end
                _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
                    ["来源"] = grum,
                    ["目标"] = hero,
                    ["伤害公式"] = {["来源攻击力比例"] = config["伤害攻击力比例"], ["目标最大生命比例"] = config["伤害目标最大生命比例"], ["总倍率"] = config["伤害总倍率"]},
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_FIRE,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["标签"] = "格鲁姆-熔岩重锤"
                })
                _____65BD_52A0_5FEB_901F_63A7_5236Buff(grum, hero, _____5FEB_901F_63A7_5236__51FB_6655, config["眩晕秒"])
                _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(hero, config["灼热层数"])
            end
            ::__continue9::
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
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(grum, angle)
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
            _____64AD_653E_683C_9C81_59C6_53F0_8BCD(grum, "熔岩重锤")
        end,
        ["on生效"] = function()
            _____7ED3_7B97_91CD_9524(context, angle)
        end
    })
end
return ____exports
