local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____53D6_5355_4F4DID, _____56E0_679C_5C42_72B6_6001_952E, _____5355_4F4D_5B58_6D3B, _____786E_4FDD_9E7F_76EE_5706_5F62_6001_6280_80FD, _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027, _____5237_65B0_56E0_679C_5C42Buff, _____89E6_53D1_56E0_679C_6EE1_5C42, getServerTime, doHeal, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____79FB_9664_5355_4F4D_8D1F_9762Buff, _____4E34_65F6_8C03_6574_653B_901F, _____8C03_6574_73A9_5BB6_5C5E_6027, GetHandleId, GetUnitTypeId, GetUnitState, GetOwningPlayer, SetPlayerAbilityAvailable, UnitAddAbility, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, DzSetUnitID, GetUnitStateJapi, _____914D_7F6E, _____5706_795E_72B6_6001_8868, _____5706_73AF_5F3A_5316_72B6_6001_8868, _____56E0_679C_5C42_72B6_6001_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.00．配置")
local _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["鹿目圆单位技能配置"]
local ____10_FF0E_9E7F_76EE_5706 = require("系统.05．Buff系统.03．Buff表.02．英雄.10．鹿目圆")
local _____9E7F_76EE_5706BuffID = ____10_FF0E_9E7F_76EE_5706["鹿目圆BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____53D6_5355_4F4DID(unit)
    return (unit == nil or unit == 0) and 0 or GetHandleId(unit)
end
function _____56E0_679C_5C42_72B6_6001_952E(source, target)
    return (tostring(_____53D6_5355_4F4DID(source)) .. "#") .. tostring(_____53D6_5355_4F4DID(target))
end
function _____5355_4F4D_5B58_6D3B(unit)
    return unit ~= nil and unit ~= 0 and GetUnitTypeId(unit) ~= 0 and GetUnitState(unit, UNIT_STATE_LIFE) > 0.405
end
function _____786E_4FDD_9E7F_76EE_5706_5F62_6001_6280_80FD(hero)
    if hero == nil or hero == 0 then
        return
    end
    local _____6280_80FD = _____914D_7F6E["技能"]
    UnitAddAbility(hero, _____6280_80FD.Q["类型ID"])
    UnitAddAbility(hero, _____6280_80FD["W蓄力"]["类型ID"])
    UnitAddAbility(hero, _____6280_80FD["W发射"]["类型ID"])
    UnitAddAbility(hero, _____6280_80FD.E["类型ID"])
    UnitAddAbility(hero, _____6280_80FD.D["类型ID"])
    UnitAddAbility(hero, _____6280_80FD["圆神入口"]["类型ID"])
    UnitAddAbility(hero, _____6280_80FD["圆神返回"]["类型ID"])
    UnitAddAbility(hero, _____6280_80FD.R["类型ID"])
end
function _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027(hero, _____5706_795E_4E2D)
    if hero == nil or hero == 0 then
        return
    end
    local owner = GetOwningPlayer(hero)
    local _____6280_80FD = _____914D_7F6E["技能"]
    SetPlayerAbilityAvailable(owner, _____6280_80FD["圆神入口"]["类型ID"], not _____5706_795E_4E2D)
    SetPlayerAbilityAvailable(owner, _____6280_80FD["旧圆神入口"]["类型ID"], not _____5706_795E_4E2D)
    SetPlayerAbilityAvailable(owner, _____6280_80FD["圆神返回"]["类型ID"], _____5706_795E_4E2D)
    SetPlayerAbilityAvailable(owner, _____6280_80FD.R["类型ID"], _____5706_795E_4E2D)
    SetPlayerAbilityAvailable(owner, _____6280_80FD["W蓄力"]["类型ID"], true)
    SetPlayerAbilityAvailable(owner, _____6280_80FD["W发射"]["类型ID"], false)
end
____exports["结束鹿目圆圆神"] = function(hero, ______539F_56E0)
    if ______539F_56E0 == nil then
        ______539F_56E0 = "结束"
    end
    if hero == nil or hero == 0 then
        return
    end
    local id = _____53D6_5355_4F4DID(hero)
    local state = _____5706_795E_72B6_6001_8868[id]
    if state == nil and GetUnitTypeId(hero) ~= _____914D_7F6E["单位"]["圆神类型ID"] then
        return
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(hero, _____9E7F_76EE_5706BuffID["圆神之力"])
    if state ~= nil then
        _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "魔法伤害", -_____914D_7F6E["圆神"]["魔法伤害加成"])
        __TS__Delete(_____5706_795E_72B6_6001_8868, id)
    end
    if GetUnitTypeId(hero) == _____914D_7F6E["单位"]["圆神类型ID"] then
        DzSetUnitID(hero, _____914D_7F6E["单位"]["普通类型ID"])
    end
    _____786E_4FDD_9E7F_76EE_5706_5F62_6001_6280_80FD(hero)
    _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027(hero, false)
