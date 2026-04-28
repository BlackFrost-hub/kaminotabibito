/**
 * 控制抗性系统初始化
 *
 * 通过统一技能事件系统监听控制技能
 */

const jass = require("jass.common") as any;
const { createDelayedCall } = require("lib.扩展函数.封装函数.01．通用工具.index") as {
  createDelayedCall: (delaySec: number, callback: () => void) => { id: number };
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
const { registerSpellChannelListener } = require("系统.03．技能系统.00．技能事件.01．核心功能") as {
  registerSpellChannelListener: (callback: (castingUnit: any, spellAbilityId: number) => void) => void;
};

const ALLOWED_PLAYERS: number[] = [0, 1, 2, 3, 6, 7, jass.PLAYER_NEUTRAL_AGGRESSIVE];

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

  createDelayedCall(0, () => {
    if (isUnitControlled(target)) {
      recastControlAbility(caster, target, abilityId, duration);
    }
  });
}

let _initialized = false;

export function initControlResist(): void {
  if (_initialized) return;
  _initialized = true;

  registerSpellChannelListener(onSpellChannel);
}

export {};
