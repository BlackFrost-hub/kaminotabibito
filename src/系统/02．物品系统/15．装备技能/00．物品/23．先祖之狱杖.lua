--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5148_7956_4E4B_72F1_6756_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["先祖之狱杖物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____5148_7956_4E4B_72F1_6756_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["先祖之狱杖配置"]
local ____20_FF0E_7269_54C1_8F85_52A9 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.20．物品辅助.index")
local _____5EF6_8FDF_6267_884C_53CC_5355_4F4D_52A8_4F5C = ____20_FF0E_7269_54C1_8F85_52A9["延迟执行双单位动作"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_1.createTimedEffect
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_2["施加扩展控制"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local UnitDamageTarget = jass.UnitDamageTarget
local UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_SHADOW_STRIKE = jass.DAMAGE_TYPE_SHADOW_STRIKE
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local function _____662F_5426_4E3A_5148_7956_4E4B_72F1_6756(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____5148_7956_4E4B_72F1_6756_7269_54C1ID
end
local function _____6267_884C_5148_7956_5EF6_8FDF_4F24_5BB3(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D)
    UnitDamageTarget(
        _____65BD_6CD5_5355_4F4D,
        _____76EE_6807_5355_4F4D,
        GetUnitState(_____76EE_6807_5355_4F4D, UNIT_STATE_MAX_LIFE) * _____5148_7956_4E4B_72F1_6756_914D_7F6E["伤害生命比例"],
        false,
        true,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_SHADOW_STRIKE,
        WEAPON_TYPE_WHOKNOWS
    )
end
local function _____542F_52A8_5148_7956_5EF6_8FDF_4F24_5BB3(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D)
    _____5EF6_8FDF_6267_884C_53CC_5355_4F4D_52A8_4F5C(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D, _____5148_7956_4E4B_72F1_6756_914D_7F6E["延迟伤害时间"] * 1000, _____6267_884C_5148_7956_5EF6_8FDF_4F24_5BB3)
end
____exports["处理先祖之狱杖使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("24．先祖之狱杖", "进入", "处理先祖之狱杖使用")
    if not _____662F_5426_4E3A_5148_7956_4E4B_72F1_6756(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    createTimedEffect(
        _____5148_7956_4E4B_72F1_6756_914D_7F6E["特效路径"],
        GetUnitX(_____76EE_6807_5355_4F4D),
        GetUnitY(_____76EE_6807_5355_4F4D),
        0,
        _____5148_7956_4E4B_72F1_6756_914D_7F6E["特效持续时间"]
    )
    _____65BD_52A0_6269_5C55_63A7_5236(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D, "stun", {["持续时间"] = _____5148_7956_4E4B_72F1_6756_914D_7F6E["眩晕时间"]})
    _____542F_52A8_5148_7956_5EF6_8FDF_4F24_5BB3(_____65BD_6CD5_5355_4F4D, _____76EE_6807_5355_4F4D)
end
return ____exports
