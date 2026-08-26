--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_95F4_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位间角度"]
local ____00_FF0E_516C_5171 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.03．熔岩恶魔王巴尔扎罗斯.01．护卫A格鲁姆.00．公共")
local _____683C_9C81_59C6_516C_5171 = ____00_FF0E_516C_5171["格鲁姆公共"]
local ____683C_9C81_59C6_516C_5171_0 = _____683C_9C81_59C6_516C_5171
local _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E = ____683C_9C81_59C6_516C_5171_0["巴尔扎罗斯技能数值配置"]
local _____64AD_653E_683C_9C81_59C6_53F0_8BCD = ____683C_9C81_59C6_516C_5171_0["播放格鲁姆台词"]
local _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED = ____683C_9C81_59C6_516C_5171_0["施加巴尔扎罗斯灼热"]
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____683C_9C81_59C6_516C_5171_0["读取单位攻击力"]
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____683C_9C81_59C6_516C_5171_0["启动基础施法时间线"]
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____683C_9C81_59C6_516C_5171_0["创建技能提示圈"]
local _____521B_5EFA_7EBF_6BB5_5371_9669_533A = ____683C_9C81_59C6_516C_5171_0["创建线段危险区"]
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____683C_9C81_59C6_516C_5171_0["获取Boss技能敌对英雄列表"]
local CosBJ = ____683C_9C81_59C6_516C_5171_0.CosBJ
local SinBJ = ____683C_9C81_59C6_516C_5171_0.SinBJ
local GetUnitX = ____683C_9C81_59C6_516C_5171_0.GetUnitX
local GetUnitY = ____683C_9C81_59C6_516C_5171_0.GetUnitY
local _____5355_4F4D_6709_6548 = ____683C_9C81_59C6_516C_5171_0["单位有效"]
local _____8BA1_7B97_706B_5F84_6301_7EED_4F24_5BB3 = ____683C_9C81_59C6_516C_5171_0["计算火径持续伤害"]
local ATTACK_TYPE_NORMAL = ____683C_9C81_59C6_516C_5171_0.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = ____683C_9C81_59C6_516C_5171_0.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = ____683C_9C81_59C6_516C_5171_0.WEAPON_TYPE_WHOKNOWS
local _____9020_6210_683C_9C81_59C6Boss_6280_80FD_4F24_5BB3 = ____683C_9C81_59C6_516C_5171_0["造成格鲁姆Boss技能伤害"]
local _____64AD_653E_70B9_7279_6548 = ____683C_9C81_59C6_516C_5171_0["播放点特效"]
local function _____53D6_706B_5F84_53C2_6570(grum, target)
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    local normalAngle = _____5355_4F4D_95F4_89D2_5EA6(grum, target)
    local lineAngle = normalAngle + 90
    local center = {
        x = GetUnitX(grum) + CosBJ(normalAngle) * config["火线中心前移"],
        y = GetUnitY(grum) + SinBJ(normalAngle) * config["火线中心前移"]
    }
    return {
        center = center,
        start = {
            x = center.x - CosBJ(lineAngle) * config["长度"] * 0.5,
            y = center.y - SinBJ(lineAngle) * config["长度"] * 0.5
        },
        lineAngle = lineAngle,
        normalAngle = normalAngle
    }
end
local function _____83B7_53D6_683C_9C81_59C6_706B_5F84_76EE_6807(variable)
    local state = variable
    if state == nil or not _____5355_4F4D_6709_6548(state.grum) then
        return {}
    end
    return _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(state.context["Boss单位"])
end
local function ____on_683C_9C81_59C6_706B_5F84_5468_671F(unit, variable)
    local state = variable
    if state == nil or not _____5355_4F4D_6709_6548(state.grum) or not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    _____9020_6210_683C_9C81_59C6Boss_6280_80FD_4F24_5BB3(
        state.grum,
        unit,
        _____8BA1_7B97_706B_5F84_6301_7EED_4F24_5BB3(state.grum),
        "AOE"
    )
    _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(state.context, unit, config["灼热层数"])
