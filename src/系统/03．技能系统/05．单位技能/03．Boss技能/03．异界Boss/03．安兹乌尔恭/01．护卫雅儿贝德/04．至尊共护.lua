--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["执行非伤害生命移除"]
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.07．护盾.07．护盾系统")
local _____5F00_59CB_62A4_76FE = ____require_result_0["开始护盾"]
local ____require_result_1 = require("lib.扩展函数.YDWE函数.09．YDUserData安全版")
local YDWETimerDestroyEffectSafe = ____require_result_1.YDWETimerDestroyEffectSafe
local ____require_result_2 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_2.getServerTime
local addDelayedCallback = ____require_result_2.addDelayedCallback
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local AddSpecialEffect = jass.AddSpecialEffect
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
____exports["启动雅儿贝德至尊共护"] = function(context, largeSkillSeconds)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    local boss = context["安兹单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(boss) or state["阶段状态"] == "失衡" then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E
    local guardState = state
    local total = GetUnitState(albedo, UNIT_STATE_LIFE) * cfg["守护者模式"]["至尊共护护盾当前生命比例"]
    if not (total > 0) then
        return false
    end
    guardState["共同护盾生效"] = true
    guardState["守护连接生效"] = false
    local ____opt_5 = guardState["独占状态"]
    if ____opt_5 ~= nil then
        ____opt_5["取消当前"](____opt_5, "抢占", "雅儿贝德-至尊共护")
    end
    local brokenCount = 0
    local fullBreakTriggered = false
    local function onShieldBreak(unit)
        brokenCount = brokenCount + 1
        local effect = AddSpecialEffect(
            cfg["表现资源"]["雅儿贝德共同护盾破碎特效路径"],
            GetUnitX(unit),
            GetUnitY(unit)
        )
        if effect ~= nil and effect ~= 0 then
            YDWETimerDestroyEffectSafe(1.2, effect)
        end
        if brokenCount < 2 or fullBreakTriggered then
            return
        end
        fullBreakTriggered = true
        guardState["共同护盾生效"] = false
        _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
            ["目标"] = albedo,
            ["数值"] = GetUnitState(albedo, UNIT_STATE_MAX_LIFE) * cfg["守护者模式"]["至尊共护破碎生命代价比例"],
            ["最低生命"] = GetUnitState(albedo, UNIT_STATE_MAX_LIFE) * cfg["守护者模式"]["雅儿贝德锁血比例"],
            ["显示文字"] = true
        })
        guardState["阶段状态"] = "失衡"
        guardState["失衡结束Ms"] = getServerTime() + cfg["守护者模式"]["至尊共护破碎失衡秒"] * 1000
        local ____opt_7 = guardState["成员生命周期"]
        if ____opt_7 ~= nil then
            ____opt_7["设置状态"](____opt_7, "雅儿贝德", "失衡", "至尊共护完全破碎")
        end
    end
    local duration = largeSkillSeconds + cfg["守护者模式"]["至尊共护自然结束延迟秒"]
    local bossEffect = AddSpecialEffectTarget(cfg["表现资源"]["雅儿贝德共同护盾特效路径"], boss, "origin")
    local albedoEffect = AddSpecialEffectTarget(cfg["表现资源"]["雅儿贝德共同护盾特效路径"], albedo, "origin")
    if bossEffect ~= nil and bossEffect ~= 0 then
        YDWETimerDestroyEffectSafe(duration, bossEffect)
    end
    if albedoEffect ~= nil and albedoEffect ~= 0 then
        YDWETimerDestroyEffectSafe(duration, albedoEffect)
    end
    _____5F00_59CB_62A4_76FE(boss, {
        ["数值"] = total * cfg["守护者模式"]["至尊共护安兹分配比例"],
        ["持续时间"] = duration,
        ["来源单位"] = albedo,
        ["显示护盾条"] = true,
        ["可驱散"] = false,
        ["标签"] = "雅儿贝德-至尊共护-安兹",
        ["破碎回调"] = onShieldBreak
    })
    _____5F00_59CB_62A4_76FE(albedo, {
        ["数值"] = total * cfg["守护者模式"]["至尊共护雅儿贝德分配比例"],
        ["持续时间"] = duration,
        ["来源单位"] = albedo,
        ["显示护盾条"] = true,
        ["可驱散"] = false,
        ["标签"] = "雅儿贝德-至尊共护-自身",
        ["破碎回调"] = onShieldBreak
    })
    local clearId = addDelayedCallback(
        duration * 1000,
        function()
            guardState["共同护盾生效"] = false
        end
    )
    local ____self_9 = context["清理"]
    ____self_9["登记延迟回调"](____self_9, "雅儿贝德-至尊共护自然结束", clearId)
    return true
end
____exports["至尊共护技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "联合护盾",
    ["语义"] = "雅儿贝德在关键施法时回到安兹身边，按当前生命生成共同护盾并分配给双方。"
}
return ____exports
