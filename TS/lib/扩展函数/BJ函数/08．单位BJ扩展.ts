/** @noSelfInFile */
/**
 * Blizzard.j / YDTrigger `BJOptimization/Unit.h` 等单位相关 BJ 封装（迁入 BJ 库）。
 *
 * 分文件约定：
 * - `GetAttackedUnitBJ` → `01．触发与事件`
 * - `GetUnitLifePercent`、`GetUnitManaPercent`、`SetUnitLifeBJ`、`SetUnitManaBJ` 及 `IsUnitDeadBJ` / `IsUnitAliveBJ`、英雄与百分比 API → `02．单位与英雄`
 * - 商店库存 → `03．物品与库存`
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
    forEachUnitInGroup: (group: any, action: (unit: any) => void) => void;
};
const CreateCorpse = jass.CreateCorpse as (
    this: void,
    whichPlayer: any,
    unitid: number,
    x: number,
    y: number,
    facing: number,
) => any;
const GetLocationX = jass.GetLocationX as (this: void, whichLocation: any) => number;
const GetLocationY = jass.GetLocationY as (this: void, whichLocation: any) => number;
const SetUnitBlendTime = jass.SetUnitBlendTime as (this: void, whichUnit: any, blendTime: number) => void;
const SetUnitAnimation = jass.SetUnitAnimation as (this: void, whichUnit: any, animation: string) => void;
const GroupAddUnit = jass.GroupAddUnit as (this: void, whichGroup: any, whichUnit: any) => void;
const TimerStart = jass.TimerStart as (
    this: void,
    whichTimer: any,
    timeout: number,
    periodic: boolean,
    handlerFunc: any,
) => void;

export function String2UnitIdBJ(unitIdString: string): number {
    return jass.UnitId(unitIdString);
}

export function GetIssuedOrderIdBJ(): number {
    return jass.GetIssuedOrderId();
}

export function GetKillingUnitBJ(): any {
    return jass.GetKillingUnit();
}

export function UnitSuspendDecayBJ(suspend: boolean, unit: any): void {
    jass.UnitSuspendDecay(unit, suspend);
}

export function GetUnitStateSwap(state: any, unit: any): number {
    return jass.GetUnitState(unit, state);
}

export function SelectUnitSingle(unit: any): void {
    jass.ClearSelection();
    jass.SelectUnit(unit, true);
}

export function SelectGroupBJ(group: any): void {
    jass.ClearSelection();
    forEachUnitInGroup(group, (u: any) => {
        if (u != null) {
            jass.SelectUnit(u, true);
        }
    });
}

export function SelectUnitAdd(unit: any): void {
    jass.SelectUnit(unit, true);
}

export function SelectUnitRemove(unit: any): void {
    jass.SelectUnit(unit, false);
}

/** 对齐 Blizzard.j 的 ForceUICancelBJ：取消指定玩家当前打开的技能/目标选择界面。 */
export function ForceUICancelBJ(player: any): void {
    if (player == null || player === 0) return;
    jass.ForceUICancel(player);
}

export function IsUnitHiddenBJ(unit: any): boolean {
    return jass.IsUnitHidden(unit);
}

export function ShowUnitHide(unit: any): void {
    jass.ShowUnit(unit, false);
}

export function IssueTrainOrderByIdBJ(unit: any, id: number): boolean {
    return jass.IssueImmediateOrderById(unit, id);
}

export function GroupTrainOrderByIdBJ(group: any, id: number): boolean {
    return jass.GroupImmediateOrderById(group, id);
}

export function IssueUpgradeOrderByIdBJ(unit: any, id: number): boolean {
    return jass.IssueUpgradeOrderById(unit, id);
}

export function SetUnitFlyHeightBJ(unit: any, height: number, rate: number): void {
    jass.SetUnitFlyHeight(unit, height, rate);
}

export function SetUnitTurnSpeedBJ(unit: any, speed: number): void {
    jass.SetUnitTurnSpeed(unit, speed);
}

export function GetUnitDefaultPropWindowBJ(unit: any): number {
    return jass.GetUnitDefaultPropWindow(unit);
}

export function SetUnitBlendTimeBJ(unit: any, time: number): void {
    jass.SetUnitBlendTime(unit, time);
}

export function SetUnitAcquireRangeBJ(unit: any, range: number): void {
    jass.SetUnitAcquireRange(unit, range);
}

export function UnitSetCanSleepBJ(unit: any, canSleep: boolean): void {
    jass.UnitAddSleep(unit, canSleep);
}

export function UnitCanSleepBJ(unit: any): boolean {
    return jass.UnitCanSleep(unit);
}

export function UnitWakeUpBJ(unit: any): void {
    jass.UnitWakeUp(unit);
}

export function UnitIsSleepingBJ(unit: any): boolean {
    return jass.UnitIsSleeping(unit);
}

export function UnitGenerateAlarms(unit: any, generate: boolean): void {
    jass.UnitIgnoreAlarm(unit, !generate);
}

