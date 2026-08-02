--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.01．运行时上下文")
local _____83B7_53D6_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取祖地双灵卫运行时上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.02．数值与表现配置")
local _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["祖地双灵卫数值与表现配置"]
local ____05_FF0E_7956_5730_53CC_7075_536B = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.05．祖地双灵卫")
local _____7956_5730_53CC_7075_536BBuffID = ____05_FF0E_7956_5730_53CC_7075_536B["祖地双灵卫BuffID"]
local ____01_FF0E_6301_7EED_5355_4F4D_8FDE_7EBF = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.07．机制连线.01．持续单位连线")
local _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF = ____01_FF0E_6301_7EED_5355_4F4D_8FDE_7EBF["创建持续单位连线"]
local ____12_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.12．台词播放")
local _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放赤誓灵卫台词"]
local _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD = ____12_FF0E_53F0_8BCD_64AD_653E["播放苍影灵卫台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local ____17_FF0E_95EA_7535_6548_679C_4EE3_7801 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码")
local _____95EA_7535_6548_679C_4EE3_7801 = ____17_FF0E_95EA_7535_6548_679C_4EE3_7801["闪电效果代码"]
local ____20_FF0E_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.20．友军范围承伤转移")
local _____521B_5EFA_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB = ____20_FF0E_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB["创建友军范围承伤转移"]
local ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.11．条件伤害修正")
local _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63 = ____11_FF0E_6761_4EF6_4F24_5BB3_4FEE_6B63["创建条件伤害修正"]
local ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.22．Boss技能伤害执行器")
local _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3 = ____22_FF0EBoss_6280_80FD_4F24_5BB3_6267_884C_5668["提交预计算Boss单体技能伤害"]
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_1.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_1["移除单位指定Buff"]
local jass = require("jass.common")
local japi = require("jass.japi")
local GetUnitStateJapi = japi.GetUnitState
local GetUnitState = jass.GetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local AddSpecialEffectTarget = jass.AddSpecialEffectTarget
local DestroyEffect = jass.DestroyEffect
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____53CC_7075_540C_8A93_5DF2_6CE8_518C = false
local function _____505C_6B62_540C_8A93_8FDE_7EBF(_____8FDE_7EBF)
    if _____8FDE_7EBF ~= nil then
        _____8FDE_7EBF["停止"](_____8FDE_7EBF, "同誓保护关闭")
    end
end
local function _____751F_547D_6BD4_4F8B(unit)
    if unit == nil or unit == 0 then
        return 0
    end
    local maxLife = GetUnitStateJapi(unit, UNIT_STATE_MAX_LIFE)
    return maxLife > 0 and GetUnitState(unit, UNIT_STATE_LIFE) / maxLife or 0
end
local function _____53D6_540C_8A93_4F4E_8840_5355_4F4D(context)
    if context["低血保护守卫"] == "赤誓灵卫" then
        return context["赤誓灵卫单位"]
    end
    if context["低血保护守卫"] == "苍影灵卫" then
        return context["苍影灵卫单位"]
    end
    return nil
end
local function _____53D6_540C_8A93_9AD8_8840_5355_4F4D(context)
    if context["低血保护守卫"] == "赤誓灵卫" then
        return context["苍影灵卫单位"]
    end
    if context["低血保护守卫"] == "苍影灵卫" then
        return context["赤誓灵卫单位"]
    end
    return nil
