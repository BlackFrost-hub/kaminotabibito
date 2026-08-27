--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00．配置")
local _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["藤原妹红单位技能配置"]
local ____00A_FF0E_8868_73B0_5DE5_5177 = require("系统.03．技能系统.05．单位技能.04．英雄技能.04．藤原妹红.00A．表现工具")
local _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["播放藤原妹红单位音效"]
local _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548 = ____00A_FF0E_8868_73B0_5DE5_5177["创建藤原妹红点特效"]
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
local removePeriodicCallback = ____require_result_0.removePeriodicCallback
local getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.08．机制触发.10．致命伤害保命与限时免疫")
local _____521B_5EFA_81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB = ____require_result_1["创建致命伤害保命与限时免疫"]
local ____require_result_2 = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接")
local registerPlayerHeroListener = ____require_result_2.registerPlayerHeroListener
local getRegisteredPlayerHero = ____require_result_2.getRegisteredPlayerHero
local ____require_result_3 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3 = ____require_result_3["造成批量AOE技能伤害"]
local ____require_result_4 = require("系统.03．技能系统.05．单位技能.00．公共.03．暴击被动公共工具")
local _____83B7_53D6_8303_56F4_654C_519B = ____require_result_4["获取范围敌军"]
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
local _____8BFB_53D6_5355_4F4D_653B_51FB_529B = ____require_result_5["读取单位攻击力"]
local _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D = ____require_result_5["读取单位最大生命"]
local _____5355_4F4D_5B58_6D3B = ____require_result_5["单位存活"]
local ____require_result_6 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_6.stringToFourCCSafe
local GetUnitTypeId = jass.GetUnitTypeId
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local Cos = jass.Cos
local Sin = jass.Sin
local SetUnitInvulnerable = jass.SetUnitInvulnerable
local PauseUnit = jass.PauseUnit
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_ANCIENT = jass.UNIT_TYPE_ANCIENT
local UNIT_TYPE_MECHANICAL = jass.UNIT_TYPE_MECHANICAL
local UNIT_TYPE_STRUCTURE = jass.UNIT_TYPE_STRUCTURE
local UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_FIRE = jass.DAMAGE_TYPE_FIRE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["单位类型ID"])
local _____88AB_52A8_6280_80FDID = stringToFourCCSafe(_____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["被动"]["技能ID"])
local GetUnitStateJapi = japi.GetUnitState
local _____88AB_52A8_72B6_6001_8868 = {}
local function _____53D6_5355_4F4D_53E5_67C4ID(unit)
    return (unit == nil or unit == 0) and 0 or (jass:GetHandleId(unit) or 0)
end
local function _____53D6_88AB_52A8_72B6_6001(unit)
    return _____88AB_52A8_72B6_6001_8868[_____53D6_5355_4F4D_53E5_67C4ID(unit)]
end
local function _____88AB_52A8_6761_4EF6_5141_8BB8_89E6_53D1(context)
    local ____opt_result_9
    if context ~= nil then
        ____opt_result_9 = context.target
    end
    local unit = ____opt_result_9
    local state = _____53D6_88AB_52A8_72B6_6001(unit)
    local ____temp_12 = state == nil
    if not ____temp_12 then
        local ____opt_10 = state["重生上下文"]
        ____temp_12 = (____opt_10 and ____opt_10["重生中"]) == true
    end
    if ____temp_12 then
        return false
    end
    if getServerTime() < state["冷却截止时间Ms"] then
        return false
    end
    local maximumMana = GetUnitStateJapi(unit, UNIT_STATE_MAX_MANA)
    if not (maximumMana > 0) then
        return false
    end
    return GetUnitState(unit, UNIT_STATE_MANA) / maximumMana >= _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["被动"]["魔法值百分比门槛"] * 0.01
end
local function _____88AB_52A8_514D_75AB_4F24_5BB3_8FC7_6EE4(context)
    local ____53D6_88AB_52A8_72B6_6001_16 = _____53D6_88AB_52A8_72B6_6001
    local ____opt_result_15
    if context ~= nil then
        ____opt_result_15 = context.target
    end
    local state = ____53D6_88AB_52A8_72B6_6001_16(____opt_result_15)
    local ____opt_17 = state and state["重生上下文"]
    return (____opt_17 and ____opt_17["重生中"]) == true
