local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____5486_54EE_4E4B_5FC3_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["咆哮之心物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____5486_54EE_4E4B_5FC3_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["咆哮之心配置"]
local ____require_result_0 = require("lib.扩展函数.自定义扩展函数.03．调试输出")
local debugLogForce = ____require_result_0.debugLogForce
local jass = require("jass.common")
local ____require_result_1 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_1.createTimedEffect
local ____require_result_2 = require("lib.扩展函数.Star扩展函数.00．SGSS")
local SGSS_SetState = ____require_result_2.SGSS_SetState
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local ConvertUnitState = jass.ConvertUnitState
local R2I = jass.R2I
local UnitDamageTarget = jass.UnitDamageTarget
local CreateTimer = jass.CreateTimer
local TimerStart = jass.TimerStart
local GetExpiredTimer = jass.GetExpiredTimer
local GetHandleId = jass.GetHandleId
local DestroyTimer = jass.DestroyTimer
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_MIND = jass.DAMAGE_TYPE_MIND
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____5486_54EE_4E4B_5FC3_8868 = {}
local function _____662F_5426_4E3A_5486_54EE_4E4B_5FC3(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____5486_54EE_4E4B_5FC3_7269_54C1ID
end
local function ____on_5486_54EE_4E4B_5FC3_5468_671F()
    local timer = GetExpiredTimer()
    local timerID = GetHandleId(timer)
    local _____4E0A_4E0B_6587 = _____5486_54EE_4E4B_5FC3_8868[timerID]
    if _____4E0A_4E0B_6587 == nil then
        DestroyTimer(timer)
        return
    end
    if _____4E0A_4E0B_6587["次数"] >= _____5486_54EE_4E4B_5FC3_914D_7F6E["次数"] then
        SGSS_SetState(_____4E0A_4E0B_6587["目标单位"], 1, -_____4E0A_4E0B_6587["附加攻击"])
        __TS__Delete(_____5486_54EE_4E4B_5FC3_8868, timerID)
        DestroyTimer(timer)
        return
    end
    _____4E0A_4E0B_6587["次数"] = _____4E0A_4E0B_6587["次数"] + 1
    createTimedEffect(
        _____5486_54EE_4E4B_5FC3_914D_7F6E["特效路径"],
        GetUnitX(_____4E0A_4E0B_6587["目标单位"]),
        GetUnitY(_____4E0A_4E0B_6587["目标单位"]),
        0,
        _____5486_54EE_4E4B_5FC3_914D_7F6E["特效持续时间"]
    )
    UnitDamageTarget(
        _____4E0A_4E0B_6587["施法单位"],
        _____4E0A_4E0B_6587["目标单位"],
        _____5486_54EE_4E4B_5FC3_914D_7F6E["每跳伤害"],
        false,
        false,
        ATTACK_TYPE_NORMAL,
        DAMAGE_TYPE_MIND,
        WEAPON_TYPE_WHOKNOWS
    )
end
____exports["处理咆哮之心使用"] = function(_____4E0A_4E0B_6587)
    debugLogForce("25．咆哮之心", "进入", "处理咆哮之心使用")
    if not _____662F_5426_4E3A_5486_54EE_4E4B_5FC3(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    local _____76EE_6807_5355_4F4D = _____4E0A_4E0B_6587["目标单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 or _____76EE_6807_5355_4F4D == nil or _____76EE_6807_5355_4F4D == 0 then
        return
    end
    local _____9644_52A0_653B_51FB = R2I(GetUnitState(
        _____76EE_6807_5355_4F4D,
        ConvertUnitState(21)
    )) / _____5486_54EE_4E4B_5FC3_914D_7F6E["力量转攻击除数"]
    SGSS_SetState(_____76EE_6807_5355_4F4D, 1, _____9644_52A0_653B_51FB)
    local timer = CreateTimer()
    if timer == nil or timer == 0 then
        return
    end
    _____5486_54EE_4E4B_5FC3_8868[GetHandleId(timer)] = {["施法单位"] = _____65BD_6CD5_5355_4F4D, ["目标单位"] = _____76EE_6807_5355_4F4D, ["附加攻击"] = _____9644_52A0_653B_51FB, ["次数"] = 0}
    TimerStart(timer, _____5486_54EE_4E4B_5FC3_914D_7F6E["周期"], true, ____on_5486_54EE_4E4B_5FC3_5468_671F)
end
return ____exports
