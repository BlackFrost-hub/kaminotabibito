--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5730_72F1_706B_5361_724C_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["地狱火卡牌物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____5730_72F1_706B_5361_724C_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["地狱火卡牌配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local GetItemTypeId = jass.GetItemTypeId
local GetUnitState = jass.GetUnitState
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.19．拓展效果.02．buff.01．地狱火卡牌")
local _____65BD_52A0_5730_72F1_706B_5361_724C_6301_7EED_6062_590D = ____require_result_1["施加地狱火卡牌持续恢复"]
local function _____662F_5426_4E3A_5730_72F1_706B_5361_724C(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____5730_72F1_706B_5361_724C_7269_54C1ID
end
local function _____8BA1_7B97_6BCF_8DF3_751F_547D_6062_590D(_____5355_4F4D)
    return GetUnitState(_____5355_4F4D, UNIT_STATE_MAX_LIFE) * _____5730_72F1_706B_5361_724C_914D_7F6E["生命恢复百分比"] + _____5730_72F1_706B_5361_724C_914D_7F6E["固定生命恢复"]
end
____exports["处理地狱火卡牌使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("09．地狱火卡牌", "进入", "处理地狱火卡牌使用")
    if not _____662F_5426_4E3A_5730_72F1_706B_5361_724C(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    _____65BD_52A0_5730_72F1_706B_5361_724C_6301_7EED_6062_590D(
        _____65BD_6CD5_5355_4F4D,
        _____65BD_6CD5_5355_4F4D,
        {
            BuffID = _____5730_72F1_706B_5361_724C_914D_7F6E.BuffID,
            ["图标路径"] = _____5730_72F1_706B_5361_724C_914D_7F6E["图标路径"],
            ["特效路径"] = _____5730_72F1_706B_5361_724C_914D_7F6E["特效路径"],
            ["特效挂点"] = _____5730_72F1_706B_5361_724C_914D_7F6E["特效挂点"],
            ["特效键"] = _____5730_72F1_706B_5361_724C_914D_7F6E["特效键"],
            ["持续时间"] = _____5730_72F1_706B_5361_724C_914D_7F6E["持续时间"],
            ["间隔"] = _____5730_72F1_706B_5361_724C_914D_7F6E["间隔"],
            ["每跳生命恢复"] = _____8BA1_7B97_6BCF_8DF3_751F_547D_6062_590D(_____65BD_6CD5_5355_4F4D)
        }
    )
end
return ____exports
