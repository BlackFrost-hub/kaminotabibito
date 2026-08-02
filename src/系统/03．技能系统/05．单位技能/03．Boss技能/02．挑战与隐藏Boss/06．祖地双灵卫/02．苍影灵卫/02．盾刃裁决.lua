--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local _____9020_6210_88C1_51B3_4F24_5BB3, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_NORMAL, WEAPON_TYPE_METAL_HEAVY_SLICE
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["开始祖地双灵卫常规施法"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411 = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["立即设置单位朝向"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____6267_884CBossAOE_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["执行BossAOE技能伤害"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["两点角度"]
local _____6781_5750_6807X = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标X"]
local _____6781_5750_6807Y = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["极坐标Y"]
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位有效"]
local _____6247_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF = _____6247_5F62_533A_57DF["单位是否在扇形区域"]
local ____03_FF0E_5BF9_5916_63A5_53E3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口")
local _____521B_5EFA_539F_751F_5F39_5E55 = ____03_FF0E_5BF9_5916_63A5_53E3["创建原生弹幕"]
local ____03_FF0E_7279_6548 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____03_FF0E_7279_6548["创建点特效"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
function _____9020_6210_88C1_51B3_4F24_5BB3(boss, target, attackRatio, lifeRatio, tag, weaponType)
    _____6267_884CBossAOE_6280_80FD_4F24_5BB3({
        ["来源"] = boss,
        ["目标"] = target,
        ["伤害公式"] = {["来源攻击力比例"] = attackRatio, ["目标最大生命比例"] = lifeRatio},
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        weaponType = weaponType,
        ["标签"] = tag
    })
end
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local SetUnitAnimationByIndex = require("jass.common").SetUnitAnimationByIndex
local function _____64AD_653E_5251_5203_91CD_65A9_76F4_7EBF_5F39_5E55(boss, x, y, facing, length, cfg)
    local barrage = _____521B_5EFA_539F_751F_5F39_5E55({
        ["所有者"] = boss,
        X = x,
        Y = y,
        ["方向角"] = facing,
        ["速度"] = 1400,
        ["最大距离"] = length,
        ["生命周期"] = 0.6,
        ["命中半径"] = cfg["直线宽度"] * 0.5,
        ["影响目标"] = "敌方",
        ["模型"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["盾刃裁决"]["剑刃重斩特效路径"],
        ["缩放"] = 1,
        ["每单位最大命中次数"] = 1,
        ["碰撞消失"] = false,
        ["目标筛选"] = function(target)
            local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
            do
                local i = 0
                while i < #heroes do
                    if heroes[i + 1] == target then
                        return true
                    end
                    i = i + 1
                end
            end
            return false
        end,
        ["on命中"] = function(target)
            _____9020_6210_88C1_51B3_4F24_5BB3(
                boss,
                target,
                cfg["重斩伤害攻击力比例"],
                cfg["单段目标最大生命比例"],
                "祖地双灵卫·盾刃裁决-重斩",
                WEAPON_TYPE_METAL_HEAVY_SLICE
            )
        end
    })
    if barrage["弹幕单位"] ~= nil and barrage["弹幕单位"] ~= 0 then
        SetUnitAnimationByIndex(barrage["弹幕单位"], 0)
    end
end
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_BASH = jass.WEAPON_TYPE_METAL_HEAVY_BASH
WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
____exports["释放盾刃裁决"] = function(context, target)
    local boss = context["苍影灵卫单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["战斗已结束"] then
        return false
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P1["盾刃裁决"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local facing = _____4E24_70B9_89D2_5EA6(
        x,
        y,
        GetUnitX(target),
        GetUnitY(target)
    )
    local firstWarning = cfg["两段间隔秒"]
    context["大型机制忙碌到Ms"] = getServerTime() + (firstWarning + cfg["两段间隔秒"] + 0.35) * 1000
    _____7ACB_5373_8BBE_7F6E_5355_4F4D_671D_5411(boss, facing)
    _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5(boss, firstWarning, "盾刃裁决", "先结算正面盾击，再沿锁定方向释放重斩")
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "扇形",
        X = x,
        Y = y,
        ["半径"] = cfg["扇形半径"],
        ["扇形角度"] = cfg["扇形角度"],
        ["朝向"] = facing,
        ["持续时间"] = firstWarning,
        ["来源单位"] = boss
    })
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["盾击动画编号"], ["持续秒"] = firstWarning + 0.15, ["恢复动画编号"] = cfg["恢复动画编号"]})
    local _____4E8B_4EF6_5217_8868 = {
        {
            ["时点毫秒"] = firstWarning * 1000,
            ["名称"] = "盾刃裁决盾击",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                    return
                end
                local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
                do
                    local i = 0
                    while i < #heroes do
                        if _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF(
                            heroes[i + 1],
                            x,
                            y,
                            cfg["扇形半径"],
                            facing,
                            cfg["扇形角度"]
                        ) then
                            _____9020_6210_88C1_51B3_4F24_5BB3(
                                boss,
                                heroes[i + 1],
                                cfg["盾击伤害攻击力比例"],
                                cfg["单段目标最大生命比例"],
                                "祖地双灵卫·盾刃裁决-盾击",
                                WEAPON_TYPE_METAL_HEAVY_BASH
                            )
                        end
                        i = i + 1
                    end
                end
                _____521B_5EFA_70B9_7279_6548({
                    ["模型路径"] = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["盾刃裁决"]["盾击命中特效路径"],
                    X = _____6781_5750_6807X(x, facing, cfg["扇形半径"] * 0.45),
                    Y = _____6781_5750_6807Y(y, facing, cfg["扇形半径"] * 0.45),
                    ["缩放"] = 5,
                    ["动画索引"] = 0,
                    ["持续秒"] = 0.8
                })
                _____5F00_59CB_7956_5730_53CC_7075_536B_5E38_89C4_65BD_6CD5(boss, cfg["两段间隔秒"], "盾刃裁决·重斩", "重斩将沿刚才的方向结算")
                _____521B_5EFA_6280_80FD_63D0_793A_5708({
                    ["类型"] = "方向直线",
                    X = x,
                    Y = y,
                    ["宽度"] = cfg["直线宽度"],
                    ["长度"] = cfg["直线长度"],
                    ["朝向"] = facing,
                    ["持续时间"] = cfg["两段间隔秒"],
                    ["来源单位"] = boss
                })
                _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["重斩动画编号"], ["持续秒"] = cfg["两段间隔秒"] + 0.2, ["恢复动画编号"] = cfg["恢复动画编号"]})
            end
        },
        {
            ["时点毫秒"] = (firstWarning + cfg["两段间隔秒"]) * 1000,
            ["名称"] = "盾刃裁决重斩",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) or context["战斗已结束"] then
                    return
                end
                _____64AD_653E_5251_5203_91CD_65A9_76F4_7EBF_5F39_5E55(
                    boss,
                    x,
                    y,
                    facing,
                    cfg["直线长度"],
                    cfg
                )
            end
        }
    }
    local executor = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "祖地双灵卫-盾刃裁决", ["清理"] = context["清理"], ["互斥组"] = "祖地双灵卫主要技能"})
    return executor["开始"](
        executor,
        {
            key = "盾刃裁决",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (firstWarning + cfg["两段间隔秒"] + 0.35) * 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____4E8B_4EF6_5217_8868)
        }
    ) ~= 0
end
____exports["盾刃裁决技能状态"] = {
    ["所属守卫"] = "苍影灵卫",
    ["所属形态"] = "正常",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["需要独立技能实例ID"] = false,
    ["包含战斗自身位移"] = false,
    ["实现要求"] = "开始时锁定方向，盾击扇形与后续窄直线重斩分别预警、分别结算。"
}
return ____exports
