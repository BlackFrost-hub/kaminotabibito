--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
---
-- @noSelfInFile
local jass = require("jass.common")
local jglobals = require("jass.globals")
local AttachSoundToUnit = jass.AttachSoundToUnit
local SetSoundVolume = jass.SetSoundVolume
local StartSound = jass.StartSound
local ____jglobals_bj_CINEMODE_GAMESPEED_0 = jglobals.bj_CINEMODE_GAMESPEED
if ____jglobals_bj_CINEMODE_GAMESPEED_0 == nil then
    ____jglobals_bj_CINEMODE_GAMESPEED_0 = 0
end
____exports.bj_CINEMODE_GAMESPEED = ____jglobals_bj_CINEMODE_GAMESPEED_0
local ____jglobals_bj_CINEMODE_INTERFACEFADE_1 = jglobals.bj_CINEMODE_INTERFACEFADE
if ____jglobals_bj_CINEMODE_INTERFACEFADE_1 == nil then
    ____jglobals_bj_CINEMODE_INTERFACEFADE_1 = 0.5
end
____exports.bj_CINEMODE_INTERFACEFADE = ____jglobals_bj_CINEMODE_INTERFACEFADE_1
local ____jglobals_bj_TRANSMISSION_PORT_HANGTIME_2 = jglobals.bj_TRANSMISSION_PORT_HANGTIME
if ____jglobals_bj_TRANSMISSION_PORT_HANGTIME_2 == nil then
    ____jglobals_bj_TRANSMISSION_PORT_HANGTIME_2 = 0
end
____exports.bj_TRANSMISSION_PORT_HANGTIME = ____jglobals_bj_TRANSMISSION_PORT_HANGTIME_2
local ____jglobals_bj_TRANSMISSION_PING_TIME_3 = jglobals.bj_TRANSMISSION_PING_TIME
if ____jglobals_bj_TRANSMISSION_PING_TIME_3 == nil then
    ____jglobals_bj_TRANSMISSION_PING_TIME_3 = 1
end
____exports.bj_TRANSMISSION_PING_TIME = ____jglobals_bj_TRANSMISSION_PING_TIME_3
local ____jglobals_bj_TRANSMISSION_IND_RED_4 = jglobals.bj_TRANSMISSION_IND_RED
if ____jglobals_bj_TRANSMISSION_IND_RED_4 == nil then
    ____jglobals_bj_TRANSMISSION_IND_RED_4 = 255
end
____exports.bj_TRANSMISSION_IND_RED = ____jglobals_bj_TRANSMISSION_IND_RED_4
local ____jglobals_bj_TRANSMISSION_IND_BLUE_5 = jglobals.bj_TRANSMISSION_IND_BLUE
if ____jglobals_bj_TRANSMISSION_IND_BLUE_5 == nil then
    ____jglobals_bj_TRANSMISSION_IND_BLUE_5 = 255
end
____exports.bj_TRANSMISSION_IND_BLUE = ____jglobals_bj_TRANSMISSION_IND_BLUE_5
local ____jglobals_bj_TRANSMISSION_IND_GREEN_6 = jglobals.bj_TRANSMISSION_IND_GREEN
if ____jglobals_bj_TRANSMISSION_IND_GREEN_6 == nil then
    ____jglobals_bj_TRANSMISSION_IND_GREEN_6 = 255
end
____exports.bj_TRANSMISSION_IND_GREEN = ____jglobals_bj_TRANSMISSION_IND_GREEN_6
local ____jglobals_bj_TRANSMISSION_IND_ALPHA_7 = jglobals.bj_TRANSMISSION_IND_ALPHA
if ____jglobals_bj_TRANSMISSION_IND_ALPHA_7 == nil then
    ____jglobals_bj_TRANSMISSION_IND_ALPHA_7 = 255
end
____exports.bj_TRANSMISSION_IND_ALPHA = ____jglobals_bj_TRANSMISSION_IND_ALPHA_7
local ____jglobals_bj_MAX_PLAYERS_8 = jglobals.bj_MAX_PLAYERS
if ____jglobals_bj_MAX_PLAYERS_8 == nil then
    ____jglobals_bj_MAX_PLAYERS_8 = 16