end
____exports["清除鹿目圆圆环强化"] = function(hero)
    if hero == nil or hero == 0 then
        return
    end
    __TS__Delete(
        _____5706_73AF_5F3A_5316_72B6_6001_8868,
        _____53D6_5355_4F4DID(hero)
    )
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(hero, _____9E7F_76EE_5706BuffID["圆环之力一次强化"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(hero, _____9E7F_76EE_5706BuffID["圆环之力二次强化"])
end
function _____5237_65B0_56E0_679C_5C42Buff(state)
    local count = #state["到期毫秒列表"]
    if count <= 0 then
        _____79FB_9664_5355_4F4D_6307_5B9ABuff(state["目标"], _____9E7F_76EE_5706BuffID["因果之力"])
        return
    end
    local now = getServerTime()
    local maxExpiry = now
    do
        local i = 0
        while i < #state["到期毫秒列表"] do
            if state["到期毫秒列表"][i + 1] > maxExpiry then
                maxExpiry = state["到期毫秒列表"][i + 1]
            end
            i = i + 1
        end
    end
    registerManualBuff(
        state["目标"],
        _____9E7F_76EE_5706BuffID["因果之力"],
        math.max(0.1, (maxExpiry - now) / 1000),
        _____914D_7F6E["被动"]["每层攻速"],
        {sourceUnit = state["来源"], stack = count}
    )
end
function _____89E6_53D1_56E0_679C_6EE1_5C42(state)
    local now = getServerTime()
    if #state["到期毫秒列表"] < _____914D_7F6E["被动"]["最大层数"] or now < state["满层下次触发毫秒"] then
        return
    end
    state["满层下次触发毫秒"] = now + _____914D_7F6E["被动"]["满层触发内置冷却秒"] * 1000
    _____79FB_9664_5355_4F4D_8D1F_9762Buff(state["目标"], false)
    local maxLife = GetUnitStateJapi(state["目标"], UNIT_STATE_MAX_LIFE)
    if maxLife > 0 then
        doHeal({
            HealSource = state["来源"],
            HealTarget = state["目标"],
            HealAmount = maxLife * _____914D_7F6E["被动"]["满层治疗最大生命比例"],
            ItemHeal = false,
            HealEffect = true,
            HealShowText = true
        })
    end
end
____exports["添加鹿目圆因果层"] = function(source, target)
    if not _____5355_4F4D_5B58_6D3B(source) or not _____5355_4F4D_5B58_6D3B(target) then
        return
    end
    local key = _____56E0_679C_5C42_72B6_6001_952E(source, target)
    local state = _____56E0_679C_5C42_72B6_6001_8868[key]
    if state == nil then
        state = {["来源"] = source, ["目标"] = target, ["到期毫秒列表"] = {}, ["满层下次触发毫秒"] = 0}
        _____56E0_679C_5C42_72B6_6001_8868[key] = state
    end
    if #state["到期毫秒列表"] < _____914D_7F6E["被动"]["最大层数"] then
        local ____state__5230_671F_6BEB_79D2_5217_8868_16 = state["到期毫秒列表"]
        ____state__5230_671F_6BEB_79D2_5217_8868_16[#____state__5230_671F_6BEB_79D2_5217_8868_16 + 1] = getServerTime() + _____914D_7F6E["被动"]["单层持续秒"] * 1000
        _____4E34_65F6_8C03_6574_653B_901F(target, _____914D_7F6E["被动"]["每层攻速"])
    end
    _____5237_65B0_56E0_679C_5C42Buff(state)
    _____89E6_53D1_56E0_679C_6EE1_5C42(state)
end
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local addPeriodicCallback = ____require_result_0.addPeriodicCallback
getServerTime = ____require_result_0.getServerTime
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.01．核心功能")
doHeal = ____require_result_1.doHeal
local ____require_result_2 = require("系统.05．Buff系统.00．Buff系统")
registerManualBuff = ____require_result_2.registerManualBuff
_____79FB_9664_5355_4F4D_6307_5B9ABuff = ____require_result_2["移除单位指定Buff"]
local ____require_result_3 = require("系统.05．Buff系统.05．Buff清除函数")
_____79FB_9664_5355_4F4D_8D1F_9762Buff = ____require_result_3["移除单位负面Buff"]
local ____require_result_4 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.16．属性位移与指令")
_____4E34_65F6_8C03_6574_653B_901F = ____require_result_4["临时调整攻速"]
_____8C03_6574_73A9_5BB6_5C5E_6027 = ____require_result_4["调整玩家属性"]
local ____require_result_5 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedUnitEffect = ____require_result_5.createTimedUnitEffect
local ____require_result_6 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_6.registerDeathListener
local ____require_result_7 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_7.registerDamageModifier
local ____require_result_8 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C = ____require_result_8["延后一帧执行伤害派生效果"]
local ____require_result_9 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_9["造成单体技能伤害"]
GetHandleId = jass.GetHandleId
GetUnitTypeId = jass.GetUnitTypeId
GetUnitState = jass.GetUnitState
GetOwningPlayer = jass.GetOwningPlayer
local IsUnitAlly = jass.IsUnitAlly
SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
UnitAddAbility = jass.UnitAddAbility
local SetUnitAnimation = jass.SetUnitAnimation
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
DzSetUnitID = japi.DzSetUnitID
GetUnitStateJapi = japi.GetUnitState
_____914D_7F6E = _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E
_____5706_795E_72B6_6001_8868 = {}
_____5706_73AF_5F3A_5316_72B6_6001_8868 = {}
_____56E0_679C_5C42_72B6_6001_8868 = {}
local _____5706_795E_666E_653B_6D3E_751F_961F_5217 = {}
local _____5706_795E_72B6_6001_7248_672C = 0
local _____5706_73AF_5F3A_5316_7248_672C = 0
local _____88AB_52A8_5C42_6570_9A71_52A8_5DF2_6CE8_518C = false
local _____5171_4EAB_72B6_6001_5DF2_6CE8_518C = false
____exports["是鹿目圆"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local typeId = GetUnitTypeId(unit)
    return typeId == _____914D_7F6E["单位"]["普通类型ID"] or typeId == _____914D_7F6E["单位"]["圆神类型ID"]
end
____exports["是鹿目圆圆神"] = function(unit)
    if unit == nil or unit == 0 then
        return false
    end
    local state = _____5706_795E_72B6_6001_8868[_____53D6_5355_4F4DID(unit)]
    return state ~= nil and state["英雄"] == unit and GetUnitTypeId(unit) == _____914D_7F6E["单位"]["圆神类型ID"]
end
____exports["鹿目圆伤害无视魔抗"] = function(unit)
    return ____exports["是鹿目圆圆神"](unit)
end
____exports["获取圆神剩余秒"] = function(unit)
    local state = _____5706_795E_72B6_6001_8868[_____53D6_5355_4F4DID(unit)]
    if state == nil or state["英雄"] ~= unit then
        return 0
    end
    local remaining = state["到期毫秒"] - getServerTime()
    return remaining > 0 and remaining / 1000 or 0
end
local function _____64AD_653E_5706_795E_964D_4E34_8868_73B0(hero)
    local _____7279_6548_5217_8868 = _____914D_7F6E["圆神"]["降临特效"]
    do
        local i = 0
        while i < #_____7279_6548_5217_8868 do
            createTimedUnitEffect(hero, "origin", _____7279_6548_5217_8868[i + 1], _____914D_7F6E["圆神"]["降临特效持续秒"])
            i = i + 1
        end
    end
end
local function _____5706_795E_72B6_6001_5230_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    local state = _____5706_795E_72B6_6001_8868[_____53D6_5355_4F4DID(data.hero)]
    if state == nil or state["版本"] ~= data.version then
        return
    end
    ____exports["结束鹿目圆圆神"](data.hero, "自然到期")
end
____exports["进入鹿目圆圆神"] = function(hero)
    if not _____5355_4F4D_5B58_6D3B(hero) or GetUnitTypeId(hero) ~= _____914D_7F6E["单位"]["普通类型ID"] then
        return false
    end
    if ____exports["是鹿目圆圆神"](hero) then
        return false
    end
    _____786E_4FDD_9E7F_76EE_5706_5F62_6001_6280_80FD(hero)
    DzSetUnitID(hero, _____914D_7F6E["单位"]["圆神类型ID"])
    _____786E_4FDD_9E7F_76EE_5706_5F62_6001_6280_80FD(hero)
    _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "魔法伤害", _____914D_7F6E["圆神"]["魔法伤害加成"])
    _____79FB_9664_5355_4F4D_8D1F_9762Buff(hero, true)
    registerManualBuff(
        hero,
        _____9E7F_76EE_5706BuffID["圆神之力"],
        _____914D_7F6E["圆神"]["持续秒"],
        _____914D_7F6E["圆神"]["魔法伤害加成"],
        {sourceUnit = hero, stack = 1}
    )
    _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027(hero, true)
    _____64AD_653E_5706_795E_964D_4E34_8868_73B0(hero)
    local ____hero_10 = hero
    local ____temp_11 = getServerTime() + _____914D_7F6E["圆神"]["持续秒"] * 1000
    _____5706_795E_72B6_6001_7248_672C = _____5706_795E_72B6_6001_7248_672C + 1
    local state = {["英雄"] = ____hero_10, ["到期毫秒"] = ____temp_11, ["版本"] = _____5706_795E_72B6_6001_7248_672C}
    _____5706_795E_72B6_6001_8868[_____53D6_5355_4F4DID(hero)] = state
    addDelayedCallback(_____914D_7F6E["圆神"]["持续秒"] * 1000, _____5706_795E_72B6_6001_5230_671F, {hero = hero, version = state["版本"]})
    return true
end
local function _____83B7_53D6_5706_795E_5165_53E3_4E0A_4E0B_6587(hero)
    return GetUnitTypeId(hero) == _____914D_7F6E["单位"]["普通类型ID"] and ({["英雄"] = hero}) or nil
end
local function _____91CA_653E_5706_795E_5165_53E3(_context, hero)
    if not ____exports["进入鹿目圆圆神"](hero) then
        return
    end
    SetUnitAnimation(hero, "spell")
end
local function _____83B7_53D6_5706_795E_8FD4_56DE_4E0A_4E0B_6587(hero)
    return ____exports["是鹿目圆圆神"](hero) and ({["英雄"] = hero}) or nil
end
local function _____91CA_653E_5706_795E_8FD4_56DE(_context, hero)
    ____exports["结束鹿目圆圆神"](hero, "主动返回")
end
local function _____5237_65B0_5706_73AF_5F3A_5316Buff(state)
    local hero = state["英雄"]
    local now = getServerTime()
    local remaining = (state["到期毫秒"] - now) / 1000
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(hero, _____9E7F_76EE_5706BuffID["圆环之力一次强化"])
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(hero, _____9E7F_76EE_5706BuffID["圆环之力二次强化"])
    if state["层数"] <= 0 or not (remaining > 0) then
        return
    end
    local buffId = state["层数"] >= 2 and _____9E7F_76EE_5706BuffID["圆环之力二次强化"] or _____9E7F_76EE_5706BuffID["圆环之力一次强化"]
    registerManualBuff(
        hero,
        buffId,
        remaining,
        state["层数"],
        {sourceUnit = hero, stack = state["层数"]}
    )
end
local function _____5706_73AF_5F3A_5316_5230_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    local state = _____5706_73AF_5F3A_5316_72B6_6001_8868[_____53D6_5355_4F4DID(data.hero)]
    if state == nil or state["版本"] ~= data.version then
        return
    end
    ____exports["清除鹿目圆圆环强化"](data.hero)
end
____exports["激活鹿目圆圆环强化"] = function(hero)
    if not _____5355_4F4D_5B58_6D3B(hero) or not ____exports["是鹿目圆"](hero) then
        return 0
    end
    local now = getServerTime()
    local id = _____53D6_5355_4F4DID(hero)
    local state = _____5706_73AF_5F3A_5316_72B6_6001_8868[id]
    if state == nil or state["到期毫秒"] <= now then
        local ____hero_12 = hero
        local ____temp_13 = now + _____914D_7F6E.D["持续秒"] * 1000
        local ____temp_14 = now + _____914D_7F6E.D["二次使用等待秒"] * 1000
        _____5706_73AF_5F3A_5316_7248_672C = _____5706_73AF_5F3A_5316_7248_672C + 1
        state = {
            ["英雄"] = ____hero_12,
            ["层数"] = 1,
            ["到期毫秒"] = ____temp_13,
            ["二次可用毫秒"] = ____temp_14,
            ["版本"] = _____5706_73AF_5F3A_5316_7248_672C,
            ["W立即满蓄"] = ____exports["是鹿目圆圆神"](hero)
        }
        _____5706_73AF_5F3A_5316_72B6_6001_8868[id] = state
    elseif state["层数"] == 1 and now >= state["二次可用毫秒"] then
        state["层数"] = 2
        state["到期毫秒"] = now + _____914D_7F6E.D["持续秒"] * 1000
        local ____state_15 = state
        _____5706_73AF_5F3A_5316_7248_672C = _____5706_73AF_5F3A_5316_7248_672C + 1
        ____state_15["版本"] = _____5706_73AF_5F3A_5316_7248_672C
        if ____exports["是鹿目圆圆神"](hero) then
            state["W立即满蓄"] = true
        end
    else
        return 0
    end
    _____5237_65B0_5706_73AF_5F3A_5316Buff(state)
    addDelayedCallback(
        math.max(1, state["到期毫秒"] - now),
        _____5706_73AF_5F3A_5316_5230_671F,
        {hero = hero, version = state["版本"]}
    )
    return state["层数"]
end
____exports["获取鹿目圆圆环强化层数"] = function(hero)
    local state = _____5706_73AF_5F3A_5316_72B6_6001_8868[_____53D6_5355_4F4DID(hero)]
    if state == nil or state["到期毫秒"] <= getServerTime() then
        return 0
    end
    return state["层数"]
end
____exports["消耗鹿目圆圆环强化"] = function(hero)
    local state = _____5706_73AF_5F3A_5316_72B6_6001_8868[_____53D6_5355_4F4DID(hero)]
    if state == nil or state["到期毫秒"] <= getServerTime() then
        return 0
    end
    local layers = state["层数"]
    ____exports["清除鹿目圆圆环强化"](hero)
    return layers
end
____exports["消耗鹿目圆W立即满蓄标记"] = function(hero)
    local state = _____5706_73AF_5F3A_5316_72B6_6001_8868[_____53D6_5355_4F4DID(hero)]
    if state == nil or state["到期毫秒"] <= getServerTime() or state["W立即满蓄"] ~= true then
        return false
    end
    state["W立即满蓄"] = false
    return true
end
____exports["鹿目圆治疗友军"] = function(source, target, life, mana, _____53E0_52A0_56E0_679C)
    if mana == nil then
        mana = 0
    end
    if _____53E0_52A0_56E0_679C == nil then
        _____53E0_52A0_56E0_679C = true
    end
    if not _____5355_4F4D_5B58_6D3B(source) or not _____5355_4F4D_5B58_6D3B(target) then
        return 0
    end
    local actual = doHeal({
        HealSource = source,
        HealTarget = target,
        HealAmount = life,
        HealManaAmount = mana,
        ItemHeal = false,
        HealEffect = life > 0,
        HealShowText = life > 0,
        ManaEffect = mana > 0,
        ManaShowText = mana > 0
    })
    if actual > 0 and _____53E0_52A0_56E0_679C and ____exports["是鹿目圆"](source) and IsUnitAlly(
        target,
        GetOwningPlayer(source)
    ) == true then
        ____exports["添加鹿目圆因果层"](source, target)
    end
    return actual
end
local function _____6E05_7406_56E0_679C_5C42_72B6_6001(key, state)
    local count = #state["到期毫秒列表"]
    if count > 0 and state["目标"] ~= nil and state["目标"] ~= 0 then
        _____4E34_65F6_8C03_6574_653B_901F(state["目标"], -_____914D_7F6E["被动"]["每层攻速"] * count)
    end
    _____79FB_9664_5355_4F4D_6307_5B9ABuff(state["目标"], _____9E7F_76EE_5706BuffID["因果之力"])
    __TS__Delete(_____56E0_679C_5C42_72B6_6001_8868, key)
end
local function _____63A8_8FDB_9E7F_76EE_5706_56E0_679C_5C42()
    local now = getServerTime()
    for key in pairs(_____56E0_679C_5C42_72B6_6001_8868) do
        do
            local state = _____56E0_679C_5C42_72B6_6001_8868[key]
            if state == nil then
                goto __continue72
            end
            if not _____5355_4F4D_5B58_6D3B(state["来源"]) or not _____5355_4F4D_5B58_6D3B(state["目标"]) then
                _____6E05_7406_56E0_679C_5C42_72B6_6001(key, state)
                goto __continue72
            end
            local removed = 0
            local kept = {}
            do
                local i = 0
                while i < #state["到期毫秒列表"] do
                    if state["到期毫秒列表"][i + 1] <= now then
                        removed = removed + 1
                    else
                        kept[#kept + 1] = state["到期毫秒列表"][i + 1]
                    end
                    i = i + 1
                end
            end
            if removed > 0 then
                state["到期毫秒列表"] = kept
                _____4E34_65F6_8C03_6574_653B_901F(state["目标"], -_____914D_7F6E["被动"]["每层攻速"] * removed)
                if #kept <= 0 then
                    _____6E05_7406_56E0_679C_5C42_72B6_6001(key, state)
                    goto __continue72
                end
                _____5237_65B0_56E0_679C_5C42Buff(state)
            end
        end
        ::__continue72::
    end
end
local function _____7ED3_7B97_5706_795E_666E_653B_6D3E_751F_961F_5217()
    while #_____5706_795E_666E_653B_6D3E_751F_961F_5217 > 0 do
        do
            local record = table.remove(_____5706_795E_666E_653B_6D3E_751F_961F_5217, 1)
            if record == nil or not _____5355_4F4D_5B58_6D3B(record["来源"]) or not _____5355_4F4D_5B58_6D3B(record["目标"]) then
                goto __continue83
            end
            _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3({
                ["来源"] = record["来源"],
                ["目标"] = record["目标"],
                ["伤害"] = record["伤害"],
                ["伤害类型"] = DAMAGE_TYPE_MAGIC,
                attack = true,
                ranged = record.ranged,
                attackType = ATTACK_TYPE_NORMAL,
                weaponType = WEAPON_TYPE_WHOKNOWS,
                ["来源类型"] = "普攻强化",
                ["技能ID"] = _____914D_7F6E["技能"]["圆神入口"]["类型ID"],
                ["标签"] = "鹿目圆-圆神魔法普攻",
                ["参与技能伤害加成"] = false,
                ["忽略魔法抗性"] = true
            })
        end
        ::__continue83::
    end
end
local function _____5706_795E_666E_653B_4F24_5BB3_4FEE_6B63(context)
    local ____opt_result_19
    if context ~= nil then
        ____opt_result_19 = context.attacker
    end
    local attacker = ____opt_result_19
    if not ____exports["是鹿目圆圆神"](attacker) then
        local ____opt_result_22
        if context ~= nil then
            ____opt_result_22 = context.currentDamage
        end
        local ____opt_result_22_23 = ____opt_result_22
        if ____opt_result_22_23 == nil then
            ____opt_result_22_23 = 0
        end
        return ____opt_result_22_23
    end
    local ____opt_result_26
    if context ~= nil then
        ____opt_result_26 = context.isNormalAttack
    end
    local ____temp_30 = ____opt_result_26 ~= true
    if not ____temp_30 then
        local ____opt_result_29
        if context ~= nil then
            ____opt_result_29 = context.isPhysicalDamage
        end
        ____temp_30 = ____opt_result_29 ~= true
    end
    if ____temp_30 then
        return context.currentDamage
    end
    local ____opt_result_33
    if context ~= nil then
        ____opt_result_33 = context.isWrappedSkillDamage
    end
    if ____opt_result_33 == true then
        return context.currentDamage
    end
    local target = context.target
    local amount = context.baseDamage
    if target == nil or target == 0 or not (amount > 0) then
        return 0
    end
    _____5706_795E_666E_653B_6D3E_751F_961F_5217[#_____5706_795E_666E_653B_6D3E_751F_961F_5217 + 1] = {["来源"] = attacker, ["目标"] = target, ["伤害"] = amount, ranged = context.isRangedAttack == true}
    _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C(_____7ED3_7B97_5706_795E_666E_653B_6D3E_751F_961F_5217)
    return 0
end
local function _____9E7F_76EE_5706_6B7B_4EA1_6E05_7406(dyingUnit, _killingUnit)
    if not ____exports["是鹿目圆"](dyingUnit) then
        return
    end
    ____exports["结束鹿目圆圆神"](dyingUnit, "死亡")
    ____exports["清除鹿目圆圆环强化"](dyingUnit)
    for key in pairs(_____56E0_679C_5C42_72B6_6001_8868) do
        do
            local state = _____56E0_679C_5C42_72B6_6001_8868[key]
            if state == nil then
                goto __continue92
            end
            if state["来源"] == dyingUnit or state["目标"] == dyingUnit then
                _____6E05_7406_56E0_679C_5C42_72B6_6001(key, state)
            end
        end
        ::__continue92::
    end
end
____exports["注册鹿目圆状态与被动"] = function()
    if _____5171_4EAB_72B6_6001_5DF2_6CE8_518C then
        return
    end
    _____5171_4EAB_72B6_6001_5DF2_6CE8_518C = true
    local _____6280_80FD = _____914D_7F6E["技能"]
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "鹿目圆-进入圆神",
        ["单位类型ID"] = _____914D_7F6E["单位"]["普通类型ID"],
        ["技能ID"] = _____6280_80FD["圆神入口"]["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6_5706_795E_5165_53E3_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5706_795E_5165_53E3,
        ["创建独立技能实例"] = false
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "鹿目圆-进入圆神（旧入口）",
        ["单位类型ID"] = _____914D_7F6E["单位"]["普通类型ID"],
        ["技能ID"] = _____6280_80FD["旧圆神入口"]["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6_5706_795E_5165_53E3_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5706_795E_5165_53E3,
        ["创建独立技能实例"] = false
    })
    _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C({
        ["名称"] = "鹿目圆-结束圆神",
        ["单位类型ID"] = _____914D_7F6E["单位"]["圆神类型ID"],
        ["技能ID"] = _____6280_80FD["圆神返回"]["类型ID"],
        ["获取或创建上下文"] = _____83B7_53D6_5706_795E_8FD4_56DE_4E0A_4E0B_6587,
        ["释放技能"] = _____91CA_653E_5706_795E_8FD4_56DE,
        ["创建独立技能实例"] = false
    })
    registerDamageModifier(_____5706_795E_666E_653B_4F24_5BB3_4FEE_6B63, 100)
    registerDeathListener(_____9E7F_76EE_5706_6B7B_4EA1_6E05_7406)
    if not _____88AB_52A8_5C42_6570_9A71_52A8_5DF2_6CE8_518C then
        _____88AB_52A8_5C42_6570_9A71_52A8_5DF2_6CE8_518C = true
        addPeriodicCallback(100, _____63A8_8FDB_9E7F_76EE_5706_56E0_679C_5C42)
    end
end
____exports["注册鹿目圆状态与被动"]()
return ____exports