end
local function _____786E_4FDD_540C_8A93_627F_4F24_8F6C_79FB(context)
    if context["同誓承伤转移"] ~= nil then
        return
    end
    context["同誓承伤转移"] = _____521B_5EFA_53CB_519B_8303_56F4_627F_4F24_8F6C_79FB({
        ["名称"] = "祖地双灵卫-双灵同誓",
        ["清理"] = context["清理"],
        ["优先级"] = -71,
        ["初始启用"] = false,
        ["排除真实伤害"] = false,
        ["获取转移比例"] = function()
            return _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["同誓高血分担比例"]
        end,
        ["获取候选单位列表"] = function(event)
            if event["受击者"] ~= _____53D6_540C_8A93_4F4E_8840_5355_4F4D(context) then
                return {}
            end
            local high = _____53D6_540C_8A93_9AD8_8840_5355_4F4D(context)
            return high ~= nil and high ~= 0 and ({high}) or ({})
        end,
        ["可承受者"] = function(event)
            local ____self_2 = context["联合生命周期"]
            local member = ____self_2["按单位取成员"](____self_2, event["候选单位"])
            return member ~= nil and member["状态"] ~= "崩解"
        end,
        ["过滤伤害"] = function(event)
            if context["战斗已结束"] or not context["同誓保护已启用"] then
                return false
            end
            local ____self_3 = context["联合生命周期"]
            local member = ____self_3["按单位取成员"](____self_3, event["受击者"])
            return member == nil or member["状态"] ~= "崩解"
        end,
        ["提交转移"] = function(event)
            local ____temp_4
            if event["攻击者"] ~= nil and event["攻击者"] ~= 0 then
                ____temp_4 = event["攻击者"]
            else
                ____temp_4 = event["受击者"]
            end
            local source = ____temp_4
            local result = _____63D0_4EA4_9884_8BA1_7B97Boss_5355_4F53_6280_80FD_4F24_5BB3({
                ["来源"] = source,
                ["目标"] = event["承受者"],
                ["伤害"] = event["计划转移伤害"],
                ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                attack = false,
                ranged = true,
                attackType = ATTACK_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "Boss技能",
                ["标签"] = "祖地双灵卫-双灵同誓-承伤转移",
                ["参与技能伤害加成"] = false,
                isDamageTransfer = true
            })
            return result["是否造成伤害"] and result["伤害"] or 0
        end
    })
end
local function _____5173_95ED_540C_8A93_4FDD_62A4(context)
    local ____temp_6
    if context["低血保护守卫"] == "赤誓灵卫" then
        ____temp_6 = context["赤誓灵卫单位"]
    else
        local ____temp_5
        if context["低血保护守卫"] == "苍影灵卫" then
            ____temp_5 = context["苍影灵卫单位"]
        else
            ____temp_5 = nil
        end
        ____temp_6 = ____temp_5
    end
    local previousLow = ____temp_6
    context["同誓保护已启用"] = false
    local ____opt_7 = context["同誓承伤转移"]
    if ____opt_7 ~= nil then
        ____opt_7["设置启用"](____opt_7, false)
    end
    context["低血保护守卫"] = nil
    if context["同誓保护特效"] ~= nil and context["同誓保护特效"] ~= 0 then
        DestroyEffect(context["同誓保护特效"])
    end
    context["同誓保护特效"] = nil
    _____505C_6B62_540C_8A93_8FDE_7EBF(context["同誓暗金连线"])
    _____505C_6B62_540C_8A93_8FDE_7EBF(context["同誓冷蓝连线"])
    context["同誓暗金连线"] = nil
    context["同誓冷蓝连线"] = nil
    if previousLow ~= nil and previousLow ~= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(previousLow, _____7956_5730_53CC_7075_536BBuffID["双灵同誓"])
    end
