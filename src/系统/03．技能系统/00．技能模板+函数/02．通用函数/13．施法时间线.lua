--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local japi = require("jass.japi")
local ____require_result_0 = require("系统.00．核心系统.05．中心计时器")
local addDelayedCallback = ____require_result_0.addDelayedCallback
local ____require_result_1 = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff")
local _____5F00_59CB_786C_76F4 = ____require_result_1["开始硬直"]
local ____require_result_2 = require("系统.09．表现系统.08．吟唱条.06．对外接口")
local _____663E_793A_5E38_89C4_6280_80FD_541F_5531_6761 = ____require_result_2["显示常规技能吟唱条"]
local _____663E_793A_5927_62DB_541F_5531_6761 = ____require_result_2["显示大招吟唱条"]
local _____663E_793A_573A_5730_5E38_9A7BAOE_541F_5531_6761 = ____require_result_2["显示场地常驻AOE吟唱条"]
local _____663E_793A_81F4_547D_60E9_7F5A_541F_5531_6761 = ____require_result_2["显示致命惩罚吟唱条"]
local _____5173_95ED_541F_5531_6761 = ____require_result_2["关闭吟唱条"]
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
____exports["启动基础施法时间线"] = function(_____53C2_6570)
    local caster = _____53C2_6570["施法者"]
    if not _____5355_4F4D_6709_6548(caster) or _____53C2_6570["on生效"] == nil then
        return
    end
    local _____64AD_653E_53F0_8BCD = _____53C2_6570["播放台词"]
    if _____64AD_653E_53F0_8BCD ~= nil then
        _____64AD_653E_53F0_8BCD()
    end
    _____9762_5411_65BD_6CD5_76EE_6807(_____53C2_6570)
    _____5F00_59CB_786C_76F4(caster, _____53C2_6570["硬直秒"])
    if _____53C2_6570["吟唱条"] ~= nil then
        _____663E_793A_65BD_6CD5_541F_5531_6761(_____53C2_6570["吟唱条"])
    end
    _____64AD_653E_65BD_6CD5_52A8_4F5C(_____53C2_6570)
    if _____53C2_6570["重播动作延迟毫秒"] ~= nil and _____53C2_6570["重播动作延迟毫秒"] > 0 then
        addDelayedCallback(
            _____53C2_6570["重播动作延迟毫秒"],
            function()
                _____64AD_653E_65BD_6CD5_52A8_4F5C(_____53C2_6570)
            end
        )
    end
    addDelayedCallback(
        R2I(_____53C2_6570["硬直秒"] * 1000),
        function()
            if _____53C2_6570["吟唱条"] ~= nil then
                _____5173_95ED_541F_5531_6761(_____53C2_6570["吟唱条"]["通道"])
            end
            if not _____5355_4F4D_6709_6548(caster) then
                return
            end
            if _____53C2_6570["生效前重新面向"] ~= false then
                _____9762_5411_65BD_6CD5_76EE_6807(_____53C2_6570)
            end
            local ____on_751F_6548 = _____53C2_6570["on生效"]
            ____on_751F_6548()
            if _____53C2_6570["完成后恢复动作"] ~= false and _____5355_4F4D_6709_6548(caster) then
                SetUnitTimeScale(caster, 1)
                SetUnitAnimationByIndex(caster, 0)
            end
        end
    )
end
return ____exports
