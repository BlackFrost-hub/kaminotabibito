--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.01．运行时上下文")
local _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["重置夏提雅猎血连击"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.02．数值与表现配置")
local _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["夏提雅数值与表现配置"]
local ____04_FF0E_9C9C_8840_5370_8BB0 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.04．鲜血印记")
local _____51C0_5316_843D_70B9_5185_590F_63D0_96C5_9C9C_8840_5370_8BB0 = ____04_FF0E_9C9C_8840_5370_8BB0["净化落点内夏提雅鲜血印记"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____21_FF0E_7EC4_5408_6280_80FD_4F24_5BB3["计算组合技能伤害"]
local ____09_FF0E_82F1_7075_6218_4E59_5973 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.09．英灵战乙女")
local _____83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71 = ____09_FF0E_82F1_7075_6218_4E59_5973["获取夏提雅英灵投影"]
local _____5C1D_8BD5_89E6_53D1_82F1_7075_6218_4E59_5973_590D_523B = ____09_FF0E_82F1_7075_6218_4E59_5973["尝试触发英灵战乙女复刻"]
local ____05_FF0E_70B9_540D_9884_8B66_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.05．点名预警执行器")
local _____521B_5EFA_70B9_540D_9884_8B66_6267_884C_5668 = ____05_FF0E_70B9_540D_9884_8B66_6267_884C_5668["创建点名预警执行器"]
local ____18_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.04．夏提雅.18．台词播放")
local _____64AD_653E_590F_63D0_96C5_53F0_8BCD = ____18_FF0E_53F0_8BCD_64AD_653E["播放夏提雅台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4 = ____require_result_1["获取Boss技能随机敌对英雄"]
local ____require_result_2 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_2["造成AOE技能伤害"]
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_3.getServerTime
local ____require_result_4 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_4.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local GetHandleId = jass.GetHandleId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local Atan2 = jass.Atan2
local GetRandomReal = jass.GetRandomReal
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_MAGIC = jass.ATTACK_TYPE_MAGIC
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local RAD_TO_DEG = 57.29577951308232
local function _____5C1D_8BD5_5B89_6392_51C0_5316_6295_67AA_82F1_7075_590D_523B(context, x, y)
    local projection = _____83B7_53D6_590F_63D0_96C5_82F1_7075_6295_5F71(context)
    if not _____5355_4F4D_6709_6548(projection) then
        return
    end
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["净化投枪"]
    local p2 = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E.P2
    local delay = GetRandomReal(p2["英灵复刻延迟最小秒"], p2["英灵复刻延迟最大秒"])
    local facing = Atan2(
        y - GetUnitY(projection),
        x - GetUnitX(projection)
    ) * RAD_TO_DEG
    local started = _____5C1D_8BD5_89E6_53D1_82F1_7075_6218_4E59_5973_590D_523B(
        context,
        "净化投枪",
        {
            X = GetUnitX(projection),
            Y = GetUnitY(projection),
            ["朝向"] = facing,
            ["延迟秒"] = delay,
            ["复刻结算"] = function()
                local effect = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["净化投枪特效路径"], x, y)
                if effect ~= nil and effect ~= 0 then
                    YDWETimerDestroyEffectSafe(cfg["特效持续秒"], effect)
                end
                _____51C0_5316_843D_70B9_5185_590F_63D0_96C5_9C9C_8840_5370_8BB0(context, x, y, cfg["伤害半径"])
                local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["Boss单位"])
                do
                    local i = 0
                    while i < #heroes do
                        do
                            local dx = GetUnitX(heroes[i + 1]) - x
                            local dy = GetUnitY(heroes[i + 1]) - y
                            if dx * dx + dy * dy > cfg["伤害半径"] * cfg["伤害半径"] then
                                goto __continue7
                            end
                            local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(context["Boss单位"], heroes[i + 1], {["来源攻击力比例"] = cfg["伤害攻击力比例"] * p2["英灵复刻伤害比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"] * p2["英灵复刻伤害比例"]})
                            _____9020_6210AOE_6280_80FD_4F24_5BB3({
                                ["来源"] = context["Boss单位"],
                                ["目标"] = heroes[i + 1],
                                ["伤害"] = damage,
                                attack = false,
                                ranged = true,
                                attackType = ATTACK_TYPE_MAGIC,
                                ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                                weaponType = WEAPON_TYPE_WHOKNOWS,
                                ["来源类型"] = "Boss技能",
                                ["标签"] = "夏提雅·英灵复刻-净化投枪"
                            })
                        end
                        ::__continue7::
                        i = i + 1
                    end
                end
            end
        }
    )
    if started then
        _____521B_5EFA_6280_80FD_63D0_793A_5708({
            ["类型"] = "敌方圆形",
            X = x,
            Y = y,
            ["半径"] = cfg["伤害半径"],
            ["持续时间"] = delay,
            ["来源单位"] = context["Boss单位"]
        })
    end
end
local function _____7ED3_7B97_51C0_5316_6295_67AA_843D_70B9(context, x, y, tag)
    local boss = context["Boss单位"]
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["净化投枪"]
    _____64AD_653EBoss_5750_6807_97F3_6548(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["净化投枪"], x, y, _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"])
    local effect = AddSpecialEffect(_____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["净化投枪特效路径"], x, y)
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["特效持续秒"], effect)
    end
    _____51C0_5316_843D_70B9_5185_590F_63D0_96C5_9C9C_8840_5370_8BB0(context, x, y, cfg["伤害半径"])
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            do
                local dx = GetUnitX(heroes[i + 1]) - x
                local dy = GetUnitY(heroes[i + 1]) - y
                if dx * dx + dy * dy > cfg["伤害半径"] * cfg["伤害半径"] then
                    goto __continue13
                end
                local damage = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, heroes[i + 1], {["来源攻击力比例"] = cfg["伤害攻击力比例"], ["目标最大生命比例"] = cfg["伤害目标最大生命比例"]})
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = heroes[i + 1],
                    ["伤害"] = damage,
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_MAGIC,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能",
                    ["标签"] = tag
                })
            end
            ::__continue13::
            i = i + 1
        end
    end