end
local function _____5F00_542F_540C_8A93_4FDD_62A4(context, lowName)
    local ____temp_9
    if lowName == "赤誓灵卫" then
        ____temp_9 = context["赤誓灵卫单位"]
    else
        ____temp_9 = context["苍影灵卫单位"]
    end
    local low = ____temp_9
    local wasEnabled = context["同誓保护已启用"]
    _____5173_95ED_540C_8A93_4FDD_62A4(context)
    if lowName == "赤誓灵卫" then
        _____64AD_653E_82CD_5F71_7075_536B_53F0_8BCD(context["苍影灵卫单位"], "双灵同誓")
    else
        _____64AD_653E_8D64_8A93_7075_536B_53F0_8BCD(context["赤誓灵卫单位"], "双灵同誓")
    end
    local sound = wasEnabled and _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["双灵同誓保护"] or _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效"]["双灵同誓建立"]
    _____64AD_653EBoss_5750_6807_97F3_6548(
        sound,
        GetUnitX(low),
        GetUnitY(low),
        _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["音效默认裁断距离"]
    )
    context["同誓保护已启用"] = true
    context["低血保护守卫"] = lowName
    _____786E_4FDD_540C_8A93_627F_4F24_8F6C_79FB(context)
    local ____opt_10 = context["同誓承伤转移"]
    if ____opt_10 ~= nil then
        ____opt_10["设置启用"](____opt_10, true)
    end
    if low ~= nil and low ~= 0 then
        context["同誓保护特效"] = AddSpecialEffectTarget(_____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["表现资源"]["公共"]["低血守卫保护特效路径"], low, "origin")
        registerManualBuff(
            low,
            _____7956_5730_53CC_7075_536BBuffID["双灵同誓"],
            3600,
            _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["同誓低血减伤比例"] * 100,
            {sourceName = "祖地双灵卫-双灵同誓"}
        )
    end
    context["同誓暗金连线"] = _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF({
        ["清理"] = context["清理"],
        ["名称"] = "祖地双灵卫-同誓暗金连线",
        ["起点单位"] = context["赤誓灵卫单位"],
        ["终点单位"] = context["苍影灵卫单位"],
        ["闪电代码"] = _____95EA_7535_6548_679C_4EE3_7801["黄色细束"],
        ["起点高度"] = 72,
        ["终点高度"] = 72,
        ["Tick间隔毫秒"] = 40,
        ["颜色"] = {r = 0.82, g = 0.56, b = 0.18, a = 0.78}
    })
    context["同誓冷蓝连线"] = _____521B_5EFA_6301_7EED_5355_4F4D_8FDE_7EBF({
        ["清理"] = context["清理"],
        ["名称"] = "祖地双灵卫-同誓冷蓝连线",
        ["起点单位"] = context["赤誓灵卫单位"],
        ["终点单位"] = context["苍影灵卫单位"],
        ["闪电代码"] = _____95EA_7535_6548_679C_4EE3_7801["蓝色细束"],
        ["起点高度"] = 88,
        ["终点高度"] = 88,
        ["Tick间隔毫秒"] = 40,
        ["颜色"] = {r = 0.36, g = 0.72, b = 1, a = 0.74}
    })
end
____exports["更新祖地双灵同誓"] = function(context, _now)
    if _now == nil then
        _now = getServerTime()
    end
    if context["战斗已结束"] or context["阶段"] == "净化收束" or context["阶段"] == "已结束" then
        _____5173_95ED_540C_8A93_4FDD_62A4(context)
        return
    end
    local redRatio = _____751F_547D_6BD4_4F8B(context["赤誓灵卫单位"])
    local azureRatio = _____751F_547D_6BD4_4F8B(context["苍影灵卫单位"])
    local diff = redRatio - azureRatio
    if diff < 0 then
        diff = -diff
    end
    local cfg = _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]
    if not context["同誓保护已启用"] and diff >= cfg["双灵同誓触发生命差"] then
        _____5F00_542F_540C_8A93_4FDD_62A4(context, redRatio <= azureRatio and "赤誓灵卫" or "苍影灵卫")
    elseif context["同誓保护已启用"] and diff <= cfg["双灵同誓解除生命差"] then
        _____5173_95ED_540C_8A93_4FDD_62A4(context)
    elseif context["同誓保护已启用"] then
        local nextLow = redRatio <= azureRatio and "赤誓灵卫" or "苍影灵卫"
        if context["低血保护守卫"] ~= nextLow then
            _____5F00_542F_540C_8A93_4FDD_62A4(context, nextLow)
        end
    end
