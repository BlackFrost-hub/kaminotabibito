--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____5355_4F4D_6709_6548 = ____19_FF0E_6218_6597_516C_5171_5DE5_5177["单位未标记死亡"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.01．运行时上下文")
local _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部安兹运行时上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.03．异界Boss.03．安兹乌尔恭.02．数值与表现配置")
local _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["安兹乌尔恭数值与表现配置"]
local ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.09．非伤害生命移除")
local _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664 = ____09_FF0E_975E_4F24_5BB3_751F_547D_79FB_9664["执行非伤害生命移除"]
local ____require_result_0 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_0.registerDamageModifier
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local addPeriodicCallback = ____require_result_1.addPeriodicCallback
local removePeriodicCallback = ____require_result_1.removePeriodicCallback
local getServerTime = ____require_result_1.getServerTime
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local IsUnitType = jass.IsUnitType
local AddSpecialEffect = jass.AddSpecialEffect
local DestroyEffect = jass.DestroyEffect
local Atan2 = jass.Atan2
local SquareRoot = jass.SquareRoot
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local EXSetEffectXY = japi.EXSetEffectXY
local EXSetEffectZ = japi.EXSetEffectZ
local EXSetEffectSize = japi.EXSetEffectSize
local EXEffectMatRotateZ = japi.EXEffectMatRotateZ
local RAD_TO_DEG = 57.29577951308232
local _____5B88_62A4_804C_8D23_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = false
local function _____662F_5426_76F4_63A5_4F24_5BB3(damage)
    if not _____5355_4F4D_6709_6548(damage.attacker) or damage.attacker == damage.target then
        return false
    end
    if damage.isNormalAttack ~= true and damage.isSkillAttack ~= true and damage.isSkillDamage ~= true then
        return false
    end
    local tag = damage.skillDamageTag
    if type(tag) == "string" and ((string.find(tag, "DOT", nil, true) or 0) - 1 >= 0 or (string.find(tag, "反伤", nil, true) or 0) - 1 >= 0 or (string.find(tag, "环境", nil, true) or 0) - 1 >= 0) then
        return false
    end
    return true
end
local function _____5B88_62A4_804C_8D23_4F24_5BB3_5171_4EAB_4FEE_6B63(damage)
    if not (damage.currentDamage > 0) or not _____662F_5426_76F4_63A5_4F24_5BB3(damage) then
        return damage.currentDamage
    end
    local contexts = _____83B7_53D6_5168_90E8_5B89_5179_8FD0_884C_65F6_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #contexts do
            do
                local context = contexts[i + 1]
                local state = context["雅儿贝德"]
                local albedo = state and state["单位"]
                if state == nil or not state["守护连接生效"] or not _____5355_4F4D_6709_6548(albedo) then
                    goto __continue9
                end
                local other = nil
                if damage.target == context["安兹单位"] then
                    other = albedo
                elseif damage.target == albedo then
                    other = context["安兹单位"]
                end
                if not _____5355_4F4D_6709_6548(other) then
                    goto __continue9
                end
                local share = damage.currentDamage * _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]["守护者之职责共享比例"]
                local minimumLife = other == albedo and GetUnitStateJapi(albedo, UNIT_STATE_MAX_LIFE) * _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]["雅儿贝德锁血比例"] or 1
                _____6267_884C_975E_4F24_5BB3_751F_547D_79FB_9664({
                    ["目标"] = other,
                    ["数值"] = share,
                    ["最低生命"] = minimumLife,
                    ["显示文字"] = true,
                    ["显示特效"] = false
                })
                return damage.currentDamage - share
            end
            ::__continue9::
            i = i + 1
        end
    end
    return damage.currentDamage
end
local function _____786E_4FDD_5B88_62A4_804C_8D23_4F24_5BB3_4FEE_6B63()
    if _____5B88_62A4_804C_8D23_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C then
        return
    end
    _____5B88_62A4_804C_8D23_4F24_5BB3_4FEE_6B63_5DF2_6CE8_518C = true
    registerDamageModifier(_____5B88_62A4_804C_8D23_4F24_5BB3_5171_4EAB_4FEE_6B63, 45)
end
local function _____5237_65B0_5B88_62A4_804C_8D23_8FDE_63A5_8868_73B0(visual)
    if visual["已结束"] then
        return
    end
    local boss = visual.context["安兹单位"]
    local ____opt_4 = visual.context["雅儿贝德"]
    local albedo = ____opt_4 and ____opt_4["单位"]
    if not _____5355_4F4D_6709_6548(boss) or not _____5355_4F4D_6709_6548(albedo) then
        return
    end
    local ax = GetUnitX(boss)
    local ay = GetUnitY(boss)
    local bx = GetUnitX(albedo)
    local by = GetUnitY(albedo)
    local dx = bx - ax
    local dy = by - ay
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    if visual["特效"] == nil or visual["特效"] == 0 then
        return
    end
    EXSetEffectXY(visual["特效"], (ax + bx) * 0.5, (ay + by) * 0.5)
    EXSetEffectZ(visual["特效"], cfg["守护者之职责连接高度"])
    EXEffectMatRotateZ(
        visual["特效"],
        Atan2(dy, dx) * RAD_TO_DEG
    )
    EXSetEffectSize(
        visual["特效"],
        SquareRoot(dx * dx + dy * dy) / cfg["守护者之职责连接基础长度"] * cfg["守护者之职责连接缩放倍率"]
    )
