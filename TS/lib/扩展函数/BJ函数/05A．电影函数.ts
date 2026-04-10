import {
    bj_CINEMODE_GAMESPEED,
    bj_CINEMODE_INTERFACEFADE,
    bj_CINEMODE_VOLUME_UNITMOVEMENT,
    bj_CINEMODE_VOLUME_UNITSOUNDS,
    bj_CINEMODE_VOLUME_COMBAT,
    bj_CINEMODE_VOLUME_SPELLS,
    bj_CINEMODE_VOLUME_UI,
    bj_CINEMODE_VOLUME_MUSIC,
    bj_CINEMODE_VOLUME_AMBIENTSOUNDS,
    bj_CINEMODE_VOLUME_FIRE,
    SOUND_VOLUMEGROUP_UNITMOVEMENT,
    SOUND_VOLUMEGROUP_UNITSOUNDS,
    SOUND_VOLUMEGROUP_COMBAT,
    SOUND_VOLUMEGROUP_SPELLS,
    SOUND_VOLUMEGROUP_UI,
    SOUND_VOLUMEGROUP_MUSIC,
    SOUND_VOLUMEGROUP_AMBIENTSOUNDS,
    SOUND_VOLUMEGROUP_FIRE,
    bj_MAX_PLAYERS,
    bj_GAME_STARTED_THRESHOLD,
    bj_TRANSMISSION_IND_RED,
    bj_TRANSMISSION_IND_BLUE,
    bj_TRANSMISSION_IND_GREEN,
    bj_TRANSMISSION_IND_ALPHA,
    bj_TRANSMISSION_PORT_HANGTIME,
    bj_TRANSMISSION_PING_TIME,
    EVENT_PLAYER_END_CINEMATIC,
    TEXMAP_FLAG_NONE,
    MAP_LOCK_SPEED,
    CancelCineSceneBJ,
    PlaySoundBJ,
    WaitForSoundBJ,
    WaitTransmissionDuration,
    EnableDawnDusk,
    IsDawnDuskEnabled,
    GetSoundDurationBJ,
    PercentToInt,
    PercentTo255,
    RMaxBJ,
    GetTransmissionDuration,
    SetCineModeVolumeGroupsBJ,
    CameraResetSmoothingFactorBJ,
} from "./05B．音效函数";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

export function SetCinematicSceneBJ(
    soundHandle: any,
    portraitUnitId: number,
    color: any,
    speakerTitle: string,
    text: string,
    sceneDuration: number,
    voiceoverDuration: number
): void {
    jglobals.bj_cineSceneLastSound = soundHandle;
    PlaySoundBJ(soundHandle);
    if (typeof jass.SetCinematicScene === "function") {
        jass.SetCinematicScene(portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration);
    }
}

export function DoTransmissionBasicsXYBJ(
    unitId: number,
    color: any,
    x: number,
    y: number,
    soundHandle: any,
    unitName: string,
    message: string,
    duration: number
): void {
    const hang = bj_TRANSMISSION_PORT_HANGTIME;
    SetCinematicSceneBJ(soundHandle, unitId, color, unitName, message, duration + hang, duration);

    if (unitId !== 0 && typeof jass.PingMinimap === "function") {
        jass.PingMinimap(x, y, bj_TRANSMISSION_PING_TIME);
    }
}

export function TryInitCinematicBehaviorBJ(): void {
    if (jglobals.bj_cineSceneBeingSkipped != null) return;
    if (
        typeof jass.CreateTrigger !== "function" ||
        typeof jass.TriggerRegisterPlayerEvent !== "function" ||
        typeof jass.TriggerAddAction !== "function" ||
        typeof jass.Player !== "function"
    ) return;

    jglobals.bj_cineSceneBeingSkipped = jass.CreateTrigger();
    for (let index = 0; index < bj_MAX_PLAYERS; index++) {
        jass.TriggerRegisterPlayerEvent(
            jglobals.bj_cineSceneBeingSkipped,
            jass.Player(index),
            EVENT_PLAYER_END_CINEMATIC
        );
    }

    if (typeof CancelCineSceneBJ === "function") {
        jass.TriggerAddAction(jglobals.bj_cineSceneBeingSkipped, CancelCineSceneBJ);
    }
}

