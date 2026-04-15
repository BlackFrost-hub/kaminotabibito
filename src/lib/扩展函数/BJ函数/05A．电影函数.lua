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
    if t1 ~= nil and type(jass.DestroyTimer) == "function" then
        jass.DestroyTimer(t1)
    end
    if t2 ~= nil and type(jass.DestroyTimer) == "function" then
        jass.DestroyTimer(t2)
    end
end
jass = require("jass.common")
jglobals = require("jass.globals")
function ____exports.SetCinematicSceneBJ(self, soundHandle, portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration)
    jglobals.bj_cineSceneLastSound = soundHandle
    PlaySoundBJ(nil, soundHandle)
    if type(jass.SetCinematicScene) == "function" then
        jass.SetCinematicScene(
            portraitUnitId,
            color,
            speakerTitle,
            text,
            sceneDuration,
            voiceoverDuration
        )
    end
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
    if unitId ~= 0 and type(jass.PingMinimap) == "function" then
        jass.PingMinimap(x, y, bj_TRANSMISSION_PING_TIME)
    end
end
function ____exports.TryInitCinematicBehaviorBJ(self)
    if jglobals.bj_cineSceneBeingSkipped ~= nil then
        return
    end
    if type(jass.CreateTrigger) ~= "function" or type(jass.TriggerRegisterPlayerEvent) ~= "function" or type(jass.TriggerAddAction) ~= "function" or type(jass.Player) ~= "function" then
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
    if type(CancelCineSceneBJ) == "function" then
        jass.TriggerAddAction(jglobals.bj_cineSceneBeingSkipped, CancelCineSceneBJ)
    end
