--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local jass, jglobals
local ____05B_FF0E_97F3_6548_51FD_6570 = require("lib.扩展函数.BJ函数.05B．音效函数")
local bj_CINEMODE_GAMESPEED = ____05B_FF0E_97F3_6548_51FD_6570.bj_CINEMODE_GAMESPEED
local bj_CINEMODE_INTERFACEFADE = ____05B_FF0E_97F3_6548_51FD_6570.bj_CINEMODE_INTERFACEFADE
local bj_MAX_PLAYERS = ____05B_FF0E_97F3_6548_51FD_6570.bj_MAX_PLAYERS
local bj_TRANSMISSION_IND_RED = ____05B_FF0E_97F3_6548_51FD_6570.bj_TRANSMISSION_IND_RED
local bj_TRANSMISSION_IND_BLUE = ____05B_FF0E_97F3_6548_51FD_6570.bj_TRANSMISSION_IND_BLUE
local bj_TRANSMISSION_IND_GREEN = ____05B_FF0E_97F3_6548_51FD_6570.bj_TRANSMISSION_IND_GREEN
local bj_TRANSMISSION_IND_ALPHA = ____05B_FF0E_97F3_6548_51FD_6570.bj_TRANSMISSION_IND_ALPHA
local bj_TRANSMISSION_PORT_HANGTIME = ____05B_FF0E_97F3_6548_51FD_6570.bj_TRANSMISSION_PORT_HANGTIME
local bj_TRANSMISSION_PING_TIME = ____05B_FF0E_97F3_6548_51FD_6570.bj_TRANSMISSION_PING_TIME
local EVENT_PLAYER_END_CINEMATIC = ____05B_FF0E_97F3_6548_51FD_6570.EVENT_PLAYER_END_CINEMATIC
local TEXMAP_FLAG_NONE = ____05B_FF0E_97F3_6548_51FD_6570.TEXMAP_FLAG_NONE
local MAP_LOCK_SPEED = ____05B_FF0E_97F3_6548_51FD_6570.MAP_LOCK_SPEED
local CancelCineSceneBJ = ____05B_FF0E_97F3_6548_51FD_6570.CancelCineSceneBJ
local PlaySoundBJ = ____05B_FF0E_97F3_6548_51FD_6570.PlaySoundBJ
local WaitTransmissionDuration = ____05B_FF0E_97F3_6548_51FD_6570.WaitTransmissionDuration
local EnableDawnDusk = ____05B_FF0E_97F3_6548_51FD_6570.EnableDawnDusk
local IsDawnDuskEnabled = ____05B_FF0E_97F3_6548_51FD_6570.IsDawnDuskEnabled
local GetTransmissionDuration = ____05B_FF0E_97F3_6548_51FD_6570.GetTransmissionDuration
local SetCineModeVolumeGroupsBJ = ____05B_FF0E_97F3_6548_51FD_6570.SetCineModeVolumeGroupsBJ
local CameraResetSmoothingFactorBJ = ____05B_FF0E_97F3_6548_51FD_6570.CameraResetSmoothingFactorBJ
local ____12_FF0E_6570_5B66_51FD_6570 = require("lib.扩展函数.BJ函数.12．数学函数")
local RMaxBJ = ____12_FF0E_6570_5B66_51FD_6570.RMaxBJ
local PercentTo255 = ____12_FF0E_6570_5B66_51FD_6570.PercentTo255
function ____exports.AbortCinematicFadeBJ(self)
    local t1 = jglobals.bj_cineFadeContinueTimer
    local t2 = jglobals.bj_cineFadeFinishTimer
    if t1 ~= nil then
        jass.DestroyTimer(t1)
    end
    if t2 ~= nil then
        jass.DestroyTimer(t2)
    end
end
jass = require("jass.common")
jglobals = require("jass.globals")
function ____exports.SetCinematicSceneBJ(self, soundHandle, portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration)
    jglobals.bj_cineSceneLastSound = soundHandle
    PlaySoundBJ(nil, soundHandle)
    jass.SetCinematicScene(
        portraitUnitId,
        color,
        speakerTitle,
        text,
        sceneDuration,
        voiceoverDuration
    )
end
function ____exports.DoTransmissionBasicsXYBJ(self, unitId, color, x, y, soundHandle, unitName, message, duration)
    local hang = bj_TRANSMISSION_PORT_HANGTIME
    ____exports.SetCinematicSceneBJ(
        nil,
        soundHandle,
        unitId,
        color,
        unitName,
        message,
        duration + hang,
        duration
    )
    if unitId ~= 0 then
        jass.PingMinimap(x, y, bj_TRANSMISSION_PING_TIME)
    end
end
function ____exports.TryInitCinematicBehaviorBJ(self)
    if jglobals.bj_cineSceneBeingSkipped ~= nil then
        return
    end
    jglobals.bj_cineSceneBeingSkipped = jass.CreateTrigger()
    do
        local index = 0
        while index < bj_MAX_PLAYERS do
            jass.TriggerRegisterPlayerEvent(
                jglobals.bj_cineSceneBeingSkipped,
                jass.Player(index),
                EVENT_PLAYER_END_CINEMATIC
            )
            index = index + 1
        end
    end
    jass.TriggerAddAction(jglobals.bj_cineSceneBeingSkipped, CancelCineSceneBJ)