export function TransmissionFromUnitWithNameBJ(
    toForce: any,
    whichUnit: any,
    unitName: string,
    soundHandle: any,
    message: string,
    timeType: number,
    timeVal: number,
    wait: boolean
): void {
    TryInitCinematicBehaviorBJ();

    const safeTime = RMaxBJ(timeVal, 0);

    let duration = 0;
    duration = GetTransmissionDuration(soundHandle, timeType, safeTime);
    jglobals.bj_lastTransmissionDuration = duration;
    jglobals.bj_lastPlayedSound = soundHandle;

    if (
        typeof jass.IsPlayerInForce === "function" &&
        typeof jass.GetLocalPlayer === "function" &&
        jass.IsPlayerInForce(jass.GetLocalPlayer(), toForce)
    ) {
        if (whichUnit == null) {
            const red = typeof jglobals.PLAYER_COLOR_RED !== "undefined" ? jglobals.PLAYER_COLOR_RED : 0;
            DoTransmissionBasicsXYBJ(0, red, 0, 0, soundHandle, unitName, message, duration);
        } else {
            const unitTypeId = typeof jass.GetUnitTypeId === "function" ? jass.GetUnitTypeId(whichUnit) : 0;
            const owner = typeof jass.GetOwningPlayer === "function" ? jass.GetOwningPlayer(whichUnit) : null;
            const color = typeof jass.GetPlayerColor === "function" ? jass.GetPlayerColor(owner) : 0;
            const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(whichUnit) : 0;
            const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(whichUnit) : 0;
            DoTransmissionBasicsXYBJ(unitTypeId, color, x, y, soundHandle, unitName, message, duration);

            if (typeof jass.IsUnitHidden === "function" && !jass.IsUnitHidden(whichUnit) && typeof jass.UnitAddIndicator === "function") {
                jass.UnitAddIndicator(
                    whichUnit,
                    bj_TRANSMISSION_IND_RED,
                    bj_TRANSMISSION_IND_BLUE,
                    bj_TRANSMISSION_IND_GREEN,
                    bj_TRANSMISSION_IND_ALPHA
                );
            }
        }
    }

    if (wait && duration > 0) {
        WaitTransmissionDuration(soundHandle, timeType, safeTime);
    }
}

