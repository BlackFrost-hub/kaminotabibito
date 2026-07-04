--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7 = ____20_FF0E_7269_54C1_8F85_52A9["主动物品调试日志"]
local ____10_FF0E_88C5_5907_6218_6597_6267_884C = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.10．装备战斗执行")
local _____9020_6210_88C5_5907_4F24_5BB3 = ____10_FF0E_88C5_5907_6218_6597_6267_884C["造成装备伤害"]
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____7194_5CA9_6076_9B54_4E4B_7075_773C_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["熔岩恶魔之灵眼物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["熔岩恶魔之灵眼配置"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C = ____20_FF0E_7269_54C1_8F85_52A9["施加临时属性效果"]
local jass = require("jass.common")
local ____require_result_0 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.10．跳链.单位绑定闪电")
local _____521B_5EFA_5355_4F4D_7ED1_5B9A_95EA_7535 = ____require_result_0["创建单位绑定闪电"]
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createUnitEffect = ____require_result_1.createUnitEffect
local GetItemTypeId = jass.GetItemTypeId
local GetUnitState = jass.GetUnitState
local SetUnitState = jass.SetUnitState
local UNIT_STATE_MANA = jass.UNIT_STATE_MANA
local UNIT_STATE_MAX_MANA = jass.UNIT_STATE_MAX_MANA
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local _____547D_4E2D_7387_5B57_6BB5 = "命中率"
local function _____662F_5426_4E3A_7194_5CA9_6076_9B54_4E4B_7075_773C(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____7194_5CA9_6076_9B54_4E4B_7075_773C_7269_54C1ID
end
____exports["处理熔岩恶魔之灵眼使用"] = function(_____4E0A_4E0B_6587)
    _____4E3B_52A8_7269_54C1_8C03_8BD5_65E5_5FD7("16．熔岩恶魔之灵眼", "进入", "处理熔岩恶魔之灵眼使用")
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
    _____65BD_52A0_4E34_65F6_5C5E_6027_6548_679C(_____76EE_6807_5355_4F4D, _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["命中率恢复延迟"] * 1000, {{["类型"] = "单位属性", ["属性名"] = _____547D_4E2D_7387_5B57_6BB5, ["数值"] = -_____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["命中率削减"]}})
    _____9020_6210_88C5_5907_4F24_5BB3(
        _____65BD_6CD5_5355_4F4D,
        _____76EE_6807_5355_4F4D,
        GetUnitState(_____65BD_6CD5_5355_4F4D, UNIT_STATE_MAX_MANA) * _____7194_5CA9_6076_9B54_4E4B_7075_773C_914D_7F6E["伤害魔法系数"],
        DAMAGE_TYPE_SHADOW_STRIKE,
        true
    )
end
return ____exports