end
local function _____88AB_52A8_91CD_751F_76EE_6807_5141_8BB8_547D_4E2D(source, target)
    return _____5355_4F4D_5B58_6D3B(target) and not IsUnitType(target, UNIT_TYPE_ANCIENT) and not IsUnitType(target, UNIT_TYPE_MECHANICAL) and not IsUnitType(target, UNIT_TYPE_STRUCTURE) and jass:IsUnitEnemy(
        target,
        jass:GetOwningPlayer(source)
    )
end
local function _____51C6_5907_88AB_52A8_91CD_751F_4F24_5BB3(target, _index, variable)
    local context = variable
    if context == nil or not _____88AB_52A8_91CD_751F_76EE_6807_5141_8BB8_547D_4E2D(context["单位"], target) then
        return nil
    end
    return {
        ["伤害"] = context["攻击力伤害"] * _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["被动"]["复活伤害攻击力倍率"],
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        attack = true,
        ranged = false,
        attackType = ATTACK_TYPE_NORMAL,
        weaponType = WEAPON_TYPE_WHOKNOWS
    }
end
local function _____7ED3_675F_88AB_52A8_91CD_751F(context)
    if not context["重生中"] then
        return
    end
    context["重生中"] = false
    if context["回调ID"] ~= 0 then
        removePeriodicCallback(context["回调ID"])
        context["回调ID"] = 0
    end
    local maximumLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(context["单位"])
    if maximumLife > 0 then
        SetUnitState(context["单位"], UNIT_STATE_LIFE, maximumLife * _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["被动"]["重生生命百分比"] * 0.01)
    end
    _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(
        _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["被动"]["重生爆炸特效"],
        GetUnitX(context["单位"]),
        GetUnitY(context["单位"])
    )
    SetUnitInvulnerable(context["单位"], false)
    PauseUnit(context["单位"], false)
    local state = _____53D6_88AB_52A8_72B6_6001(context["单位"])
    if state ~= nil and state["重生上下文"] == context then
        state["重生上下文"] = nil
    end
end
local function _____85E4_539F_59B9_7EA2_88AB_52A8_91CD_751FTick(variable)
    local context = variable
    if context == nil or not context["重生中"] then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(context["单位"]) then
        _____7ED3_675F_88AB_52A8_91CD_751F(context)
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["被动"]
    if context["重生阶段"] >= cfg["爆炸阶段"] then
        _____7ED3_675F_88AB_52A8_91CD_751F(context)
        return
    end
    local x = GetUnitX(context["单位"])
    local y = GetUnitY(context["单位"])
    if not context["火焰已播放"] and context["重生阶段"] >= cfg["火焰阶段"] then
        context["火焰已播放"] = true
        _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(cfg["火焰特效"], x, y)
    end
    do
        local i = 1
        while i <= cfg["环形数量"] do
            local angle = cfg["环形间隔角度"] * i
            local radians = angle * 0.017453292519943295
            _____521B_5EFA_85E4_539F_59B9_7EA2_70B9_7279_6548(
                cfg["环形特效"],
                x + Cos(radians) * cfg["环形半径"] * context["环形层级"],
                y + Sin(radians) * cfg["环形半径"] * context["环形层级"],
                angle
            )
            i = i + 1
        end
    end
    local targets = _____83B7_53D6_8303_56F4_654C_519B(context["单位"], x, y, cfg["伤害范围"])
    _____9020_6210_6279_91CFAOE_6280_80FD_4F24_5BB3({
        ["来源"] = context["单位"],
        ["目标列表"] = targets,
        ["伤害类型"] = DAMAGE_TYPE_FIRE,
        ["技能ID"] = _____88AB_52A8_6280_80FDID,
        ["来源类型"] = "单位技能",
        ["标签"] = "藤原妹红-不死鸟重生",
        ["每目标处理器"] = _____51C6_5907_88AB_52A8_91CD_751F_4F24_5BB3,
        ["变量"] = context
    })
    context["重生阶段"] = context["重生阶段"] + cfg["重生阶段增量"]
    context["环形层级"] = context["环形层级"] + 1
    local maximumLife = _____8BFB_53D6_5355_4F4D_6700_5927_751F_547D(context["单位"])
    if maximumLife > 0 then
        SetUnitState(context["单位"], UNIT_STATE_LIFE, maximumLife * context["重生阶段"])
    end