end
____exports.bj_MAX_PLAYERS = ____jglobals_bj_MAX_PLAYERS_8
local ____jglobals_bj_TIMETYPE_ADD_9 = jglobals.bj_TIMETYPE_ADD
if ____jglobals_bj_TIMETYPE_ADD_9 == nil then
    ____jglobals_bj_TIMETYPE_ADD_9 = 0
end
____exports.bj_TIMETYPE_ADD = ____jglobals_bj_TIMETYPE_ADD_9
local ____jglobals_bj_TIMETYPE_SET_10 = jglobals.bj_TIMETYPE_SET
if ____jglobals_bj_TIMETYPE_SET_10 == nil then
    ____jglobals_bj_TIMETYPE_SET_10 = 1
end
____exports.bj_TIMETYPE_SET = ____jglobals_bj_TIMETYPE_SET_10
local ____jglobals_bj_TIMETYPE_SUB_11 = jglobals.bj_TIMETYPE_SUB
if ____jglobals_bj_TIMETYPE_SUB_11 == nil then
    ____jglobals_bj_TIMETYPE_SUB_11 = 2
end
____exports.bj_TIMETYPE_SUB = ____jglobals_bj_TIMETYPE_SUB_11
local ____jglobals_bj_NOTHING_SOUND_DURATION_12 = jglobals.bj_NOTHING_SOUND_DURATION
if ____jglobals_bj_NOTHING_SOUND_DURATION_12 == nil then
    ____jglobals_bj_NOTHING_SOUND_DURATION_12 = 5
end
____exports.bj_NOTHING_SOUND_DURATION = ____jglobals_bj_NOTHING_SOUND_DURATION_12
local ____jglobals_bj_GAME_STARTED_THRESHOLD_13 = jglobals.bj_GAME_STARTED_THRESHOLD
if ____jglobals_bj_GAME_STARTED_THRESHOLD_13 == nil then
    ____jglobals_bj_GAME_STARTED_THRESHOLD_13 = 0.1
end
____exports.bj_GAME_STARTED_THRESHOLD = ____jglobals_bj_GAME_STARTED_THRESHOLD_13
local ____jglobals_bj_CINEMODE_VOLUME_UNITMOVEMENT_14 = jglobals.bj_CINEMODE_VOLUME_UNITMOVEMENT
if ____jglobals_bj_CINEMODE_VOLUME_UNITMOVEMENT_14 == nil then
    ____jglobals_bj_CINEMODE_VOLUME_UNITMOVEMENT_14 = 0.25
end
____exports.bj_CINEMODE_VOLUME_UNITMOVEMENT = ____jglobals_bj_CINEMODE_VOLUME_UNITMOVEMENT_14
local ____jglobals_bj_CINEMODE_VOLUME_UNITSOUNDS_15 = jglobals.bj_CINEMODE_VOLUME_UNITSOUNDS
if ____jglobals_bj_CINEMODE_VOLUME_UNITSOUNDS_15 == nil then
    ____jglobals_bj_CINEMODE_VOLUME_UNITSOUNDS_15 = 0.4
end
____exports.bj_CINEMODE_VOLUME_UNITSOUNDS = ____jglobals_bj_CINEMODE_VOLUME_UNITSOUNDS_15
local ____jglobals_bj_CINEMODE_VOLUME_COMBAT_16 = jglobals.bj_CINEMODE_VOLUME_COMBAT
if ____jglobals_bj_CINEMODE_VOLUME_COMBAT_16 == nil then
    ____jglobals_bj_CINEMODE_VOLUME_COMBAT_16 = 0.4
end
____exports.bj_CINEMODE_VOLUME_COMBAT = ____jglobals_bj_CINEMODE_VOLUME_COMBAT_16
local ____jglobals_bj_CINEMODE_VOLUME_SPELLS_17 = jglobals.bj_CINEMODE_VOLUME_SPELLS
if ____jglobals_bj_CINEMODE_VOLUME_SPELLS_17 == nil then
    ____jglobals_bj_CINEMODE_VOLUME_SPELLS_17 = 0.4
