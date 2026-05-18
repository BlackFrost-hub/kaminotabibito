--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____7194_5CA9_6076_9B54_4E4B_7075_773C_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["熔岩恶魔之灵眼物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["熔岩恶魔之灵眼配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local ____require_result_1 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_1.addDelayedCallback
local jass = require("jass.common")
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_2["创建单位绑定闪电"]
local ____require_result_3 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_3.createUnitEffect
local ____require_result_4 = require("lib.扩展函数.YDWE函数.index")
local YDUserDataGet = ____require_result_4.YDUserDataGet
local YDUserDataSet = ____require_result_4.YDUserDataSet
local GetItemTypeId = jass.GetItemTypeId
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____547D_4E2D_7387_5B57_6BB5 = "命中率"
local function _____662F_5426_4E3A_7194_5CA9_6076_9B54_4E4B_7075_773C(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____7194_5CA9_6076_9B54_4E4B_7075_773C_7269_54C1ID
end
local function _____8C03_6574_547D_4E2D_7387(_____5355_4F4D, _____53D8_5316_503C)
    if _____5355_4F4D == nil or _____5355_4F4D == 0 then
        return
    end
    local _____5DF2_5B58_503C = YDUserDataGet("unit", _____5355_4F4D, _____547D_4E2D_7387_5B57_6BB5, "real")
    local _____5F53_524D_503C = _____5DF2_5B58_503C == nil and 0 or _____5DF2_5B58_503C
    YDUserDataSet(
        "unit",
        _____5355_4F4D,
        _____547D_4E2D_7387_5B57_6BB5,
        "real",
        _____5F53_524D_503C + _____53D8_5316_503C
    )
end
local function _____5EF6_8FDF_6062_590D_547D_4E2D_7387(_____76EE_6807_5355_4F4D)
    addDelayedCallback(
        _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["命中率恢复延迟"] * 1000,
        function()
            if _____76EE_6807_5355_4F4D ~= nil and _____76EE_6807_5355_4F4D ~= 0 then
                _____8C03_6574_547D_4E2D_7387(_____76EE_6807_5355_4F4D, _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["命中率削减"])
            end
        end
    )
end
____exports["处理熔岩恶魔之灵眼使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("16．熔岩恶魔之灵眼", "进入", "处理熔岩恶魔之灵眼使用")
    if not _____662F_5426_4E3A_7194_5CA9_6076_9B54_4E4B_7075_773C(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({["效果代码"] = _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["魔力之焰闪电"], ["起点单位"] = _____65BD_6CD5_5355_4F4D, ["终点单位"] = _____76EE_6807_5355_4F4D, ["持续时间"] = _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["闪电持续时间"]})
    _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535({["效果代码"] = _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["死亡之指闪电"], ["起点单位"] = _____65BD_6CD5_5355_4F4D, ["终点单位"] = _____76EE_6807_5355_4F4D, ["持续时间"] = _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["闪电持续时间"]})
    SetUnitState(
        _____65BD_6CD5_5355_4F4D,
        UNIT_STATE_MANA,
        GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MANA) - GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MAX_MANA) * _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["魔法消耗比例"]
    )
    createUnitEffect(
        _____76EE_6807_5355_4F4D,
        _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["特效挂点"],
        _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["特效路径"],
        _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["特效持续时间"],
        "熔岩恶魔之灵眼"
    )
    _____8C03_6574_547D_4E2D_7387(_____76EE_6807_5355_4F4D, -_____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["命中率削减"])
    UnitDamageTarget(
        _____65BD_6CD5_5355_4F4D,
        _____76EE_6807_5355_4F4D,
        GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MAX_MANA) * _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["伤害魔法系数"],
        false,
        true,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_SHADOW_STRIKE,
        WEAPON_TYPE_WHOKNOWS
    )
    _____5EF6_8FDF_6062_590D_547D_4E2D_7387(_____76EE_6807_5355_4F4D)
end
return ____exports