end
function ____exports.TransmissionFromUnitWithNameBJ(self, toForce, whichUnit, unitName, soundHandle, message, timeType, timeVal, wait)
    ____exports.TryInitCinematicBehaviorBJ(nil)
    local safeTime = RMaxBJ(nil, timeVal, 0)
    local duration = 0
    duration = GetTransmissionDuration(nil, soundHandle, timeType, safeTime)
    jglobals.bj_lastTransmissionDuration = duration
    jglobals.bj_lastPlayedSound = soundHandle
    if jass.IsPlayerInForce(
        jass.GetLocalPlayer(),
        toForce
    ) then
        if whichUnit == nil then
            local ____temp_0
            if type(jglobals.PLAYER_COLOR_RED) ~= "nil" then
                ____temp_0 = jglobals.PLAYER_COLOR_RED
            else
                ____temp_0 = 0
            end
            local red = ____temp_0
            ____exports.DoTransmissionBasicsXYBJ(
                nil,
                0,
                red,
                0,
                0,
                soundHandle,
                unitName,
                message,
                duration
            )
        else
            local unitTypeId = jass.GetUnitTypeId(whichUnit)
            local owner = jass.GetOwningPlayer(whichUnit)
            local color = jass.GetPlayerColor(owner)
            local x = jass.GetUnitX(whichUnit)
            local y = jass.GetUnitY(whichUnit)
            ____exports.DoTransmissionBasicsXYBJ(
                nil,
                unitTypeId,
                color,
                x,
                y,
                soundHandle,
                unitName,
                message,
                duration
            )
            if not jass.IsUnitHidden(whichUnit) then
                jass.UnitAddIndicator(
                    whichUnit,
                    bj_TRANSMISSION_IND_RED,
                    bj_TRANSMISSION_IND_BLUE,
                    bj_TRANSMISSION_IND_GREEN,
                    bj_TRANSMISSION_IND_ALPHA
                )
            end
        end
    end
    if wait and duration > 0 then
        WaitTransmissionDuration(nil, soundHandle, timeType, safeTime)
    end
end
function ____exports.CinematicModeExBJ(self, cineMode, forForce, interfaceFadeTime)
    if not jglobals.bj_gameStarted then
        interfaceFadeTime = 0
    end
    if cineMode then
        if not jglobals.bj_cineModeAlreadyIn then
            jglobals.bj_cineModeAlreadyIn = true
            jglobals.bj_cineModePriorSpeed = jass.GetGameSpeed()
            jglobals.bj_cineModePriorFogSetting = jass.IsFogEnabled()
            jglobals.bj_cineModePriorMaskSetting = jass.IsFogMaskEnabled()
            jglobals.bj_cineModePriorDawnDusk = IsDawnDuskEnabled(nil)
            jglobals.bj_cineModeSavedSeed = jass.GetRandomInt(0, 1000000)
        end
        if jass.IsPlayerInForce(
            jass.GetLocalPlayer(),
            forForce
        ) then
            jass.ClearTextMessages()
            jass.ShowInterface(false, interfaceFadeTime)
            jass.EnableUserControl(false)
            jass.EnableOcclusion(false)
            SetCineModeVolumeGroupsBJ(nil)
        end
        jass.SetGameSpeed(bj_CINEMODE_GAMESPEED)
        jass.SetMapFlag(MAP_LOCK_SPEED, true)
        jass.FogMaskEnable(false)
        jass.FogEnable(false)
        jass.EnableWorldFogBoundary(false)
        EnableDawnDusk(nil, false)
        jass.SetRandomSeed(0)
        return
    end
    jglobals.bj_cineModeAlreadyIn = false
    if jass.IsPlayerInForce(
        jass.GetLocalPlayer(),
        forForce
    ) then
        jass.ShowInterface(true, interfaceFadeTime)
        jass.EnableUserControl(true)
        jass.EnableOcclusion(true)
        jass.VolumeGroupReset()
        jass.EndThematicMusic()
        CameraResetSmoothingFactorBJ(nil)
    end
    jass.SetMapFlag(MAP_LOCK_SPEED, false)
    jass.SetGameSpeed(jglobals.bj_cineModePriorSpeed)
    jass.FogMaskEnable(jglobals.bj_cineModePriorMaskSetting)
    jass.FogEnable(jglobals.bj_cineModePriorFogSetting)
    jass.EnableWorldFogBoundary(true)
    EnableDawnDusk(nil, jglobals.bj_cineModePriorDawnDusk)
    jass.SetRandomSeed(jglobals.bj_cineModeSavedSeed)
end
function ____exports.CinematicModeBJ(self, cineMode, forForce)
    ____exports.CinematicModeExBJ(nil, cineMode, forForce, bj_CINEMODE_INTERFACEFADE)
end
function ____exports.CinematicFilterGenericBJ(self, duration, bmode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1)
    ____exports.AbortCinematicFadeBJ(nil)
    jass.SetCineFilterTexture(tex)
    jass.SetCineFilterBlendMode(bmode)
    jass.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    jass.SetCineFilterStartUV(0, 0, 1, 1)
    jass.SetCineFilterEndUV(0, 0, 1, 1)
    jass.SetCineFilterStartColor(
        PercentTo255(nil, red0),
        PercentTo255(nil, green0),
        PercentTo255(nil, blue0),
        PercentTo255(nil, 100 - trans0)
    )
    jass.SetCineFilterEndColor(
        PercentTo255(nil, red1),
        PercentTo255(nil, green1),
        PercentTo255(nil, blue1),
        PercentTo255(nil, 100 - trans1)
    )
    jass.SetCineFilterDuration(duration)
    jass.DisplayCineFilter(true)
end
return ____exports