end
____exports.bj_CINEMODE_VOLUME_SPELLS = ____jglobals_bj_CINEMODE_VOLUME_SPELLS_17
local ____jglobals_bj_CINEMODE_VOLUME_UI_18 = jglobals.bj_CINEMODE_VOLUME_UI
if ____jglobals_bj_CINEMODE_VOLUME_UI_18 == nil then
    ____jglobals_bj_CINEMODE_VOLUME_UI_18 = 0.4
end
____exports.bj_CINEMODE_VOLUME_UI = ____jglobals_bj_CINEMODE_VOLUME_UI_18
local ____jglobals_bj_CINEMODE_VOLUME_MUSIC_19 = jglobals.bj_CINEMODE_VOLUME_MUSIC
if ____jglobals_bj_CINEMODE_VOLUME_MUSIC_19 == nil then
    ____jglobals_bj_CINEMODE_VOLUME_MUSIC_19 = 0.4
end
____exports.bj_CINEMODE_VOLUME_MUSIC = ____jglobals_bj_CINEMODE_VOLUME_MUSIC_19
local ____jglobals_bj_CINEMODE_VOLUME_AMBIENTSOUNDS_20 = jglobals.bj_CINEMODE_VOLUME_AMBIENTSOUNDS
if ____jglobals_bj_CINEMODE_VOLUME_AMBIENTSOUNDS_20 == nil then
    ____jglobals_bj_CINEMODE_VOLUME_AMBIENTSOUNDS_20 = 0.4
end
____exports.bj_CINEMODE_VOLUME_AMBIENTSOUNDS = ____jglobals_bj_CINEMODE_VOLUME_AMBIENTSOUNDS_20
local ____jglobals_bj_CINEMODE_VOLUME_FIRE_21 = jglobals.bj_CINEMODE_VOLUME_FIRE
if ____jglobals_bj_CINEMODE_VOLUME_FIRE_21 == nil then
    ____jglobals_bj_CINEMODE_VOLUME_FIRE_21 = 0.4
end
____exports.bj_CINEMODE_VOLUME_FIRE = ____jglobals_bj_CINEMODE_VOLUME_FIRE_21
local ____jglobals_SOUND_VOLUMEGROUP_UNITMOVEMENT_22 = jglobals.SOUND_VOLUMEGROUP_UNITMOVEMENT
if ____jglobals_SOUND_VOLUMEGROUP_UNITMOVEMENT_22 == nil then
    ____jglobals_SOUND_VOLUMEGROUP_UNITMOVEMENT_22 = 0
end
____exports.SOUND_VOLUMEGROUP_UNITMOVEMENT = ____jglobals_SOUND_VOLUMEGROUP_UNITMOVEMENT_22
local ____jglobals_SOUND_VOLUMEGROUP_UNITSOUNDS_23 = jglobals.SOUND_VOLUMEGROUP_UNITSOUNDS
if ____jglobals_SOUND_VOLUMEGROUP_UNITSOUNDS_23 == nil then
    ____jglobals_SOUND_VOLUMEGROUP_UNITSOUNDS_23 = 1
end
____exports.SOUND_VOLUMEGROUP_UNITSOUNDS = ____jglobals_SOUND_VOLUMEGROUP_UNITSOUNDS_23
local ____jglobals_SOUND_VOLUMEGROUP_COMBAT_24 = jglobals.SOUND_VOLUMEGROUP_COMBAT
if ____jglobals_SOUND_VOLUMEGROUP_COMBAT_24 == nil then
    ____jglobals_SOUND_VOLUMEGROUP_COMBAT_24 = 2
