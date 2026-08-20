local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____56E0_679C_5C42_72B6_6001_952E, _____786E_4FDD_9E7F_76EE_5706_5F62_6001_6280_80FD, _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027, _____53D6_5706_795E_72B6_6001, _____64AD_653E_5706_795E_964D_4E34_70B9_7279_6548, _____5706_795E_964D_4E34_5C55_793A_82F1_96C4, _____521B_5EFA_5706_795E_6A31_82B1_5355_4F4D, _____5706_795E_964D_4E34_4E0B_964D, _____5706_795E_6301_7EED_8DDF_968F, _____8BBE_7F6E_5706_795E_653B_51FB_529B, _____5706_795E_72B6_6001_5230_671F, _____5237_65B0_56E0_679C_5C42Buff, _____89E6_53D1_56E0_679C_6EE1_5C42, jass, addDelayedCallback, removeDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime, doHeal, registerManualBuff, _____79FB_9664_5355_4F4D_6307_5B9ABuff, _____79FB_9664_5355_4F4D_8D1F_9762Buff, _____4E34_65F6_8C03_6574_653B_901F, _____8C03_6574_73A9_5BB6_5C5E_6027, _____521B_5EFA_70B9_7279_6548, _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168, _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0, _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6, _____53D6_5355_4F4DID, _____5355_4F4D_5B58_6D3B, GetUnitTypeId, GetUnitX, GetUnitY, GetUnitFlyHeight, GetUnitDefaultFlyHeight, GetOwningPlayer, SetPlayerAbilityAvailable, SetUnitState, SetUnitPosition, SetUnitFlyHeight, SetUnitScale, SetUnitInvulnerable, ShowUnit, PauseUnit, UnitApplyTimedLife, UnitAddAbility, UNIT_STATE_LIFE, UNIT_STATE_MAX_LIFE, UNIT_STATE_ATTACK1_BASE, DzSetUnitID, GetUnitStateJapi, SetUnitStateJapi, DzSetUnitModel, UNIT_TIMED_LIFE_BUFF, BJ_DEGTORAD, Cos, Sin, _____914D_7F6E, _____5706_795E_72B6_6001_8868, _____5706_73AF_5F3A_5316_72B6_6001_8868, _____56E0_679C_5C42_72B6_6001_8868, _____5706_73AF_4E4B_7406_65BD_6CD5_4E2D_8868
local ____00_FF0E_914D_7F6E = require("系统.03．技能系统.05．单位技能.04．英雄技能.15．鹿目圆.00．配置")
local _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E = ____00_FF0E_914D_7F6E["鹿目圆单位技能配置"]
local ____10_FF0E_9E7F_76EE_5706 = require("系统.05．Buff系统.03．Buff表.02．英雄.10．鹿目圆")
local _____9E7F_76EE_5706BuffID = ____10_FF0E_9E7F_76EE_5706["鹿目圆BuffID"]
local ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.16．单位技能壳监听注册器")
local _____6CE8_518C_5355_4F4D_6280_80FD_58F3_76D1_542C = ____16_FF0E_5355_4F4D_6280_80FD_58F3_76D1_542C_6CE8_518C_5668["注册单位技能壳监听"]
function _____56E0_679C_5C42_72B6_6001_952E(source, target)
    return (tostring(_____53D6_5355_4F4DID(source)) .. "#") .. tostring(_____53D6_5355_4F4DID(target))
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
function _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027(hero, _____5706_795E_4E2D, _____964D_4E34_5DF2_5B8C_6210)
    if _____964D_4E34_5DF2_5B8C_6210 == nil then
        _____964D_4E34_5DF2_5B8C_6210 = true
    end
    if hero == nil or hero == 0 then
        return
    end
    local owner = GetOwningPlayer(hero)
    local _____6280_80FD = _____914D_7F6E["技能"]
    local _____5706_73AF_4E4B_7406_65BD_6CD5_4E2D = _____5706_73AF_4E4B_7406_65BD_6CD5_4E2D_8868[_____53D6_5355_4F4DID(hero)] == true
    SetPlayerAbilityAvailable(owner, _____6280_80FD["圆神入口"]["类型ID"], not _____5706_795E_4E2D and not _____5706_73AF_4E4B_7406_65BD_6CD5_4E2D)
    SetPlayerAbilityAvailable(owner, _____6280_80FD["旧圆神入口"]["类型ID"], not _____5706_795E_4E2D and not _____5706_73AF_4E4B_7406_65BD_6CD5_4E2D)
    SetPlayerAbilityAvailable(owner, _____6280_80FD["圆神返回"]["类型ID"], _____5706_795E_4E2D and not _____5706_73AF_4E4B_7406_65BD_6CD5_4E2D)
    SetPlayerAbilityAvailable(owner, _____6280_80FD.R["类型ID"], _____5706_795E_4E2D and _____964D_4E34_5DF2_5B8C_6210 and not _____5706_73AF_4E4B_7406_65BD_6CD5_4E2D)
    SetPlayerAbilityAvailable(owner, _____6280_80FD["W蓄力"]["类型ID"], true)
    SetPlayerAbilityAvailable(owner, _____6280_80FD["W发射"]["类型ID"], false)
