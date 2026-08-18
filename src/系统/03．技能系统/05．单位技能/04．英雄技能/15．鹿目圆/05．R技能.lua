local ____lualib = require("lualib_bundle")
local __TS__ObjectAssign = ____lualib.__TS__ObjectAssign
local ____exports = {}
local _____662FR_6709_6548_76EE_6807, ____R_654C_65B9_6BCF_76EE_6807_5904_7406, GetUnitTypeId, GetUnitState, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, GetUnitStateJapi, _____914D_7F6E
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.00．配置")
local _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["鹿目圆单位技能配置"]
local ____01_FF0E_72B6_6001_4E0E_88AB_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.01．状态与被动")
local _____662F_9E7F_76EE_5706_5706_795E = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["是鹿目圆圆神"]
local _____83B7_53D6_5706_795E_5269_4F59_79D2 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["获取圆神剩余秒"]
local _____7ED3_675F_9E7F_76EE_5706_5706_795E = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["结束鹿目圆圆神"]
local ____10_FF0E_9E7F_76EE_5706 = require("系统.05．Buff系统.03．Buff表.02．英雄.10．鹿目圆")
local _____9E7F_76EE_5706BuffID = ____10_FF0E_9E7F_76EE_5706["鹿目圆BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____662FR_6709_6548_76EE_6807(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
function ____R_654C_65B9_6BCF_76EE_6807_5904_7406(target, _index, variable)
    local data = variable
    if data == nil or not _____662FR_6709_6548_76EE_6807(target) then
        return nil
    end
    local maxLife = GetUnitStateJapi(target, UNIT_STATE_MAX_LIFE)
    local life = GetUnitState(target, UNIT_STATE_LIFE)
    local missingLife = maxLife > life and maxLife - life or 0
    local totalDamage = (data.context["攻击力快照"] * _____914D_7F6E.R["攻击力比例"] + missingLife * _____914D_7F6E.R["已损失生命比例"]) * data.multiplier
    return {["伤害"] = totalDamage / _____914D_7F6E.R["Tick次数"]}
end
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local _____65BD_52A0_5355_4F4D_63A7_5236_8D1F_9762_6548_679C_514D_75AB = ____require_result_1["施加单位控制负面效果免疫"]
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_2.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_3["结束独立技能伤害实例"]
local ____require_result_4 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
local doHeal = ____require_result_4.doHeal
local ____require_result_5 = require("系统.03．技能系统.02．技能消耗.01．魔法消耗返还")
local _____6D88_8017_5355_4F4D_5168_90E8_5F53_524D_9B54_6CD5 = ____require_result_5["消耗单位全部当前魔法"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_6["创建单位并登记排泄安全"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_7.getUnitsInRange
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local _____521B_5EFA_70B9_7279_6548 = ____require_result_8["创建点特效"]
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_9["读取单位攻击力"]
local _____4E24_70B9_89D2_5EA6 = ____require_result_9["两点角度"]
local ____require_result_10 = require("lib.扩展函数.BJ函数.07．杂项")
local GetRandomDirectionDeg = ____require_result_10.GetRandomDirectionDeg
GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
GetUnitState = jass.GetUnitState
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitAlly = jass.IsUnitAlly
local SetUnitFacing = jass.SetUnitFacing
local SetUnitX = jass.SetUnitX
local SetUnitY = jass.SetUnitY
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local RemoveUnit = jass.RemoveUnit
local GetRandomReal = jass.GetRandomReal
local SquareRoot = jass.SquareRoot
local Cos = jass.Cos
local Sin = jass.Sin
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local ____jass_bj_DEGTORAD_11 = jass.bj_DEGTORAD
if ____jass_bj_DEGTORAD_11 == nil then
    ____jass_bj_DEGTORAD_11 = 0.017453292519943295
end
local bj_DEGTORAD = ____jass_bj_DEGTORAD_11
GetUnitStateJapi = japi.GetUnitState
_____914D_7F6E = _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E
local function _____79FB_9664_5355_4F4D_58F3(unit)
    if unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0 then
        RemoveUnit(unit)
    end
end
local function _____4E24_70B9_8DDD_79BB(x1, y1, x2, y2)
    local dx = x2 - x1
    local dy = y2 - y1
    return SquareRoot(dx * dx + dy * dy)
end
local function _____83B7_53D6R_5165_53E3(caster)
    if not _____662F_9E7F_76EE_5706_5706_795E(caster) then
        return nil
    end
    local startX = GetUnitX(caster)
    local startY = GetUnitY(caster)
    local targetX = GetSpellTargetX()
    local targetY = GetSpellTargetY()
    local distance = _____4E24_70B9_8DDD_79BB(startX, startY, targetX, targetY)
    if distance < _____914D_7F6E.R["最低施法距离"] then
        return nil
    end
    return {
        ["施法者"] = caster,
        ["目标X"] = targetX,
        ["目标Y"] = targetY,
        ["方向"] = _____4E24_70B9_89D2_5EA6(startX, startY, targetX, targetY),
        ["距离"] = distance,
        ["剩余圆神秒"] = _____83B7_53D6_5706_795E_5269_4F59_79D2(caster),
        ["攻击力快照"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(caster)
    }
end
local function _____6E05_7406R(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    if context["周期ID"] ~= 0 then
        removePeriodicCallback(context["周期ID"])
        context["周期ID"] = 0
    end
    _____79FB_9664_5355_4F4D_58F3(context["主箭"])
    _____79FB_9664_5355_4F4D_58F3(context["副箭"])
    context["主箭"] = nil
    context["副箭"] = nil
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____9E7F_76EE_5706BuffID["圆环之理"])
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
end
local function _____6E05_7406R_8109_51B2_7BAD(variable)
    local data = variable
    if data ~= nil then
        _____79FB_9664_5355_4F4D_58F3(data.unit)
    end
end
local function _____521B_5EFAR_8109_51B2_7BAD(context)
    local angle = GetRandomDirectionDeg()
    local radius = GetRandomReal(50, 650)
    local radians = angle * bj_DEGTORAD
    local x = context["目标X"] + radius * Cos(radians)
    local y = context["目标Y"] + radius * Sin(radians)
    local arrow = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        context["所有者"],
        _____914D_7F6E["单位壳"]["W发射箭"],
        x,
        y,
        angle
    )
    if arrow == nil or arrow == 0 then
        return
    end
    SetUnitAnimationByIndex(arrow, 3)
    addDelayedCallback(1500, _____6E05_7406R_8109_51B2_7BAD, {unit = arrow})
end
local function _____7ED3_7B97R_5355_6B21_8109_51B2(context)
    _____521B_5EFAR_8109_51B2_7BAD(context)
    local units = getUnitsInRange(context["目标X"], context["目标Y"], _____914D_7F6E.R["范围"])
    local enemies = {}
    local allies = {}
    do
        local i = 0
        while i < #units do
            do
                local unit = units[i + 1]
                if not _____662FR_6709_6548_76EE_6807(unit) then
                    goto __continue18
                end
                if IsUnitEnemy(unit, context["所有者"]) == true then
                    enemies[#enemies + 1] = unit
                elseif IsUnitAlly(unit, context["所有者"]) == true then
                    allies[#allies + 1] = unit
                end
            end
            ::__continue18::
            i = i + 1
        end
    end
    local multiplier = 1 + context["剩余圆神秒"] / 20
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = enemies,
        ["伤害"] = 0,
        ["伤害类型"] = DAMAGE_TYPE_SHADOW_STRIKE,
        attack = false,
        ranged = true,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____914D_7F6E["技能"].R["类型ID"],
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "鹿目圆-R-圆环之理",
        ["参与技能伤害加成"] = true,
        ["每目标处理器"] = ____R_654C_65B9_6BCF_76EE_6807_5904_7406,
        ["变量"] = {context = context, multiplier = multiplier}
    })
    do
        local i = 0
        while i < #allies do
            local ally = allies[i + 1]
            doHeal({
                HealSource = context["施法者"],
                HealTarget = ally,
                HealAmount = GetUnitStateJapi(ally, UNIT_STATE_MAX_LIFE),
                HealManaAmount = GetUnitStateJapi(ally, UNIT_STATE_MAX_MANA),
                ItemHeal = false,
                HealEffect = false,
                HealShowText = false,
                ManaEffect = false,
                ManaShowText = false
            })
            i = i + 1
        end
    end
end
local function ____R_7ED3_7B97Tick(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if context["已结算Tick"] >= _____914D_7F6E.R["Tick次数"] then
        _____6E05_7406R(context)
        return
    end
    context["已结算Tick"] = context["已结算Tick"] + 1
    _____7ED3_7B97R_5355_6B21_8109_51B2(context)
    if context["已结算Tick"] >= _____914D_7F6E.R["Tick次数"] then
        _____6E05_7406R(context)
    end
end
local function ____R_5F39_9053Tick(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if context["已移动距离"] >= context["距离"] then
        removePeriodicCallback(context["周期ID"])
        context["周期ID"] = 0
        _____79FB_9664_5355_4F4D_58F3(context["主箭"])
        _____79FB_9664_5355_4F4D_58F3(context["副箭"])
        context["主箭"] = nil
        context["副箭"] = nil
        _____521B_5EFA_70B9_7279_6548({
            ["模型路径"] = _____914D_7F6E.R["命中特效"],
            X = context["目标X"],
            Y = context["目标Y"],
            Z = 0,
            ["面向角度"] = 270,
            ["缩放"] = _____914D_7F6E.R["命中特效缩放"],
            ["持续秒"] = 6
        })
        context["周期ID"] = addPeriodicCallback(_____914D_7F6E.R["Tick间隔毫秒"], ____R_7ED3_7B97Tick, context)
        return
    end
    local move = context["距离"] - context["已移动距离"] < _____914D_7F6E.R["箭步长"] and context["距离"] - context["已移动距离"] or _____914D_7F6E.R["箭步长"]
    context["已移动距离"] = context["已移动距离"] + move
    local radians = context["方向"] * bj_DEGTORAD
    local x = GetUnitX(context["主箭"]) + move * Cos(radians)
    local y = GetUnitY(context["主箭"]) + move * Sin(radians)
    SetUnitX(context["主箭"], x)
    SetUnitY(context["主箭"], y)
    SetUnitX(context["副箭"], x)
    SetUnitY(context["副箭"], y)
end
local function _____91CA_653ER(entry, caster, _____6280_80FD_5B9E_4F8BID)
    local startX = GetUnitX(caster)
    local startY = GetUnitY(caster)
    local owner = GetOwningPlayer(caster)
    _____6D88_8017_5355_4F4D_5168_90E8_5F53_524D_9B54_6CD5(caster)
    _____7ED3_675F_9E7F_76EE_5706_5706_795E(caster, "施放圆环之理")
    _____5F00_59CB_786C_76F4(caster, _____914D_7F6E.R["起手硬直秒"])
    SetUnitAnimation(caster, "spell")
    _____65BD_52A0_5355_4F4D_63A7_5236_8D1F_9762_6548_679C_514D_75AB(caster, _____914D_7F6E.R["施法控制免疫秒"], true)
    registerManualBuff(
        caster,
        _____9E7F_76EE_5706BuffID["圆环之理"],
        _____914D_7F6E.R["持续秒"],
        0,
        {sourceUnit = caster, stack = 1}
    )
    local mainArrow = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        _____914D_7F6E["单位壳"]["R主箭"],
        startX,
        startY,
        entry["方向"]
    )
    local subArrow = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        owner,
        _____914D_7F6E["单位壳"]["R副箭"],
        startX,
        startY,
        entry["方向"]
    )
    if mainArrow == nil or mainArrow == 0 or subArrow == nil or subArrow == 0 then
        _____79FB_9664_5355_4F4D_58F3(mainArrow)
        _____79FB_9664_5355_4F4D_58F3(subArrow)
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(caster, _____9E7F_76EE_5706BuffID["圆环之理"])
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    SetUnitFacing(mainArrow, entry["方向"])
    SetUnitFlyHeight(mainArrow, _____914D_7F6E.R["主箭高度"], 0)
    SetUnitScale(mainArrow, _____914D_7F6E.R["主箭缩放"], _____914D_7F6E.R["主箭缩放"], _____914D_7F6E.R["主箭缩放"])
    SetUnitFacing(subArrow, entry["方向"])
    SetUnitFlyHeight(subArrow, _____914D_7F6E.R["副箭高度"], 0)
    SetUnitScale(subArrow, _____914D_7F6E.R["副箭缩放"], _____914D_7F6E.R["副箭缩放"], _____914D_7F6E.R["副箭缩放"])
    local context = __TS__ObjectAssign({}, entry, {
        ["所有者"] = owner,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["主箭"] = mainArrow,
        ["副箭"] = subArrow,
        ["已移动距离"] = 0,
        ["已结算Tick"] = 0,
        ["周期ID"] = 0,
        ["已结束"] = false
    })
    context["周期ID"] = addPeriodicCallback(_____914D_7F6E.R["箭间隔毫秒"], ____R_5F39_9053Tick, context)
end
_____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
    ["名称"] = "鹿目圆-圆环之理",
    ["单位类型ID"] = _____914D_7F6E["单位"]["圆神类型ID"],
    ["技能ID"] = _____914D_7F6E["技能"].R["类型ID"],
    ["获取或创建上下文"] = _____83B7_53D6R_5165_53E3,
    ["释放技能"] = _____91CA_653ER,
    ["创建独立技能实例"] = true,
    ["独立技能来源类型"] = "单位技能",
    ["技能实例持续时间秒"] = 12
})
return ____exports