end
local function ____on_53CC_7075_540C_8A93_4F24_5BB3_4FEE_6B63(damage)
    if damage == nil then
        return 0
    end
    if damage.isDamageTransfer == true then
        return damage.currentDamage
    end
    local context = _____83B7_53D6_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587(damage.target)
    if context == nil or context["战斗已结束"] then
        return damage.currentDamage
    end
    local ____self_12 = context["联合生命周期"]
    local member = ____self_12["按单位取成员"](____self_12, damage.target)
    if member ~= nil and member["状态"] == "崩解" then
        return 0
    end
    local result = damage.currentDamage
    if context["阶段"] == "P3双蚀共鸣" and context["P3共鸣层数"] > 0 then
        result = result * (1 - context["P3共鸣层数"] * _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["P3每层共鸣减伤比例"])
    end
    if getServerTime() < context["净化易伤到Ms"] then
        result = result * (1 + _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E.P3["净化后易伤比例"])
    end
    if not context["同誓保护已启用"] or context["低血保护守卫"] == nil then
        return result
    end
    local ____temp_13
    if context["低血保护守卫"] == "赤誓灵卫" then
        ____temp_13 = damage.target == context["赤誓灵卫单位"]
    else
        ____temp_13 = damage.target == context["苍影灵卫单位"]
    end
    local isLow = ____temp_13
    if not isLow then
        return result
    end
    result = result * (1 - _____7956_5730_53CC_7075_536B_6570_503C_4E0E_8868_73B0_914D_7F6E["公共"]["同誓低血减伤比例"])
    return result
end
local function _____6EE1_8DB3_53CC_7075_540C_8A93_4F24_5BB3_4FEE_6B63_6761_4EF6(damage)
    if damage == nil or damage.isDamageTransfer == true then
        return false
    end
    local context = _____83B7_53D6_7956_5730_53CC_7075_536B_8FD0_884C_65F6_4E0A_4E0B_6587(damage.target)
    if context == nil or context["战斗已结束"] then
        return false
    end
    local ____self_14 = context["联合生命周期"]
    local member = ____self_14["按单位取成员"](____self_14, damage.target)
    if member ~= nil and member["状态"] == "崩解" then
        return true
    end
    if context["阶段"] == "P3双蚀共鸣" and context["P3共鸣层数"] > 0 then
        return true
    end
    if getServerTime() < context["净化易伤到Ms"] then
        return true
    end
    if not context["同誓保护已启用"] or context["低血保护守卫"] == nil then
        return false
    end
    local ____temp_15
    if context["低血保护守卫"] == "赤誓灵卫" then
        ____temp_15 = damage.target == context["赤誓灵卫单位"]
    else
        ____temp_15 = damage.target == context["苍影灵卫单位"]
    end
    return ____temp_15
end
____exports["注册祖地双灵同誓"] = function()
    if _____53CC_7075_540C_8A93_5DF2_6CE8_518C then
        return
    end
    _____53CC_7075_540C_8A93_5DF2_6CE8_518C = true
    _____521B_5EFA_6761_4EF6_4F24_5BB3_4FEE_6B63({["名称"] = "祖地双灵卫-双灵同誓伤害修正", ["优先级"] = -70, ["条件"] = _____6EE1_8DB3_53CC_7075_540C_8A93_4F24_5BB3_4FEE_6B63_6761_4EF6, ["修正"] = ____on_53CC_7075_540C_8A93_4F24_5BB3_4FEE_6B63})
end
____exports["双灵同誓机制状态"] = {
    ["类型"] = "共享被动",
    ["已完成设计"] = true,
    ["已完成实现"] = true,
    ["已注册"] = true,
    ["语义"] = "双方生命差过大时保护低血守卫，防止从满血开始单点击破。",
    ["实现要求"] = "保护必须通过誓链、举盾或护盾表现明确反馈，不允许只有后台减伤。"
}
return ____exports
