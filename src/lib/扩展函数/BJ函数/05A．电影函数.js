import { bj_CINEMODE_GAMESPEED, bj_CINEMODE_INTERFACEFADE, bj_MAX_PLAYERS, bj_TRANSMISSION_IND_RED, bj_TRANSMISSION_IND_BLUE, bj_TRANSMISSION_IND_GREEN, bj_TRANSMISSION_IND_ALPHA, bj_TRANSMISSION_PORT_HANGTIME, bj_TRANSMISSION_PING_TIME, EVENT_PLAYER_END_CINEMATIC, TEXMAP_FLAG_NONE, MAP_LOCK_SPEED, CancelCineSceneBJ, PlaySoundBJ, WaitTransmissionDuration, EnableDawnDusk, IsDawnDuskEnabled, PercentTo255, RMaxBJ, GetTransmissionDuration, SetCineModeVolumeGroupsBJ, CameraResetSmoothingFactorBJ, } from "./05B．音效函数";
const jass = require("jass.common");
const jglobals = require("jass.globals");
export function SetCinematicSceneBJ(soundHandle, portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration) {
    jglobals.bj_cineSceneLastSound = soundHandle;
    PlaySoundBJ(soundHandle);
    if (typeof jass.SetCinematicScene === "function") {
        jass.SetCinematicScene(portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration);
    }
}
export function DoTransmissionBasicsXYBJ(unitId, color, x, y, soundHandle, unitName, message, duration) {
    const hang = bj_TRANSMISSION_PORT_HANGTIME;
    SetCinematicSceneBJ(soundHandle, unitId, color, unitName, message, duration + hang, duration);
    if (unitId !== 0 && typeof jass.PingMinimap === "function") {
        jass.PingMinimap(x, y, bj_TRANSMISSION_PING_TIME);
    }
}
export function TryInitCinematicBehaviorBJ() {
    if (jglobals.bj_cineSceneBeingSkipped != null)
        return;
    if (typeof jass.CreateTrigger !== "function" ||
        typeof jass.TriggerRegisterPlayerEvent !== "function" ||
        typeof jass.TriggerAddAction !== "function" ||
        typeof jass.Player !== "function")
        return;
    jglobals.bj_cineSceneBeingSkipped = jass.CreateTrigger();
    for (let index = 0; index < bj_MAX_PLAYERS; index++) {
        jass.TriggerRegisterPlayerEvent(jglobals.bj_cineSceneBeingSkipped, jass.Player(index), EVENT_PLAYER_END_CINEMATIC);
    }
    if (typeof CancelCineSceneBJ === "function") {
        jass.TriggerAddAction(jglobals.bj_cineSceneBeingSkipped, CancelCineSceneBJ);
    }
}
export function TransmissionFromUnitWithNameBJ(toForce, whichUnit, unitName, soundHandle, message, timeType, timeVal, wait) {
    TryInitCinematicBehaviorBJ();
    const safeTime = RMaxBJ(timeVal, 0);
    let duration = 0;
    duration = GetTransmissionDuration(soundHandle, timeType, safeTime);
    jglobals.bj_lastTransmissionDuration = duration;
    jglobals.bj_lastPlayedSound = soundHandle;
    if (typeof jass.IsPlayerInForce === "function" &&
        typeof jass.GetLocalPlayer === "function" &&
        jass.IsPlayerInForce(jass.GetLocalPlayer(), toForce)) {
        if (whichUnit == null) {
            const red = typeof jglobals.PLAYER_COLOR_RED !== "undefined" ? jglobals.PLAYER_COLOR_RED : 0;
            DoTransmissionBasicsXYBJ(0, red, 0, 0, soundHandle, unitName, message, duration);
        }
        else {
            const unitTypeId = typeof jass.GetUnitTypeId === "function" ? jass.GetUnitTypeId(whichUnit) : 0;
            const owner = typeof jass.GetOwningPlayer === "function" ? jass.GetOwningPlayer(whichUnit) : null;
            const color = typeof jass.GetPlayerColor === "function" ? jass.GetPlayerColor(owner) : 0;
            const x = typeof jass.GetUnitX === "function" ? jass.GetUnitX(whichUnit) : 0;
            const y = typeof jass.GetUnitY === "function" ? jass.GetUnitY(whichUnit) : 0;
            DoTransmissionBasicsXYBJ(unitTypeId, color, x, y, soundHandle, unitName, message, duration);
            if (typeof jass.IsUnitHidden === "function" && !jass.IsUnitHidden(whichUnit) && typeof jass.UnitAddIndicator === "function") {
                jass.UnitAddIndicator(whichUnit, bj_TRANSMISSION_IND_RED, bj_TRANSMISSION_IND_BLUE, bj_TRANSMISSION_IND_GREEN, bj_TRANSMISSION_IND_ALPHA);
            }
        }
    }
    if (wait && duration > 0) {
        WaitTransmissionDuration(soundHandle, timeType, safeTime);
    }
}
export function CinematicModeExBJ(cineMode, forForce, interfaceFadeTime) {
    if (!jglobals.bj_gameStarted) {
        interfaceFadeTime = 0;
    }
    if (cineMode) {
        if (!jglobals.bj_cineModeAlreadyIn) {
            jglobals.bj_cineModeAlreadyIn = true;
            if (typeof jass.GetGameSpeed === "function")
                jglobals.bj_cineModePriorSpeed = jass.GetGameSpeed();
            if (typeof jass.IsFogEnabled === "function")
                jglobals.bj_cineModePriorFogSetting = jass.IsFogEnabled();
            if (typeof jass.IsFogMaskEnabled === "function")
                jglobals.bj_cineModePriorMaskSetting = jass.IsFogMaskEnabled();
            jglobals.bj_cineModePriorDawnDusk = IsDawnDuskEnabled();
            if (typeof jass.GetRandomInt === "function")
                jglobals.bj_cineModeSavedSeed = jass.GetRandomInt(0, 1000000);
        }
        if (typeof jass.IsPlayerInForce === "function" &&
            typeof jass.GetLocalPlayer === "function" &&
            jass.IsPlayerInForce(jass.GetLocalPlayer(), forForce)) {
            if (typeof jass.ClearTextMessages === "function")
                jass.ClearTextMessages();
            if (typeof jass.ShowInterface === "function")
                jass.ShowInterface(false, interfaceFadeTime);
            if (typeof jass.EnableUserControl === "function")
                jass.EnableUserControl(false);
            if (typeof jass.EnableOcclusion === "function")
                jass.EnableOcclusion(false);
            SetCineModeVolumeGroupsBJ();
        }
        if (typeof jass.SetGameSpeed === "function")
            jass.SetGameSpeed(bj_CINEMODE_GAMESPEED);
        if (typeof jass.SetMapFlag === "function")
            jass.SetMapFlag(MAP_LOCK_SPEED, true);
        if (typeof jass.FogMaskEnable === "function")
            jass.FogMaskEnable(false);
        if (typeof jass.FogEnable === "function")
            jass.FogEnable(false);
        if (typeof jass.EnableWorldFogBoundary === "function")
            jass.EnableWorldFogBoundary(false);
        EnableDawnDusk(false);
        if (typeof jass.SetRandomSeed === "function")
            jass.SetRandomSeed(0);
        return;
    }
    jglobals.bj_cineModeAlreadyIn = false;
    if (typeof jass.IsPlayerInForce === "function" &&
        typeof jass.GetLocalPlayer === "function" &&
        jass.IsPlayerInForce(jass.GetLocalPlayer(), forForce)) {
        if (typeof jass.ShowInterface === "function")
            jass.ShowInterface(true, interfaceFadeTime);
        if (typeof jass.EnableUserControl === "function")
            jass.EnableUserControl(true);
        if (typeof jass.EnableOcclusion === "function")
            jass.EnableOcclusion(true);
        if (typeof jass.VolumeGroupReset === "function")
            jass.VolumeGroupReset();
        if (typeof jass.EndThematicMusic === "function")
            jass.EndThematicMusic();
        CameraResetSmoothingFactorBJ();
    }
    if (typeof jass.SetMapFlag === "function")
        jass.SetMapFlag(MAP_LOCK_SPEED, false);
    if (typeof jass.SetGameSpeed === "function")
        jass.SetGameSpeed(jglobals.bj_cineModePriorSpeed);
    if (typeof jass.FogMaskEnable === "function")
        jass.FogMaskEnable(jglobals.bj_cineModePriorMaskSetting);
    if (typeof jass.FogEnable === "function")
        jass.FogEnable(jglobals.bj_cineModePriorFogSetting);
    if (typeof jass.EnableWorldFogBoundary === "function")
        jass.EnableWorldFogBoundary(true);
    EnableDawnDusk(jglobals.bj_cineModePriorDawnDusk);
    if (typeof jass.SetRandomSeed === "function")
        jass.SetRandomSeed(jglobals.bj_cineModeSavedSeed);
}
export function CinematicModeBJ(cineMode, forForce) {
    CinematicModeExBJ(cineMode, forForce, bj_CINEMODE_INTERFACEFADE);
}
export function CinematicFilterGenericBJ(duration, bmode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1) {
    if (typeof jass.AbortCinematicFadeBJ === "function") {
    }
    if (typeof jass.SetCineFilterTexture === "function")
        jass.SetCineFilterTexture(tex);
    if (typeof jass.SetCineFilterBlendMode === "function")
        jass.SetCineFilterBlendMode(bmode);
    if (typeof jass.SetCineFilterTexMapFlags === "function")
        jass.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE);
    if (typeof jass.SetCineFilterStartUV === "function")
        jass.SetCineFilterStartUV(0, 0, 1, 1);
    if (typeof jass.SetCineFilterEndUV === "function")
        jass.SetCineFilterEndUV(0, 0, 1, 1);
    if (typeof jass.SetCineFilterStartColor === "function") {
        jass.SetCineFilterStartColor(PercentTo255(red0), PercentTo255(green0), PercentTo255(blue0), PercentTo255(100 - trans0));
    }
    if (typeof jass.SetCineFilterEndColor === "function") {
        jass.SetCineFilterEndColor(PercentTo255(red1), PercentTo255(green1), PercentTo255(blue1), PercentTo255(100 - trans1));
    }
    if (typeof jass.SetCineFilterDuration === "function")
        jass.SetCineFilterDuration(duration);
    if (typeof jass.DisplayCineFilter === "function")
        jass.DisplayCineFilter(true);
}
export function AbortCinematicFadeBJ() {
    const t1 = jglobals.bj_cineFadeContinueTimer;
    const t2 = jglobals.bj_cineFadeFinishTimer;
    if (t1 != null && typeof jass.DestroyTimer === "function") {
        jass.DestroyTimer(t1);
    }
    if (t2 != null && typeof jass.DestroyTimer === "function") {
        jass.DestroyTimer(t2);
    }
}
