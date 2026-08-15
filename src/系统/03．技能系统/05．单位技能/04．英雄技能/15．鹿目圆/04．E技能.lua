local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.00．配置")
local _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["鹿目圆单位技能配置"]
local ____01_FF0E_72B6_6001_4E0E_88AB_52A8 = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.01．状态与被动")
local _____662F_9E7F_76EE_5706 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["是鹿目圆"]
local _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297 = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆伤害无视魔抗"]
local _____9E7F_76EE_5706_6CBB_7597_53CB_519B = ____01_FF0E_72B6_6001_4E0E_88AB_52A8["鹿目圆治疗友军"]
local ____10_FF0E_9E7F_76EE_5706 = require("系统.05．Buff系统.03．Buff表.02．英雄.10．鹿目圆")
local _____9E7F_76EE_5706BuffID = ____10_FF0E_9E7F_76EE_5706["鹿目圆BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local ____require_result_1 = require("lib.扩展函数.Star扩展函数.Star扩展库.03．硬直暂停系统")
local _____6DFB_52A0_5355_4F4D_6682_505C = ____require_result_1["添加单位暂停"]
local _____79FB_9664_5355_4F4D_6682_505C = ____require_result_1["移除单位暂停"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.02．冲锋·击退.01．击退系统.03．对外接口")
local _____5F00_59CB_51B2_950B = ____require_result_2["开始冲锋"]
local ____require_result_3 = require("系统.05．Buff系统.00．Buff系统")
local registerManualBuff = ____require_result_3.registerManualBuff
local _____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_3["移除单位指定Buff"]
local ____require_result_4 = require("系统.05．Buff系统.05．Buff清除函数")
local _____79FB_9664_5355_4F4D_8D1F_9762Buff = ____require_result_4["移除单位负面Buff"]
local ____require_result_5 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_5["造成批量AOE技能伤害"]
local _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B = ____require_result_5["结束独立技能伤害实例"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
local _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_6["创建单位并登记排泄安全"]
local ____require_result_7 = require("lib.扩展函数.自定义扩展函数.01．选取中心范围")
local getUnitsInRange = ____require_result_7.getUnitsInRange
local ____require_result_8 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_8.createTimedEffect
local ____require_result_9 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____4E24_70B9_89D2_5EA6 = ____require_result_9["两点角度"]
local GetHandleId = jass.GetHandleId
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetSpellTargetX = jass.GetSpellTargetX
local GetSpellTargetY = jass.GetSpellTargetY
local GetOwningPlayer = jass.GetOwningPlayer
local GetHeroLevel = jass.GetHeroLevel
local GetRandomReal = jass.GetRandomReal
local GetRandomDirectionDeg = jass.GetRandomDirectionDeg
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitFlyHeight = jass.SetUnitFlyHeight
local SetUnitScale = jass.SetUnitScale
local GetUnitFlyHeight = jass.GetUnitFlyHeight
local RemoveUnit = jass.RemoveUnit
local IsUnitType = jass.IsUnitType
local IsUnitEnemy = jass.IsUnitEnemy
local IsUnitAlly = jass.IsUnitAlly
local SquareRoot = jass.SquareRoot
local Cos = jass.Cos
local Sin = jass.Sin
local ____jass_bj_DEGTORAD_10 = jass.bj_DEGTORAD
if ____jass_bj_DEGTORAD_10 == nil then
    ____jass_bj_DEGTORAD_10 = 0.017453292519943295
end
local bj_DEGTORAD = ____jass_bj_DEGTORAD_10
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local GetUnitStateJapi = japi.GetUnitState
local _____914D_7F6E = _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E
local ____E_4E0A_4E0B_6587_8868 = {}
local function _____53D6_5355_4F4DID(unit)
    return (unit == nil or unit == 0) and 0 or GetHandleId(unit)
end
local function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
local function _____662FE_5408_6CD5_5355_4F4D(unit)
    return _____5355_4F4D_5B58_6D3B(unit) and IsUnitType(unit, UNIT_TYPE_MECHANICAL) ~= true and IsUnitType(unit, UNIT_TYPE_ANCIENT) ~= true
end
local function _____6E05_7406E_96E8_5355_4F4D(context)
    do
        local i = 0
        while i < #context["雨单位"] do
            local unit = context["雨单位"][i + 1]
            if unit ~= nil and unit ~= 0 then
                RemoveUnit(unit)
            end
            i = i + 1
        end
    end
    context["雨单位"] = {}
end
local function _____7ED3_675FE(context)
    if context["已结束"] then
        return
    end
    context["已结束"] = true
    if context["周期ID"] ~= 0 then
        removePeriodicCallback(context["周期ID"])
        context["周期ID"] = 0
    end
    _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["暂停来源"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____9E7F_76EE_5706BuffID["虹之雨"])
    _____6E05_7406E_96E8_5355_4F4D(context)
    _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(context["技能实例ID"])
    local id = _____53D6_5355_4F4DID(context["施法者"])
    if id ~= 0 and ____E_4E0A_4E0B_6587_8868[id] == context then
        __TS__Delete(____E_4E0A_4E0B_6587_8868, id)
    end
end
local function _____521B_5EFAE_96E8_58F3(context)
    local distance = GetRandomReal(20, _____914D_7F6E.E["范围"])
    local angle = GetRandomDirectionDeg()
    local radians = angle * bj_DEGTORAD
    local x = context["区域X"] + Cos(radians) * distance
    local y = context["区域Y"] + Sin(radians) * distance
    local rain = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        GetOwningPlayer(context["施法者"]),
        _____914D_7F6E["单位壳"]["虹之雨"],
        x,
        y,
        angle
    )
    if rain == nil or rain == 0 then
        return
    end
    SetUnitFlyHeight(rain, _____914D_7F6E.E["雨单位高度"], 0)
    SetUnitScale(rain, _____914D_7F6E.E["雨单位缩放"], _____914D_7F6E.E["雨单位缩放"], _____914D_7F6E.E["雨单位缩放"])
    local ____context__96E8_5355_4F4D_11 = context["雨单位"]
    ____context__96E8_5355_4F4D_11[#____context__96E8_5355_4F4D_11 + 1] = rain
end
local function _____63A8_8FDBE_96E8_58F3(context)
    local kept = {}
    do
        local i = 0
        while i < #context["雨单位"] do
            do
                local unit = context["雨单位"][i + 1]
                if not _____5355_4F4D_5B58_6D3B(unit) then
                    goto __continue17
                end
                local nextHeight = GetUnitFlyHeight(unit) - _____914D_7F6E.E["雨单位下降步长"]
                if nextHeight <= _____914D_7F6E.E["雨单位清理高度"] then
                    RemoveUnit(unit)
                    goto __continue17
                end
                SetUnitFlyHeight(unit, nextHeight, 0)
                kept[#kept + 1] = unit
            end
            ::__continue17::
            i = i + 1
        end
    end
    context["雨单位"] = kept
end
local function ____E_533A_57DF_8109_51B2(context)
    createTimedEffect(
        _____914D_7F6E.E["脉冲特效"],
        context["区域X"],
        context["区域Y"],
        0,
        1.5
    )
    local owner = GetOwningPlayer(context["施法者"])
    local units = getUnitsInRange(context["区域X"], context["区域Y"], _____914D_7F6E.E["范围"])
    local enemies = {}
    do
        local i = 0
        while i < #units do
            do
                local unit = units[i + 1]
                if not _____662FE_5408_6CD5_5355_4F4D(unit) then
                    goto __continue22
                end
                if IsUnitEnemy(unit, owner) == true then
                    enemies[#enemies + 1] = unit
                elseif IsUnitAlly(unit, owner) == true then
                    _____9E7F_76EE_5706_6CBB_7597_53CB_519B(context["施法者"], unit, context["每次结算值"], 0)
                end
            end
            ::__continue22::
            i = i + 1
        end
    end
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["施法者"],
        ["目标列表"] = enemies,
        ["伤害"] = context["每次结算值"],
        ["伤害类型"] = DAMAGE_TYPE_PLANT,
        attack = false,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS,
        ["来源类型"] = "单位技能",
        ["技能ID"] = _____914D_7F6E["技能"].E["类型ID"],
        ["技能实例ID"] = context["技能实例ID"],
        ["标签"] = "鹿目圆-E-虹之雨",
        ["参与技能伤害加成"] = true,
        ["忽略魔法抗性"] = _____9E7F_76EE_5706_4F24_5BB3_65E0_89C6_9B54_6297(context["施法者"])
    })
end
local function ____E_533A_57DF_7ED3_675F_9A71_6563(context)
    local owner = GetOwningPlayer(context["施法者"])
    local units = getUnitsInRange(context["区域X"], context["区域Y"], _____914D_7F6E.E["范围"])
    do
        local i = 0
        while i < #units do
            local unit = units[i + 1]
            if _____662FE_5408_6CD5_5355_4F4D(unit) and IsUnitAlly(unit, owner) == true then
                _____79FB_9664_5355_4F4D_8D1F_9762Buff(unit, false)
            end
            i = i + 1
        end
    end
    context["区域已结算"] = true
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(context["施法者"], _____9E7F_76EE_5706BuffID["虹之雨"])
end
local function ____E_533A_57DFTick(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____7ED3_675FE(context)
        return
    end
    context.Tick = context.Tick + 1
    if context.Tick <= 100 then
        _____521B_5EFAE_96E8_58F3(context)
    end
    _____63A8_8FDBE_96E8_58F3(context)
    if context.Tick == 20 or context.Tick == 40 or context.Tick == 60 or context.Tick == 80 or context.Tick == 100 then
        ____E_533A_57DF_8109_51B2(context)
    end
    if context.Tick >= 100 and not context["区域已结算"] then
        ____E_533A_57DF_7ED3_675F_9A71_6563(context)
    end
    if context.Tick >= 100 and #context["雨单位"] <= 0 then
        _____7ED3_675FE(context)
    end
end
local function _____5F00_59CBE_533A_57DF(context)
    if context["已结束"] or not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____7ED3_675FE(context)
        return
    end
    context["区域已启动"] = true
    context["区域X"] = GetUnitX(context["施法者"])
    context["区域Y"] = GetUnitY(context["施法者"])
    context.Tick = 0
    registerManualBuff(
        context["施法者"],
        _____9E7F_76EE_5706BuffID["虹之雨"],
        _____914D_7F6E.E["持续秒"],
        context["每次结算值"],
        {sourceUnit = context["施法者"], effectSourceName = "虹之雨", effectSourceType = "技能"}
    )
    context["周期ID"] = addPeriodicCallback(_____914D_7F6E.E["雨单位生成间隔毫秒"], ____E_533A_57DFTick, context)
end
local function ____E_51B2_950B_7ED3_675F(unit, reason)
    local context = ____E_4E0A_4E0B_6587_8868[_____53D6_5355_4F4DID(unit)]
    if context == nil or context["已结束"] or context["区域已启动"] then
        return
    end
    if reason == "死亡" or reason == "主单位死亡" or reason == "中断" then
        _____7ED3_675FE(context)
        return
    end
    _____5F00_59CBE_533A_57DF(context)
end
local function _____5F00_59CBE_79FB_52A8(variable)
    local context = variable
    if context == nil or context["已结束"] then
        return
    end
    _____79FB_9664_5355_4F4D_6682_505C(context["施法者"], context["暂停来源"])
    if not _____5355_4F4D_5B58_6D3B(context["施法者"]) then
        _____7ED3_675FE(context)
        return
    end
    local startX = GetUnitX(context["施法者"])
    local startY = GetUnitY(context["施法者"])
    local dx = context["目标X"] - startX
    local dy = context["目标Y"] - startY
    local distance = SquareRoot(dx * dx + dy * dy)
    local moveDistance = distance > _____914D_7F6E.E["移动距离"] and _____914D_7F6E.E["移动距离"] or distance
    if not (moveDistance > 1) then
        _____5F00_59CBE_533A_57DF(context)
        return
    end
    local moveId = _____5F00_59CB_51B2_950B(context["施法者"], {
        ["距离"] = moveDistance,
        ["持续时间"] = _____914D_7F6E.E["移动持续秒"],
        ["目标X"] = context["目标X"],
        ["目标Y"] = context["目标Y"],
        ["检查地形"] = true,
        ["暂停单位"] = true,
        ["禁用碰撞"] = true,
        ["位移特效"] = "",
        ["动画名"] = "spell",
        ["结束回调"] = ____E_51B2_950B_7ED3_675F
    })
    if moveId == 0 then
        _____5F00_59CBE_533A_57DF(context)
    end
end
local function _____83B7_53D6E_5165_53E3(hero)
    return _____662F_9E7F_76EE_5706(hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653EE(_entry, caster, _____6280_80FD_5B9E_4F8BID)
    if not _____5355_4F4D_5B58_6D3B(caster) or _____6280_80FD_5B9E_4F8BID == nil then
        _____7ED3_675F_72EC_7ACB_6280_80FD_4F24_5BB3_5B9E_4F8B(_____6280_80FD_5B9E_4F8BID)
        return
    end
    local id = _____53D6_5355_4F4DID(caster)
    local old = ____E_4E0A_4E0B_6587_8868[id]
    if old ~= nil then
        _____7ED3_675FE(old)
    end
    local maxMana = GetUnitStateJapi(caster, UNIT_STATE_MAX_MANA)
    local total = maxMana * (_____914D_7F6E.E["最大魔法基础比例"] + GetHeroLevel(caster) * _____914D_7F6E.E["每英雄等级额外比例"])
    local context = {
        ["施法者"] = caster,
        ["技能实例ID"] = _____6280_80FD_5B9E_4F8BID,
        ["暂停来源"] = "鹿目圆-E-" .. tostring(_____6280_80FD_5B9E_4F8BID),
        ["目标X"] = GetSpellTargetX(),
        ["目标Y"] = GetSpellTargetY(),
        ["区域X"] = 0,
        ["区域Y"] = 0,
        ["每次结算值"] = total / _____914D_7F6E.E["脉冲次数"],
        ["雨单位"] = {},
        ["周期ID"] = 0,
        Tick = 0,
        ["区域已启动"] = false,
        ["区域已结算"] = false,
        ["已结束"] = false
    }
    ____E_4E0A_4E0B_6587_8868[id] = context
    local facing = _____4E24_70B9_89D2_5EA6(
        GetUnitX(caster),
        GetUnitY(caster),
        context["目标X"],
        context["目标Y"]
    )
    SetUnitFacing(caster, facing)
    _____6DFB_52A0_5355_4F4D_6682_505C(caster, context["暂停来源"])
    SetUnitAnimation(caster, "spell")
    createTimedEffect(
        _____914D_7F6E.E["起手特效"],
        context["目标X"],
        context["目标Y"],
        -300,
        _____914D_7F6E.E["起手特效持续秒"]
    )
    addDelayedCallback(_____914D_7F6E.E["起手硬直秒"] * 1000, _____5F00_59CBE_79FB_52A8, context)
end
local function _____6CE8_518CE_5355_4F4D_7C7B_578B(unitTypeId)
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "鹿目圆-虹之雨",
        ["单位类型ID"] = unitTypeId,
        ["技能ID"] = _____914D_7F6E["技能"].E["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6E_5165_53E3,
        ["释放技能"] = _____91CA_653EE,
        ["创建独立技能实例"] = true,
        ["独立技能来源类型"] = "单位技能",
        ["技能实例持续时间秒"] = 7
    })
end
_____6CE8_518CE_5355_4F4D_7C7B_578B(_____914D_7F6E["单位"]["普通类型ID"])
_____6CE8_518CE_5355_4F4D_7C7B_578B(_____914D_7F6E["单位"]["圆神类型ID"])
return ____exports
