--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local ____require_result_0 = require("lib.扩展函数.Star扩展函数.Star扩展库.00．镜头函数")
local StarOther_PanCameraToTimedForPlayer = ____require_result_0.StarOther_PanCameraToTimedForPlayer
local StarOther_PanCameraToTimedUnitForPlayer = ____require_result_0.StarOther_PanCameraToTimedUnitForPlayer
local ____require_result_1 = require("lib.扩展函数.BJ函数.07．杂项")
local GetPlayersAll = ____require_result_1.GetPlayersAll
local GetLocalPlayer = jass.GetLocalPlayer
local IsPlayerInForce = jass.IsPlayerInForce
local ResetToGameCamera = jass.ResetToGameCamera
local SetCameraField = jass.SetCameraField
local CAMERA_FIELD_TARGET_DISTANCE = jass.CAMERA_FIELD_TARGET_DISTANCE
local CAMERA_FIELD_FARZ = jass.CAMERA_FIELD_FARZ
local CAMERA_FIELD_ROTATION = jass.CAMERA_FIELD_ROTATION
local CAMERA_FIELD_ANGLE_OF_ATTACK = jass.CAMERA_FIELD_ANGLE_OF_ATTACK
local CAMERA_FIELD_ROLL = jass.CAMERA_FIELD_ROLL
local CAMERA_FIELD_FIELD_OF_VIEW = jass.CAMERA_FIELD_FIELD_OF_VIEW
local CAMERA_FIELD_ZOFFSET = jass.CAMERA_FIELD_ZOFFSET
____exports["应用镜头预设给玩家"] = function(whichPlayer, _____9884_8BBE, duration)
    StarOther_PanCameraToTimedForPlayer(whichPlayer, _____9884_8BBE.X, _____9884_8BBE.Y, duration)
    if GetLocalPlayer() ~= whichPlayer then
        return
    end
    SetCameraField(CAMERA_FIELD_TARGET_DISTANCE, _____9884_8BBE["距离到目标"], duration)
    SetCameraField(CAMERA_FIELD_FARZ, _____9884_8BBE["远景剪裁"], duration)
    SetCameraField(CAMERA_FIELD_ROTATION, _____9884_8BBE["旋转角度"], duration)
    SetCameraField(CAMERA_FIELD_ANGLE_OF_ATTACK, _____9884_8BBE["攻角"], duration)
    SetCameraField(CAMERA_FIELD_ROLL, _____9884_8BBE["滚动角度"], duration)
    SetCameraField(CAMERA_FIELD_FIELD_OF_VIEW, _____9884_8BBE["观察区域"], duration)
    SetCameraField(CAMERA_FIELD_ZOFFSET, _____9884_8BBE["高度偏移"], duration)
end
____exports["应用镜头预设给玩家组"] = function(whichForce, _____9884_8BBE, duration)
    local localPlayer = GetLocalPlayer()
    if not IsPlayerInForce(localPlayer, whichForce) then
        return
    end
    ____exports["应用镜头预设给玩家"](localPlayer, _____9884_8BBE, duration)
end
____exports["平移并应用镜头预设到本地"] = function(_____9884_8BBE, duration)
    ____exports["应用镜头预设给玩家"](
        GetLocalPlayer(),
        _____9884_8BBE,
        duration
    )
end
____exports["平移并应用镜头预设到全部玩家"] = function(_____9884_8BBE, duration)
    ____exports["应用镜头预设给玩家组"](
        GetPlayersAll(),
        _____9884_8BBE,
        duration
    )
end
____exports["重置玩家镜头并平移到单位"] = function(whichPlayer, unit, duration)
    if GetLocalPlayer() ~= whichPlayer then
        return
    end
    ResetToGameCamera(0)
    if unit == nil or unit == 0 then
        return
    end
    StarOther_PanCameraToTimedUnitForPlayer(whichPlayer, unit, duration)
end
return ____exports
