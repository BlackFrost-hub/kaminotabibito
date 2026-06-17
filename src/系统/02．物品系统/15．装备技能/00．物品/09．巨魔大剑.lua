local ____lualib = require("lualib_bundle")
local Map = ____lualib.Map
local __TS__New = ____lualib.__TS__New
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5DE8_9B54_5927_5251_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["巨魔大剑物品ID"]
local ____00_FF0E_65BD_6CD5_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.02．施法触发.00．施法触发配置")
local _____5DE8_9B54_5927_5251_914D_7F6E = ____00_FF0E_65BD_6CD5_89E6_53D1_914D_7F6E["巨魔大剑配置"]
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.02．计时器")
local createDelayedCall = ____require_result_0.createDelayedCall
local cancelDelayedCall = ____require_result_0.cancelDelayedCall
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_1.createTimedEffect
local ____require_result_2 = require("系统.04．伤害系统.00．伤害计算.04．主计算流程")
local registerAppliedFinalDamageListener = ____require_result_2.registerAppliedFinalDamageListener
local ____require_result_3 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.08．扩散伤害.扩散伤害")
local _____6269_6563_4F24_5BB3 = ____require_result_3["扩散伤害"]
local ____require_result_4 = require("lib.扩展函数.物品相关函数.物品判断函数")
local UnitHasItemOfTypeBJ = ____require_result_4.UnitHasItemOfTypeBJ
local ____require_result_5 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．便捷短函数集合.08．同类伤害类型")
local _____83B7_53D6_540C_7C7B_4F24_5BB3_7C7B_578B = ____require_result_5["获取同类伤害类型"]
local jass = require("jass.common")
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetHandleId = jass.GetHandleId
local IsUnitType = jass.IsUnitType
local UNIT_TYPE_HERO = jass.UNIT_TYPE_HERO
local _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668 = __TS__New(Map)
local _____5DF2_6CE8_518C_5DE8_9B54_5927_5251_9996_4F24_76D1_542C = false
local function _____5355_4F4D_6301_6709_5DE8_9B54_5927_5251(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return false
    end
    if _____5DE8_9B54_5927_5251_7269_54C1ID <= 0 then
        return false
    end
    local result = UnitHasItemOfTypeBJ(_____5355_4F4D, _____5DE8_9B54_5927_5251_7269_54C1ID) == true
    return result
end
local function _____5DE8_9B54_5927_5251_6761_4EF6_6210_7ACB(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D)
    if not IsUnitType(_____65BD_6CD5_5355_4F4D, UNIT_TYPE_HERO) then
        return false
    end
    if not _____5355_4F4D_6301_6709_5DE8_9B54_5927_5251(_____65BD_6CD5_5355_4F4D) then
        return false
    end
    local result = _____76EE_6807_5355_4F4D ~= nil and _____76EE_6807_5355_4F4D ~= 0
    return result
end
local function _____83B7_53D6_5DE8_9B54_5927_5251_7A97_53E3_952E(_____5355_4F4D)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return 0
    end
    return GetHandleId(_____5355_4F4D)
end
local function _____6E05_7406_5DE8_9B54_5927_5251_7A97_53E3(_____5355_4F4D, _____53D6_6D88_8BA1_65F6_5668)
    if _____53D6_6D88_8BA1_65F6_5668 == nil then
        _____53D6_6D88_8BA1_65F6_5668 = true
    end
    local _____952E = _____83B7_53D6_5DE8_9B54_5927_5251_7A97_53E3_952E(_____5355_4F4D)
    if _____952E <= 0 then
        return
    end
    local _____53E5_67C4 = _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:get(_____952E)
    if _____53D6_6D88_8BA1_65F6_5668 and _____53E5_67C4 ~= nil then
        cancelDelayedCall(_____53E5_67C4)
    end
    _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:delete(_____952E)
end
local function _____6253_5F00_5DE8_9B54_5927_5251_7A97_53E3(_____5355_4F4D)
    local _____952E = _____83B7_53D6_5DE8_9B54_5927_5251_7A97_53E3_952E(_____5355_4F4D)
    if _____952E <= 0 then
        return
    end
    _____6E05_7406_5DE8_9B54_5927_5251_7A97_53E3(_____5355_4F4D, true)
    local _____53E5_67C4 = nil
    _____53E5_67C4 = createDelayedCall(
        _____5DE8_9B54_5927_5251_914D_7F6E["持续时间"],
        function()
            if _____53E5_67C4 == nil then
                return
            end
            if _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:get(_____952E) == _____53E5_67C4 then
                _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:delete(_____952E)
            end
        end
    )
    _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:set(_____952E, _____53E5_67C4)
end
local function _____5904_7406_5DE8_9B54_5927_5251_9996_4F24(target, attacker, applied, snapshot)
    if target == nil or attacker == nil or not (applied >= 1) then
        return
    end
    if snapshot ~= nil and snapshot.isTrueDamage == true then
        return
    end
    if not _____5355_4F4D_6301_6709_5DE8_9B54_5927_5251(attacker) then
        return
    end
    local _____952E = _____83B7_53D6_5DE8_9B54_5927_5251_7A97_53E3_952E(attacker)
    if _____952E <= 0 then
        return
    end
    local _____53E5_67C4 = _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:get(_____952E)
    if _____53E5_67C4 == nil then
        return
    end
    _____5DE8_9B54_5927_5251_7A97_53E3_8BA1_65F6_5668:delete(_____952E)
    cancelDelayedCall(_____53E5_67C4)
    local x = GetUnitX(target)
    local y = GetUnitY(target)
    createTimedEffect(
        _____5DE8_9B54_5927_5251_914D_7F6E["扩散特效路径"],
        x,
        y,
        0,
        _____5DE8_9B54_5927_5251_914D_7F6E["扩散特效持续时间"]
    )
    local _____7C7B_578B = _____83B7_53D6_540C_7C7B_4F24_5BB3_7C7B_578B(snapshot)
    _____6269_6563_4F24_5BB3({
        ["来源单位"] = attacker,
        ["主目标"] = target,
        ["伤害值"] = applied,
        ["扩散半径"] = _____5DE8_9B54_5927_5251_914D_7F6E["扩散半径"],
        ["扩散百分比"] = _____5DE8_9B54_5927_5251_914D_7F6E["扩散百分比"],
        ["是否包含主目标"] = false,
        ["攻击类型"] = _____7C7B_578B["攻击类型"],
        ["伤害类型"] = _____7C7B_578B["伤害类型"],
        ["武器类型"] = _____7C7B_578B["武器类型"]
    })
end
local function _____521D_59CB_5316_5DE8_9B54_5927_5251_9996_4F24_76D1_542C()
    if _____5DF2_6CE8_518C_5DE8_9B54_5927_5251_9996_4F24_76D1_542C then
        return
    end
    _____5DF2_6CE8_518C_5DE8_9B54_5927_5251_9996_4F24_76D1_542C = true
    registerAppliedFinalDamageListener(_____5904_7406_5DE8_9B54_5927_5251_9996_4F24)
end
____exports["处理巨魔大剑施法"] = function(_____65BD_6CD5_5355_4F4D, _____6280_80FDID, _____76EE_6807_5355_4F4D)
    _____521D_59CB_5316_5DE8_9B54_5927_5251_9996_4F24_76D1_542C()
    if not _____5DE8_9B54_5927_5251_6761_4EF6_6210_7ACB(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D) then
        return
    end
    _____6253_5F00_5DE8_9B54_5927_5251_7A97_53E3(_____65BD_6CD5_5355_4F4D)
end
_____521D_59CB_5316_5DE8_9B54_5927_5251_9996_4F24_76D1_542C()
return ____exports
