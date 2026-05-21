const jass = require("jass.common");
const jglobals = require("jass.globals");
export const bj_CINEMODE_GAMESPEED = jglobals.bj_CINEMODE_GAMESPEED ?? 0;
export const bj_CINEMODE_INTERFACEFADE = jglobals.bj_CINEMODE_INTERFACEFADE ?? 0.5;
export const bj_TRANSMISSION_PORT_HANGTIME = jglobals.bj_TRANSMISSION_PORT_HANGTIME ?? 0;
export const bj_TRANSMISSION_PING_TIME = jglobals.bj_TRANSMISSION_PING_TIME ?? 1.0;
export const bj_TRANSMISSION_IND_RED = jglobals.bj_TRANSMISSION_IND_RED ?? 255;
export const bj_TRANSMISSION_IND_BLUE = jglobals.bj_TRANSMISSION_IND_BLUE ?? 255;
export const bj_TRANSMISSION_IND_GREEN = jglobals.bj_TRANSMISSION_IND_GREEN ?? 255;
export const bj_TRANSMISSION_IND_ALPHA = jglobals.bj_TRANSMISSION_IND_ALPHA ?? 255;
export const bj_MAX_PLAYERS = jglobals.bj_MAX_PLAYERS ?? 16;
export const bj_TIMETYPE_ADD = jglobals.bj_TIMETYPE_ADD ?? 0;
export const bj_TIMETYPE_SET = jglobals.bj_TIMETYPE_SET ?? 1;
export const bj_TIMETYPE_SUB = jglobals.bj_TIMETYPE_SUB ?? 2;
export const bj_NOTHING_SOUND_DURATION = jglobals.bj_NOTHING_SOUND_DURATION ?? 5.0;
export const bj_GAME_STARTED_THRESHOLD = jglobals.bj_GAME_STARTED_THRESHOLD ?? 0.1;
export const bj_CINEMODE_VOLUME_UNITMOVEMENT = jglobals.bj_CINEMODE_VOLUME_UNITMOVEMENT ?? 0.25;
export const bj_CINEMODE_VOLUME_UNITSOUNDS = jglobals.bj_CINEMODE_VOLUME_UNITSOUNDS ?? 0.4;
export const bj_CINEMODE_VOLUME_COMBAT = jglobals.bj_CINEMODE_VOLUME_COMBAT ?? 0.4;
export const bj_CINEMODE_VOLUME_SPELLS = jglobals.bj_CINEMODE_VOLUME_SPELLS ?? 0.4;
export const bj_CINEMODE_VOLUME_UI = jglobals.bj_CINEMODE_VOLUME_UI ?? 0.4;
export const bj_CINEMODE_VOLUME_MUSIC = jglobals.bj_CINEMODE_VOLUME_MUSIC ?? 0.4;
export const bj_CINEMODE_VOLUME_AMBIENTSOUNDS = jglobals.bj_CINEMODE_VOLUME_AMBIENTSOUNDS ?? 0.4;
export const bj_CINEMODE_VOLUME_FIRE = jglobals.bj_CINEMODE_VOLUME_FIRE ?? 0.4;
export const SOUND_VOLUMEGROUP_UNITMOVEMENT = jglobals.SOUND_VOLUMEGROUP_UNITMOVEMENT ?? 0;
export const SOUND_VOLUMEGROUP_UNITSOUNDS = jglobals.SOUND_VOLUMEGROUP_UNITSOUNDS ?? 1;
export const SOUND_VOLUMEGROUP_COMBAT = jglobals.SOUND_VOLUMEGROUP_COMBAT ?? 2;
export const SOUND_VOLUMEGROUP_SPELLS = jglobals.SOUND_VOLUMEGROUP_SPELLS ?? 3;
export const SOUND_VOLUMEGROUP_UI = jglobals.SOUND_VOLUMEGROUP_UI ?? 4;
export const SOUND_VOLUMEGROUP_MUSIC = jglobals.SOUND_VOLUMEGROUP_MUSIC ?? 5;
export const SOUND_VOLUMEGROUP_AMBIENTSOUNDS = jglobals.SOUND_VOLUMEGROUP_AMBIENTSOUNDS ?? 6;
export const SOUND_VOLUMEGROUP_FIRE = jglobals.SOUND_VOLUMEGROUP_FIRE ?? 7;
export let bj_cineSceneLastSound = jglobals.bj_cineSceneLastSound;
export let bj_cineSceneBeingSkipped = jglobals.bj_cineSceneBeingSkipped;
export let bj_useDawnDuskSounds = jglobals.bj_useDawnDuskSounds ?? false;
export let bj_gameStarted = jglobals.bj_gameStarted ?? false;
export let bj_volumeGroupsTimer = jglobals.bj_volumeGroupsTimer;
export let bj_cineModeAlreadyIn = jglobals.bj_cineModeAlreadyIn ?? false;
export let bj_cineModePriorSpeed = jglobals.bj_cineModePriorSpeed ?? 0;
export let bj_cineModePriorFogSetting = jglobals.bj_cineModePriorFogSetting ?? false;
export let bj_cineModePriorMaskSetting = jglobals.bj_cineModePriorMaskSetting ?? false;
export let bj_cineModePriorDawnDusk = jglobals.bj_cineModePriorDawnDusk ?? false;
export let bj_cineModeSavedSeed = jglobals.bj_cineModeSavedSeed ?? 0;
export let bj_cineFadeContinueTimer = jglobals.bj_cineFadeContinueTimer;
export let bj_cineFadeFinishTimer = jglobals.bj_cineFadeFinishTimer;
export const EVENT_PLAYER_END_CINEMATIC = jglobals.EVENT_PLAYER_END_CINEMATIC ?? 2;
export const TEXMAP_FLAG_NONE = jglobals.TEXMAP_FLAG_NONE ?? 0;
export const MAP_LOCK_SPEED = jglobals.MAP_LOCK_SPEED ?? 0;
export function StopSoundBJ(soundHandle, fadeOut) {
    jass.StopSound(soundHandle, false, fadeOut);
}
export function CancelCineSceneBJ() {
    StopSoundBJ(bj_cineSceneLastSound, true);
    jass.EndCinematicScene();
}
export function CameraResetSmoothingFactorBJ() {
    jass.CameraSetSmoothingFactor(0);
}
export function SetCineModeVolumeGroupsImmediateBJ() {
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITMOVEMENT, bj_CINEMODE_VOLUME_UNITMOVEMENT);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITSOUNDS, bj_CINEMODE_VOLUME_UNITSOUNDS);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_COMBAT, bj_CINEMODE_VOLUME_COMBAT);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_SPELLS, bj_CINEMODE_VOLUME_SPELLS);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UI, bj_CINEMODE_VOLUME_UI);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC, bj_CINEMODE_VOLUME_MUSIC);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_AMBIENTSOUNDS, bj_CINEMODE_VOLUME_AMBIENTSOUNDS);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_FIRE, bj_CINEMODE_VOLUME_FIRE);
}
export function SetCineModeVolumeGroupsBJ() {
    if (bj_gameStarted) {
        SetCineModeVolumeGroupsImmediateBJ();
    }
    else {
        const t = bj_volumeGroupsTimer;
        if (t != null) {
            jass.TimerStart(t, bj_GAME_STARTED_THRESHOLD, false, SetCineModeVolumeGroupsImmediateBJ);
        }
    }
}
export function GetSoundDurationBJ(soundHandle) {
    if (soundHandle == null)
        return bj_NOTHING_SOUND_DURATION;
    return jass.GetSoundDuration(soundHandle) * 0.001;
}
export function GetTransmissionDuration(soundHandle, timeType, timeVal) {
    let duration;
    if (timeType === bj_TIMETYPE_ADD) {
        duration = GetSoundDurationBJ(soundHandle) + timeVal;
    }
    else if (timeType === bj_TIMETYPE_SET) {
        duration = timeVal;
    }
    else if (timeType === bj_TIMETYPE_SUB) {
        duration = GetSoundDurationBJ(soundHandle) - timeVal;
    }
    else {
        duration = GetSoundDurationBJ(soundHandle);
    }
    if (duration < 0)
        duration = 0;
    return duration;
}
export function WaitForSoundBJ(soundHandle, offset) {
    jass.TriggerWaitForSound(soundHandle, offset);
}
export function WaitTransmissionDuration(soundHandle, timeType, timeVal) {
    if (timeType === bj_TIMETYPE_SET) {
        jass.TriggerSleepAction(timeVal);
    }
    else if (soundHandle == null) {
        jass.TriggerSleepAction(bj_NOTHING_SOUND_DURATION);
    }
    else if (timeType === bj_TIMETYPE_SUB) {
        WaitForSoundBJ(soundHandle, timeVal);
    }
    else if (timeType === bj_TIMETYPE_ADD) {
        WaitForSoundBJ(soundHandle, 0);
        jass.TriggerSleepAction(timeVal);
    }
}
export function EnableDawnDusk(flag) {
    bj_useDawnDuskSounds = flag;
}
export function IsDawnDuskEnabled() {
    return !!bj_useDawnDuskSounds;
}
export function PlaySoundBJ(soundHandle) {
    jglobals.bj_lastPlayedSound = soundHandle;
    if (soundHandle != null) {
        jass.StartSound(soundHandle);
    }
}
