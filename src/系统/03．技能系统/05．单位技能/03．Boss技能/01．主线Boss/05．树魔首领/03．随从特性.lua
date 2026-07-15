--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.00．配置")
local _____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["树魔首领单位技能配置"]
local ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587 = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.01．运行时上下文")
local _____83B7_53D6_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取树魔首领上下文"]
local _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取或创建树魔首领上下文"]
local _____83B7_53D6_5168_90E8_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["获取全部树魔首领上下文"]
local _____6E05_7406_6811_9B54_9996_9886_4E0A_4E0B_6587 = ____01_FF0E_8FD0_884C_65F6_4E0A_4E0B_6587["清理树魔首领上下文"]
local ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.02．数值与表现配置")
local _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领数值与表现配置"]
local _____6811_9B54_9996_9886_97F3_6548_914D_7F6E = ____02_FF0E_6570_503C_4E0E_8868_73B0_914D_7F6E["树魔首领音效配置"]
local ____08_FF0E_53F0_8BCD_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.01．主线Boss.05．树魔首领.08．台词播放")
local _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD = ____08_FF0E_53F0_8BCD_64AD_653E["播放树魔首领台词"]
local ____00_FF0EBoss_97F3_6548_64AD_653E = require("系统.03．技能系统.05．单位技能.03．Boss技能.00．公共.00．Boss音效播放")
local _____64AD_653EBoss_5750_6807_97F3_6548 = ____00_FF0EBoss_97F3_6548_64AD_653E["播放Boss坐标音效"]
local _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60 = ____00_FF0EBoss_97F3_6548_64AD_653E["尝试播放Boss拟声池"]
local ____19_FF0E_6218_6597_516C_5171_5DE5_5177 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local stringToFourCC = ____19_FF0E_6218_6597_516C_5171_5DE5_5177.stringToFourCC
local jass = require("jass.common")
local jglobals = require("jass.globals")
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitFacing = jass.GetUnitFacing
local GetUnitDefaultMoveSpeed = jass.GetUnitDefaultMoveSpeed
local GetOwningPlayer = jass.GetOwningPlayer
local CreateUnit = jass.CreateUnit
local IssueTargetOrder = jass.IssueTargetOrder
local IsUnitType = jass.IsUnitType
local GetRandomReal = jass.GetRandomReal
local GetRandomInt = jass.GetRandomInt
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_1.registerDamageModifier
local ____require_result_2 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_2.registerDeathListener
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.05．Buff系统.03．Buff表.01．Boss.01．主线Boss.04．树魔首领")
local _____6811_9B54_9996_9886BuffID = ____require_result_4["树魔首领BuffID"]
local ____require_result_5 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_5.SGSS_SetState
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_6.createTimedEffect
local _____653B_901F_5C5E_6027ID = 10
local _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID = 9
local _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["单位ID"])
local _____730E_5934_8005_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["猎头者"])
local _____5DEB_533B_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["巫医"])
local _____6295_63B7_8005_5355_4F4D_7C7B_578BID = stringToFourCC(_____6811_9B54_9996_9886_5355_4F4D_6280_80FD_914D_7F6E["召唤物ID"]["投掷者"])
local _____6811_9B54_9996_9886_968F_4ECE_7279_6027_5DF2_6CE8_518C = false
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____662F_6811_9B54_9996_9886(unit)
    return _____5355_4F4D_5B58_6D3B(unit) and GetUnitTypeId(unit) == _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID
end
local function _____5355_4F4D_7C7B_578B_662F_6811_9B54_9996_9886(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) == _____6811_9B54_9996_9886_5355_4F4D_7C7B_578BID
end
local function _____968F_673A_53EC_5524_70B9(boss)
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    return {
        x = GetUnitX(boss) + GetRandomReal(-cfg["召唤范围"], cfg["召唤范围"]),
        y = GetUnitY(boss) + GetRandomReal(-cfg["召唤范围"], cfg["召唤范围"])
    }
end
local function _____53EC_5524_6811_9B54_968F_4ECE(context, unitTypeId)
    local boss = context["Boss单位"]
    local _____70B9 = _____968F_673A_53EC_5524_70B9(boss)
    local minion = CreateUnit(
        GetOwningPlayer(boss),
        unitTypeId,
        _____70B9.x,
        _____70B9.y,
        GetRandomReal(0, 360)
    )
    if minion == nil or minion == 0 then
        return nil
    end
    local ____self_7 = context["随从组"]
    ____self_7["登记"](____self_7, minion)
    local ____self_8 = context["清理"]
    ____self_8["登记单位"](____self_8, "树魔首领随从", minion)
    IssueTargetOrder(minion, "patrol", boss)
    return minion
