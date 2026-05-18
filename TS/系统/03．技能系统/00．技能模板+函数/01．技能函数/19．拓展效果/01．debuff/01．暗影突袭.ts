/** @noSelfInFile */

const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const jass = require("jass.common") as any;
const { registerManualBuff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: {
    sourceName?: string;
    iconOverride?: string;
    effectModelOverride?: string;
    nativeBuffAbilityIds?: number[];
    onRemove?: (this: void, unit: any, buffID: string, row: any) => void;
  }) => void;
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, sourceUnit: any, u: any, as: number, ms: number, time: number) => void;
};
const { GetHandleId, GetUnitState, GetUnitX, GetUnitY, GetUnitName, GetOwningPlayer, UnitDamageTarget, CreateTimer, DestroyTimer, GetExpiredTimer, TimerStart, UNIT_STATE_LIFE, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS } = jass as {
  GetHandleId: (h: any) => number;
  GetUnitState: (u: any, state: any) => number;
  GetUnitX: (u: any) => number;
  GetUnitY: (u: any) => number;
  GetUnitName: (u: any) => string;
  GetOwningPlayer: (u: any) => any;
  UnitDamageTarget: (source: any, target: any, amount: number, attack: boolean, ranged: boolean, attackType: any, damageType: any, weaponType: any) => boolean;
  CreateTimer: () => any;
  DestroyTimer: (timer: any) => void;
  GetExpiredTimer: () => any;
  TimerStart: (timer: any, timeout: number, periodic: boolean, callback: (this: void) => void) => void;
  UNIT_STATE_LIFE: any;
  ATTACK_TYPE_NORMAL: any;
  DAMAGE_TYPE_POISON: any;
  WEAPON_TYPE_WHOKNOWS: any;
};
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};

const 暗影突袭BuffID = "C025";
const 暗影突袭图标 = "ReplaceableTextures\\CommandButtons\\BTNShadowStrike.blp";
const 暗影突袭特效 = "Abilities\Spells\NightElf\shadowstrike\shadowstrike.mdl";
const 暗影突袭弹幕模型 = "Abilities\Spells\NightElf\shadowstrike\ShadowStrikeMissile.mdl";

export interface 暗影突袭减益参数 {
  buffID?: string;
  iconOverride?: string;
  effectModelOverride?: string;
  sourceName?: string;
  duration?: number;
  damagePerSecond?: number;
  slowAttack?: number;
  slowMove?: number;
}

export interface 暗影突袭追踪参数 {
  模型?: string;
  速度?: number;
  命中半径?: number;
  生命周期?: number;
  最大距离?: number;
  轨迹类型?: "追踪" | "直线";
  减益?: 暗影突袭减益参数;
}

interface 暗影突袭毒素状态 {
  source: any;
  target: any;
  remainingTicks: number;
  damagePerTick: number;
}

const 暗影突袭毒素计时表: Record<number, 暗影突袭毒素状态 | undefined> = {};
const 暗影突袭毒素标记表: Record<number, number | undefined> = {};

function 暗影突袭毒素结束(this: void): void {
  const timer = GetExpiredTimer();
  const timerId = GetHandleId(timer);
  delete 暗影突袭毒素计时表[timerId];
  DestroyTimer(timer);
}

function 暗影突袭毒素tick(this: void): void {
  const timer = GetExpiredTimer();
  const timerId = GetHandleId(timer);
  const state = 暗影突袭毒素计时表[timerId];
  if (state == null) {
    DestroyTimer(timer);
    return;
  }
  if (state.remainingTicks <= 0) {
    暗影突袭毒素结束();
    return;
  }
  state.remainingTicks -= 1;
  const target = state.target;
  if (target != null && target !== 0 && GetUnitState(target, UNIT_STATE_LIFE) > 0.405) {
    const targetHid = GetHandleId(target);
    暗影突袭毒素标记表[targetHid] = (暗影突袭毒素标记表[targetHid] ?? 0) + 1;
    UnitDamageTarget(state.source, target, state.damagePerTick, false, false, ATTACK_TYPE_NORMAL, DAMAGE_TYPE_POISON, WEAPON_TYPE_WHOKNOWS);
    const current = 暗影突袭毒素标记表[targetHid] ?? 0;
    if (current <= 1) {
      delete 暗影突袭毒素标记表[targetHid];
    } else {
      暗影突袭毒素标记表[targetHid] = current - 1;
    }
  }
  if (state.remainingTicks <= 0) {
    暗影突袭毒素结束();
  }
}

export function 是否为暗影突袭毒素伤害(this: void, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const hid = GetHandleId(unit);
  return (暗影突袭毒素标记表[hid] ?? 0) > 0;
}

export function 标记暗影突袭毒素伤害(this: void, unit: any, callback: () => void): void {
  if (unit == null || unit === 0) {
    callback();
    return;
  }
  const hid = GetHandleId(unit);
  暗影突袭毒素标记表[hid] = (暗影突袭毒素标记表[hid] ?? 0) + 1;
  try {
    callback();
  } finally {
    const current = 暗影突袭毒素标记表[hid] ?? 0;
    if (current <= 1) {
      delete 暗影突袭毒素标记表[hid];
    } else {
      暗影突袭毒素标记表[hid] = current - 1;
    }
  }
}

export function 施加暗影突袭减益(this: void, source: any, target: any, 参数: 暗影突袭减益参数 = {}): void {
  if (source == null || source === 0 || target == null || target === 0) return;
  const duration = 参数.duration ?? 2.0;
  const damagePerSecond = 参数.damagePerSecond ?? 500;
  const slowAttack = 参数.slowAttack ?? 30;
  const slowMove = 参数.slowMove ?? 30;
  debugLogForce("暗影突袭", "施加减益", "source:", source, "target:", target, "duration:", duration, "dps:", damagePerSecond);
  registerManualBuff(target, 参数.buffID ?? 暗影突袭BuffID, duration, 0, {
    sourceName: 参数.sourceName ?? GetUnitName(source),
    iconOverride: 参数.iconOverride ?? 暗影突袭图标,
    effectModelOverride: 参数.effectModelOverride ?? 暗影突袭特效,
  });
  SFB_setSlow(source, target, slowAttack, slowMove, duration);

  const timer = CreateTimer();
  const timerId = GetHandleId(timer);
  暗影突袭毒素计时表[timerId] = {
    source,
    target,
    remainingTicks: Math.max(1, Math.ceil(duration)),
    damagePerTick: damagePerSecond,
  };
  TimerStart(timer, 1.0, true, 暗影突袭毒素tick);
}

export function 创建暗影突袭追踪(this: void, source: any, target: any, 参数: 暗影突袭追踪参数 = {}): void {
  if (source == null || source === 0 || target == null || target === 0) return;
  function 暗影突袭弹幕命中(this: void, 命中单位: any): void {
    施加暗影突袭减益(source, 命中单位, 参数.减益 ?? {});
  }
  创建原生弹幕({
    所有者: source,
    X: GetUnitX(source),
    Y: GetUnitY(source),
    速度: 参数.速度 ?? 1500,
    轨迹类型: 参数.轨迹类型 ?? "追踪",
    指定目标: target,
    命中半径: 参数.命中半径 ?? 80,
    生命周期: 参数.生命周期 ?? 4,
    碰撞消失: true,
    最大距离: 参数.最大距离 ?? 5000,
    模型: 参数.模型 ?? 暗影突袭弹幕模型,
    on命中单位: 暗影突袭弹幕命中,
  });
}

export {};