export function CinematicModeExBJ(cineMode: boolean, forForce: any, interfaceFadeTime: number): void {
    if (!jglobals.bj_gameStarted) {
        interfaceFadeTime = 0;
    }

    if (cineMode) {
        if (!jglobals.bj_cineModeAlreadyIn) {
            jglobals.bj_cineModeAlreadyIn = true;
            if (typeof jass.GetGameSpeed === "function") jglobals.bj_cineModePriorSpeed = jass.GetGameSpeed();
            if (typeof jass.IsFogEnabled === "function") jglobals.bj_cineModePriorFogSetting = jass.IsFogEnabled();
            if (typeof jass.IsFogMaskEnabled === "function") jglobals.bj_cineModePriorMaskSetting = jass.IsFogMaskEnabled();
            jglobals.bj_cineModePriorDawnDusk = IsDawnDuskEnabled();
            if (typeof jass.GetRandomInt === "function") jglobals.bj_cineModeSavedSeed = jass.GetRandomInt(0, 1000000);
        }

        if (
            typeof jass.IsPlayerInForce === "function" &&
            typeof jass.GetLocalPlayer === "function" &&
            jass.IsPlayerInForce(jass.GetLocalPlayer(), forForce)
        ) {
            if (typeof jass.ClearTextMessages === "function") jass.ClearTextMessages();
            if (typeof jass.ShowInterface === "function") jass.ShowInterface(false, interfaceFadeTime);
            if (typeof jass.EnableUserControl === "function") jass.EnableUserControl(false);
            if (typeof jass.EnableOcclusion === "function") jass.EnableOcclusion(false);
            SetCineModeVolumeGroupsBJ();
        }

        if (typeof jass.SetGameSpeed === "function") jass.SetGameSpeed(bj_CINEMODE_GAMESPEED);
        if (typeof jass.SetMapFlag === "function") jass.SetMapFlag(MAP_LOCK_SPEED, true);
        if (typeof jass.FogMaskEnable === "function") jass.FogMaskEnable(false);
        if (typeof jass.FogEnable === "function") jass.FogEnable(false);
        if (typeof jass.EnableWorldFogBoundary === "function") jass.EnableWorldFogBoundary(false);
        EnableDawnDusk(false);
        if (typeof jass.SetRandomSeed === "function") jass.SetRandomSeed(0);
        return;
    }

    jglobals.bj_cineModeAlreadyIn = false;
    if (
        typeof jass.IsPlayerInForce === "function" &&
        typeof jass.GetLocalPlayer === "function" &&
        jass.IsPlayerInForce(jass.GetLocalPlayer(), forForce)
    ) {
        if (typeof jass.ShowInterface === "function") jass.ShowInterface(true, interfaceFadeTime);
        if (typeof jass.EnableUserControl === "function") jass.EnableUserControl(true);
        if (typeof jass.EnableOcclusion === "function") jass.EnableOcclusion(true);
        if (typeof jass.VolumeGroupReset === "function") jass.VolumeGroupReset();
        if (typeof jass.EndThematicMusic === "function") jass.EndThematicMusic();
        CameraResetSmoothingFactorBJ();
    }

    if (typeof jass.SetMapFlag === "function") jass.SetMapFlag(MAP_LOCK_SPEED, false);
    if (typeof jass.SetGameSpeed === "function") jass.SetGameSpeed(jglobals.bj_cineModePriorSpeed);
    if (typeof jass.FogMaskEnable === "function") jass.FogMaskEnable(jglobals.bj_cineModePriorMaskSetting);
    if (typeof jass.FogEnable === "function") jass.FogEnable(jglobals.bj_cineModePriorFogSetting);
    if (typeof jass.EnableWorldFogBoundary === "function") jass.EnableWorldFogBoundary(true);
    EnableDawnDusk(jglobals.bj_cineModePriorDawnDusk);
    if (typeof jass.SetRandomSeed === "function") jass.SetRandomSeed(jglobals.bj_cineModeSavedSeed);
}

export function CinematicModeBJ(cineMode: boolean, forForce: any): void {
    CinematicModeExBJ(cineMode, forForce, bj_CINEMODE_INTERFACEFADE);
}

export function CinematicFilterGenericBJ(
    duration: number,
    bmode: any,
    tex: string,
    red0: number,
    green0: number,
    blue0: number,
    trans0: number,
    red1: number,
    green1: number,
    blue1: number,
    trans1: number
): void {
    if (typeof jass.AbortCinematicFadeBJ === "function") {
    }
    if (typeof jass.SetCineFilterTexture === "function") jass.SetCineFilterTexture(tex);
    if (typeof jass.SetCineFilterBlendMode === "function") jass.SetCineFilterBlendMode(bmode);
    if (typeof jass.SetCineFilterTexMapFlags === "function") jass.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE);
    if (typeof jass.SetCineFilterStartUV === "function") jass.SetCineFilterStartUV(0, 0, 1, 1);
    if (typeof jass.SetCineFilterEndUV === "function") jass.SetCineFilterEndUV(0, 0, 1, 1);
    if (typeof jass.SetCineFilterStartColor === "function") {
        jass.SetCineFilterStartColor(
            PercentTo255(red0),
            PercentTo255(green0),
            PercentTo255(blue0),
            PercentTo255(100 - trans0)
        );
    }
    if (typeof jass.SetCineFilterEndColor === "function") {
        jass.SetCineFilterEndColor(
            PercentTo255(red1),
            PercentTo255(green1),
            PercentTo255(blue1),
            PercentTo255(100 - trans1)
        );
    }
    if (typeof jass.SetCineFilterDuration === "function") jass.SetCineFilterDuration(duration);
    if (typeof jass.DisplayCineFilter === "function") jass.DisplayCineFilter(true);
}

export function AbortCinematicFadeBJ(): void {
    const t1 = jglobals.bj_cineFadeContinueTimer;
    const t2 = jglobals.bj_cineFadeFinishTimer;
    if (t1 != null && typeof jass.DestroyTimer === "function") {
        jass.DestroyTimer(t1);
    }
    if (t2 != null && typeof jass.DestroyTimer === "function") {
        jass.DestroyTimer(t2);
    }
}

export {};