end
local function _____968F_673A_53D6_97F3_6548_8DEF_5F84(list)
    if #list <= 0 then
        return ""
    end
    return list[GetRandomInt(0, #list - 1) + 1]
end
local function _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_602A_53EB(boss, _____89E6_53D1_6982_7387_767E_5206_6BD4)
    local soundCfg = _____6811_9B54_9996_9886_97F3_6548_914D_7F6E
    _____5C1D_8BD5_64AD_653EBoss_62DF_58F0_6C60({
        ["标识"] = soundCfg["怪物拟声"]["标识"],
        ["音效路径列表"] = soundCfg["怪物拟声"]["音效路径列表"],
        X = GetUnitX(boss),
        Y = GetUnitY(boss),
        ["裁断距离"] = soundCfg["默认裁断距离"],
        ["冷却Ms"] = soundCfg["怪物拟声"]["冷却Ms"],
        ["触发概率百分比"] = _____89E6_53D1_6982_7387_767E_5206_6BD4
    })
end
local function _____53EC_5524_4E00_6CE2_968F_4ECE(context)
    local roll = GetRandomInt(1, 3)
    local _____5DF2_53EC_5524_968F_4ECE = false
    if roll == 1 then
        if _____53EC_5524_6811_9B54_968F_4ECE(context, _____730E_5934_8005_5355_4F4D_7C7B_578BID) ~= nil then
            _____5DF2_53EC_5524_968F_4ECE = true
        end
        if _____53EC_5524_6811_9B54_968F_4ECE(context, _____730E_5934_8005_5355_4F4D_7C7B_578BID) ~= nil then
            _____5DF2_53EC_5524_968F_4ECE = true
        end
    elseif roll == 2 then
        local witchDoctor = _____53EC_5524_6811_9B54_968F_4ECE(context, _____5DEB_533B_5355_4F4D_7C7B_578BID)
        if witchDoctor ~= nil and witchDoctor ~= 0 then
            _____5DF2_53EC_5524_968F_4ECE = true
            local healId = 0
            healId = addPeriodicCallback(
                _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]["巫医治疗间隔秒"] * 1000,
                function()
                    if not _____5355_4F4D_5B58_6D3B(witchDoctor) or not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) then
                        removePeriodicCallback(healId)
                        return
                    end
                    IssueTargetOrder(witchDoctor, "healingwave", context["Boss单位"])
                end
            )
            local ____self_9 = context["清理"]
            ____self_9["登记周期回调"](____self_9, "树魔巫医治疗", healId)
        end
    else
        if _____53EC_5524_6811_9B54_968F_4ECE(context, _____6295_63B7_8005_5355_4F4D_7C7B_578BID) ~= nil then
            _____5DF2_53EC_5524_968F_4ECE = true
        end
    end
    if _____5DF2_53EC_5524_968F_4ECE then
        local soundCfg = _____6811_9B54_9996_9886_97F3_6548_914D_7F6E
        _____64AD_653EBoss_5750_6807_97F3_6548(
            _____968F_673A_53D6_97F3_6548_8DEF_5F84(soundCfg["随从特性"]["召唤号令列表"]),
            GetUnitX(context["Boss单位"]),
            GetUnitY(context["Boss单位"]),
            soundCfg["默认裁断距离"]
        )
        _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_602A_53EB(context["Boss单位"], soundCfg["怪物拟声"]["召唤触发概率百分比"])
    end
    _____64AD_653E_6811_9B54_9996_9886_53F0_8BCD(context["Boss单位"], "随从特性")
end
local function _____8FDB_5165_65E0_4ECE_66B4_6012(context)
    if context["无从暴怒中"] then
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    context["无从暴怒中"] = true
    context["暴怒攻速增量"] = cfg["无小弟攻速提高"]
    context["暴怒移速增量"] = GetUnitDefaultMoveSpeed(context["Boss单位"]) * cfg["无小弟移速提高"]
    SGSS_SetState(context["Boss单位"], _____653B_901F_5C5E_6027ID, context["暴怒攻速增量"])
    SGSS_SetState(context["Boss单位"], _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, context["暴怒移速增量"])
    _____64AD_653EBoss_5750_6807_97F3_6548(
        _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["随从特性"]["无从暴怒"],
        GetUnitX(context["Boss单位"]),
        GetUnitY(context["Boss单位"]),
        _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["默认裁断距离"]
    )
    _____5C1D_8BD5_64AD_653E_6811_9B54_9996_9886_602A_53EB(context["Boss单位"], _____6811_9B54_9996_9886_97F3_6548_914D_7F6E["怪物拟声"]["暴怒触发概率百分比"])
