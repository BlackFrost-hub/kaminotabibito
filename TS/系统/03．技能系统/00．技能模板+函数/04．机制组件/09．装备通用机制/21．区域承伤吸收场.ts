/** @noSelfInFile */

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (this: void, target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
const { onTick10ms, offTick10ms } = require("系统.00．核心系统.05．中心计时器") as {
  onTick10ms: (this: void, callback: (this: void) => void) => void;
  offTick10ms: (this: void, callback: (this: void) => void) => void;
};
const { EC_CreateEffect } = require("lib.扩展函数.Star扩展函数.04．EC扩展库") as {
  EC_CreateEffect: (this: void, path: string, x: number, y: number, z: number, fac: number, size: number, speed: number, time: number) => any;
};

const jass = require("jass.common") as any;
const GetHandleId = jass.GetHandleId as (handle: any) => number;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const IsUnitAlly = jass.IsUnitAlly as (unit: any, player: any) => boolean;
const IsUnitOwnedByPlayer = jass.IsUnitOwnedByPlayer as (unit: any, player: any) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const SetUnitState = jass.SetUnitState as (unit: any, state: any, value: number) => void;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;

export interface 区域承伤吸收场事件 {
  场ID: number;
  施法单位: any;
  受伤单位: any;
  攻击者: any;
  本次伤害: number;
  吸收量: number;
  剩余吸收值: number;
  伤害快照: any;
}

export interface 区域承伤吸收场参数 {
  名称?: string;
  施法单位: any;
  X: number;
  Y: number;
  持续秒数: number;
  作用半径: number;
  吸收值: number;
  特效路径: string;
  特效尺寸?: number;
  特效高度?: number;
  特效朝向?: number;
  特效速度?: number;
  只影响友军?: boolean;
  包含同玩家单位?: boolean;
  吸收量限制为剩余值?: boolean;
  可吸收单位?: (this: void, event: { 场ID: number; 施法单位: any; 受伤单位: any; 攻击者: any; 伤害快照: any }) => boolean;
  on吸收?: (this: void, event: 区域承伤吸收场事件) => void;
  on结束?: (this: void, event: { 场ID: number; 施法单位: any; 是否耗尽: boolean }) => void;
}

export interface 区域承伤吸收场控制器 {
  readonly id: number;
  获取剩余吸收值(): number;
  移除(): void;
}

type 区域承伤吸收场实例 = {
  id: number;
  参数: 区域承伤吸收场参数;
  施法玩家: any;
  特效: any;
  剩余时间: number;
  剩余吸收值: number;
  已移除: boolean;
};

const 区域承伤吸收场表: Record<number, 区域承伤吸收场实例 | undefined> = {};
const 区域承伤吸收场ID列表: number[] = [];
let 已注册区域承伤吸收场伤害监听 = false;
let 已注册区域承伤吸收场计时器 = false;

class 区域承伤吸收场控制器实现 implements 区域承伤吸收场控制器 {
  readonly id: number;

  constructor(id: number) {
    this.id = id;
  }

  获取剩余吸收值(): number {
    return 区域承伤吸收场表[this.id]?.剩余吸收值 ?? 0;
  }

  移除(): void {
    移除区域承伤吸收场(this.id, false);
  }
}

function 从区域承伤吸收场列表移除(this: void, id: number): void {
  for (let i = 区域承伤吸收场ID列表.length - 1; i >= 0; i--) {
    if (区域承伤吸收场ID列表[i] === id) {
      区域承伤吸收场ID列表.splice(i, 1);
      return;
    }
  }
}

function 确保区域承伤吸收场计时器(this: void): void {
  if (已注册区域承伤吸收场计时器) return;
  已注册区域承伤吸收场计时器 = true;
  onTick10ms(on区域承伤吸收场Tick);
}

function 尝试关闭区域承伤吸收场计时器(this: void): void {
  if (!已注册区域承伤吸收场计时器) return;
  if (区域承伤吸收场ID列表.length > 0) return;
  已注册区域承伤吸收场计时器 = false;
  offTick10ms(on区域承伤吸收场Tick);
}

function 确保区域承伤吸收场伤害监听(this: void): void {
  if (已注册区域承伤吸收场伤害监听) return;
  已注册区域承伤吸收场伤害监听 = true;
  registerAppliedFinalDamageListener(on区域承伤吸收场最终伤害);
}

function 移除区域承伤吸收场(this: void, id: number, 是否耗尽: boolean): void {
  const 实例 = 区域承伤吸收场表[id];
  if (实例 == null || 实例.已移除) return;
  实例.已移除 = true;
  delete 区域承伤吸收场表[id];
  从区域承伤吸收场列表移除(id);
  if (实例.特效 != null && 实例.特效 !== 0) DestroyEffect(实例.特效);
  if (实例.参数.on结束 != null) {
    实例.参数.on结束({ 场ID: id, 施法单位: 实例.参数.施法单位, 是否耗尽 });
  }
  尝试关闭区域承伤吸收场计时器();
}

function on区域承伤吸收场Tick(this: void): void {
  for (let i = 区域承伤吸收场ID列表.length - 1; i >= 0; i--) {
    const id = 区域承伤吸收场ID列表[i];
    const 实例 = 区域承伤吸收场表[id];
    if (实例 == null || 实例.剩余吸收值 <= 0) {
      移除区域承伤吸收场(id, true);
      continue;
    }
    实例.剩余时间 = 实例.剩余时间 - 0.01;
    if (实例.剩余时间 <= 0) 移除区域承伤吸收场(id, false);
  }
  尝试关闭区域承伤吸收场计时器();
}

function 单位在吸收场内(this: void, 实例: 区域承伤吸收场实例, unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const 参数 = 实例.参数;
  const dx = GetUnitX(unit) - 参数.X;
  const dy = GetUnitY(unit) - 参数.Y;
  if (dx * dx + dy * dy > 参数.作用半径 * 参数.作用半径) return false;
  if ((参数.只影响友军 ?? true) && !IsUnitAlly(unit, 实例.施法玩家)) {
    if (!(参数.包含同玩家单位 ?? true) || !IsUnitOwnedByPlayer(unit, 实例.施法玩家)) return false;
  }
  return true;
}

function 计算区域承伤吸收量(this: void, 实例: 区域承伤吸收场实例, damage: number): number {
  if (!(damage > 0)) return 0;
  if (实例.参数.吸收量限制为剩余值 === true && damage > 实例.剩余吸收值) {
    return 实例.剩余吸收值;
  }
  return damage;
}

function on区域承伤吸收场最终伤害(this: void, target: any, attacker: any, applied: number, snapshot: any): void {
  if (target == null || target === 0 || !(applied > 0)) return;
  for (let i = 区域承伤吸收场ID列表.length - 1; i >= 0; i--) {
    const id = 区域承伤吸收场ID列表[i];
    const 实例 = 区域承伤吸收场表[id];
    if (实例 == null || 实例.剩余吸收值 <= 0) {
      移除区域承伤吸收场(id, true);
      continue;
    }
    if (!单位在吸收场内(实例, target)) continue;
    if (实例.参数.可吸收单位 != null && !实例.参数.可吸收单位({ 场ID: id, 施法单位: 实例.参数.施法单位, 受伤单位: target, 攻击者: attacker, 伤害快照: snapshot })) continue;

    const absorb = 计算区域承伤吸收量(实例, applied);
    if (!(absorb > 0)) continue;

    SetUnitState(target, UNIT_STATE_LIFE, GetUnitState(target, UNIT_STATE_LIFE) + absorb);
    实例.剩余吸收值 = 实例.剩余吸收值 - absorb;
    if (实例.参数.on吸收 != null) {
      实例.参数.on吸收({
        场ID: id,
        施法单位: 实例.参数.施法单位,
        受伤单位: target,
        攻击者: attacker,
        本次伤害: applied,
        吸收量: absorb,
        剩余吸收值: 实例.剩余吸收值,
        伤害快照: snapshot,
      });
    }
    if (实例.剩余吸收值 <= 0) 移除区域承伤吸收场(id, true);
  }
}

export function 创建区域承伤吸收场(this: void, 参数: 区域承伤吸收场参数): 区域承伤吸收场控制器 | null {
  if (参数.施法单位 == null || 参数.施法单位 === 0) return null;
  if (!(参数.持续秒数 > 0) || !(参数.作用半径 > 0) || !(参数.吸收值 > 0)) return null;

  const effect = EC_CreateEffect(参数.特效路径, 参数.X, 参数.Y, 参数.特效高度 ?? 0, 参数.特效朝向 ?? 0, 参数.特效尺寸 ?? 1, 参数.特效速度 ?? 1, -1);
  if (effect == null || effect === 0) return null;

  const id = GetHandleId(effect);
  if (id <= 0) {
    DestroyEffect(effect);
    return null;
  }

  区域承伤吸收场表[id] = {
    id,
    参数,
    施法玩家: GetOwningPlayer(参数.施法单位),
    特效: effect,
    剩余时间: 参数.持续秒数,
    剩余吸收值: 参数.吸收值,
    已移除: false,
  };
  区域承伤吸收场ID列表.push(id);
  确保区域承伤吸收场伤害监听();
  确保区域承伤吸收场计时器();
  return new 区域承伤吸收场控制器实现(id);
}

export {};
