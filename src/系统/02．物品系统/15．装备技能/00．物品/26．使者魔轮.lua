local ____lualib = require("lualib_bundle")
local __TS__ArraySplice = ____lualib.__TS__ArraySplice
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local _____4ECE_5217_8868_79FB_9664_9B54_76FEID, _____5C1D_8BD5_5173_95ED_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668, _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE, ____on_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668Tick, _____53D7_4F24_5355_4F4D_5728_9B54_76FE_5185, _____5438_6536_4F7F_8005_9B54_8F6E_4F24_5BB3, ____on_4F7F_8005_9B54_8F6E_4F24_5BB3_4E8B_4EF6, offTick10ms, GetUnitX, GetUnitY, IsUnitAlly, IsUnitOwnedByPlayer, GetUnitState, SetUnitState, DestroyEffect, UNIT_STATE_LIFE, _____4F7F_8005_9B54_8F6E_9B54_76FE_8868, _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868, _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____4F7F_8005_9B54_8F6E_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["使者魔轮物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____4F7F_8005_9B54_8F6E_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["使者魔轮配置"]
function _____4ECE_5217_8868_79FB_9664_9B54_76FEID(id)
    do
        local i = #_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 - 1
        while i >= 0 do
            if _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868[i + 1] == id then
                __TS__ArraySplice(_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868, i, 1)
                return
            end
            i = i - 1
        end
    end
end
function _____5C1D_8BD5_5173_95ED_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
    if not _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    if #_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 > 0 then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 = false
    offTick10ms(____on_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668Tick)
end
function _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
    local _____5B9E_4F8B = _____4F7F_8005_9B54_8F6E_9B54_76FE_8868[id]
    if _____5B9E_4F8B == nil then
        return
    end
    __TS__Delete(_____4F7F_8005_9B54_8F6E_9B54_76FE_8868, id)
    _____4ECE_5217_8868_79FB_9664_9B54_76FEID(id)
    if _____5B9E_4F8B["特效"] ~= nil and _____5B9E_4F8B["特效"] ~= 0 then
        DestroyEffect(_____5B9E_4F8B["特效"])
    end
    _____5C1D_8BD5_5173_95ED_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
end
function ____on_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668Tick()
    do
        local i = #_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 - 1
        while i >= 0 do
            do
                local id = _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868[i + 1]
                local _____5B9E_4F8B = _____4F7F_8005_9B54_8F6E_9B54_76FE_8868[id]
                if _____5B9E_4F8B == nil or _____5B9E_4F8B["护盾值"] <= 0 then
                    _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
                    goto __continue36
                end
                _____5B9E_4F8B["剩余时间"] = _____5B9E_4F8B["剩余时间"] - 0.01
                if _____5B9E_4F8B["剩余时间"] <= 0 then
                    _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
                end
            end
            ::__continue36::
            i = i - 1
        end
    end
    _____5C1D_8BD5_5173_95ED_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
end
function _____53D7_4F24_5355_4F4D_5728_9B54_76FE_5185(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D)
    if _____53D7_4F24_5355_4F4D == nil or _____53D7_4F24_5355_4F4D == 0 then
        return false
    end
    local dx = GetUnitX(_____53D7_4F24_5355_4F4D) - _____5B9E_4F8B.x
    local dy = GetUnitY(_____53D7_4F24_5355_4F4D) - _____5B9E_4F8B.y
    if dx * dx + dy * dy > _____5B9E_4F8B["作用半径"] * _____5B9E_4F8B["作用半径"] then
        return false
    end
    if IsUnitAlly(_____53D7_4F24_5355_4F4D, _____5B9E_4F8B["施法玩家"]) then
        return true
    end
    return IsUnitOwnedByPlayer(_____53D7_4F24_5355_4F4D, _____5B9E_4F8B["施法玩家"])
end
function _____5438_6536_4F7F_8005_9B54_8F6E_4F24_5BB3(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D, _____4F24_5BB3_503C)
    SetUnitState(
        _____53D7_4F24_5355_4F4D,
        UNIT_STATE_LIFE,
        GetUnitState(_____53D7_4F24_5355_4F4D, UNIT_STATE_LIFE) + _____4F24_5BB3_503C
    )
    _____5B9E_4F8B["护盾值"] = _____5B9E_4F8B["护盾值"] - _____4F24_5BB3_503C
end
function ____on_4F7F_8005_9B54_8F6E_4F24_5BB3_4E8B_4EF6(_____53D7_4F24_5355_4F4D, ______653B_51FB_8005, _____4F24_5BB3_503C, _snapshot)
    if _____53D7_4F24_5355_4F4D == nil or _____53D7_4F24_5355_4F4D == 0 or not (_____4F24_5BB3_503C > 0) then
        return
    end
    do
        local i = #_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 - 1
        while i >= 0 do
            do
                local id = _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868[i + 1]
                local _____5B9E_4F8B = _____4F7F_8005_9B54_8F6E_9B54_76FE_8868[id]
                if _____5B9E_4F8B == nil or _____5B9E_4F8B["护盾值"] <= 0 then
                    _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
                    goto __continue49
                end
                if not _____53D7_4F24_5355_4F4D_5728_9B54_76FE_5185(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D) then
                    goto __continue49
                end
                _____5438_6536_4F7F_8005_9B54_8F6E_4F24_5BB3(_____5B9E_4F8B, _____53D7_4F24_5355_4F4D, _____4F24_5BB3_503C)
                if _____5B9E_4F8B["护盾值"] <= 0 then
                    _____79FB_9664_4F7F_8005_9B54_8F6E_9B54_76FE(id)
                end
            end
            ::__continue49::
            i = i - 1
        end
    end
end
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local Atan2BJ = ____require_result_0.Atan2BJ
local ____require_result_1 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_1.registerAppliedFinalDamageListener
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.06．伤害修正回调")
local registerDamageModifier = ____require_result_2.registerDamageModifier
local ____require_result_3 = require("系统.00．核心系统.05．中心计时器")
local onTick10ms = ____require_result_3.onTick10ms
offTick10ms = ____require_result_3.offTick10ms
local ____require_result_4 = require("lib.扩展函数.Star扩展函数.04．EC扩展库")
local EC_CreateEffect = ____require_result_4.EC_CreateEffect
local ____require_result_5 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_5.UnitHasItemOfTypeBJ
local ____require_result_6 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_6["减少魔法值"]
local ____require_result_7 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.24．魔法吸收护盾.01．魔法吸收护盾")
local _____64AD_653E_9B54_6CD5_5438_6536_62A4_76FE_7279_6548 = ____require_result_7["播放魔法吸收护盾特效"]
local GetItemTypeId = jass.GetItemTypeId
local GetHandleId = jass.GetHandleId
local GetOwningPlayer = jass.GetOwningPlayer
GetUnitX = jass.GetUnitX
GetUnitY = jass.GetUnitY
IsUnitAlly = jass.IsUnitAlly
IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer
GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
SetUnitState = jass.SetUnitState
DestroyEffect = jass.DestroyEffect
UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
_____4F7F_8005_9B54_8F6E_9B54_76FE_8868 = {}
_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 = {}
local _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C = false
_____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 = false
local _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_88AB_52A8_4FEE_6B63 = false
local function _____662F_5426_4E3A_4F7F_8005_9B54_8F6E(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    if _____4F7F_8005_9B54_8F6E_7269_54C1ID <= 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____4F7F_8005_9B54_8F6E_7269_54C1ID
end
local function _____5355_4F4D_6301_6709_4F7F_8005_9B54_8F6E(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 or _____4F7F_8005_9B54_8F6E_7269_54C1ID <= 0 then
        return false
    end
    return UnitHasItemOfTypeBJ(_____5355_4F4D, _____4F7F_8005_9B54_8F6E_7269_54C1ID) == true
end
local function _____53D6_6700_5C0F_503C(a, b)
    return a < b and a or b
end
local function _____8BA1_7B97_4F7F_8005_9B54_8F6E_53D7_51FB_7279_6548_89D2_5EA6(_____53D7_4F24_5355_4F4D, _____4F24_5BB3_6765_6E90)
    if _____53D7_4F24_5355_4F4D == nil or _____53D7_4F24_5355_4F4D == 0 then
        return 0
    end
    if _____4F24_5BB3_6765_6E90 == nil or _____4F24_5BB3_6765_6E90 == 0 then
        return 0
    end
    return Atan2BJ(
        GetUnitY(_____4F24_5BB3_6765_6E90) - GetUnitY(_____53D7_4F24_5355_4F4D),
        GetUnitX(_____4F24_5BB3_6765_6E90) - GetUnitX(_____53D7_4F24_5355_4F4D)
    )
end
local function ____on_4F7F_8005_9B54_8F6E_88AB_52A8_4F24_5BB3_4FEE_6B63(context)
    local _____53D7_4F24_5355_4F4D = context.target
    if _____53D7_4F24_5355_4F4D == nil or _____53D7_4F24_5355_4F4D == 0 then
        return context.currentDamage
    end
    if not (context.currentDamage > 0) then
        return context.currentDamage
    end
    if context.isPhysicalDamage then
        return context.currentDamage
    end
    if not _____5355_4F4D_6301_6709_4F7F_8005_9B54_8F6E(_____53D7_4F24_5355_4F4D) then
        return context.currentDamage
    end
    local _____5F53_524D_9B54_6CD5 = GetUnitState(_____53D7_4F24_5355_4F4D, UNIT_STATE_MANA)
    if not (_____5F53_524D_9B54_6CD5 > 0) then
        return context.currentDamage
    end
    local _____6700_5927_9B54_6CD5 = GetUnitStateJapi(_____53D7_4F24_5355_4F4D, UNIT_STATE_MAX_MANA)
    if not (_____6700_5927_9B54_6CD5 > 0) then
        return context.currentDamage
    end
    local _____89E6_53D1_95E8_69DB = _____6700_5927_9B54_6CD5 * _____4F7F_8005_9B54_8F6E_914D_7F6E["被动最低魔法百分比"] + _____4F7F_8005_9B54_8F6E_914D_7F6E["被动最低魔法固定值"]
    if not (_____5F53_524D_9B54_6CD5 > _____89E6_53D1_95E8_69DB) then
        return context.currentDamage
    end
    local _____6BD4_4F8B_5438_6536_4E0A_9650 = context.currentDamage * _____4F7F_8005_9B54_8F6E_914D_7F6E["被动魔法吸收比例"]
    local _____9B54_6CD5_5438_6536_4E0A_9650 = _____5F53_524D_9B54_6CD5 * _____4F7F_8005_9B54_8F6E_914D_7F6E["被动每点魔法吸收伤害"]
    local _____5438_6536_91CF = _____53D6_6700_5C0F_503C(_____6BD4_4F8B_5438_6536_4E0A_9650, _____9B54_6CD5_5438_6536_4E0A_9650)
    if not (_____5438_6536_91CF > 0) then
        return context.currentDamage
    end
    local _____6D88_8017_9B54_6CD5 = _____5438_6536_91CF / _____4F7F_8005_9B54_8F6E_914D_7F6E["被动每点魔法吸收伤害"]
    _____51CF_5C11_9B54_6CD5_503C(_____53D7_4F24_5355_4F4D, _____6D88_8017_9B54_6CD5, true, true)
    _____64AD_653E_9B54_6CD5_5438_6536_62A4_76FE_7279_6548({
        ["单位"] = _____53D7_4F24_5355_4F4D,
        ["是否有特效"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动是否有特效"],
        ["特效路径"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动特效路径"],
        ["特效挂点"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动特效挂点"],
        ["特效绑定单位"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动特效绑定单位"],
        ["特效持续时间"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["被动特效持续时间"],
        ["特效朝向角度"] = _____8BA1_7B97_4F7F_8005_9B54_8F6E_53D7_51FB_7279_6548_89D2_5EA6(_____53D7_4F24_5355_4F4D, context.attacker)
    })
    return context.currentDamage - _____5438_6536_91CF
end
local function _____521D_59CB_5316_4F7F_8005_9B54_8F6E_88AB_52A8()
    if _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_88AB_52A8_4FEE_6B63 then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_88AB_52A8_4FEE_6B63 = true
    registerDamageModifier(____on_4F7F_8005_9B54_8F6E_88AB_52A8_4F24_5BB3_4FEE_6B63, 35)
end
local function _____786E_4FDD_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
    if _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668 = true
    onTick10ms(____on_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668Tick)
end
local function _____786E_4FDD_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C()
    if _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C = true
    registerAppliedFinalDamageListener(____on_4F7F_8005_9B54_8F6E_4F24_5BB3_4E8B_4EF6)
end
local function _____6CE8_518C_4F7F_8005_9B54_8F6E_9B54_76FE(_____65BD_6CD5_5355_4F4D, x, y, _____62A4_76FE_503C)
    local _____7279_6548 = EC_CreateEffect(
        _____4F7F_8005_9B54_8F6E_914D_7F6E["特效路径"],
        x,
        y,
        0,
        0,
        _____4F7F_8005_9B54_8F6E_914D_7F6E["特效尺寸"],
        1,
        -1
    )
    if _____7279_6548 == nil or _____7279_6548 == 0 then
        return
    end
    local id = GetHandleId(_____7279_6548)
    if id <= 0 then
        DestroyEffect(_____7279_6548)
        return
    end
    _____4F7F_8005_9B54_8F6E_9B54_76FE_8868[id] = {
        id = id,
        ["施法单位"] = _____65BD_6CD5_5355_4F4D,
        ["施法玩家"] = GetOwningPlayer(_____65BD_6CD5_5355_4F4D),
        ["特效"] = _____7279_6548,
        x = x,
        y = y,
        ["剩余时间"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["持续时间"],
        ["作用半径"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["作用半径"],
        ["护盾值"] = _____62A4_76FE_503C
    }
    _____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868[#_____4F7F_8005_9B54_8F6E_9B54_76FEID_5217_8868 + 1] = id
    _____786E_4FDD_4F7F_8005_9B54_8F6E_4F24_5BB3_76D1_542C()
    _____786E_4FDD_4F7F_8005_9B54_8F6E_4E2D_5FC3_8BA1_65F6_5668()
end
____exports["处理使者魔轮使用"] = function(_____4E0A_4E0B_6587)
    if not _____662F_5426_4E3A_4F7F_8005_9B54_8F6E(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____6700_5927_9B54_6CD5 = GetUnitStateJapi(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MAX_MANA)
    local _____6D88_8017_9B54_6CD5 = _____6700_5927_9B54_6CD5 * _____4F7F_8005_9B54_8F6E_914D_7F6E["消耗魔法比例"]
    if not (_____6D88_8017_9B54_6CD5 > 0) then
        return
    end
    SetUnitState(
        _____65BD_6CD5_5355_4F4D,
        UNIT_STATE_MANA,
        GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MANA) - _____6D88_8017_9B54_6CD5
    )
    _____6CE8_518C_4F7F_8005_9B54_8F6E_9B54_76FE(_____65BD_6CD5_5355_4F4D, _____4E0A_4E0B_6587["目标X"], _____4E0A_4E0B_6587["目标Y"], _____6D88_8017_9B54_6CD5)
end
_____521D_59CB_5316_4F7F_8005_9B54_8F6E_88AB_52A8()
return ____exports
