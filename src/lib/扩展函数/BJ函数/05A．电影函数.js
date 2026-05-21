import { bj_CINEMODE_GAMESPEED, bj_CINEMODE_INTERFACEFADE, bj_MAX_PLAYERS, bj_TRANSMISSION_IND_RED, bj_TRANSMISSION_IND_BLUE, bj_TRANSMISSION_IND_GREEN, bj_TRANSMISSION_IND_ALPHA, bj_TRANSMISSION_PORT_HANGTIME, bj_TRANSMISSION_PING_TIME, EVENT_PLAYER_END_CINEMATIC, TEXMAP_FLAG_NONE, MAP_LOCK_SPEED, CancelCineSceneBJ, PlaySoundBJ, WaitTransmissionDuration, EnableDawnDusk, IsDawnDuskEnabled, GetTransmissionDuration, SetCineModeVolumeGroupsBJ, CameraResetSmoothingFactorBJ, } from "./05B．音效函数";
import { RMaxBJ, PercentTo255 } from "./12．数学函数";
const jass = require("jass.common");
const jglobals = require("jass.globals");
export function SetCinematicSceneBJ(soundHandle, portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration) {
    jglobals.bj_cineSceneLastSound = soundHandle;
    PlaySoundBJ(soundHandle);
    jass.SetCinematicScene(portraitUnitId, color, speakerTitle, text, sceneDuration, voiceoverDuration);
}
export function DoTransmissionBasicsXYBJ(unitId, color, x, y, soundHandle, unitName, message, duration) {
    const hang = bj_TRANSMISSION_PORT_HANGTIME;
    SetCinematicSceneBJ(soundHandle, unitId, color, unitName, message, duration + hang, duration);
    if (unitId !== 0) {
        jass.PingMinimap(x, y, bj_TRANSMISSION_PING_TIME);
    }
}
export function TryInitCinematicBehaviorBJ() {
    if (jglobals.bj_cineSceneBeingSkipped != null)
        return;
    jglobals.bj_cineSceneBeingSkipped = jass.CreateTrigger();
    for (let index = 0; index < bj_MAX_PLAYERS; index++) {
        jass.TriggerRegisterPlayerEvent(jglobals.bj_cineSceneBeingSkipped, jass.Player(index), EVENT_PLAYER_END_CINEMATIC);
    }
    jass.TriggerAddAction(jglobals.bj_cineSceneBeingSkipped, CancelCineSceneBJ);
}
export function TransmissionFromUnitWithNameBJ(toForce, whichUnit, unitName, soundHandle, message, timeType, timeVal, wait) {
    TryInitCinematicBehaviorBJ();
    const safeTime = RMaxBJ(timeVal, 0);
    let duration = 0;
    duration = GetTransmissionDuration(soundHandle, timeType, safeTime);
    jglobals.bj_lastTransmissionDuration = duration;
    jglobals.bj_lastPlayedSound = soundHandle;
    if (jass.IsPlayerInForce(jass.GetLocalPlayer(), toForce)) {
        if (whichUnit == null) {
            const red = typeof jglobals.PLAYER_COLOR_RED !== "undefined" ? jglobals.PLAYER_COLOR_RED : 0;
            DoTransmissionBasicsXYBJ(0, red, 0, 0, soundHandle, unitName, message, duration);
        }
        else {
            const unitTypeId = jass.GetUnitTypeId(whichUnit);
            const owner = jass.GetOwningPlayer(whichUnit);
            const color = jass.GetPlayerColor(owner);
            const x = jass.GetUnitX(whichUnit);
            const y = jass.GetUnitY(whichUnit);
            DoTransmissionBasicsXYBJ(unitTypeId, color, x, y, soundHandle, unitName, message, duration);
            if (!jass.IsUnitHidden(whichUnit)) {
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
            jglobals.bj_cineModePriorSpeed = jass.GetGameSpeed();
            jglobals.bj_cineModePriorFogSetting = jass.IsFogEnabled();
            jglobals.bj_cineModePriorMaskSetting = jass.IsFogMaskEnabled();
            jglobals.bj_cineModePriorDawnDusk = IsDawnDuskEnabled();
            jglobals.bj_cineModeSavedSeed = jass.GetRandomInt(0, 1000000);
        }
        if (jass.IsPlayerInForce(jass.GetLocalPlayer(), forForce)) {
            jass.ClearTextMessages();
            jass.ShowInterface(false, interfaceFadeTime);
            jass.EnableUserControl(false);
            jass.EnableOcclusion(false);
            SetCineModeVolumeGroupsBJ();
        }
        jass.SetGameSpeed(bj_CINEMODE_GAMESPEED);
        jass.SetMapFlag(MAP_LOCK_SPEED, true);
        jass.FogMaskEnable(false);
        jass.FogEnable(false);
        jass.EnableWorldFogBoundary(false);
        EnableDawnDusk(false);
        jass.SetRandomSeed(0);
        return;
    }
    jglobals.bj_cineModeAlreadyIn = false;
    if (jass.IsPlayerInForce(jass.GetLocalPlayer(), forForce)) {
        jass.ShowInterface(true, interfaceFadeTime);
        jass.EnableUserControl(true);
        jass.EnableOcclusion(true);
        jass.VolumeGroupReset();
        jass.EndThematicMusic();
        CameraResetSmoothingFactorBJ();
    }
    jass.SetMapFlag(MAP_LOCK_SPEED, false);
    jass.SetGameSpeed(jglobals.bj_cineModePriorSpeed);
    jass.FogMaskEnable(jglobals.bj_cineModePriorMaskSetting);
    jass.FogEnable(jglobals.bj_cineModePriorFogSetting);
    jass.EnableWorldFogBoundary(true);
    EnableDawnDusk(jglobals.bj_cineModePriorDawnDusk);
    jass.SetRandomSeed(jglobals.bj_cineModeSavedSeed);
}
export function CinematicModeBJ(cineMode, forForce) {
    CinematicModeExBJ(cineMode, forForce, bj_CINEMODE_INTERFACEFADE);
}
export function CinematicFilterGenericBJ(duration, bmode, tex, red0, green0, blue0, trans0, red1, green1, blue1, trans1) {
    AbortCinematicFadeBJ();
    jass.SetCineFilterTexture(tex);
    jass.SetCineFilterBlendMode(bmode);
    jass.SetCineFilterTexMapFlags(TEXMAP_FLAG_NONE);
    jass.SetCineFilterStartUV(0, 0, 1, 1);
    jass.SetCineFilterEndUV(0, 0, 1, 1);
    jass.SetCineFilterStartColor(PercentTo255(red0), PercentTo255(green0), PercentTo255(blue0), PercentTo255(100 - trans0));
    jass.SetCineFilterEndColor(PercentTo255(red1), PercentTo255(green1), PercentTo255(blue1), PercentTo255(100 - trans1));
    jass.SetCineFilterDuration(duration);
    jass.DisplayCineFilter(true);
}
export function AbortCinematicFadeBJ() {
    const t1 = jglobals.bj_cineFadeContinueTimer;
    const t2 = jglobals.bj_cineFadeFinishTimer;
    if (t1 != null) {
        jass.DestroyTimer(t1);
    }
    if (t2 != null) {
        jass.DestroyTimer(t2);
    }
}
