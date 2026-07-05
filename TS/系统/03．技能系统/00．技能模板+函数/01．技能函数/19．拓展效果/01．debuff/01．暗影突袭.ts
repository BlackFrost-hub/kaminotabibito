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
const { getBuffRuntime } = require("系统.05．Buff系统.00．Buff系统") as {
  getBuffRuntime: (this: void, unit: any, buffID: string) => any | null;
};
const { SFB_setSlow } = require("lib.扩展函数.Star扩展函数.Star扩展库.04B．快速Buff接口") as {
  SFB_setSlow: (this: void, sourceUnit: any, u: any, as: number, ms: number, time: number) => void;
};
const { 创建原生弹幕 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.03．对外接口") as {
  创建原生弹幕: (this: void, 参数: any) => any;
};
const { 创建追踪插值轨迹 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.01．弹幕.01．TS原生弹幕.01．轨迹.index") as {
  创建追踪插值轨迹: (this: void, 目标单位: any, 到达距离?: number) => any;
};
const { isSameUnit } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isSameUnit: (this: void, unitA: any, unitB: any) => boolean;
};
const buffTableMod = require("系统.05．Buff系统.01．Buff表") as {
  buffs: Record<string, { icon?: string; effect?: string }>;
};

const GetHandleId = jass.GetHandleId as (h: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const GetUnitX = jass.GetUnitX as (u: any) => number;
const GetUnitY = jass.GetUnitY as (u: any) => number;
const GetUnitFacing = jass.GetUnitFacing as (u: any) => number;
const GetUnitName = jass.GetUnitName as (u: any) => string;
const R2I = jass.R2I as (value: number) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_POISON = jass.DAMAGE_TYPE_POISON as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 造成持续伤害 } = require("系统.04．伤害系统.07．持续伤害系统") as {
  造成持续伤害: (this: void, source: any, target: any, amount: number, damageType: any, ranged?: boolean, attackType?: any, weaponType?: any) => boolean;
};

const 暗影突袭BuffID = "C025";
const 暗影突袭弹幕模型 = "Abilities\\Spells\\NightElf\\shadowstrike\\ShadowStrikeMissile.mdl";

function 读取Buff图标(this: void, BuffID: string): string | undefined {
  const meta = buffTableMod.buffs[BuffID];
  return meta != null && meta.icon != null && meta.icon !== "" ? meta.icon : undefined;
}

function 读取Buff特效(this: void, BuffID: string): string | undefined {
  const meta = buffTableMod.buffs[BuffID];
  return meta != null && meta.effect != null && meta.effect !== "" ? meta.effect : undefined;
}

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
  毒素ID: number;
  source: any;
  target: any;
  buffID: string;
  remainingTicks: number;
  damagePerTick: number;
  下次伤害时间毫秒: number;
}

const 暗影突袭毒素计时表: Record<number, 暗影突袭毒素状态 | undefined> = {};
const 暗影突袭毒素ID列表: number[] = [];
const 暗影突袭毒素标记表: Record<number, number | undefined> = {};
let 下一个暗影突袭毒素ID = 0;
let 暗影突袭毒素扫描回调ID = 0;

function 暗影突袭向上取整秒数(this: void, duration: number): number {
  const 整秒 = R2I(duration);
  if (duration > 整秒) return 整秒 + 1;
  return 整秒 > 0 ? 整秒 : 1;
}

function 暗影突袭毒素结束(this: void, 毒素ID: number): void {
  delete 暗影突袭毒素计时表[毒素ID];
}