end
local function ____on_683C_9C81_59C6_706B_5F84_7A7F_8D8A(unit, variable)
    local state = variable
    if state == nil or not _____5355_4F4D_6709_6548(state.grum) or not _____5355_4F4D_6709_6548(unit) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = state.grum,
        ["目标"] = unit,
        ["伤害公式"] = {["来源攻击力比例"] = config["穿越伤害攻击力比例"], ["目标最大生命比例"] = config["穿越伤害目标最大生命比例"], ["总倍率"] = config["伤害总倍率"]},
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["标签"] = "格鲁姆-熔岩火径-穿越"
    })
    _____65BD_52A0_5DF4_5C14_624E_7F57_65AF_707C_70ED(state.context, unit, config["灼热层数"])
end
local function _____521B_5EFA_706B_5F84(context, center, lineAngle)
    local grum = context["格鲁姆"]
    if not _____5355_4F4D_6709_6548(grum) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    local effect = _____64AD_653E_70B9_7279_6548(
        config["火线模型路径"],
        center.x,
        center.y,
        config["火线特效高度"],
        config["火线特效缩放"],
        config["持续秒"],
        lineAngle + 90
    )
    local ____self_1 = context["清理"]
    ____self_1["登记特效"](____self_1, "格鲁姆-熔岩火径主特效", effect)
    _____521B_5EFA_7EBF_6BB5_5371_9669_533A({
        ["清理"] = context["清理"],
        ["名称"] = "格鲁姆-熔岩火径",
        ["起点X"] = center.x - CosBJ(lineAngle) * config["长度"] * 0.5,
        ["起点Y"] = center.y - SinBJ(lineAngle) * config["长度"] * 0.5,
        ["方向角"] = lineAngle,
        ["长度"] = config["长度"],
        ["宽度"] = config["宽度"],
        ["持续秒"] = config["持续秒"],
        ["Tick间隔毫秒"] = config["Tick间隔毫秒"],
        ["周期秒"] = config["周期秒"],
        ["变量"] = {context = context, grum = grum},
        ["单位列表"] = _____83B7_53D6_683C_9C81_59C6_706B_5F84_76EE_6807,
        ["穿越防抖秒"] = config["穿越防抖秒"],
        ["提示圈"] = {["类型"] = "方向直线", ["来源单位"] = grum},
        ["on周期"] = ____on_683C_9C81_59C6_706B_5F84_5468_671F,
        ["on穿越"] = ____on_683C_9C81_59C6_706B_5F84_7A7F_8D8A
    })
end
____exports["释放格鲁姆火径"] = function(context, target)
    local grum = context["格鲁姆"]
    if not _____5355_4F4D_6709_6548(grum) or not _____5355_4F4D_6709_6548(target) then
        return
    end
    local config = _____5DF4_5C14_624E_7F57_65AF_6280_80FD_6570_503C_914D_7F6E["熔岩火径"]
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(
        grum,
        _____5355_4F4D_95F4_89D2_5EA6(grum, target)
    )
    local fire = _____53D6_706B_5F84_53C2_6570(grum, target)
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "矩形",
        X = fire.start.x,
        Y = fire.start.y,
        ["宽度"] = config["宽度"],
        ["长度"] = config["长度"],
        ["朝向"] = fire.lineAngle,
        ["持续时间"] = config["施法硬直秒"]
    })
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = grum,
        ["目标X"] = fire.center.x,
        ["目标Y"] = fire.center.y,
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
            _____64AD_653E_683C_9C81_59C6_53F0_8BCD(grum, "熔岩火径")
        end,
        ["on生效"] = function()
            _____521B_5EFA_706B_5F84(context, fire.center, fire.lineAngle)
        end
    })
end
return ____exports
