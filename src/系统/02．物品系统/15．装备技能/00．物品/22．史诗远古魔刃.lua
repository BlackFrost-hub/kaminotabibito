local ____lualib = require("lualib_bundle")
local __TS__Delete = ____lualib.__TS__Delete
local ____exports = {}
local ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID = require("系统.02．物品系统.15．装备技能.03．主动技能.00．公共.01．主动技能物品ID")
local _____53F2_8BD7_8FDC_53E4_9B54_5203_7269_54C1ID = ____01_FF0E_4E3B_52A8_6280_80FD_7269_54C1ID["史诗远古魔刃物品ID"]
local ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E = require("系统.02．物品系统.15．装备技能.03．主动技能.03．物品使用触发.00．物品使用触发配置")
local _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E = ____00_FF0E_7269_54C1_4F7F_7528_89E6_53D1_914D_7F6E["史诗远古魔刃配置"]
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.封装函数.01．通用工具.03．特效")
local createTimedEffect = ____require_result_0.createTimedEffect
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.02．单位与范围")
local _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA = ____require_result_1["获取坐标范围敌人"]
local _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9 = ____require_result_1["单位是否有效且敌对"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统")
local _____65BD_52A0_6269_5C55_63A7_5236 = ____require_result_2["施加扩展控制"]
local GetItemTypeId = jass.GetItemTypeId
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local GetUnitState = jass.GetUnitState
local GetHandleId = jass.GetHandleId
local ConvertUnitState = jass.ConvertUnitState
local Atan2 = jass.Atan2
local Cos = jass.Cos
local Sin = jass.Sin
local CreateTimer = jass.CreateTimer
local TimerStart = jass.TimerStart
local GetExpiredTimer = jass.GetExpiredTimer
local DestroyTimer = jass.DestroyTimer
local UnitDamageTarget = jass.UnitDamageTarget
local ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL
local DAMAGE_TYPE_NORMAL = jass.DAMAGE_TYPE_NORMAL
local WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS
local _____626B_63A0_8868 = {}
local function _____662F_5426_4E3A_53F2_8BD7_8FDC_53E4_9B54_5203(_____7269_54C1)
    if _____7269_54C1 == nil or _____7269_54C1 == 0 then
        return false
    end
    return GetItemTypeId(_____7269_54C1) == _____53F2_8BD7_8FDC_53E4_9B54_5203_7269_54C1ID
end
local function ____on_53F2_8BD7_8FDC_53E4_9B54_5203_626B_63A0()
    local timer = GetExpiredTimer()
    local timerID = GetHandleId(timer)
    local _____4E0A_4E0B_6587 = _____626B_63A0_8868[timerID]
    if _____4E0A_4E0B_6587 == nil then
        DestroyTimer(timer)
        return
    end
    if _____4E0A_4E0B_6587["次数"] >= _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["最大次数"] then
        __TS__Delete(_____626B_63A0_8868, timerID)
        DestroyTimer(timer)
        return
    end
    _____4E0A_4E0B_6587["次数"] = _____4E0A_4E0B_6587["次数"] + 1
    _____4E0A_4E0B_6587.x = _____4E0A_4E0B_6587.x + Cos(_____4E0A_4E0B_6587["角度"]) * _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["每次距离"]
    _____4E0A_4E0B_6587.y = _____4E0A_4E0B_6587.y + Sin(_____4E0A_4E0B_6587["角度"]) * _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["每次距离"]
    createTimedEffect(
        _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["特效路径"],
        _____4E0A_4E0B_6587.x,
        _____4E0A_4E0B_6587.y,
        0,
        _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["特效持续时间"]
    )
    local _____4F24_5BB3_503C = GetUnitState(
        _____4E0A_4E0B_6587["施法单位"],
        ConvertUnitState(21)
    ) * _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["力量系数"]
    local _____654C_4EBA_5217_8868 = _____83B7_53D6_5750_6807_8303_56F4_654C_4EBA(_____4E0A_4E0B_6587["施法单位"], _____4E0A_4E0B_6587.x, _____4E0A_4E0B_6587.y, _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["作用范围"])
    do
        local i = 0
        while i < #_____654C_4EBA_5217_8868 do
            do
                local _____654C_4EBA = _____654C_4EBA_5217_8868[i + 1]
                if not _____5355_4F4D_662F_5426_6709_6548_4E14_654C_5BF9(_____654C_4EBA, _____4E0A_4E0B_6587["施法单位"]) then
                    goto __continue8
                end
                local _____654C_4EBAID = GetHandleId(_____654C_4EBA)
                if _____4E0A_4E0B_6587["已命中"][_____654C_4EBAID] then
                    goto __continue8
                end
                _____4E0A_4E0B_6587["已命中"][_____654C_4EBAID] = true
                UnitDamageTarget(
                    _____4E0A_4E0B_6587["施法单位"],
                    _____654C_4EBA,
                    _____4F24_5BB3_503C,
                    false,
                    false,
                    ATTACK_TYPE_NORMAL,
                    DAMAGE_TYPE_NORMAL,
                    WEAPON_TYPE_WHOKNOWS
                )
                _____65BD_52A0_6269_5C55_63A7_5236(_____4E0A_4E0B_6587["施法单位"], _____654C_4EBA, "stun", {["持续时间"] = _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["眩晕时间"]})
            end
            ::__continue8::
            i = i + 1
        end
    end
end
____exports["处理史诗远古魔刃使用"] = function(_____4E0A_4E0B_6587)
    if not _____662F_5426_4E3A_53F2_8BD7_8FDC_53E4_9B54_5203(_____4E0A_4E0B_6587["物品"]) then
        return
    end
    local _____65BD_6CD5_5355_4F4D = _____4E0A_4E0B_6587["施法单位"]
    if _____65BD_6CD5_5355_4F4D == nil or _____65BD_6CD5_5355_4F4D == 0 then
        return
    end
    local _____8D77_70B9X = GetUnitX(_____65BD_6CD5_5355_4F4D)
    local _____8D77_70B9Y = GetUnitY(_____65BD_6CD5_5355_4F4D)
    local timer = CreateTimer()
    if timer == nil or timer == 0 then
        return
    end
    _____626B_63A0_8868[GetHandleId(timer)] = {
        ["施法单位"] = _____65BD_6CD5_5355_4F4D,
        x = _____8D77_70B9X,
        y = _____8D77_70B9Y,
        ["角度"] = Atan2(_____4E0A_4E0B_6587["目标Y"] - _____8D77_70B9Y, _____4E0A_4E0B_6587["目标X"] - _____8D77_70B9X),
        ["次数"] = 0,
        ["已命中"] = {}
    }
    TimerStart(timer, _____53F2_8BD7_8FDC_53E4_9B54_5203_914D_7F6E["周期"], true, ____on_53F2_8BD7_8FDC_53E4_9B54_5203_626B_63A0)
end
return ____exports