function 暗影突袭毒素tick(this: void, 毒素ID: number): void {
  const state = 暗影突袭毒素计时表[毒素ID];
  if (state == null) return;
  if (getBuffRuntime(state.target, state.buffID) == null) {
    暗影突袭毒素结束(毒素ID);
    return;
  }
  if (state.remainingTicks <= 0) {
    暗影突袭毒素结束(毒素ID);
    return;
  }
  state.remainingTicks -= 1;
  const target = state.target;
  if (target != null && target !== 0 && GetUnitState(target, UNIT_STATE_LIFE) > 0.405) {
    const targetHid = GetHandleId(target);
    暗影突袭毒素标记表[targetHid] = (暗影突袭毒素标记表[targetHid] ?? 0) + 1;
    debugLogForce("暗影突袭", "毒素tick", "source:", state.source, "target:", target, "damage:", state.damagePerTick, "remaining:", state.remainingTicks);
    造成持续伤害(state.source, target, state.damagePerTick, DAMAGE_TYPE_POISON, false, ATTACK_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
    const current = 暗影突袭毒素标记表[targetHid] ?? 0;
    if (current <= 1) {
      delete 暗影突袭毒素标记表[targetHid];
    } else {
      暗影突袭毒素标记表[targetHid] = current - 1;
    }
  }
  if (state.remainingTicks <= 0) {
    暗影突袭毒素结束(毒素ID);
    return;
  }
  state.下次伤害时间毫秒 += 1000;
}

function on暗影突袭毒素扫描(this: void): void {
  const 当前时间毫秒 = getServerTime();
  let 写入索引 = 0;
  for (let i = 0; i < 暗影突袭毒素ID列表.length; i++) {
    const 毒素ID = 暗影突袭毒素ID列表[i];
    const state = 暗影突袭毒素计时表[毒素ID];
    if (state == null) {
      continue;
    }
    if (当前时间毫秒 >= state.下次伤害时间毫秒) {
      暗影突袭毒素tick(毒素ID);
    }
    if (暗影突袭毒素计时表[毒素ID] != null) {
      暗影突袭毒素ID列表[写入索引] = 毒素ID;
      写入索引 += 1;
    }
  }
  for (let i = 暗影突袭毒素ID列表.length - 1; i >= 写入索引; i--) {
    暗影突袭毒素ID列表.pop();
  }
  if (暗影突袭毒素ID列表.length === 0 && 暗影突袭毒素扫描回调ID !== 0) {
    removePeriodicCallback(暗影突袭毒素扫描回调ID);
    暗影突袭毒素扫描回调ID = 0;
  }
}

function 确保暗影突袭毒素扫描已启动(this: void): void {
  if (暗影突袭毒素扫描回调ID !== 0) return;
  暗影突袭毒素扫描回调ID = addPeriodicCallback(10, on暗影突袭毒素扫描);
}

function on暗影突袭Buff移除(this: void, unit: any, buffID: string, _row: any): void {
  if (unit == null || unit === 0 || buffID === "") return;
  for (const key in 暗影突袭毒素计时表) {
    const state = 暗影突袭毒素计时表[key];
    if (state == null) continue;
    if (state.target !== unit || state.buffID !== buffID) continue;
    delete 暗影突袭毒素计时表[key];
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
  const slowAttack = 参数.slowAttack ?? 0.3;
  const slowMove = 参数.slowMove ?? 0.3;
  const buffID = 参数.buffID ?? 暗影突袭BuffID;
  debugLogForce("暗影突袭", "施加减益", "source:", source, "target:", target, "duration:", duration, "dps:", damagePerSecond);
  registerManualBuff(target, buffID, duration, 0, {
    sourceName: 参数.sourceName ?? GetUnitName(source),
    iconOverride: 参数.iconOverride ?? 读取Buff图标(buffID),
    effectModelOverride: 参数.effectModelOverride ?? 读取Buff特效(buffID),
    onRemove: on暗影突袭Buff移除,
  });
  SFB_setSlow(source, target, slowAttack, slowMove, duration);

  const 毒素ID = ++下一个暗影突袭毒素ID;
  暗影突袭毒素计时表[毒素ID] = {
    毒素ID,
    source,
    target,
    buffID,
    remainingTicks: 暗影突袭向上取整秒数(duration),
    damagePerTick: damagePerSecond,
    下次伤害时间毫秒: getServerTime() + 1000,
  };
  暗影突袭毒素ID列表.push(毒素ID);
  确保暗影突袭毒素扫描已启动();
}

export function 创建暗影突袭追踪(this: void, source: any, target: any, 参数: 暗影突袭追踪参数 = {}): void {
  if (source == null || source === 0 || target == null || target === 0) return;
  debugLogForce(
    "暗影突袭",
    "准备创建追踪弹幕",
    "source:",
    source,
    "target:",
    target,
    "sourcePos=(",
    GetUnitX(source),
    ",",
    GetUnitY(source),
    ")",
    "targetPos=(",
    GetUnitX(target),
    ",",
    GetUnitY(target),
    ")",
  );
  let 已施加 = false;
  function 暗影突袭弹幕命中(this: void, 命中单位: any): void {
    if (已施加) return;
    已施加 = true;
    debugLogForce("暗影突袭", "弹幕命中", "source:", source, "target:", 命中单位);
    施加暗影突袭减益(source, 命中单位, 参数.减益 ?? {});
  }
  function 暗影突袭到达目标点(this: void): void {
    if (已施加) return;
    if (target == null || target === 0) return;
    已施加 = true;
    debugLogForce("暗影突袭", "到达目标点补命中", "source:", source, "target:", target);
    施加暗影突袭减益(source, target, 参数.减益 ?? {});
  }
  function 暗影突袭结束(this: void, 原因: string): void {
    debugLogForce("暗影突袭", "结束", "source:", source, "target:", target, "原因:", 原因);
  }
  function 暗影突袭目标筛选(this: void, 目标单位: any): boolean {
    return isSameUnit(目标单位, target);
  }
  创建原生弹幕({
    所有者: source,
    X: GetUnitX(source),
    Y: GetUnitY(source),
    方向角: GetUnitFacing(source),
    指定目标: target,
    速度: 参数.速度 ?? 1500,
    轨迹采样器: 创建追踪插值轨迹(target, 参数.命中半径 ?? 100),
    命中半径: 参数.命中半径 ?? 100,
    生命周期: 参数.生命周期 ?? 8,
    碰撞消失: true,
    最大距离: 参数.最大距离 ?? 5000,
    模型: 参数.模型 ?? 暗影突袭弹幕模型,
    附着特效模型: 参数.模型 ?? 暗影突袭弹幕模型,
    影响目标: "全部",
    目标筛选: 暗影突袭目标筛选,
    最大总命中次数: 1,
    每单位最大命中次数: 1,
    on到达目标点: 暗影突袭到达目标点,
    on命中: 暗影突袭弹幕命中,
    on命中单位: 暗影突袭弹幕命中,
    on结束: 暗影突袭结束,
  });
}

export {};