end
function ____exports.TransmissionFromUnitWithNameBJ(self, toForce, whichUnit, unitName, soundHandle, message, timeType, timeVal, wait)
    ____exports.TryInitCinematicBehaviorBJ(nil)
    local safeTime = RMaxBJ(nil, timeVal, 0)
    local duration = 0
    duration = GetTransmissionDuration(nil, soundHandle, timeType, safeTime)
    jglobals.bj_lastTransmissionDuration = duration
    jglobals.bj_lastPlayedSound = soundHandle
    if type(jass.IsPlayerInForce) == "function" and type(jass.GetLocalPlayer) == "function" and jass.IsPlayerInForce(
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
            local ____temp_1
            if type(jass.GetUnitTypeId) == "function" then
                ____temp_1 = jass.GetUnitTypeId(whichUnit)
            else
                ____temp_1 = 0
            end
            local unitTypeId = ____temp_1
            local ____temp_2
            if type(jass.GetOwningPlayer) == "function" then
                ____temp_2 = jass.GetOwningPlayer(whichUnit)
            else
                ____temp_2 = nil
            end
            local owner = ____temp_2
            local ____temp_3
            if type(jass.GetPlayerColor) == "function" then
                ____temp_3 = jass.GetPlayerColor(owner)
            else
                ____temp_3 = 0
            end
            local color = ____temp_3
            local ____temp_4
            if type(jass.GetUnitX) == "function" then
                ____temp_4 = jass.GetUnitX(whichUnit)
            else
                ____temp_4 = 0
            end
            local x = ____temp_4
            local ____temp_5
            if type(jass.GetUnitY) == "function" then
                ____temp_5 = jass.GetUnitY(whichUnit)
            else
                ____temp_5 = 0
            end
            local y = ____temp_5
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
            if type(jass.IsUnitHidden) == "function" and not jass.IsUnitHidden(whichUnit) and type(jass.UnitAddIndicator) == "function" then
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
            if type(jass.GetGameSpeed) == "function" then
                jglobals.bj_cineModePriorSpeed = jass.GetGameSpeed()
            end
            if type(jass.IsFogEnabled) == "function" then
                jglobals.bj_cineModePriorFogSetting = jass.IsFogEnabled()
            end
            if type(jass.IsFogMaskEnabled) == "function" then
                jglobals.bj_cineModePriorMaskSetting = jass.IsFogMaskEnabled()
            end
            jglobals.bj_cineModePriorDawnDusk = IsDawnDuskEnabled(nil)
            if type(jass.GetRandomInt) == "function" then
                jglobals.bj_cineModeSavedSeed = jass.GetRandomInt(0, 1000000)
            end
        end
        if type(jass.IsPlayerInForce) == "function" and type(jass.GetLocalPlayer) == "function" and jass.IsPlayerInForce(
            jass.GetLocalPlayer(),
            forForce
        ) then
            if type(jass.ClearTextMessages) == "function" then
                jass.ClearTextMessages()
            end
            if type(jass.ShowInterface) == "function" then
                jass.ShowInterface(false, interfaceFadeTime)
            end
            if type(jass.EnableUserControl) == "function" then
                jass.EnableUserControl(false)
            end
            if type(jass.EnableOcclusion) == "function" then
                jass.EnableOcclusion(false)
            end
            SetCineModeVolumeGroupsBJ(nil)
        end
        if type(jass.SetGameSpeed) == "function" then
            jass.SetGameSpeed(bj_CINEMODE_GAMESPEED)
        end
        if type(jass.SetMapFlag) == "function" then
            jass.SetMapFlag(MAP_LOCK_SPEED, true)
        end
        if type(jass.FogMaskEnable) == "function" then
            jass.FogMaskEnable(false)
        end
        if type(jass.FogEnable) == "function" then
            jass.FogEnable(false)
        end
        if type(jass.EnableWorldFogBoundary) == "function" then
            jass.EnableWorldFogBoundary(false)
        end
        EnableDawnDusk(nil, false)
        if type(jass.SetRandomSeed) == "function" then
            jass.SetRandomSeed(0)
        end
        return
    end
    jglobals.bj_cineModeAlreadyIn = false
    if type(jass.IsPlayerInForce) == "function" and type(jass.GetLocalPlayer) == "function" and jass.IsPlayerInForce(
        jass.GetLocalPlayer(),
        forForce
    ) then
        if type(jass.ShowInterface) == "function" then
            jass.ShowInterface(true, interfaceFadeTime)
        end
        if type(jass.EnableUserControl) == "function" then
            jass.EnableUserControl(true)
        end
        if type(jass.EnableOcclusion) == "function" then
            jass.EnableOcclusion(true)
        end
        if type(jass.VolumeGroupReset) == "function" then
            jass.VolumeGroupReset()
        end
        if type(jass.EndThematicMusic) == "function" then
            jass.EndThematicMusic()
        end
        CameraResetSmoothingFactorBJ(nil)
    end
    if type(jass.SetMapFlag) == "function" then
        jass.SetMapFlag(MAP_LOCK_SPEED, false)
    end
    if type(jass.SetGameSpeed) == "function" then
        jass.SetGameSpeed(jglobals.bj_cineModePriorSpeed)
    end
    if type(jass.FogMaskEnable) == "function" then
        jass.FogMaskEnable(jglobals.bj_cineModePriorMaskSetting)
    end
    if type(jass.FogEnable) == "function" then
        jass.FogEnable(jglobals.bj_cineModePriorFogSetting)
    end
    if type(jass.EnableWorldFogBoundary) == "function" then
        jass.EnableWorldFogBoundary(true)
    end
    EnableDawnDusk(nil, jglobals.bj_cineModePriorDawnDusk)
    if type(jass.SetRandomSeed) == "function" then
        jass.SetRandomSeed(jglobals.bj_cineModeSavedSeed)
    end
end
function ____exports.CinematicModeBJ(self, cineMode, forForce)
    ____exports.CinematicModeExBJ(nil, cineMode, forForce, bj_CINEMODE_INTERFACEFADE)
end
function ____exports.CinematicFilterGenericBJ(self, duration, bmode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1)
    ____exports.AbortCinematicFadeBJ(nil)
    if type(jass.SetCineFilterTexture) == "function" then
        jass.SetCineFilterTexture(tex)
    end
    if type(jass.SetCineFilterBlendMode) == "function" then
        jass.SetCineFilterBlendMode(bmode)
    end
    if type(jass.SetCineFilterTexMapFlags) == "function" then
        jass.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE)
    end
    if type(jass.SetCineFilterStartUV) == "function" then
        jass.SetCineFilterStartUV(0, 0, 1, 1)
    end
    if type(jass.SetCineFilterEndUV) == "function" then
        jass.SetCineFilterEndUV(0, 0, 1, 1)
    end
    if type(jass.SetCineFilterStartColor) == "function" then
        jass.SetCineFilterStartColor(
            PercentTo255(nil, red0),
            PercentTo255(nil, green0),
            PercentTo255(nil, blue0),
            PercentTo255(nil, 100 - trans0)
        )
    end
    if type(jass.SetCineFilterEndColor) == "function" then
        jass.SetCineFilterEndColor(
            PercentTo255(nil, red1),
            PercentTo255(nil, green1),
            PercentTo255(nil, blue1),
            PercentTo255(nil, 100 - trans1)
        )
    end
    if type(jass.SetCineFilterDuration) == "function" then
        jass.SetCineFilterDuration(duration)
    end
    if type(jass.DisplayCineFilter) == "function" then
        jass.DisplayCineFilter(true)
    end
end
return ____exports