end
____exports["释放夏提雅净化投枪"] = function(context, target)
    local boss = context["Boss单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(target) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    _____64AD_653E_590F_63D0_96C5_53F0_8BCD(boss, "净化投枪")
    local cfg = _____590F_63D0_96C5_6570_503C_4E0E_8868_73B0_914D_7F6E["净化投枪"]
    local x = GetUnitX(target)
    local y = GetUnitY(target)
    local isP3 = context["阶段"] == "P3真祖血宴"
    local ____isP3_5
    if isP3 then
        ____isP3_5 = _____83B7_53D6Boss_6280_80FD_968F_673A_654C_5BF9_82F1_96C4(boss, nil, nil, {target})
    else
        ____isP3_5 = nil
    end
    local secondTarget = ____isP3_5
    local secondX = _____5355_4F4D_6709_6548(secondTarget) and GetUnitX(secondTarget) or x
    local secondY = _____5355_4F4D_6709_6548(secondTarget) and GetUnitY(secondTarget) or y
    local totalDuration = cfg["预警秒"] + (isP3 and cfg["P3第二枚投枪延迟秒"] or 0)
    context["上次净化投枪目标ID"] = GetHandleId(target)
    _____91CD_7F6E_590F_63D0_96C5_730E_8840_8FDE_51FB(context)
    context["普通机制忙碌到Ms"] = getServerTime() + (totalDuration + 0.4) * 1000
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = boss, ["动画编号"] = cfg["动画编号"], ["持续秒"] = totalDuration, ["恢复动画编号"] = 0})
    _____521B_5EFA_70B9_540D_9884_8B66_6267_884C_5668({
        ["清理"] = context["清理"],
        ["名称"] = "夏提雅-净化投枪",
        ["锁定X"] = x,
        ["锁定Y"] = y,
        ["延迟秒"] = cfg["预警秒"],
        ["提示圈"] = {["类型"] = "敌方圆形", ["半径"] = cfg["伤害半径"], ["持续时间"] = cfg["预警秒"], ["来源单位"] = boss},
        ["on结算"] = function(result)
            if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] then
                return
            end
            _____7ED3_7B97_51C0_5316_6295_67AA_843D_70B9(context, result["锁定X"], result["锁定Y"], "夏提雅·净化投枪")
            if not isP3 then
                _____5C1D_8BD5_5B89_6392_51C0_5316_6295_67AA_82F1_7075_590D_523B(context, result["锁定X"], result["锁定Y"])
            end
        end
    })
    if isP3 then
        _____521B_5EFA_70B9_540D_9884_8B66_6267_884C_5668({
            ["清理"] = context["清理"],
            ["名称"] = "夏提雅-净化投枪-P3第二枚",
            ["锁定X"] = secondX,
            ["锁定Y"] = secondY,
            ["延迟秒"] = totalDuration,
            ["提示圈"] = {["类型"] = "敌方圆形", ["半径"] = cfg["伤害半径"], ["持续时间"] = totalDuration, ["来源单位"] = boss},
            ["on结算"] = function(result)
                if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["阶段"] ~= "P3真祖血宴" then
                    return
                end
                _____7ED3_7B97_51C0_5316_6295_67AA_843D_70B9(context, result["锁定X"], result["锁定Y"], "夏提雅·净化投枪-P3第二枚")
            end
        })
    end
    return true
end
____exports["净化投枪技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = false,
    ["语义"] = "苍白金神圣投枪延迟落下；落点覆盖血印时摧毁血印，P3改为两枚提前锁定落点并先后结算。"
}
return ____exports