end
function _____53D6_5706_795E_72B6_6001(hero)
    local state = _____5706_795E_72B6_6001_8868[_____53D6_5355_4F4DID(hero)]
    return state ~= nil and state["英雄"] == hero and state or nil
end
function _____64AD_653E_5706_795E_964D_4E34_70B9_7279_6548(state, _____521B_5EFA_73AF_7ED5_7279_6548)
    local cfg = _____914D_7F6E["圆神"]
    _____521B_5EFA_70B9_7279_6548({
        ["模型路径"] = cfg["降临中心特效路径"],
        X = state["位置X"],
        Y = state["位置Y"],
        Z = cfg["降临中心高度"],
        ["面向角度"] = cfg["降临面向角度"],
        ["缩放"] = cfg["降临特效缩放"],
        ["持续秒"] = cfg["降临特效持续秒"],
        ["动画索引"] = 0
    })
    if not _____521B_5EFA_73AF_7ED5_7279_6548 then
        return
    end
    do
        local i = 1
        while i <= 6 do
            local radians = i * 60 * BJ_DEGTORAD
            _____521B_5EFA_70B9_7279_6548({
                ["模型路径"] = cfg["降临环绕特效路径"],
                X = state["位置X"] + cfg["降临环绕半径"] * Cos(radians),
                Y = state["位置Y"] + cfg["降临环绕半径"] * Sin(radians),
                Z = cfg["降临环绕高度"],
                ["面向角度"] = cfg["降临面向角度"],
                ["缩放"] = cfg["降临特效缩放"],
                ["持续秒"] = cfg["降临特效持续秒"]
            })
            i = i + 1
        end
    end
