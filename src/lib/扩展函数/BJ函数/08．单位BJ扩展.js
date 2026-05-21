/**
 * Blizzard.j / YDTrigger `BJOptimization/Unit.h` 等单位相关 BJ 封装（迁入 BJ 库）。
 *
 * 分文件约定：
 * - `GetAttackedUnitBJ` → `01．触发与事件`
 * - `GetUnitLifePercent`、`GetUnitManaPercent`、`SetUnitLifeBJ`、`SetUnitManaBJ` 及 `IsUnitDeadBJ` / `IsUnitAliveBJ`、英雄与百分比 API → `02．单位与英雄`
 * - 商店库存 → `03．物品与库存`
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { forEachUnitInGroup } = require("lib.扩展函数.封装函数.01．通用工具.index");
export function String2UnitIdBJ(unitIdString) {
    return jass.UnitId(unitIdString);
}
export function GetIssuedOrderIdBJ() {
    return jass.GetIssuedOrderId();
}
export function GetKillingUnitBJ() {
    return jass.GetKillingUnit();
}
export function UnitSuspendDecayBJ(suspend, unit) {
    jass.UnitSuspendDecay(unit, suspend);
}
export function GetUnitStateSwap(state, unit) {
    return jass.GetUnitState(unit, state);
}
export function SelectUnitSingle(unit) {
    jass.ClearSelection();
    jass.SelectUnit(unit, true);
}
export function SelectGroupBJ(group) {
    jass.ClearSelection();
    forEachUnitInGroup(group, (u) => {
        if (u != null) {
            jass.SelectUnit(u, true);
        }
    });
}
export function SelectUnitAdd(unit) {
    jass.SelectUnit(unit, true);
}
export function SelectUnitRemove(unit) {
    jass.SelectUnit(unit, false);
}
export function IsUnitHiddenBJ(unit) {
    return jass.IsUnitHidden(unit);
}
export function ShowUnitHide(unit) {
    jass.ShowUnit(unit, false);
}
export function IssueTrainOrderByIdBJ(unit, id) {
    return jass.IssueImmediateOrderById(unit, id);
}
export function GroupTrainOrderByIdBJ(group, id) {
    return jass.GroupImmediateOrderById(group, id);
}
export function IssueUpgradeOrderByIdBJ(unit, id) {
    return jass.IssueUpgradeOrderById(unit, id);
}
export function SetUnitFlyHeightBJ(unit, height, rate) {
    jass.SetUnitFlyHeight(unit, height, rate);
}
export function SetUnitTurnSpeedBJ(unit, speed) {
    jass.SetUnitTurnSpeed(unit, speed);
}
export function GetUnitDefaultPropWindowBJ(unit) {
    return jass.GetUnitDefaultPropWindow(unit);
}
export function SetUnitBlendTimeBJ(unit, time) {
    jass.SetUnitBlendTime(unit, time);
}
export function SetUnitAcquireRangeBJ(unit, range) {
    jass.SetUnitAcquireRange(unit, range);
}
export function UnitSetCanSleepBJ(unit, canSleep) {
    jass.UnitAddSleep(unit, canSleep);
}
export function UnitCanSleepBJ(unit) {
    return jass.UnitCanSleep(unit);
}
export function UnitWakeUpBJ(unit) {
    jass.UnitWakeUp(unit);
}
export function UnitIsSleepingBJ(unit) {
    return jass.UnitIsSleeping(unit);
}
export function UnitGenerateAlarms(unit, generate) {
    jass.UnitIgnoreAlarm(unit, !generate);
}
export function PauseUnitBJ(pause, unit) {
    jass.PauseUnit(unit, pause);
}
export function IsUnitPausedBJ(unit) {
    return jass.IsUnitPaused(unit);
}
export function ResetUnitAnimation(whichUnit) {
    if (whichUnit == null || whichUnit === 0)
        return;
    jass.SetUnitAnimation(whichUnit, "stand");
}
export function UnitPauseTimedLifeBJ(flag, unit) {
    jass.UnitPauseTimedLife(unit, flag);
}
export function UnitApplyTimedLifeBJ(duration, buffId, unit) {
    jass.UnitApplyTimedLife(unit, buffId, duration);
}
export function UnitShareVisionBJ(share, unit, player) {
    jass.UnitShareVision(unit, player, share);
}
export function UnitRemoveAbilityBJ(abilityId, unit) {
    return jass.UnitRemoveAbility(unit, abilityId);
}
export function UnitAddAbilityBJ(abilityId, unit) {
    return jass.UnitAddAbility(unit, abilityId);
}
export function UnitRemoveTypeBJ(type, unit) {
    return jass.UnitRemoveType(unit, type);
}
export function UnitAddTypeBJ(type, unit) {
    return jass.UnitAddType(unit, type);
}
export function UnitMakeAbilityPermanentBJ(permanent, abilityId, unit) {
    jass.UnitMakeAbilityPermanent(unit, permanent, abilityId);
}
export function SetUnitExplodedBJ(unit, exploded) {
    jass.SetUnitExploded(unit, exploded);
}
export function GetTransportUnitBJ() {
    return jass.GetTransportUnit();
}
export function GetLoadedUnitBJ() {
    return jass.GetLoadedUnit();
}
export function IsUnitInTransportBJ(unit, transport) {
    return jass.IsUnitInTransport(unit, transport);
}
export function IsUnitLoadedBJ(unit) {
    return jass.IsUnitLoaded(unit);
}
export function IsUnitIllusionBJ(unit) {
    return jass.IsUnitIllusion(unit);
}
export function SetUnitUseFoodBJ(enable, unit) {
    jass.SetUnitUseFood(unit, enable);
}
export function UnitDamageTargetBJ(unit, target, amount, attacktype, damagetype) {
    const weapon = jass.WEAPON_TYPE_WHOKNOWS != null ? jass.WEAPON_TYPE_WHOKNOWS : null;
    return jass.UnitDamageTarget(unit, target, amount, true, false, attacktype, damagetype, weapon);
}
export function UnitId2OrderIdBJ(unitId) {
    return unitId;
}
export function GetLastCreatedUnit() {
    return jglobals.bj_lastCreatedUnit;
}
export function GetLastReplacedUnitBJ() {
    return jglobals.bj_lastReplacedUnit;
}
/**
 * 对齐 Blizzard.j：
 * function DoesUnitGenerateAlarms takes unit whichUnit returns boolean
 *     return not UnitIgnoreAlarmToggled(whichUnit)
 * endfunction
 */
export function DoesUnitGenerateAlarms(unit) {
    return !jass.UnitIgnoreAlarmToggled(unit);
}
export function GetUnitPropWindowBJ(unit) {
    return jass.GetUnitPropWindow(unit) * jglobals.bj_RADTODEG;
}
