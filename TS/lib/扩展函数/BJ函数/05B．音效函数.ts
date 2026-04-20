const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

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

export let bj_cineSceneLastSound: any = jglobals.bj_cineSceneLastSound;
export let bj_cineSceneBeingSkipped: any = jglobals.bj_cineSceneBeingSkipped;
export let bj_useDawnDuskSounds: boolean = jglobals.bj_useDawnDuskSounds ?? false;
export let bj_gameStarted: boolean = jglobals.bj_gameStarted ?? false;
export let bj_volumeGroupsTimer: any = jglobals.bj_volumeGroupsTimer;
export let bj_cineModeAlreadyIn: boolean = jglobals.bj_cineModeAlreadyIn ?? false;
export let bj_cineModePriorSpeed: number = jglobals.bj_cineModePriorSpeed ?? 0;
export let bj_cineModePriorFogSetting: boolean = jglobals.bj_cineModePriorFogSetting ?? false;
export let bj_cineModePriorMaskSetting: boolean = jglobals.bj_cineModePriorMaskSetting ?? false;
export let bj_cineModePriorDawnDusk: boolean = jglobals.bj_cineModePriorDawnDusk ?? false;
export let bj_cineModeSavedSeed: number = jglobals.bj_cineModeSavedSeed ?? 0;
export let bj_cineFadeContinueTimer: any = jglobals.bj_cineFadeContinueTimer;
export let bj_cineFadeFinishTimer: any = jglobals.bj_cineFadeFinishTimer;

export const EVENT_PLAYER_END_CINEMATIC = jglobals.EVENT_PLAYER_END_CINEMATIC ?? 2;
export const TEXMAP_FLAG_NONE = jglobals.TEXMAP_FLAG_NONE ?? 0;
export const MAP_LOCK_SPEED = jglobals.MAP_LOCK_SPEED ?? 0;

export function StopSoundBJ(soundHandle: any, fadeOut: boolean): void {
    jass.StopSound(soundHandle, false, fadeOut);
}

export function CancelCineSceneBJ(): void {
    StopSoundBJ(bj_cineSceneLastSound, true);
    jass.EndCinematicScene();
}

export function CameraResetSmoothingFactorBJ(): void {
    jass.CameraSetSmoothingFactor(0);
}

export function SetCineModeVolumeGroupsImmediateBJ(): void {
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITMOVEMENT, bj_CINEMODE_VOLUME_UNITMOVEMENT);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UNITSOUNDS, bj_CINEMODE_VOLUME_UNITSOUNDS);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_COMBAT, bj_CINEMODE_VOLUME_COMBAT);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_SPELLS, bj_CINEMODE_VOLUME_SPELLS);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_UI, bj_CINEMODE_VOLUME_UI);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_MUSIC, bj_CINEMODE_VOLUME_MUSIC);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_AMBIENTSOUNDS, bj_CINEMODE_VOLUME_AMBIENTSOUNDS);
    jass.VolumeGroupSetVolume(SOUND_VOLUMEGROUP_FIRE, bj_CINEMODE_VOLUME_FIRE);
}

export function SetCineModeVolumeGroupsBJ(): void {
    if (bj_gameStarted) {
        SetCineModeVolumeGroupsImmediateBJ();
    } else {
        const t = bj_volumeGroupsTimer;
        if (t != null) {
            jass.TimerStart(t, bj_GAME_STARTED_THRESHOLD, false, SetCineModeVolumeGroupsImmediateBJ);
        }
    }
}

export function GetSoundDurationBJ(soundHandle: any): number {
    if (soundHandle == null) return bj_NOTHING_SOUND_DURATION;
    return jass.GetSoundDuration(soundHandle) * 0.001;
}

export function GetTransmissionDuration(soundHandle: any, timeType: number, timeVal: number): number {
    let duration: number;
    if (timeType === bj_TIMETYPE_ADD) {
        duration = GetSoundDurationBJ(soundHandle) + timeVal;
    } else if (timeType === bj_TIMETYPE_SET) {
        duration = timeVal;
    } else if (timeType === bj_TIMETYPE_SUB) {
        duration = GetSoundDurationBJ(soundHandle) - timeVal;
    } else {
        duration = GetSoundDurationBJ(soundHandle);
    }
    if (duration < 0) duration = 0;
    return duration;
}

export function WaitForSoundBJ(soundHandle: any, offset: number): void {
    if (typeof jass.TriggerWaitForSound === "function") {
        jass.TriggerWaitForSound(soundHandle, offset);
    }
}

export function WaitTransmissionDuration(soundHandle: any, timeType: number, timeVal: number): void {
    if (timeType === bj_TIMETYPE_SET) {
        if (typeof jass.TriggerSleepAction === "function") {
            jass.TriggerSleepAction(timeVal);
        }
    } else if (soundHandle == null) {
        if (typeof jass.TriggerSleepAction === "function") {
            jass.TriggerSleepAction(bj_NOTHING_SOUND_DURATION);
        }
    } else if (timeType === bj_TIMETYPE_SUB) {
        WaitForSoundBJ(soundHandle, timeVal);
    } else if (timeType === bj_TIMETYPE_ADD) {
        WaitForSoundBJ(soundHandle, 0);
        if (typeof jass.TriggerSleepAction === "function") {
            jass.TriggerSleepAction(timeVal);
        }
    }
}

export function EnableDawnDusk(flag: boolean): void {
    bj_useDawnDuskSounds = flag;
}

export function IsDawnDuskEnabled(): boolean {
    return !!bj_useDawnDuskSounds;
}

export function PlaySoundBJ(soundHandle: any): void {
    jglobals.bj_lastPlayedSound = soundHandle;
    if (soundHandle != null && typeof jass.StartSound === "function") {
        jass.StartSound(soundHandle);
    }
}

export {};
