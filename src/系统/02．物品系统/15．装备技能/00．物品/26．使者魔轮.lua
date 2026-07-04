--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____4F7F_8005_9B54_8F6E_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["使者魔轮物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____4F7F_8005_9B54_8F6E_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["使者魔轮配置"]
local ____13_FF0E_4F24_5BB3_4FEE_6B63_9608_503C_89E6_53D1 = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.13．伤害修正阈值触发")
local _____521B_5EFA_4F24_5BB3_4FEE_6B63_9608_503C_89E6_53D1 = ____13_FF0E_4F24_5BB3_4FEE_6B63_9608_503C_89E6_53D1["创建伤害修正阈值触发"]
local ____21_FF0E_533A_57DF_627F_4F24_5438_6536_573A = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.09．装备通用机制.21．区域承伤吸收场")
local _____521B_5EFA_533A_57DF_627F_4F24_5438_6536_573A = ____21_FF0E_533A_57DF_627F_4F24_5438_6536_573A["创建区域承伤吸收场"]
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("lib.扩展函数.BJ函数.12．数学函数")
local Atan2BJ = ____require_result_0.Atan2BJ
local ____require_result_1 = require("系统.04．伤害系统.02．治疗系统.07．减少生命值")
local _____51CF_5C11_9B54_6CD5_503C = ____require_result_1["减少魔法值"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.24．魔法吸收护盾.01．魔法吸收护盾")
local _____64AD_653E_9B54_6CD5_5438_6536_62A4_76FE_7279_6548 = ____require_result_2["播放魔法吸收护盾特效"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetUnitStateJapi = japi.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
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
local function _____8BA1_7B97_4F7F_8005_9B54_8F6E_88AB_52A8_4F24_5BB3_4FEE_6B63(event)
    return ____on_4F7F_8005_9B54_8F6E_88AB_52A8_4F24_5BB3_4FEE_6B63(event["上下文"])
end
local function _____521D_59CB_5316_4F7F_8005_9B54_8F6E_88AB_52A8()
    if _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_88AB_52A8_4FEE_6B63 then
        return
    end
    _____5DF2_6CE8_518C_4F7F_8005_9B54_8F6E_88AB_52A8_4FEE_6B63 = true
    _____521B_5EFA_4F24_5BB3_4FEE_6B63_9608_503C_89E6_53D1({
        ["名称"] = "使者魔轮被动魔法吸收",
        ["装备名"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["装备名称"],
        ["持有者"] = "受击者",
        ["优先级"] = 35,
        ["计算伤害"] = _____8BA1_7B97_4F7F_8005_9B54_8F6E_88AB_52A8_4F24_5BB3_4FEE_6B63
    })
end
local function _____6CE8_518C_4F7F_8005_9B54_8F6E_9B54_76FE(_____65BD_6CD5_5355_4F4D, x, y, _____62A4_76FE_503C)
    _____521B_5EFA_533A_57DF_627F_4F24_5438_6536_573A({
        ["名称"] = "使者魔轮魔盾",
        ["施法单位"] = _____65BD_6CD5_5355_4F4D,
        X = x,
        Y = y,
        ["持续秒数"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["持续时间"],
        ["作用半径"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["作用半径"],
        ["吸收值"] = _____62A4_76FE_503C,
        ["特效路径"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["特效路径"],
        ["特效尺寸"] = _____4F7F_8005_9B54_8F6E_914D_7F6E["特效尺寸"],
        ["只影响友军"] = true,
        ["包含同玩家单位"] = true,
        ["吸收量限制为剩余值"] = false
    })
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