end
local function _____89E6_53D1_85E4_539F_59B9_7EA2_88AB_52A8_91CD_751F(event)
    local ____opt_result_23
    if event ~= nil then
        ____opt_result_23 = event["单位"]
    end
    local unit = ____opt_result_23
    local state = _____53D6_88AB_52A8_72B6_6001(unit)
    if state == nil then
        return
    end
    local cfg = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["被动"]
    state["冷却截止时间Ms"] = getServerTime() + cfg["被动冷却秒"] * 1000
    local context = {
        ["单位"] = unit,
        ["攻击力伤害"] = _____8BFB_53D6_5355_4F4D_653B_51FB_529B(unit),
        ["重生阶段"] = 0,
        ["环形层级"] = 1,
        ["火焰已播放"] = false,
        ["回调ID"] = 0,
        ["重生中"] = true
    }
    state["重生上下文"] = context
    SetUnitState(unit, UNIT_STATE_LIFE, 1)
    SetUnitInvulnerable(unit, true)
    PauseUnit(unit, true)
    _____64AD_653E_85E4_539F_59B9_7EA2_5355_4F4D_97F3_6548(unit, cfg["起手音效键"])
    context["回调ID"] = addPeriodicCallback(cfg["重生周期毫秒"], _____85E4_539F_59B9_7EA2_88AB_52A8_91CD_751FTick, context)
end
local function _____521B_5EFA_85E4_539F_59B9_7EA2_88AB_52A8_72B6_6001(unit)
    if unit == nil or unit == 0 or GetUnitTypeId(unit) ~= _____85E4_539F_59B9_7EA2_5355_4F4D_7C7B_578BID then
        return
    end
    local unitId = _____53D6_5355_4F4D_53E5_67C4ID(unit)
    if unitId == 0 or _____88AB_52A8_72B6_6001_8868[unitId] ~= nil then
        return
    end
    local state = {["单位"] = unit, ["冷却截止时间Ms"] = 0}
    _____88AB_52A8_72B6_6001_8868[unitId] = state
    state["控制器"] = _____521B_5EFA_81F4_547D_4F24_5BB3_4FDD_547D_4E0E_9650_65F6_514D_75AB({
        ["名称"] = "藤原妹红-不死鸟重生",
        ["单位"] = unit,
        ["固定生命下限"] = 1,
        ["免疫持续秒"] = _____85E4_539F_59B9_7EA2_5355_4F4D_6280_80FD_914D_7F6E["被动"]["重生无敌持续秒"],
        ["生命下限修正优先级"] = -100,
        ["免疫修正优先级"] = -99,
        ["过滤致命伤害"] = _____88AB_52A8_6761_4EF6_5141_8BB8_89E6_53D1,
        ["过滤免疫伤害"] = _____88AB_52A8_514D_75AB_4F24_5BB3_8FC7_6EE4,
        ["on触发"] = _____89E6_53D1_85E4_539F_59B9_7EA2_88AB_52A8_91CD_751F
    })
end
local function _____85E4_539F_59B9_7EA2_73A9_5BB6_82F1_96C4_6CE8_518C(_player, hero)
    _____521B_5EFA_85E4_539F_59B9_7EA2_88AB_52A8_72B6_6001(hero)
end
local function _____521D_59CB_5316_5DF2_6CE8_518C_85E4_539F_59B9_7EA2()
    do
        local i = 0
        while i < 16 do
            _____521B_5EFA_85E4_539F_59B9_7EA2_88AB_52A8_72B6_6001(getRegisteredPlayerHero(jass:Player(i)))
            i = i + 1
        end
    end
end
registerPlayerHeroListener(_____85E4_539F_59B9_7EA2_73A9_5BB6_82F1_96C4_6CE8_518C)
_____521D_59CB_5316_5DF2_6CE8_518C_85E4_539F_59B9_7EA2()
return ____exports
