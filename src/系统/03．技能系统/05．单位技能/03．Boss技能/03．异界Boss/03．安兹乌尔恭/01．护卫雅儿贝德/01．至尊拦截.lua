--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部安兹运行时上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local _____51FB_9000_7CFB_7EDF = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.击退系统")
local _____5F00_59CB_51B2_950B = _____51FB_9000_7CFB_7EDF["开始冲锋"]
local _____5F00_59CB_51FB_9000 = _____51FB_9000_7CFB_7EDF["开始击退"]
local ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.00．单位动画等待")
local _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B = ____00_FF0E_5355_4F4D_52A8_753B_7B49_5F85["播放限时单位动画"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.16．技能提示圈工厂")
local _____521B_5EFA_6280_80FD_63D0_793A_5708 = ____require_result_0["创建技能提示圈"]
local ____require_result_1 = require("系统.01．单位系统.06．仇恨系统.05．技能目标选择")
local _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868 = ____require_result_1["获取Boss技能敌对英雄列表"]
local ____require_result_2 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_2["读取单位攻击力"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210AOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成AOE技能伤害"]
local ____require_result_4 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_4.registerAppliedFinalDamageListener
local ____require_result_5 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_5.YDWETimerDestroyEffectSafe
local ____require_result_6 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_6.addDelayedCallback
local getServerTime = ____require_result_6.getServerTime
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local SquareRoot = jass.SquareRoot
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_METAL_HEAVY_SLICE = jass.WEAPON_TYPE_METAL_HEAVY_SLICE
local RAD_TO_DEG = 57.29577951308232
local _____81F3_5C0A_62E6_622A_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = false
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____7ED3_7B97_81F3_5C0A_62E6_622A(context, x, y)
    local ____opt_7 = context["雅儿贝德"]
    local albedo = ____opt_7 and ____opt_7["单位"]
    if not _____5355_4F4D_6709_6548(albedo) or context["挑战已结束"] then
        return
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local effect = AddSpecialEffect(cfg["表现资源"]["雅儿贝德重击特效路径"], x, y)
    if effect ~= nil and effect ~= 0 then
        YDWETimerDestroyEffectSafe(cfg["守护者模式"]["黑翼横扫特效持续秒"], effect)
    end
    local heroes = _____83B7_53D6Boss_6280_80FD_654C_5BF9_82F1_96C4_5217_8868(context["安兹单位"])
    local radius = cfg["守护者模式"]["至尊拦截结算半径"]
    do
        local i = 0
        while i < #heroes do
            do
                local target = heroes[i + 1]
                if not _____5355_4F4D_6709_6548(target) then
                    goto __continue7
                end
                local dx = GetUnitX(target) - x
                local dy = GetUnitY(target) - y
                if dx * dx + dy * dy > radius * radius then
                    goto __continue7
                end
                _____9020_6210AOE_6280_80FD_4F24_5BB3({
                    ["来源"] = albedo,
                    ["目标"] = target,
                    ["伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(albedo) * cfg["守护者模式"]["至尊拦截伤害攻击力比例"] + GetUnitState(target, UNIT_STATE_MAX_LIFE) * cfg["守护者模式"]["至尊拦截伤害目标最大生命比例"],
                    attack = false,
                    ranged = false,
                    attackType = ATTACK_TYPE_NORMAL,
                    ["伤害类型"] = DAMAGE_TYPE_NORMAL,
                    weaponType = WEAPON_TYPE_METAL_HEAVY_SLICE,
                    ["来源类型"] = "Boss技能",
                    ["标签"] = "雅儿贝德·至尊拦截"
                })
                _____5F00_59CB_51FB_9000(target, {
                    ["来源单位"] = albedo,
                    ["距离"] = cfg["守护者模式"]["至尊拦截击退距离"],
                    ["持续时间"] = cfg["守护者模式"]["至尊拦截击退秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true
                })
            end
            ::__continue7::
            i = i + 1
        end
    end
end
____exports["释放雅儿贝德至尊拦截"] = function(context, attacker)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    local boss = context["安兹单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(attacker) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    if state["阶段状态"] == "失衡" or state["阶段状态"] == "已离场" then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    local now = getServerTime()
    if now < state["上次至尊拦截Ms"] + cfg["至尊拦截冷却秒"] * 1000 then
        return false
    end
    local angleRadians = Atan2(
        GetUnitY(attacker) - GetUnitY(boss),
        GetUnitX(attacker) - GetUnitX(boss)
    )
    local endX = GetUnitX(boss) + Cos(angleRadians) * cfg["至尊拦截落点距安兹"]
    local endY = GetUnitY(boss) + Sin(angleRadians) * cfg["至尊拦截落点距安兹"]
    local startX = GetUnitX(albedo)
    local startY = GetUnitY(albedo)
    local dx = endX - startX
    local dy = endY - startY
    local distance = SquareRoot(dx * dx + dy * dy)
    if distance <= 1 then
        return false
    end
    local ____opt_11 = state["独占状态"]
    local token = ____opt_11 and ____opt_11["开始"](____opt_11, {key = "雅儿贝德-至尊拦截", ["优先级"] = 50, ["持续毫秒"] = (cfg["至尊拦截预警秒"] + cfg["至尊拦截冲锋秒"] + 0.8) * 1000, ["可被抢占"] = false}) or 0
    if token == 0 then
        return false
    end
    state["守护连接生效"] = false
    state["上次至尊拦截Ms"] = now
    local facing = Atan2(dy, dx) * RAD_TO_DEG
    _____521B_5EFA_6280_80FD_63D0_793A_5708({
        ["类型"] = "方向直线",
        X = (startX + endX) * 0.5,
        Y = (startY + endY) * 0.5,
        ["宽度"] = cfg["至尊拦截路径宽度"],
        ["长度"] = distance,
        ["朝向"] = facing,
        ["持续时间"] = cfg["至尊拦截预警秒"],
        ["来源单位"] = albedo
    })
    _____64AD_653E_9650_65F6_5355_4F4D_52A8_753B({["单位"] = albedo, ["动画编号"] = cfg["至尊拦截动画编号"], ["持续秒"] = cfg["至尊拦截预警秒"] + cfg["至尊拦截冲锋秒"], ["恢复动画编号"] = 1})
    local delayedId = addDelayedCallback(
        cfg["至尊拦截预警秒"] * 1000,
        function()
            if not _____5355_4F4D_6709_6548(albedo) or context["挑战已结束"] then
                return
            end
            _____5F00_59CB_51B2_950B(
                albedo,
                {
                    ["目标X"] = endX,
                    ["目标Y"] = endY,
                    ["距离"] = distance,
                    ["持续时间"] = cfg["至尊拦截冲锋秒"],
                    ["检查地形"] = true,
                    ["暂停单位"] = true,
                    ["禁用碰撞"] = true,
                    ["结束回调"] = function()
                        _____7ED3_7B97_81F3_5C0A_62E6_622A(context, endX, endY)
                    end
                }
            )
        end
    )
    local ____self_13 = context["清理"]
    ____self_13["登记延迟回调"](____self_13, "雅儿贝德-至尊拦截预警", delayedId)
    return true
end
local function ____on_5B89_5179_627F_53D7_7206_53D1_4F24_5BB3(target, attacker, applied)
    if not (applied > 0) or not _____5355_4F4D_6709_6548(target) or not _____5355_4F4D_6709_6548(attacker) then
        return
    end
    local contexts = _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                if context["安兹单位"] ~= target or context["模式"] ~= "守护者介入" then
                    goto __continue22
                end
                local threshold = GetUnitState(target, UNIT_STATE_MAX_LIFE) * _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]["至尊拦截触发伤害最大生命比例"]
                if applied >= threshold then
                    ____exports["释放雅儿贝德至尊拦截"](context, attacker)
                end
                return
            end
            ::__continue22::
            i = i + 1
        end
    end
end
____exports["注册雅儿贝德至尊拦截"] = function()
    if _____81F3_5C0A_62E6_622A_4F24_5BB3_76D1_542C_5DF2_6CE8_518C then
        return
    end
    _____81F3_5C0A_62E6_622A_4F24_5BB3_76D1_542C_5DF2_6CE8_518C = true
    registerAppliedFinalDamageListener(____on_5B89_5179_627F_53D7_7206_53D1_4F24_5BB3)
end
____exports["至尊拦截技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["伤害形态"] = "AOE",
    ["包含战斗自身位移"] = true,
    ["语义"] = "安兹短时间受到高爆发时，雅儿贝德冲锋到威胁目标与安兹之间并击退目标。"
}
return ____exports