export function PauseUnitBJ(pause: boolean, unit: any): void {
    jass.PauseUnit(unit, pause);
}

export function IsUnitPausedBJ(unit: any): boolean {
    return jass.IsUnitPaused(unit);
}

export function ResetUnitAnimation(this: void, whichUnit: any): void {
    if (whichUnit == null || whichUnit === 0) return;
    jass.SetUnitAnimation(whichUnit, "stand");
}

export function UnitPauseTimedLifeBJ(flag: boolean, unit: any): void {
    jass.UnitPauseTimedLife(unit, flag);
}

export function UnitApplyTimedLifeBJ(duration: number, buffId: number, unit: any): void {
    jass.UnitApplyTimedLife(unit, buffId, duration);
}

export function UnitShareVisionBJ(share: boolean, unit: any, player: any): void {
    jass.UnitShareVision(unit, player, share);
}

export function UnitRemoveAbilityBJ(abilityId: number, unit: any): boolean {
    return jass.UnitRemoveAbility(unit, abilityId);
}

export function UnitAddAbilityBJ(abilityId: number, unit: any): boolean {
    return jass.UnitAddAbility(unit, abilityId);
}

export function UnitRemoveTypeBJ(type: any, unit: any): boolean {
    return jass.UnitRemoveType(unit, type);
}

export function UnitAddTypeBJ(type: any, unit: any): boolean {
    return jass.UnitAddType(unit, type);
}

export function UnitMakeAbilityPermanentBJ(permanent: boolean, abilityId: number, unit: any): void {
    jass.UnitMakeAbilityPermanent(unit, permanent, abilityId);
}

export function SetUnitExplodedBJ(unit: any, exploded: boolean): void {
    jass.SetUnitExploded(unit, exploded);
}

export function GetTransportUnitBJ(): any {
    return jass.GetTransportUnit();
}

export function GetLoadedUnitBJ(): any {
    return jass.GetLoadedUnit();
}

export function IsUnitInTransportBJ(unit: any, transport: any): boolean {
    return jass.IsUnitInTransport(unit, transport);
}

export function IsUnitLoadedBJ(unit: any): boolean {
    return jass.IsUnitLoaded(unit);
}

export function IsUnitIllusionBJ(unit: any): boolean {
    return jass.IsUnitIllusion(unit);
}

export function SetUnitUseFoodBJ(enable: boolean, unit: any): void {
    jass.SetUnitUseFood(unit, enable);
}

export function UnitDamageTargetBJ(
    unit: any,
    target: any,
    amount: number,
    attacktype: any,
    damagetype: any
): boolean {
    const weapon =
        jass.WEAPON_TYPE_WHOKNOWS != null ? jass.WEAPON_TYPE_WHOKNOWS : null;
    return jass.UnitDamageTarget(unit, target, amount, true, false, attacktype, damagetype, weapon);
}

export function UnitId2OrderIdBJ(unitId: number): number {
    return unitId;
}

export function GetLastCreatedUnit(): any {
    return jglobals.bj_lastCreatedUnit;
}

export function GetLastReplacedUnitBJ(): any {
    return jglobals.bj_lastReplacedUnit;
}

/**
 * 对齐 Blizzard.j：
 * function DoesUnitGenerateAlarms takes unit whichUnit returns boolean
 *     return not UnitIgnoreAlarmToggled(whichUnit)
 * endfunction
 */
export function DoesUnitGenerateAlarms(unit: any): boolean {
    return !jass.UnitIgnoreAlarmToggled(unit);
}

export function GetUnitPropWindowBJ(unit: any): number {
    return jass.GetUnitPropWindow(unit) * jglobals.bj_RADTODEG;
}

/** 对应 Blizzard.j 的 CreatePermanentCorpseLocBJ。 */
export function CreatePermanentCorpseLocBJ(
    this: void,
    style: number,
    unitid: number,
    whichPlayer: any,
    loc: any,
    facing: number,
): any {
    if (loc == null || loc === 0) return null;

    const corpse = CreateCorpse(whichPlayer, unitid, GetLocationX(loc), GetLocationY(loc), facing);
    jglobals.bj_lastCreatedUnit = corpse;
    if (corpse == null || corpse === 0) return corpse;

    SetUnitBlendTime(corpse, 0);
    const fleshStyle = jglobals.bj_CORPSETYPE_FLESH;
    const decayGroup = style === fleshStyle
        ? jglobals.bj_suspendDecayFleshGroup
        : jglobals.bj_suspendDecayBoneGroup;
    SetUnitAnimation(corpse, style === fleshStyle ? "decay flesh" : "decay bone");
    if (decayGroup != null && decayGroup !== 0) {
        GroupAddUnit(decayGroup, corpse);
    }

    const decayTimer = jglobals.bj_delayedSuspendDecayTimer;
    if (decayTimer != null && decayTimer !== 0) {
        TimerStart(decayTimer, 0.05, false, null);
    }
    return corpse;
}

export {};