end
____exports.SOUND_VOLUMEGROUP_COMBAT = ____jglobals_SOUND_VOLUMEGROUP_COMBAT_24
local ____jglobals_SOUND_VOLUMEGROUP_SPELLS_25 = jglobals.SOUND_VOLUMEGROUP_SPELLS
if ____jglobals_SOUND_VOLUMEGROUP_SPELLS_25 == nil then
    ____jglobals_SOUND_VOLUMEGROUP_SPELLS_25 = 3
end
____exports.SOUND_VOLUMEGROUP_SPELLS = ____jglobals_SOUND_VOLUMEGROUP_SPELLS_25
local ____jglobals_SOUND_VOLUMEGROUP_UI_26 = jglobals.SOUND_VOLUMEGROUP_UI
if ____jglobals_SOUND_VOLUMEGROUP_UI_26 == nil then
    ____jglobals_SOUND_VOLUMEGROUP_UI_26 = 4
end
____exports.SOUND_VOLUMEGROUP_UI = ____jglobals_SOUND_VOLUMEGROUP_UI_26
local ____jglobals_SOUND_VOLUMEGROUP_MUSIC_27 = jglobals.SOUND_VOLUMEGROUP_MUSIC
if ____jglobals_SOUND_VOLUMEGROUP_MUSIC_27 == nil then
    ____jglobals_SOUND_VOLUMEGROUP_MUSIC_27 = 5
end
____exports.SOUND_VOLUMEGROUP_MUSIC = ____jglobals_SOUND_VOLUMEGROUP_MUSIC_27
local ____jglobals_SOUND_VOLUMEGROUP_AMBIENTSOUNDS_28 = jglobals.SOUND_VOLUMEGROUP_AMBIENTSOUNDS
if ____jglobals_SOUND_VOLUMEGROUP_AMBIENTSOUNDS_28 == nil then
    ____jglobals_SOUND_VOLUMEGROUP_AMBIENTSOUNDS_28 = 6
end
____exports.SOUND_VOLUMEGROUP_AMBIENTSOUNDS = ____jglobals_SOUND_VOLUMEGROUP_AMBIENTSOUNDS_28
local ____jglobals_SOUND_VOLUMEGROUP_FIRE_29 = jglobals.SOUND_VOLUMEGROUP_FIRE
if ____jglobals_SOUND_VOLUMEGROUP_FIRE_29 == nil then
    ____jglobals_SOUND_VOLUMEGROUP_FIRE_29 = 7
end
____exports.SOUND_VOLUMEGROUP_FIRE = ____jglobals_SOUND_VOLUMEGROUP_FIRE_29
____exports.bj_cineSceneLastSound = jglobals.bj_cineSceneLastSound
____exports.bj_cineSceneBeingSkipped = jglobals.bj_cineSceneBeingSkipped
local ____jglobals_bj_useDawnDuskSounds_30 = jglobals.bj_useDawnDuskSounds
if ____jglobals_bj_useDawnDuskSounds_30 == nil then
    ____jglobals_bj_useDawnDuskSounds_30 = false
end
____exports.bj_useDawnDuskSounds = ____jglobals_bj_useDawnDuskSounds_30
local ____jglobals_bj_gameStarted_31 = jglobals.bj_gameStarted
if ____jglobals_bj_gameStarted_31 == nil then
    ____jglobals_bj_gameStarted_31 = false
end
____exports.bj_gameStarted = ____jglobals_bj_gameStarted_31
____exports.bj_volumeGroupsTimer = jglobals.bj_volumeGroupsTimer
local ____jglobals_bj_cineModeAlreadyIn_32 = jglobals.bj_cineModeAlreadyIn
if ____jglobals_bj_cineModeAlreadyIn_32 == nil then
    ____jglobals_bj_cineModeAlreadyIn_32 = false
end
____exports.bj_cineModeAlreadyIn = ____jglobals_bj_cineModeAlreadyIn_32
local ____jglobals_bj_cineModePriorSpeed_33 = jglobals.bj_cineModePriorSpeed
if ____jglobals_bj_cineModePriorSpeed_33 == nil then
    ____jglobals_bj_cineModePriorSpeed_33 = 0
