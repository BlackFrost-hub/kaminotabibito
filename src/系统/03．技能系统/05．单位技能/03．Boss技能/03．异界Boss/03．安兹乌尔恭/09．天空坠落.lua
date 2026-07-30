--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹模型动画配置"]
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.12．台词播放")
local _____64AD_653E_5B89_5179_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放安兹台词"]
local ____04_FF0E_5706_5F62_5B89_5168_533A_7EC4 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.02．战斗区域.04．圆形安全区组")
local _____521B_5EFA_5706_5F62_5B89_5168_533A_7EC4 = ____04_FF0E_5706_5F62_5B89_5168_533A_7EC4["创建圆形安全区组"]
local ____05_FF0E_9ED1_7FFC_62D8_675F = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．护卫雅儿贝德.05．黑翼拘束")
local _____542F_52A8_96C5_513F_8D1D_5FB7_5929_7A7A_5760_843D_8054_52A8 = ____05_FF0E_9ED1_7FFC_62D8_675F["启动雅儿贝德天空坠落联动"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.21．组合技能伤害")
local _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3 = ____require_result_0["计算组合技能伤害"]
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.13．施法时间线")
local _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF = ____require_result_1["启动基础施法时间线"]
local ____require_result_2 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_2["获取Boss技能敌对英雄列表"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成AOE技能伤害"]
local ____require_result_4 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_4.addDelayedCallback
local getServerTime = ____require_result_4.getServerTime
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_5.YDWETimerDestroyEffectSafe
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetRandomReal = jass.GetRandomReal
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local Cos = jass.Cos
local Sin = jass.Sin
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
local DEG_TO_RAD = 0.017453292519943295
local _____5929_7A7A_5760_843D_5927_578B_6280_80FDKey = "天空坠落"
local function _____9500_6BC1_5929_7A7A_5760_843D_9884_8B66_8868_73B0(instance)
    if instance["表现已清理"] then
        return
    end
    instance["表现已清理"] = true
    if instance["法阵特效"] ~= nil and instance["法阵特效"] ~= 0 then
        DestroyEffect(instance["法阵特效"])
        instance["法阵特效"] = 0
    end
    do
        local i = 0
        while i < #instance["墓碑特效列表"] do
            local effect = instance["墓碑特效列表"][i + 1]
            if effect ~= nil and effect ~= 0 then
                DestroyEffect(effect)
            end
            i = i + 1
        end
    end
    instance["墓碑特效列表"] = {}
    local ____self_6 = instance["安全区组"]
    ____self_6["销毁"](____self_6)
end
local function _____521B_5EFA_5929_7A7A_5760_843D_9884_8B66(context, castSeconds)
    local boss = context["安兹单位"]
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local stage = cfg["阶段技能"]
    local originX = GetUnitX(boss)
    local originY = GetUnitY(boss)
    local safeZones = {}
    local graves = {}
    do
        local i = 0
        while i < stage["天空坠落安全区数量"] do
            local angle = (30 + i * 120) * DEG_TO_RAD
            local cos = Cos(angle)
            local sin = Sin(angle)
            local graveX = originX + cos * stage["天空坠落墓碑距离"]
            local graveY = originY + sin * stage["天空坠落墓碑距离"]
            local safeX = originX + cos * stage["天空坠落安全区中心距离"]
            local safeY = originY + sin * stage["天空坠落安全区中心距离"]
            local grave = AddSpecialEffect(cfg["表现资源"]["天空坠落墓碑特效路径"], graveX, graveY)
            if grave ~= nil and grave ~= 0 then
                EXSetEffectSize(grave, stage["天空坠落墓碑缩放"])
                graves[#graves + 1] = grave
            end
            safeZones[#safeZones + 1] = {
                ID = "天空坠落墓碑阴影" .. tostring(i + 1),
                X = safeX,
                Y = safeY,
                ["半径"] = stage["天空坠落安全区半径"],
                ["名称"] = "墓碑阴影"
            }
            i = i + 1
        end
    end
    local safeZoneGroup = _____521B_5EFA_5706_5F62_5B89_5168_533A_7EC4({
        ["清理"] = context["清理"],
        ["名称"] = "安兹·天空坠落安全区",
        ["安全区列表"] = safeZones,
        ["默认显示提示"] = true,
        ["提示持续秒"] = castSeconds
    })
    local circle = AddSpecialEffect(cfg["表现资源"]["天空坠落天空法阵特效路径"], originX, originY)
    if circle ~= nil and circle ~= 0 then
        EXSetEffectZ(circle, stage["天空坠落法阵高度"])
        EXSetEffectSize(circle, stage["天空坠落法阵缩放"])
    end
    local instance = {["安全区组"] = safeZoneGroup, ["法阵特效"] = circle, ["墓碑特效列表"] = graves, ["表现已清理"] = false}
    local ____self_7 = context["清理"]
    ____self_7["登记清理"](
        ____self_7,
        "安兹-天空坠落预警表现",
        function()
            _____9500_6BC1_5929_7A7A_5760_843D_9884_8B66_8868_73B0(instance)
        end
    )
    return instance
end
local function _____7ED3_7B97_5929_7A7A_5760_843D_5355_6B21_4F24_5BB3(damageContext, attackRatio, maxLifeRatio, tag)
    local context = damageContext["运行时"]
    local boss = context["安兹单位"]
    local ____temp_9 = not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"]
    if not ____temp_9 then
        local ____self_8 = context["清理"]
        ____temp_9 = ____self_8["已清理"](____self_8)
    end
    if ____temp_9 then
        return
    end
    do
        local i = 0
        while i < #damageContext["目标列表"] do
            do
                local target = damageContext["目标列表"][i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue17
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = boss,
                    ["目标"] = target,
                    ["伤害"] = _____8BA1_7B97_7EC4_5408_6280_80FD_4F24_5BB3(boss, target, {["来源攻击力比例"] = attackRatio, ["目标最大生命比例"] = maxLifeRatio}),
                    attack = false,
                    ranged = true,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                    weaponType = WEAPON_TYPE_WHOKNOWS,
                    ["来源类型"] = "Boss技能",
                    ["标签"] = tag
                })
            end
            ::__continue17::
            i = i + 1
        end
    end
end
local function _____542F_52A8_5929_7A7A_5760_843D_7ED3_7B97(context, instance)
    local boss = context["安兹单位"]
    local ____temp_11 = not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"]
    if not ____temp_11 then
        local ____self_10 = context["清理"]
        ____temp_11 = ____self_10["已清理"](____self_10)
    end
    if ____temp_11 then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local stage = cfg["阶段技能"]
    local x = GetUnitX(boss)
    local y = GetUnitY(boss)
    local targets = {}
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(boss)
    do
        local i = 0
        while i < #heroes do
            local target = heroes[i + 1]
            local ____5355_4F4D_6709_6548_result_13 = _____5355_4F4D_6709_6548(target)
            if ____5355_4F4D_6709_6548_result_13 then
                local ____self_12 = instance["安全区组"]
                ____5355_4F4D_6709_6548_result_13 = not ____self_12["单位是否安全"](____self_12, target)
            end
            if ____5355_4F4D_6709_6548_result_13 then
                targets[#targets + 1] = target
            end
            i = i + 1
        end
    end
    local damageContext = {["运行时"] = context, ["目标列表"] = targets}
    local laser = AddSpecialEffect(cfg["表现资源"]["天空坠落光柱特效路径"], x, y)
    local impact = AddSpecialEffect(cfg["表现资源"]["天空坠落冲击特效路径"], x, y)
    if laser ~= nil and laser ~= 0 then
        EXSetEffectSize(laser, stage["天空坠落光柱特效缩放"])
        YDWETimerDestroyEffectSafe(stage["天空坠落冲击特效持续秒"], laser)
    end
    if impact ~= nil and impact ~= 0 then
        EXSetEffectSize(impact, stage["天空坠落冲击特效缩放"])
        EXSetEffectZ(impact, stage["天空坠落冲击特效高度"])
        YDWETimerDestroyEffectSafe(stage["天空坠落冲击特效持续秒"], impact)
    end
    _____9500_6BC1_5929_7A7A_5760_843D_9884_8B66_8868_73B0(instance)
    local landingId = addDelayedCallback(
        (stage["天空坠落落地延迟秒"] + stage["天空坠落主冲击额外延迟秒"]) * 1000,
        function()
            local ____temp_15 = not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"]
            if not ____temp_15 then
                local ____self_14 = context["清理"]
                ____temp_15 = ____self_14["已清理"](____self_14)
            end
            if ____temp_15 then
                return
            end
            _____64AD_653EBoss_5750_6807_97F3_6548(cfg["音效"]["天空坠落贯穿"], x, y, cfg["音效默认裁断距离"])
            _____7ED3_7B97_5929_7A7A_5760_843D_5355_6B21_4F24_5BB3(damageContext, stage["天空坠落主伤害Boss攻击力比例"], stage["天空坠落主伤害目标最大生命比例"], "安兹·天空坠落主冲击")
        end
    )
    local ____self_16 = context["清理"]
    ____self_16["登记延迟回调"](____self_16, "安兹-天空坠落主冲击", landingId)
    do
        local waveIndex = 1
        while waveIndex <= stage["天空坠落余波次数"] do
            local currentWave = waveIndex
            local delayMs = (stage["天空坠落落地延迟秒"] + currentWave * stage["天空坠落余波间隔秒"]) * 1000
            local waveId = addDelayedCallback(
                delayMs,
                function()
                    _____7ED3_7B97_5929_7A7A_5760_843D_5355_6B21_4F24_5BB3(
                        damageContext,
                        stage["天空坠落余波伤害Boss攻击力比例"],
                        stage["天空坠落余波伤害目标最大生命比例"],
                        "安兹·天空坠落余波" .. tostring(currentWave)
                    )
                end
            )
            local ____self_17 = context["清理"]
            ____self_17["登记延迟回调"](
                ____self_17,
                "安兹-天空坠落余波" .. tostring(currentWave),
                waveId
            )
            waveIndex = waveIndex + 1
        end
    end
end
____exports["释放安兹天空坠落"] = function(context)
    local boss = context["安兹单位"]
    if not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["天空坠落已释放"] or context["当前大型技能"] ~= nil then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["阶段技能"]
    local castSeconds = GetRandomReal(cfg["天空坠落施法最小秒"], cfg["天空坠落施法最大秒"])
    local recoverySeconds = GetRandomReal(cfg["天空坠落回落最小秒"], cfg["天空坠落回落最大秒"])
    context["天空坠落已释放"] = true
    context["当前大型技能"] = _____5929_7A7A_5760_843D_5927_578B_6280_80FDKey
    _____64AD_653E_5B89_5179_53F0_8BCD(boss, "天空坠落")
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["天空坠落聚能"],
        GetUnitX(boss),
        GetUnitY(boss),
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    local instance = _____521B_5EFA_5929_7A7A_5760_843D_9884_8B66(context, castSeconds)
    if context["模式"] == "守护者介入" then
        _____542F_52A8_96C5_513F_8D1D_5FB7_5929_7A7A_5760_843D_8054_52A8(context, castSeconds)
    end
    _____542F_52A8_57FA_7840_65BD_6CD5_65F6_95F4_7EBF({
        ["施法者"] = boss,
        ["硬直秒"] = castSeconds,
        ["动画编号"] = cfg["天空坠落动画编号"],
        ["动画速度"] = cfg["天空坠落动画速度"],
        ["恢复动画编号"] = _____5B89_5179_6A21_578B_52A8_753B_914D_7F6E["待机编号"],
        ["吟唱条"] = {
            ["通道"] = "大招",
            ["总时长"] = castSeconds,
            ["颜色ID"] = 3,
            ["标题文本"] = "超位魔法·天空坠落",
            ["提示文本"] = "进入墓碑背后的白色安全区"
        },
        ["on生效"] = function()
            _____542F_52A8_5929_7A7A_5760_843D_7ED3_7B97(context, instance)
            local recoveryId = addDelayedCallback(
                recoverySeconds * 1000,
                function()
                    if context["当前大型技能"] == _____5929_7A7A_5760_843D_5927_578B_6280_80FDKey then
                        context["当前大型技能"] = nil
                        context["上次大型技能结束Ms"] = getServerTime()
                    end
                end
            )
            local ____self_18 = context["清理"]
            ____self_18["登记延迟回调"](____self_18, "安兹-天空坠落输出窗口", recoveryId)
        end
    })
    return true
end
____exports["天空坠落技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["类型"] = "超位魔法阶段技",
    ["语义"] = "高空白金法阵蓄势，玩家进入墓碑阴影规避贯穿场地的致命光柱。",
    ["实现要求"] = "破解后必须保留稳定输出窗口，禁止护盾、时间停止和护卫拦截立即覆盖。"
}
return ____exports