end
function _____5706_795E_964D_4E34_5C55_793A_82F1_96C4(variable)
    local state = variable
    if state == nil or _____53D6_5706_795E_72B6_6001(state["英雄"]) ~= state or state["阶段"] ~= "降临中" then
        return
    end
    state["降临展示ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(state["英雄"]) or GetUnitTypeId(state["英雄"]) ~= _____914D_7F6E["单位"]["圆神类型ID"] then
        ____exports["结束鹿目圆圆神"](state["英雄"], "降临中断")
        return
    end
    SetUnitPosition(state["英雄"], state["位置X"], state["位置Y"])
    SetUnitInvulnerable(state["英雄"], true)
    PauseUnit(state["英雄"], false)
    ShowUnit(state["英雄"], true)
    _____64AD_653E_5706_795E_964D_4E34_70B9_7279_6548(state, false)
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(state["英雄"])
    SetUnitFlyHeight(state["英雄"], 1000, 0)
    state["降临下降次数"] = 0
    state["降临下降ID"] = addPeriodicCallback(_____914D_7F6E["圆神"]["降临下降间隔毫秒"], _____5706_795E_964D_4E34_4E0B_964D, state)
end
function _____521B_5EFA_5706_795E_6A31_82B1_5355_4F4D(state)
    local shell = _____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168(
        GetOwningPlayer(state["英雄"]),
        _____914D_7F6E["单位壳"]["圆神樱花"],
        state["位置X"],
        state["位置Y"],
        0
    )
    if shell == nil or shell == 0 then
        return
    end
    state["圆神樱花特效"] = shell
    SetUnitScale(shell, _____914D_7F6E["圆神"]["樱花缩放"], _____914D_7F6E["圆神"]["樱花缩放"], _____914D_7F6E["圆神"]["樱花缩放"])
    _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(shell)
    SetUnitFlyHeight(shell, _____914D_7F6E["圆神"]["樱花高度"], 0)
    SetUnitStateJapi(shell, UNIT_STATE_MAX_LIFE, _____914D_7F6E["圆神"]["樱花生命值"])
    SetUnitState(shell, UNIT_STATE_LIFE, _____914D_7F6E["圆神"]["樱花生命值"])
    UnitApplyTimedLife(shell, UNIT_TIMED_LIFE_BUFF, _____914D_7F6E["圆神"]["樱花持续秒"])
    if DzSetUnitModel ~= nil then
        DzSetUnitModel(shell, _____914D_7F6E["圆神"]["樱花模型路径"])
    end
end
function _____5706_795E_964D_4E34_4E0B_964D(variable)
    local state = variable
    if state == nil or _____53D6_5706_795E_72B6_6001(state["英雄"]) ~= state or state["阶段"] ~= "降临中" then
        return
    end
    if state["降临下降次数"] >= _____914D_7F6E["圆神"]["降临下降次数"] then
        removePeriodicCallback(state["降临下降ID"])
        state["降临下降ID"] = 0
        SetUnitInvulnerable(state["英雄"], false)
        SetUnitFlyHeight(state["英雄"], 0, 0)
        _____521B_5EFA_5706_795E_6A31_82B1_5355_4F4D(state)
        state["阶段"] = "已完成"
        state["到期毫秒"] = getServerTime() + _____914D_7F6E["圆神"]["持续秒"] * 1000
        state["状态到期ID"] = addDelayedCallback(_____914D_7F6E["圆神"]["持续秒"] * 1000, _____5706_795E_72B6_6001_5230_671F, {hero = state["英雄"], version = state["版本"]})
        state["持续跟随ID"] = addPeriodicCallback(100, _____5706_795E_6301_7EED_8DDF_968F, state)
        _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027(state["英雄"], true, true)
        return
    end
    state["降临下降次数"] = state["降临下降次数"] + 1
    SetUnitFlyHeight(
        state["英雄"],
        GetUnitFlyHeight(state["英雄"]) - _____914D_7F6E["圆神"]["降临下降步长"],
        0
    )
end
function _____5706_795E_6301_7EED_8DDF_968F(variable)
    local state = variable
    if state == nil or _____53D6_5706_795E_72B6_6001(state["英雄"]) ~= state or state["阶段"] ~= "已完成" then
        return
    end
    if not _____5355_4F4D_5B58_6D3B(state["英雄"]) or GetUnitTypeId(state["英雄"]) ~= _____914D_7F6E["单位"]["圆神类型ID"] then
        ____exports["结束鹿目圆圆神"](state["英雄"], "形态改变")
        return
    end
    if state["圆神樱花特效"] ~= nil and state["圆神樱花特效"] ~= 0 and GetUnitTypeId(state["圆神樱花特效"]) ~= 0 then
        SetUnitPosition(
            state["圆神樱花特效"],
            GetUnitX(state["英雄"]),
            GetUnitY(state["英雄"])
        )
    end
end
function _____8BBE_7F6E_5706_795E_653B_51FB_529B(hero)
    if hero == nil or hero == 0 then
        return
    end
    local _____76EE_6807_653B_51FB_529B = _____914D_7F6E["圆神"]["攻击基础值"] + jass.GetHeroInt(hero, false) * _____914D_7F6E["圆神"]["攻击智力系数"]
    SetUnitStateJapi(hero, UNIT_STATE_ATTACK1_BASE, _____76EE_6807_653B_51FB_529B)
end
function _____5706_795E_72B6_6001_5230_671F(variable)
    local data = variable
    if data == nil then
        return
    end
    local state = _____5706_795E_72B6_6001_8868[_____53D6_5355_4F4DID(data.hero)]
    if state == nil or state["版本"] ~= data.version then
        return
    end
    state["状态到期ID"] = 0
    ____exports["结束鹿目圆圆神"](data.hero, "自然到期")
end
____exports["结束鹿目圆圆神"] = function(hero, _____539F_56E0)
    if _____539F_56E0 == nil then
        _____539F_56E0 = "结束"
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
        if state["降临起始ID"] ~= 0 then
            removeDelayedCallback(state["降临起始ID"])
            state["降临起始ID"] = 0
        end
        if state["降临展示ID"] ~= 0 then
            removeDelayedCallback(state["降临展示ID"])
            state["降临展示ID"] = 0
        end
        if state["降临下降ID"] ~= 0 then
            removePeriodicCallback(state["降临下降ID"])
            state["降临下降ID"] = 0
        end
        if state["状态到期ID"] ~= 0 then
            removeDelayedCallback(state["状态到期ID"])
            state["状态到期ID"] = 0
        end
        if state["持续跟随ID"] ~= 0 then
            removePeriodicCallback(state["持续跟随ID"])
            state["持续跟随ID"] = 0
        end
        if state["圆神樱花特效"] ~= nil and state["圆神樱花特效"] ~= 0 and GetUnitTypeId(state["圆神樱花特效"]) ~= 0 then
            _____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0(state["圆神樱花特效"])
            state["圆神樱花特效"] = nil
        end
        if state["阶段"] == "降临中" then
            SetUnitInvulnerable(hero, false)
            PauseUnit(hero, false)
            ShowUnit(hero, true)
            if _____5355_4F4D_5B58_6D3B(hero) then
                _____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6(hero)
                SetUnitFlyHeight(
                    hero,
                    GetUnitDefaultFlyHeight(hero),
                    0
                )
            end
        end
        _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "魔法伤害", -_____914D_7F6E["圆神"]["魔法伤害加成"])
        __TS__Delete(_____5706_795E_72B6_6001_8868, id)
    end
    if GetUnitTypeId(hero) == _____914D_7F6E["单位"]["圆神类型ID"] then
        DzSetUnitID(hero, _____914D_7F6E["单位"]["普通类型ID"])
    end
    if _____539F_56E0 ~= "死亡" then
        _____8BBE_7F6E_5706_795E_653B_51FB_529B(hero)
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
    local _____5269_4F59_79D2 = (maxExpiry - now) / 1000
    registerManualBuff(
        state["目标"],
        _____9E7F_76EE_5706BuffID["因果之力"],
        _____5269_4F59_79D2 >= 0.1 and _____5269_4F59_79D2 or 0.1,
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
        local ____state__5230_671F_6BEB_79D2_5217_8868_20 = state["到期毫秒列表"]
        ____state__5230_671F_6BEB_79D2_5217_8868_20[#____state__5230_671F_6BEB_79D2_5217_8868_20 + 1] = getServerTime() + _____914D_7F6E["被动"]["单层持续秒"] * 1000
        _____4E34_65F6_8C03_6574_653B_901F(target, _____914D_7F6E["被动"]["每层攻速"])
    end
    _____5237_65B0_56E0_679C_5C42Buff(state)
    _____89E6_53D1_56E0_679C_6EE1_5C42(state)
end
jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
addDelayedCallback = ____require_result_0.addDelayedCallback
removeDelayedCallback = ____require_result_0.removeDelayedCallback
addPeriodicCallback = ____require_result_0.addPeriodicCallback
removePeriodicCallback = ____require_result_0.removePeriodicCallback
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
_____521B_5EFA_70B9_7279_6548 = ____require_result_5["创建点特效"]
local ____require_result_6 = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装")
_____521B_5EFA_5355_4F4D_5E76_767B_8BB0_6392_6CC4_5B89_5168 = ____require_result_6["创建单位并登记排泄安全"]
local ____require_result_7 = require("系统.00．核心系统.01．事件中心.07A．单位排泄")
_____7ACB_5373_79FB_9664_5355_4F4D_5E76_53D6_6D88_6392_6CC4_767B_8BB0 = ____require_result_7["立即移除单位并取消排泄登记"]
local ____require_result_8 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.03．跳跃·击飞.01．跳跃系统.00．共享")
_____786E_4FDD_5355_4F4D_53EF_8BBE_7F6E_98DE_884C_9AD8_5EA6 = ____require_result_8["确保单位可设置飞行高度"]
local ____require_result_9 = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版")
local stringToFourCCSafe = ____require_result_9.stringToFourCCSafe
local ____require_result_10 = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心")
local registerDeathListener = ____require_result_10.registerDeathListener
local ____require_result_11 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_11.registerDamageModifier
local ____require_result_12 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local _____5EF6_540E_4E00_5E27_6267_884C_4F24_5BB3_6D3E_751F_6548_679C = ____require_result_12["延后一帧执行伤害派生效果"]
local ____require_result_13 = require("系统.04．伤害系统.08．技能伤害系统")
local _____9020_6210_5355_4F53_6280_80FD_4F24_5BB3 = ____require_result_13["造成单体技能伤害"]
local ____require_result_14 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.19．战斗公共工具")
_____53D6_5355_4F4DID = ____require_result_14["取单位ID"]
_____5355_4F4D_5B58_6D3B = ____require_result_14["单位存活"]
GetUnitTypeId = jass.GetUnitTypeId
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
GetUnitFlyHeight = jass.GetUnitFlyHeight
GetUnitDefaultFlyHeight = jass.GetUnitDefaultFlyHeight
GetOwningPlayer = jass.GetOwningPlayer
local IsUnitAlly = jass.IsUnitAlly
SetPlayerAbilityAvailable = jass.SetPlayerAbilityAvailable
SetUnitState = jass.SetUnitState
SetUnitPosition = jass.SetUnitPosition
SetUnitFlyHeight = jass.SetUnitFlyHeight
SetUnitScale = jass.SetUnitScale
SetUnitInvulnerable = jass.SetUnitInvulnerable
ShowUnit = jass.ShowUnit
PauseUnit = jass.PauseUnit
local UnitRemoveBuffsEx = jass.UnitRemoveBuffsEx
UnitApplyTimedLife = jass.UnitApplyTimedLife
local ConvertUnitState = jass.ConvertUnitState
UnitAddAbility = jass.UnitAddAbility
local SetUnitAnimation = jass.SetUnitAnimation
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
UNIT_STATE_ATTACK1_BASE = ConvertUnitState(18)
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
DzSetUnitID = japi.DzSetUnitID
GetUnitStateJapi = japi.GetUnitState
SetUnitStateJapi = japi.SetUnitState
DzSetUnitModel = japi.DzSetUnitModel
UNIT_TIMED_LIFE_BUFF = stringToFourCCSafe("BHwe")
local ____jass_bj_DEGTORAD_15 = jass.bj_DEGTORAD
if ____jass_bj_DEGTORAD_15 == nil then
    ____jass_bj_DEGTORAD_15 = 0.017453292519943295
end
BJ_DEGTORAD = ____jass_bj_DEGTORAD_15
Cos = jass.Cos
Sin = jass.Sin
_____914D_7F6E = _____9E7F_76EE_5706_5355_4F4D_6280_80FD_914D_7F6E
_____5706_795E_72B6_6001_8868 = {}
_____5706_73AF_5F3A_5316_72B6_6001_8868 = {}
_____56E0_679C_5C42_72B6_6001_8868 = {}
local _____5706_795E_666E_653B_6D3E_751F_961F_5217 = {}
_____5706_73AF_4E4B_7406_65BD_6CD5_4E2D_8868 = {}
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
--- R 成功后直到全部箭道与脉冲清理完成，都不恢复圆神入口技能。
____exports["设置鹿目圆圆环之理施法状态"] = function(hero, _____65BD_6CD5_4E2D)
    if hero == nil or hero == 0 then
        return
    end
    local id = _____53D6_5355_4F4DID(hero)
    if _____65BD_6CD5_4E2D then
        _____5706_73AF_4E4B_7406_65BD_6CD5_4E2D_8868[id] = true
    else
        __TS__Delete(_____5706_73AF_4E4B_7406_65BD_6CD5_4E2D_8868, id)
    end
    _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027(
        hero,
        ____exports["是鹿目圆圆神"](hero),
        true
    )
end
local function _____5706_795E_964D_4E34_8D77_59CB(variable)
    local data = variable
    if data == nil then
        return
    end
    local state = _____53D6_5706_795E_72B6_6001(data.hero)
    if state == nil or state["版本"] ~= data.version or state["阶段"] ~= "降临中" then
        return
    end
    state["降临起始ID"] = 0
    if not _____5355_4F4D_5B58_6D3B(state["英雄"]) or GetUnitTypeId(state["英雄"]) ~= _____914D_7F6E["单位"]["圆神类型ID"] then
        ____exports["结束鹿目圆圆神"](state["英雄"], "降临中断")
        return
    end
    state["位置X"] = GetUnitX(state["英雄"])
    state["位置Y"] = GetUnitY(state["英雄"])
    UnitRemoveBuffsEx(
        state["英雄"],
        false,
        true,
        false,
        false,
        false,
        false,
        true
    )
    ShowUnit(state["英雄"], false)
    PauseUnit(state["英雄"], true)
    _____64AD_653E_5706_795E_964D_4E34_70B9_7279_6548(state, true)
    state["降临展示ID"] = addDelayedCallback(_____914D_7F6E["圆神"]["降临展示延迟毫秒"], _____5706_795E_964D_4E34_5C55_793A_82F1_96C4, state)
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
    local ____hero_16 = hero
    _____5706_795E_72B6_6001_7248_672C = _____5706_795E_72B6_6001_7248_672C + 1
    local state = {
        ["英雄"] = ____hero_16,
        ["到期毫秒"] = 0,
        ["版本"] = _____5706_795E_72B6_6001_7248_672C,
        ["阶段"] = "降临中",
        ["位置X"] = GetUnitX(hero),
        ["位置Y"] = GetUnitY(hero),
        ["降临起始ID"] = 0,
        ["降临展示ID"] = 0,
        ["降临下降ID"] = 0,
        ["状态到期ID"] = 0,
        ["持续跟随ID"] = 0,
        ["降临下降次数"] = 0,
        ["圆神樱花特效"] = nil
    }
    _____5706_795E_72B6_6001_8868[_____53D6_5355_4F4DID(hero)] = state
    _____8BBE_7F6E_5706_795E_653B_51FB_529B(hero)
    _____8C03_6574_73A9_5BB6_5C5E_6027(hero, "魔法伤害", _____914D_7F6E["圆神"]["魔法伤害加成"])
    _____79FB_9664_5355_4F4D_8D1F_9762Buff(hero, true)
    registerManualBuff(
        hero,
        _____9E7F_76EE_5706BuffID["圆神之力"],
        _____914D_7F6E["圆神"]["持续秒"] + _____914D_7F6E["圆神"]["降临Buff额外持续秒"],
        _____914D_7F6E["圆神"]["魔法伤害加成"],
        {sourceUnit = hero, stack = 1}
    )
    _____540C_6B65_5706_795E_6280_80FD_53EF_7528_6027(hero, true, false)
    state["降临起始ID"] = addDelayedCallback(_____914D_7F6E["圆神"]["降临起始延迟毫秒"], _____5706_795E_964D_4E34_8D77_59CB, {hero = hero, version = state["版本"]})
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
        local ____hero_17 = hero
        local ____temp_18 = now + _____914D_7F6E.D["持续秒"] * 1000
        _____5706_73AF_5F3A_5316_7248_672C = _____5706_73AF_5F3A_5316_7248_672C + 1
        state = {
            ["英雄"] = ____hero_17,
            ["层数"] = 1,
            ["到期毫秒"] = ____temp_18,
            ["版本"] = _____5706_73AF_5F3A_5316_7248_672C,
            ["W立即满蓄"] = ____exports["是鹿目圆圆神"](hero)
        }
        _____5706_73AF_5F3A_5316_72B6_6001_8868[id] = state
    else
        state["层数"] = state["层数"] + 1
        state["到期毫秒"] = now + _____914D_7F6E.D["持续秒"] * 1000
        local ____state_19 = state
        _____5706_73AF_5F3A_5316_7248_672C = _____5706_73AF_5F3A_5316_7248_672C + 1
        ____state_19["版本"] = _____5706_73AF_5F3A_5316_7248_672C
        if ____exports["是鹿目圆圆神"](hero) then
            state["W立即满蓄"] = true
        end
    end
    _____5237_65B0_5706_73AF_5F3A_5316Buff(state)
    local _____5269_4F59_6BEB_79D2 = state["到期毫秒"] - now
    addDelayedCallback(_____5269_4F59_6BEB_79D2 >= 1 and _____5269_4F59_6BEB_79D2 or 1, _____5706_73AF_5F3A_5316_5230_671F, {hero = hero, version = state["版本"]})
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
                goto __continue103
            end
            if not _____5355_4F4D_5B58_6D3B(state["来源"]) or not _____5355_4F4D_5B58_6D3B(state["目标"]) then
                _____6E05_7406_56E0_679C_5C42_72B6_6001(key, state)
                goto __continue103
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
                    goto __continue103
                end
                _____5237_65B0_56E0_679C_5C42Buff(state)
            end
        end
        ::__continue103::
    end
end
local function _____7ED3_7B97_5706_795E_666E_653B_6D3E_751F_961F_5217()
    while #_____5706_795E_666E_653B_6D3E_751F_961F_5217 > 0 do
        do
            local record = table.remove(_____5706_795E_666E_653B_6D3E_751F_961F_5217, 1)
            if record == nil or not _____5355_4F4D_5B58_6D3B(record["来源"]) or not _____5355_4F4D_5B58_6D3B(record["目标"]) then
                goto __continue114
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
        ::__continue114::
    end
end
local function _____5706_795E_666E_653B_4F24_5BB3_4FEE_6B63(context)
    local ____opt_result_23
    if context ~= nil then
        ____opt_result_23 = context.attacker
    end
    local attacker = ____opt_result_23
    if not ____exports["是鹿目圆圆神"](attacker) then
        local ____opt_result_26
        if context ~= nil then
            ____opt_result_26 = context.currentDamage
        end
        local ____opt_result_26_27 = ____opt_result_26
        if ____opt_result_26_27 == nil then
            ____opt_result_26_27 = 0
        end
        return ____opt_result_26_27
    end
    local ____opt_result_30
    if context ~= nil then
        ____opt_result_30 = context.isNormalAttack
    end
    local ____temp_34 = ____opt_result_30 ~= true
    if not ____temp_34 then
        local ____opt_result_33
        if context ~= nil then
            ____opt_result_33 = context.isPhysicalDamage
        end
        ____temp_34 = ____opt_result_33 ~= true
    end
    if ____temp_34 then
        return context.currentDamage
    end
    local ____opt_result_37
    if context ~= nil then
        ____opt_result_37 = context.isWrappedSkillDamage
    end
    if ____opt_result_37 == true then
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
                goto __continue123
            end
            if state["来源"] == dyingUnit or state["目标"] == dyingUnit then
                _____6E05_7406_56E0_679C_5C42_72B6_6001(key, state)
            end
        end
        ::__continue123::
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
