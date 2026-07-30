--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____01_FF0E_63A7_5236_4E0EBuff = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____01_FF0E_63A7_5236_4E0EBuff["开始硬直"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local _____6247_5F62_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.扇形区域")
local _____5355_4F4D_662F_5426_5728_6247_5F62_533A_57DF = _____6247_5F62_533A_57DF["单位是否在扇形区域"]
local _____80F6_56CA_533A_57DF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.09．形状区域.胶囊区域")
local _____5355_4F4D_662F_5426_5728_80F6_56CA_533A_57DF = _____80F6_56CA_533A_57DF["单位是否在胶囊区域"]
local ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.01．固定组合技能执行器")
local _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668 = ____01_FF0E_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668["创建固定组合技能执行器"]
local ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.14．固定组合技能模板.02．固定时间轴阶段工厂")
local _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868 = ____02_FF0E_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5DE5_5382["创建固定时间轴阶段列表"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____19_FF0E_541F_5531_6761 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.19．吟唱条")
local _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761 = ____19_FF0E_541F_5531_6761["显示夏提雅常规吟唱条"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local SetUnitFacing = jass.SetUnitFacing
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local DEG_TO_RAD = 0.017453292519943295
local RAD_TO_DEG = 57.29577951308232
local function _____9020_6210_8F6E_821E_4F24_5BB3(source, target, attackRatio, lifeRatio, tag)
    local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(source, target, {["来源攻击力比例"] = attackRatio, ["目标最大生命比例"] = lifeRatio})
    _____9020_6210AOE_6280_80FD_4F24_5BB3({
        ["来源"] = source,
        ["目标"] = target,
        ["伤害"] = damage,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        ["伤害类型"] = DAMAGE_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
        ["来源类型"] = "Boss技能",
        ["标签"] = tag
    })
end
____exports["释放夏提雅血月轮舞"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "血月轮舞")
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["血月轮舞"]
    local secondDelay = context["阶段"] == "P3真祖血宴" and cfg["第二段延迟秒"] * cfg["P3第二段延迟倍率"] or cfg["第二段延迟秒"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local facing = Atan2(
        GetUnitY(target) - y,
        GetUnitX(target) - x
    ) * RAD_TO_DEG
    local reverseFacing = facing + 180
    local reverseRad = reverseFacing * DEG_TO_RAD
    local reverseEndX = x + Cos(reverseRad) * cfg["反刺长度"]
    local reverseEndY = y + Sin(reverseRad) * cfg["反刺长度"]
    local _____4E8B_4EF6_5217_8868 = {
        {
            ["时点毫秒"] = 0,
            ["名称"] = "血月轮舞开始",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
                    return
                end
                _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
                context["普通机制忙碌到Ms"] = getServerTime() + (cfg["第一段预警秒"] + secondDelay + 0.5) * 1000
                SetUnitFacing(boss, facing)
                _____5F00_59CB_786C_76F4(boss, cfg["第一段预警秒"] + secondDelay)
                _____663E_793A_590F_63D0_96C5_5E38_89C4_541F_5531_6761(cfg["第一段预警秒"] + secondDelay, cfg["吟唱条颜色ID"], cfg["吟唱条标题文本"], cfg["吟唱条提示文本"])
                _____521B_5EFA_6280_80FD_63D0_793A_5708({
                    ["类型"] = "扇形",
                    X = x,
                    Y = y,
                    ["半径"] = cfg["扇形半径"],
                    ["扇形角度"] = cfg["扇形角度"],
                    ["朝向"] = facing,
                    ["持续时间"] = cfg["第一段预警秒"],
                    ["来源单位"] = boss
                })
                _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["横扫动画编号"], ["持续秒"] = cfg["第一段预警秒"] + 0.25, ["恢复动画编号"] = 0})
            end
        },
        {
            ["时点毫秒"] = cfg["第一段预警秒"] * 1000,
            ["名称"] = "血月轮舞横扫结算",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
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
                            _____9020_6210_8F6E_821E_4F24_5BB3(
                                boss,
                                heroes[i + 1],
                                cfg["横扫伤害攻击力比例"],
                                cfg["横扫伤害目标最大生命比例"],
                                "夏提雅·血月轮舞-横扫"
                            )
                        end
                        i = i + 1
                    end
                end
                local effect = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["血月轮舞特效路径"], x, y)
                if effect ~= nil and effect ~= 0 then
                    YDWETimerDestroyEffectSafe(cfg["特效持续秒"], effect)
                end
                _____521B_5EFA_6280_80FD_63D0_793A_5708({
                    ["类型"] = "方向直线",
                    X = x,
                    Y = y,
                    ["宽度"] = cfg["反刺宽度"],
                    ["长度"] = cfg["反刺长度"],
                    ["朝向"] = reverseFacing,
                    ["持续时间"] = secondDelay,
                    ["来源单位"] = boss
                })
                SetUnitFacing(boss, reverseFacing)
                _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["反刺动画编号"], ["持续秒"] = secondDelay + 0.25, ["恢复动画编号"] = 0})
            end
        },
        {
            ["时点毫秒"] = (cfg["第一段预警秒"] + secondDelay) * 1000,
            ["名称"] = "血月轮舞反刺结算",
            ["执行"] = function()
                if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
                    return
                end
                local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
                do
                    local i = 0
                    while i < #heroes do
                        if _____5355_4F4D_662F_5426_5728_80F6_56CA_533A_57DF(
                            heroes[i + 1],
                            x,
                            y,
                            reverseEndX,
                            reverseEndY,
                            cfg["反刺宽度"]
                        ) then
                            _____9020_6210_8F6E_821E_4F24_5BB3(
                                boss,
                                heroes[i + 1],
                                cfg["反刺伤害攻击力比例"],
                                cfg["反刺伤害目标最大生命比例"],
                                "夏提雅·血月轮舞-反刺"
                            )
                        end
                        i = i + 1
                    end
                end
            end
        }
    }
    if context["血月轮舞组合执行器"] == nil then
        context["血月轮舞组合执行器"] = _____521B_5EFA_56FA_5B9A_7EC4_5408_6280_80FD_6267_884C_5668({["名称"] = "夏提雅-血月轮舞", ["清理"] = context["清理"], ["互斥组"] = "夏提雅普通技能"})
    end
    local ____self_5 = context["血月轮舞组合执行器"]
    local _____6267_884CID = ____self_5["开始"](
        ____self_5,
        {
            key = "血月轮舞",
            ["单位"] = boss,
            ["上下文"] = context,
            ["最大持续毫秒"] = (cfg["第一段预警秒"] + secondDelay + 0.5) * 1000,
            ["阶段列表"] = _____521B_5EFA_56FA_5B9A_65F6_95F4_8F74_9636_6BB5_5217_8868(_____4E8B_4EF6_5217_8868)
        }
    )
    return _____6267_884CID ~= 0
end
____exports["血月轮舞技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = false,
    ["语义"] = "宽扇形横扫后接窄直线反刺，两段方向提前锁定；开始时清空猎血连击。"
}
return ____exports