end
____exports.bj_cineModePriorSpeed = ____jglobals_bj_cineModePriorSpeed_33
local ____jglobals_bj_cineModePriorFogSetting_34 = jglobals.bj_cineModePriorFogSetting
if ____jglobals_bj_cineModePriorFogSetting_34 == nil then
    ____jglobals_bj_cineModePriorFogSetting_34 = false
end
____exports.bj_cineModePriorFogSetting = ____jglobals_bj_cineModePriorFogSetting_34
local ____jglobals_bj_cineModePriorMaskSetting_35 = jglobals.bj_cineModePriorMaskSetting
if ____jglobals_bj_cineModePriorMaskSetting_35 == nil then
    ____jglobals_bj_cineModePriorMaskSetting_35 = false
end
____exports.bj_cineModePriorMaskSetting = ____jglobals_bj_cineModePriorMaskSetting_35
local ____jglobals_bj_cineModePriorDawnDusk_36 = jglobals.bj_cineModePriorDawnDusk
if ____jglobals_bj_cineModePriorDawnDusk_36 == nil then
    ____jglobals_bj_cineModePriorDawnDusk_36 = false
end
____exports.bj_cineModePriorDawnDusk = ____jglobals_bj_cineModePriorDawnDusk_36
local ____jglobals_bj_cineModeSavedSeed_37 = jglobals.bj_cineModeSavedSeed
if ____jglobals_bj_cineModeSavedSeed_37 == nil then
    ____jglobals_bj_cineModeSavedSeed_37 = 0
end
____exports.bj_cineModeSavedSeed = ____jglobals_bj_cineModeSavedSeed_37
____exports.bj_cineFadeContinueTimer = jglobals.bj_cineFadeContinueTimer
____exports.bj_cineFadeFinishTimer = jglobals.bj_cineFadeFinishTimer
local ____jglobals_EVENT_PLAYER_END_CINEMATIC_38 = jglobals.EVENT_PLAYER_END_CINEMATIC
if ____jglobals_EVENT_PLAYER_END_CINEMATIC_38 == nil then
    ____jglobals_EVENT_PLAYER_END_CINEMATIC_38 = 2
end
____exports.EVENT_PLAYER_END_CINEMATIC = ____jglobals_EVENT_PLAYER_END_CINEMATIC_38
local ____jglobals_TEXMAP_FLAG_NONE_39 = jglobals.TEXMAP_FLAG_NONE
if ____jglobals_TEXMAP_FLAG_NONE_39 == nil then
    ____jglobals_TEXMAP_FLAG_NONE_39 = 0
end
____exports.TEXMAP_FLAG_NONE = ____jglobals_TEXMAP_FLAG_NONE_39
local ____jglobals_MAP_LOCK_SPEED_40 = jglobals.MAP_LOCK_SPEED
if ____jglobals_MAP_LOCK_SPEED_40 == nil then
    ____jglobals_MAP_LOCK_SPEED_40 = 0
end
____exports.MAP_LOCK_SPEED = ____jglobals_MAP_LOCK_SPEED_40
function ____exports.StopSoundBJ(soundHandle, fadeOut)
    jass:StopSound(soundHandle, false, fadeOut)
end
function ____exports.CancelCineSceneBJ()
    ____exports.StopSoundBJ(____exports.bj_cineSceneLastSound, true)
    jass:EndCinematicScene()
end
function ____exports.CameraResetSmoothingFactorBJ()
    jass:CameraSetSmoothingFactor(0)