end
local function _____6E05_7406_5B88_62A4_804C_8D23_8868_73B0(visual)
    if visual["已结束"] then
        return
    end
    visual["已结束"] = true
    visual.context["雅儿贝德"]["守护连接生效"] = false
    if visual["刷新ID"] ~= 0 then
        removePeriodicCallback(visual["刷新ID"])
    end
    if visual["特效"] ~= nil and visual["特效"] ~= 0 then
        DestroyEffect(visual["特效"])
    end
end
____exports["释放雅儿贝德守护者之职责"] = function(context)
    local state = context["雅儿贝德"]
    local albedo = state and state["单位"]
    local boss = context["安兹单位"]
    if state == nil or not _____5355_4F4D_6709_6548(albedo) or not _____5355_4F4D_6709_6548(boss) or context["挑战已结束"] or context["当前大型技能"] ~= nil then
        return false
    end
    local cfg = _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["守护者模式"]
    if state["阶段状态"] == "失衡" or state["阶段状态"] == "已离场" or state["当前生命比例"] < cfg["守护者之职责最低生命比例"] then
        return false
    end
    local now = getServerTime()
    if now < state["上次守护职责Ms"] + cfg["守护者之职责冷却秒"] * 1000 then
        return false
    end
    local dx = GetUnitX(albedo) - GetUnitX(boss)
    local dy = GetUnitY(albedo) - GetUnitY(boss)
    if dx * dx + dy * dy > cfg["守护者之职责断裂距离"] * cfg["守护者之职责断裂距离"] then
        return false
    end
    local visual
    local ____opt_8 = state["独占状态"]
    local token = ____opt_8 and ____opt_8["开始"](
        ____opt_8,
        {
            key = "雅儿贝德-守护者之职责",
            ["优先级"] = 10,
            ["持续毫秒"] = (cfg["守护者之职责预连接秒"] + cfg["守护者之职责持续秒"]) * 1000,
            ["可被抢占"] = true,
            ["on结束"] = function()
                if visual ~= nil then
                    _____6E05_7406_5B88_62A4_804C_8D23_8868_73B0(visual)
                end
            end
        }
    ) or 0
    if token == 0 then
        return false
    end
    state["上次守护职责Ms"] = now
    local effect = AddSpecialEffect(
        _____5B89_5179_4E4C_5C14_606D_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["雅儿贝德守护连接特效路径"],
        (GetUnitX(boss) + GetUnitX(albedo)) * 0.5,
        (GetUnitY(boss) + GetUnitY(albedo)) * 0.5
    )
    visual = {
        context = context,
        token = token,
        ["特效"] = effect,
        ["刷新ID"] = 0,
        ["已结束"] = false
    }
    _____5237_65B0_5B88_62A4_804C_8D23_8FDE_63A5_8868_73B0(visual)
    visual["刷新ID"] = addPeriodicCallback(
        cfg["守护者之职责连接刷新间隔毫秒"],
        function()
            if context["当前大型技能"] ~= nil or state["阶段状态"] == "失衡" then
                local ____opt_10 = state["独占状态"]
                if ____opt_10 ~= nil then
                    ____opt_10["结束"](____opt_10, token, "抢占", context["当前大型技能"] or "雅儿贝德失衡")
                end
                return
            end
            local distanceX = GetUnitX(albedo) - GetUnitX(boss)
            local distanceY = GetUnitY(albedo) - GetUnitY(boss)
            if distanceX * distanceX + distanceY * distanceY > cfg["守护者之职责断裂距离"] * cfg["守护者之职责断裂距离"] then
                local ____opt_12 = state["独占状态"]
                if ____opt_12 ~= nil then
                    ____opt_12["结束"](____opt_12, token, "取消", "双方距离过远")
                end
                return
            end
            _____5237_65B0_5B88_62A4_804C_8D23_8FDE_63A5_8868_73B0(visual)
        end
    )
    local activeId = addDelayedCallback(
        cfg["守护者之职责预连接秒"] * 1000,
        function()
            local ____opt_16 = state["独占状态"]
            local ____opt_14 = ____opt_16 and ____opt_16["取当前"](____opt_16)
            if (____opt_14 and ____opt_14.token) == token then
                state["守护连接生效"] = true
            end
        end
    )
    local ____self_18 = context["清理"]
    ____self_18["登记延迟回调"](____self_18, "雅儿贝德-守护职责预连接", activeId)
    local ____self_19 = context["清理"]
    ____self_19["登记清理"](
        ____self_19,
        "雅儿贝德-守护职责表现",
        function()
            _____6E05_7406_5B88_62A4_804C_8D23_8868_73B0(visual)
        end
    )
    return true
end
____exports["注册雅儿贝德守护者之职责"] = function()
    _____786E_4FDD_5B88_62A4_804C_8D23_4F24_5BB3_4FEE_6B63()
end
____exports["守护者之职责技能状态"] = {
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["类型"] = "独占伤害共享状态",
    ["语义"] = "一秒预连接后，安兹与雅儿贝德短时按比例共享直接伤害。",
    ["实现要求"] = "转移伤害不得再次触发吸血、反伤、受击效果或二次转移；与其他主动技能互斥。"
}
return ____exports
