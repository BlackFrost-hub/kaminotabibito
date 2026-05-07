/** @noSelfInFile */
/**
 * 控制抗性系统初始化
 *
 * 通过统一技能事件系统监听控制技能
 */

const jass = require("jass.common") as any;
const { safeTimerStart, safeDestroyTimer } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTimerStart: (timer: any, timeout: number, periodic: boolean, action: () => void) => void;
  safeDestroyTimer: (timer: any) => void;
};

const { isExcludedFromControlResist, isControlAbility, isUnitControlled } = require("系统.05．Buff系统.01．控制抗性.01．控制检测") as {
  isExcludedFromControlResist: (unit: any) => boolean;
  isControlAbility: (abilityId: number) => boolean;
  isUnitControlled: (unit: any) => boolean;
};
const { calcReducedControlTime } = require("系统.05．Buff系统.01．控制抗性.02．控制时间计算") as {
  calcReducedControlTime: (target: any, abilityId: number) => number;
};
const { recastControlAbility } = require("系统.05．Buff系统.01．控制抗性.03．控制重施放") as {
  recastControlAbility: (caster: any, target: any, abilityId: number, duration: number) => void;
};
const { registerSpellChannelListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellChannelListener: (this: void, callback: (this: void, castingUnit: any, spellAbilityId: number) => void) => void;
};

const ALLOWED_PLAYERS: number[] = [0, 1, 2, 3, 6, 7, jass.PLAYER_NEUTRAL_AGGRESSIVE];

const controlResistCtxByTimerHid: Record<number, { caster: any; target: any; abilityId: number; duration: number }> = {};

function onControlResistTimerExpire(this: void): void {
  const t = jass.GetExpiredTimer();
  if (!t) return;
  const hid = jass.GetHandleId(t) as number;
  const ctx = controlResistCtxByTimerHid[hid];
  delete controlResistCtxByTimerHid[hid];
  safeDestroyTimer(t);
  if (!ctx) return;
  if (isUnitControlled(ctx.target)) {
    recastControlAbility(ctx.caster, ctx.target, ctx.abilityId, ctx.duration);
  }
}

function isAllowedPlayer(player: any): boolean {
  const id = jass.GetPlayerId(player);
  for (let i = 0; i < ALLOWED_PLAYERS.length; i++) {
    if (ALLOWED_PLAYERS[i] === id) return true;
  }
  return false;
}

function onSpellChannel(caster: any, abilityId: number): void {
  if (!isAllowedPlayer(jass.GetOwningPlayer(caster))) return;

  if (isExcludedFromControlResist(caster)) return;

  const target = jass.GetSpellTargetUnit();
  if (target == null) return;

  if (!isControlAbility(abilityId)) return;

  if (!isUnitControlled(target)) return;

  const duration = calcReducedControlTime(target, abilityId);

  const t = jass.CreateTimer();
  if (t) {
    controlResistCtxByTimerHid[jass.GetHandleId(t) as number] = { caster, target, abilityId, duration };
    safeTimerStart(t, 0, false, onControlResistTimerExpire);
  }
}

let _initialized = false;

export function initControlResist(): void {
  if (_initialized) return;
  _initialized = true;

  registerSpellChannelListener(onSpellChannel);
}

export {};