end
function ____exports.SetCineModeVolumeGroupsImmediateBJ()
    jass:VolumeGroupSetVolume(____exports.SOUND_VOLUMEGROUP_UNITMOVEMENT, ____exports.bj_CINEMODE_VOLUME_UNITMOVEMENT)
    jass:VolumeGroupSetVolume(____exports.SOUND_VOLUMEGROUP_UNITSOUNDS, ____exports.bj_CINEMODE_VOLUME_UNITSOUNDS)
    jass:VolumeGroupSetVolume(____exports.SOUND_VOLUMEGROUP_COMBAT, ____exports.bj_CINEMODE_VOLUME_COMBAT)
    jass:VolumeGroupSetVolume(____exports.SOUND_VOLUMEGROUP_SPELLS, ____exports.bj_CINEMODE_VOLUME_SPELLS)
    jass:VolumeGroupSetVolume(____exports.SOUND_VOLUMEGROUP_UI, ____exports.bj_CINEMODE_VOLUME_UI)
    jass:VolumeGroupSetVolume(____exports.SOUND_VOLUMEGROUP_MUSIC, ____exports.bj_CINEMODE_VOLUME_MUSIC)
    jass:VolumeGroupSetVolume(____exports.SOUND_VOLUMEGROUP_AMBIENTSOUNDS, ____exports.bj_CINEMODE_VOLUME_AMBIENTSOUNDS)
    jass:VolumeGroupSetVolume(____exports.SOUND_VOLUMEGROUP_FIRE, ____exports.bj_CINEMODE_VOLUME_FIRE)
end
function ____exports.SetCineModeVolumeGroupsBJ()
    if ____exports.bj_gameStarted then
        ____exports.SetCineModeVolumeGroupsImmediateBJ()
    else
        local t = ____exports.bj_volumeGroupsTimer
        if t ~= nil then
            jass:TimerStart(t, ____exports.bj_GAME_STARTED_THRESHOLD, false, ____exports.SetCineModeVolumeGroupsImmediateBJ)
        end
    end
end
function ____exports.GetSoundDurationBJ(soundHandle)
    if soundHandle == nil then
        return ____exports.bj_NOTHING_SOUND_DURATION
    end
    return jass:GetSoundDuration(soundHandle) * 0.001
end
function ____exports.GetTransmissionDuration(soundHandle, timeType, timeVal)
    local duration
    if timeType == ____exports.bj_TIMETYPE_ADD then
        duration = ____exports.GetSoundDurationBJ(soundHandle) + timeVal
    elseif timeType == ____exports.bj_TIMETYPE_SET then
        duration = timeVal
    elseif timeType == ____exports.bj_TIMETYPE_SUB then
        duration = ____exports.GetSoundDurationBJ(soundHandle) - timeVal
    else
        duration = ____exports.GetSoundDurationBJ(soundHandle)
    end
    if duration < 0 then
        duration = 0
    end
    return duration
end
function ____exports.WaitForSoundBJ(soundHandle, offset)
    jass:TriggerWaitForSound(soundHandle, offset)
end
function ____exports.WaitTransmissionDuration(soundHandle, timeType, timeVal)
    if timeType == ____exports.bj_TIMETYPE_SET then
        jass:TriggerSleepAction(timeVal)
    elseif soundHandle == nil then
        jass:TriggerSleepAction(____exports.bj_NOTHING_SOUND_DURATION)
    elseif timeType == ____exports.bj_TIMETYPE_SUB then
        ____exports.WaitForSoundBJ(soundHandle, timeVal)
    elseif timeType == ____exports.bj_TIMETYPE_ADD then
        ____exports.WaitForSoundBJ(soundHandle, 0)
        jass:TriggerSleepAction(timeVal)
    end
end
function ____exports.EnableDawnDusk(flag)
    ____exports.bj_useDawnDuskSounds = flag
end
function ____exports.IsDawnDuskEnabled()
    return not not ____exports.bj_useDawnDuskSounds
end
function ____exports.PlaySoundBJ(soundHandle)
    jglobals.bj_lastPlayedSound = soundHandle
    if soundHandle ~= nil then
        StartSound(soundHandle)
    end
end
--- 与 Blizzard.j 的 PlaySoundOnUnitBJ 保持一致。
function ____exports.PlaySoundOnUnitBJ(soundHandle, volumePercent, whichUnit)
    AttachSoundToUnit(soundHandle, whichUnit)
    SetSoundVolume(soundHandle, volumePercent)
    ____exports.PlaySoundBJ(soundHandle)
end
return ____exports