end
local function _____9000_51FA_65E0_4ECE_66B4_6012(context)
    if not context["无从暴怒中"] then
        return
    end
    context["无从暴怒中"] = false
    if context["暴怒攻速增量"] ~= 0 then
        SGSS_SetState(context["Boss单位"], _____653B_901F_5C5E_6027ID, -context["暴怒攻速增量"])
    end
    if context["暴怒移速增量"] ~= 0 then
        SGSS_SetState(context["Boss单位"], _____53E0_52A0_79FB_52A8_901F_5EA6_5C5E_6027ID, -context["暴怒移速增量"])
    end
    context["暴怒攻速增量"] = 0
    context["暴怒移速增量"] = 0
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____6811_9B54_9996_9886BuffID["无从暴怒"])
end
local function _____5237_65B0_968F_4ECE_72B6_6001(context)
    if not _____5355_4F4D_5B58_6D3B(context["Boss单位"]) then
        _____6E05_7406_6811_9B54_9996_9886_4E0A_4E0B_6587(context["Boss单位"])
        return
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local ____self_10 = context["随从组"]
    local count = ____self_10["取存活数量"](____self_10)
    context["当前随从数量"] = count
    context["当前兽群层数"] = math.min(4, count)
    if count > 0 then
        _____9000_51FA_65E0_4ECE_66B4_6012(context)
        registerManualBuff(
            context["Boss单位"],
            _____6811_9B54_9996_9886BuffID["兽群号令"],
            cfg["兽群Buff刷新秒"],
            context["当前兽群层数"],
            {sourceName = "树魔首领"}
        )
    else
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["Boss单位"], _____6811_9B54_9996_9886BuffID["兽群号令"])
        _____8FDB_5165_65E0_4ECE_66B4_6012(context)
        registerManualBuff(
            context["Boss单位"],
            _____6811_9B54_9996_9886BuffID["无从暴怒"],
            cfg["暴怒Buff刷新秒"],
            1,
            {sourceName = "树魔首领"}
        )
        createTimedEffect(
            cfg["暴怒持续特效路径"],
            GetUnitX(context["Boss单位"]),
            GetUnitY(context["Boss单位"]),
            0,
            cfg["暴怒持续特效刷新毫秒"] / 1000
        )
    end
end
local function _____6811_9B54_9996_9886_968F_4ECE_4F24_5BB3_4FEE_6B63(damageContext)
    local attacker = damageContext.attacker
    if not _____662F_6811_9B54_9996_9886(attacker) then
        return damageContext.currentDamage
    end
    local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(attacker)
    if context == nil or context["当前兽群层数"] <= 0 then
        return damageContext.currentDamage
    end
    local cfg = _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]
    local bonus = math.min(cfg["最高攻击提高"], context["当前兽群层数"] * cfg["每个小弟攻击提高"])
    return damageContext.currentDamage * (1 + bonus)
end
local function ____on_6811_9B54_9996_9886_6B7B_4EA1(dyingUnit)
    if not _____5355_4F4D_7C7B_578B_662F_6811_9B54_9996_9886(dyingUnit) then
        return
    end
    local context = _____83B7_53D6_6811_9B54_9996_9886_4E0A_4E0B_6587(dyingUnit)
    if context ~= nil then
        _____9000_51FA_65E0_4ECE_66B4_6012(context)
    end
    _____6E05_7406_6811_9B54_9996_9886_4E0A_4E0B_6587(dyingUnit)
end
local function _____6811_9B54_9996_9886_968F_4ECE_7279_6027Tick()
    local currentBoss = jglobals.udg_Boss
    if _____662F_6811_9B54_9996_9886(currentBoss) then
        local context = _____83B7_53D6_6216_521B_5EFA_6811_9B54_9996_9886_4E0A_4E0B_6587(currentBoss)
        if context ~= nil and not context["随从特性已初始化"] then
            context["随从特性已初始化"] = true
            context["下一次召唤Ms"] = getServerTime() + _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]["召唤间隔秒"] * 1000
        end
    end
    local now = getServerTime()
    local list = _____83B7_53D6_5168_90E8_6811_9B54_9996_9886_4E0A_4E0B_6587()
    do
        local i = 0
        while i < #list do
            do
                local context = list[i + 1]
                if context == nil then
                    goto __continue42
                end
                _____5237_65B0_968F_4ECE_72B6_6001(context)
                if context["下一次召唤Ms"] > 0 and now >= context["下一次召唤Ms"] then
                    _____53EC_5524_4E00_6CE2_968F_4ECE(context)
                    context["下一次召唤Ms"] = now + _____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]["召唤间隔秒"] * 1000
                end
            end
            ::__continue42::
            i = i + 1
        end
    end
end
____exports["注册树魔首领随从特性"] = function()
    if _____6811_9B54_9996_9886_968F_4ECE_7279_6027_5DF2_6CE8_518C then
        return
    end
    _____6811_9B54_9996_9886_968F_4ECE_7279_6027_5DF2_6CE8_518C = true
    registerDamageModifier(_____6811_9B54_9996_9886_968F_4ECE_4F24_5BB3_4FEE_6B63, 45)
    registerDeathListener(____on_6811_9B54_9996_9886_6B7B_4EA1)
    addPeriodicCallback(_____6811_9B54_9996_9886_6570_503C_4E0E_8868_73B0_914D_7F6E["随从特性"]["追随刷新间隔毫秒"], _____6811_9B54_9996_9886_968F_4ECE_7279_6027Tick)
end
return ____exports
