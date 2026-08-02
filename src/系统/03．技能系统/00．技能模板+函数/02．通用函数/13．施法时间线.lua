--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local removeDelayedCallback = ____require_result_0.removeDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.00．技能模板.04．主动技能流程模板.00．流程生命周期")
local _____521B_5EFA_4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F = ____require_result_1["创建主动技能流程生命周期"]
local ____require_result_2 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_2["开始硬直"]
local ____require_result_3 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_3["显示常规技能吟唱条"]
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_3["显示大招吟唱条"]
local _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761 = ____require_result_3["显示场地常驻AOE吟唱条"]
local _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761 = ____require_result_3["显示致命惩罚吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_3["关闭吟唱条"]
local GetUnitX = jass.GetUnitX
local GetUnitY = jass.GetUnitY
local SetUnitFacing = jass.SetUnitFacing
local SetUnitAnimation = jass.SetUnitAnimation
local SetUnitAnimationByIndex = jass.SetUnitAnimationByIndex
local SetUnitTimeScale = jass.SetUnitTimeScale
local IsUnitType = jass.IsUnitType
local Atan2 = jass.Atan2
local R2I = jass.R2I
local UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD
local EXSetUnitFacing = japi.EXSetUnitFacing
local BJ_RADTODEG = 57.29577951308232
local BJ_DEGTORAD = 0.017453292519943295
local function _____5355_4F4D_6709_6548(unit)
    return unit ~= nil and unit ~= 0 and IsUnitType(unit, UNIT_TYPE_DEAD) ~= true
end
local function _____53D6_76EE_6807X(_____53C2_6570)
    if _____53C2_6570["目标单位"] ~= nil and _____53C2_6570["目标单位"] ~= 0 then
        return GetUnitX(_____53C2_6570["目标单位"])
    end
    return _____53C2_6570["目标X"]
end
local function _____53D6_76EE_6807Y(_____53C2_6570)
    if _____53C2_6570["目标单位"] ~= nil and _____53C2_6570["目标单位"] ~= 0 then
        return GetUnitY(_____53C2_6570["目标单位"])
    end
    return _____53C2_6570["目标Y"]
end
local function _____9762_5411_65BD_6CD5_76EE_6807(_____53C2_6570)
    local caster = _____53C2_6570["施法者"]
    if not _____5355_4F4D_6709_6548(caster) then
        return
    end
    local targetX = _____53D6_76EE_6807X(_____53C2_6570)
    local targetY = _____53D6_76EE_6807Y(_____53C2_6570)
    if targetX == nil or targetY == nil then
        return
    end
    local angle = Atan2(
        targetY - GetUnitY(caster),
        targetX - GetUnitX(caster)
    ) * BJ_RADTODEG
    SetUnitFacing(caster, angle)
    if EXSetUnitFacing ~= nil then
        EXSetUnitFacing(caster, angle * BJ_DEGTORAD)
    end
end
local function _____64AD_653E_65BD_6CD5_52A8_4F5C(_____53C2_6570)
    local caster = _____53C2_6570["施法者"]
    if not _____5355_4F4D_6709_6548(caster) then
        return
    end
    SetUnitTimeScale(caster, _____53C2_6570["动画速度"] or 1)
    if _____53C2_6570["动画编号"] ~= nil then
        SetUnitAnimationByIndex(caster, _____53C2_6570["动画编号"])
    elseif _____53C2_6570["动画名"] ~= nil and _____53C2_6570["动画名"] ~= "" then
        SetUnitAnimation(caster, _____53C2_6570["动画名"])
    end
end
local function _____64AD_653E_540E_7EED_65BD_6CD5_52A8_4F5C(_____53C2_6570)
    local caster = _____53C2_6570["施法者"]
    if not _____5355_4F4D_6709_6548(caster) then
        return
    end
    SetUnitTimeScale(caster, _____53C2_6570["后续动画速度"] or _____53C2_6570["动画速度"] or 1)
    if _____53C2_6570["后续动画编号"] ~= nil then
        SetUnitAnimationByIndex(caster, _____53C2_6570["后续动画编号"])
    elseif _____53C2_6570["后续动画名"] ~= nil and _____53C2_6570["后续动画名"] ~= "" then
        SetUnitAnimation(caster, _____53C2_6570["后续动画名"])
    end
end
local function _____663E_793A_65BD_6CD5_541F_5531_6761(_____53C2_6570)
    if _____53C2_6570["通道"] == "大招" then
        _____663E_793A_5927_62DB_541F_5531_6761(_____53C2_6570)
    elseif _____53C2_6570["通道"] == "场地常驻AOE" then
        _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761(_____53C2_6570)
    elseif _____53C2_6570["通道"] == "致命惩罚" then
        _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761(_____53C2_6570)
    else
        _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761(_____53C2_6570)
    end
end
local function _____79FB_9664_65F6_95F4_7EBF_5EF6_8FDF_56DE_8C03(_____8FD0_884C_65F6)
    if _____8FD0_884C_65F6["后续动作回调ID"] ~= 0 then
        removeDelayedCallback(_____8FD0_884C_65F6["后续动作回调ID"])
    end
    if _____8FD0_884C_65F6["重播动作回调ID"] ~= 0 then
        removeDelayedCallback(_____8FD0_884C_65F6["重播动作回调ID"])
    end
    if _____8FD0_884C_65F6["生效回调ID"] ~= 0 then
        removeDelayedCallback(_____8FD0_884C_65F6["生效回调ID"])
    end
    if _____8FD0_884C_65F6["完成回调ID"] ~= 0 then
        removeDelayedCallback(_____8FD0_884C_65F6["完成回调ID"])
    end
    _____8FD0_884C_65F6["后续动作回调ID"] = 0
    _____8FD0_884C_65F6["重播动作回调ID"] = 0
    _____8FD0_884C_65F6["生效回调ID"] = 0
    _____8FD0_884C_65F6["完成回调ID"] = 0
end
local function _____6062_590D_65F6_95F4_7EBF_65BD_6CD5_52A8_4F5C(_____53C2_6570)
    local caster = _____53C2_6570["施法者"]
    if not _____5355_4F4D_6709_6548(caster) then
        return
    end
    SetUnitTimeScale(caster, 1)
    SetUnitAnimationByIndex(caster, _____53C2_6570["恢复动画编号"] or 0)
end
local function _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_505C_6B62(______539F_56E0, variable)
    local _____8FD0_884C_65F6 = variable
    if _____8FD0_884C_65F6 == nil then
        return
    end
    _____79FB_9664_65F6_95F4_7EBF_5EF6_8FDF_56DE_8C03(_____8FD0_884C_65F6)
    if _____8FD0_884C_65F6["参数"]["吟唱条"] ~= nil then
        _____5173_95ED_541F_5531_6761(_____8FD0_884C_65F6["参数"]["吟唱条"]["通道"])
    end
    if _____8FD0_884C_65F6["参数"]["取消后恢复动作"] ~= false then
        _____6062_590D_65F6_95F4_7EBF_65BD_6CD5_52A8_4F5C(_____8FD0_884C_65F6["参数"])
    end
end
local function _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_7ED3_675F(_____539F_56E0, variable)
    local _____8FD0_884C_65F6 = variable
    if (_____8FD0_884C_65F6 and _____8FD0_884C_65F6["参数"]["on结束"]) ~= nil then
        _____8FD0_884C_65F6["参数"]["on结束"](_____539F_56E0)
    end
end
local function _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_540E_7EED_52A8_4F5C(variable)
    local _____8FD0_884C_65F6 = variable
    if _____8FD0_884C_65F6 == nil then
        return
    end
    _____8FD0_884C_65F6["后续动作回调ID"] = 0
    local ____opt_6 = _____8FD0_884C_65F6["控制器"]
    if ____opt_6 and ____opt_6["是否结束"]() then
        return
    end
    if not _____5355_4F4D_6709_6548(_____8FD0_884C_65F6["参数"]["施法者"]) then
        local ____opt_8 = _____8FD0_884C_65F6["控制器"]
        if ____opt_8 ~= nil then
            ____opt_8["停止"]("死亡")
        end
        return
    end
    _____64AD_653E_540E_7EED_65BD_6CD5_52A8_4F5C(_____8FD0_884C_65F6["参数"])
end
local function _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_91CD_64AD_52A8_4F5C(variable)
    local _____8FD0_884C_65F6 = variable
    if _____8FD0_884C_65F6 == nil then
        return
    end
    _____8FD0_884C_65F6["重播动作回调ID"] = 0
    local ____opt_10 = _____8FD0_884C_65F6["控制器"]
    if ____opt_10 and ____opt_10["是否结束"]() then
        return
    end
    if not _____5355_4F4D_6709_6548(_____8FD0_884C_65F6["参数"]["施法者"]) then
        local ____opt_12 = _____8FD0_884C_65F6["控制器"]
        if ____opt_12 ~= nil then
            ____opt_12["停止"]("死亡")
        end
        return
    end
    _____64AD_653E_65BD_6CD5_52A8_4F5C(_____8FD0_884C_65F6["参数"])
end
local function _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_5B8C_6210(variable)
    local _____8FD0_884C_65F6 = variable
    if _____8FD0_884C_65F6 == nil then
        return
    end
    _____8FD0_884C_65F6["完成回调ID"] = 0
    local ____opt_14 = _____8FD0_884C_65F6["控制器"]
    if ____opt_14 and ____opt_14["是否结束"]() then
        return
    end
    local ____opt_16 = _____8FD0_884C_65F6["控制器"]
    if ____opt_16 ~= nil then
        ____opt_16["完成"]()
    end
end
local function _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_751F_6548(variable)
    local _____8FD0_884C_65F6 = variable
    if _____8FD0_884C_65F6 == nil then
        return
    end
    _____8FD0_884C_65F6["生效回调ID"] = 0
    local _____53C2_6570 = _____8FD0_884C_65F6["参数"]
    local _____63A7_5236_5668 = _____8FD0_884C_65F6["控制器"]
    if _____63A7_5236_5668 == nil or _____63A7_5236_5668["是否结束"]() then
        return
    end
    if _____53C2_6570["吟唱条"] ~= nil then
        _____5173_95ED_541F_5531_6761(_____53C2_6570["吟唱条"]["通道"])
    end
    if not _____5355_4F4D_6709_6548(_____53C2_6570["施法者"]) then
        _____63A7_5236_5668["停止"]("死亡")
        return
    end
    if _____53C2_6570["目标失效时取消"] == true and _____53C2_6570["目标单位"] ~= nil and _____53C2_6570["目标单位"] ~= 0 and not _____5355_4F4D_6709_6548(_____53C2_6570["目标单位"]) then
        _____63A7_5236_5668["停止"]("目标失效")
        return
    end
    if _____53C2_6570["生效前重新面向"] ~= false then
        _____9762_5411_65BD_6CD5_76EE_6807(_____53C2_6570)
    end
    _____53C2_6570["on生效"]()
    if _____53C2_6570["完成后恢复动作"] ~= false then
        _____6062_590D_65F6_95F4_7EBF_65BD_6CD5_52A8_4F5C(_____53C2_6570)
    end
    local _____5B8C_6210_5EF6_8FDF_6BEB_79D2 = _____53C2_6570["完成延迟毫秒"]
    if _____5B8C_6210_5EF6_8FDF_6BEB_79D2 ~= nil and _____5B8C_6210_5EF6_8FDF_6BEB_79D2 > 0 then
        _____8FD0_884C_65F6["完成回调ID"] = addDelayedCallback(_____5B8C_6210_5EF6_8FDF_6BEB_79D2, _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_5B8C_6210, _____8FD0_884C_65F6)
        return
    end
    _____63A7_5236_5668["完成"]()
end
____exports["启动基础施法时间线"] = function(_____53C2_6570)
    local _____8FD0_884C_65F6 = {
        ["参数"] = _____53C2_6570,
        ["后续动作回调ID"] = 0,
        ["重播动作回调ID"] = 0,
        ["生效回调ID"] = 0,
        ["完成回调ID"] = 0
    }
    local _____63A7_5236_5668 = _____521B_5EFA_4E3B_52A8_6280_80FD_6D41_7A0B_751F_547D_5468_671F({
        ["名称"] = _____53C2_6570["名称"] or "基础施法时间线",
        ["施法者"] = _____53C2_6570["施法者"],
        ["目标"] = _____53C2_6570["目标单位"],
        ["清理"] = _____53C2_6570["清理"],
        ["施法者死亡时取消"] = _____53C2_6570["施法者死亡时取消"],
        ["目标死亡时取消"] = _____53C2_6570["目标失效时取消"] == true,
        ["变量"] = _____8FD0_884C_65F6,
        ["on停止"] = _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_505C_6B62,
        ["on结束"] = _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_7ED3_675F
    })
    _____8FD0_884C_65F6["控制器"] = _____63A7_5236_5668
    if _____63A7_5236_5668["是否结束"]() or _____53C2_6570["on生效"] == nil then
        return _____63A7_5236_5668
    end
    local _____64AD_653E_53F0_8BCD = _____53C2_6570["播放台词"]
    if _____64AD_653E_53F0_8BCD ~= nil then
        _____64AD_653E_53F0_8BCD()
    end
    _____9762_5411_65BD_6CD5_76EE_6807(_____53C2_6570)
    if _____53C2_6570["硬直秒"] > 0 then
        _____5F00_59CB_786C_76F4(_____53C2_6570["施法者"], _____53C2_6570["硬直秒"])
    end
    if _____53C2_6570["吟唱条"] ~= nil then
        _____663E_793A_65BD_6CD5_541F_5531_6761(_____53C2_6570["吟唱条"])
    end
    _____64AD_653E_65BD_6CD5_52A8_4F5C(_____53C2_6570)
    if _____53C2_6570["后续动画延迟毫秒"] ~= nil and _____53C2_6570["后续动画延迟毫秒"] > 0 then
        _____8FD0_884C_65F6["后续动作回调ID"] = addDelayedCallback(_____53C2_6570["后续动画延迟毫秒"], _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_540E_7EED_52A8_4F5C, _____8FD0_884C_65F6)
    end
    if _____53C2_6570["重播动作延迟毫秒"] ~= nil and _____53C2_6570["重播动作延迟毫秒"] > 0 then
        _____8FD0_884C_65F6["重播动作回调ID"] = addDelayedCallback(_____53C2_6570["重播动作延迟毫秒"], _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_91CD_64AD_52A8_4F5C, _____8FD0_884C_65F6)
    end
    local _____751F_6548_5EF6_8FDF_79D2 = _____53C2_6570["生效延迟秒"] or _____53C2_6570["硬直秒"]
    _____8FD0_884C_65F6["生效回调ID"] = addDelayedCallback(
        R2I(_____751F_6548_5EF6_8FDF_79D2 * 1000),
        _____57FA_7840_65BD_6CD5_65F6_95F4_7EBF_751F_6548,
        _____8FD0_884C_65F6
    )
    return _____63A7_5236_5668
end
return ____exports
