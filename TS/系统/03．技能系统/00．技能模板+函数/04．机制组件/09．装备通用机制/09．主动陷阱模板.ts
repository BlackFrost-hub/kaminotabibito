/** @noSelfInFile */

import type { 机制清理篮子 } from "../06．机制清理/01．机制清理篮子";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { getUnitsInRange } = require("lib.扩展函数.自定义扩展函数.01．选取中心范围") as {
  getUnitsInRange: (this: void, x: number, y: number, radius: number) => any[];
};
const { 施加扩展控制 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.16．扩展控制.扩展控制系统") as {
  施加扩展控制: (this: void, 来源单位: any, 目标单位: any, 类型: 主动陷阱控制类型, 参数: { 持续时间: number }) => number;
};

const AddSpecialEffect = jass.AddSpecialEffect as (modelName: string, x: number, y: number) => any;
const DestroyEffect = jass.DestroyEffect as (effect: any) => void;
const GetOwningPlayer = jass.GetOwningPlayer as (unit: any) => any;
const IsUnitEnemy = jass.IsUnitEnemy as (whichUnit: any, whichPlayer: any) => boolean;
const IsUnitType = jass.IsUnitType as (unit: any, whichType: any) => boolean;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UnitDamageTarget = jass.UnitDamageTarget as (
  whichUnit: any,
  target: any,
  amount: number,
  attack: boolean,
  ranged: boolean,
  attackType: any,
  damageType: any,
  weaponType: any
) => boolean;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL as any;
const DAMAGE_TYPE_MAGIC = jass.DAMAGE_TYPE_MAGIC as any;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS as any;
const EXSetEffectSize = japi.EXSetEffectSize as ((effect: any, size: number) => void) | undefined;

export const 默认主动陷阱模型 = "Abilities\\Spells\\Orc\\StasisTrap\\StasisTotemTarget.mdl";

export type 主动陷阱结束原因 = "触发" | "过期" | "手动销毁";
export type 主动陷阱控制类型 =
  | "stun"
  | "freeze"
  | "silence"
  | "polymorph"
  | "disarm"
  | "slow"
  | "stagger"
  | "pause"
  | "expause"
  | "sleep"
  | "roots"
  | "cyclone"
  | "taunt"
  | "charm"
  | "fear";

export interface 主动陷阱参数 {
  清理?: 机制清理篮子;
  名称?: string;
  施法者: any;
  X: number;
  Y: number;
  持续秒数: number;
  触发半径: number;
  检测间隔毫秒?: number;
  模型路径?: string;
  缩放?: number;
  触发后销毁?: boolean;
  只触发敌人?: boolean;
  过滤目标?: (this: void, 目标单位: any, 陷阱: 主动陷阱实例) => boolean;
  触发伤害?: number;
  伤害类型?: any;
  攻击类型?: any;
  武器类型?: any;
  控制类型?: 主动陷阱控制类型;
  控制持续秒数?: number;
  触发特效路径?: string;
  on触发?: (this: void, 目标单位: any, 陷阱: 主动陷阱实例) => void;
  on结束?: (this: void, 陷阱: 主动陷阱实例, 原因: 主动陷阱结束原因) => void;
}

export interface 主动陷阱实例 {
  readonly ID: number;
  readonly 名称: string;
  readonly 特效: any;
  readonly X: number;
  readonly Y: number;
  销毁(原因?: 主动陷阱结束原因): void;
}

let 下一个主动陷阱ID = 0;

function 单位有效存活(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true && GetUnitState(unit, UNIT_STATE_LIFE) > 0.405;
}

function on主动陷阱Tick(this: void, variable?: any): void {
  const 实例 = variable as 主动陷阱实现 | undefined;
  if (实例 != null) 实例.推进();
}

class 主动陷阱实现 implements 主动陷阱实例 {
  readonly ID: number;
  readonly 名称: string;
  readonly 特效: any;
  readonly X: number;
  readonly Y: number;
  private 参数: 主动陷阱参数;
  private 到期时间: number;
  private 回调ID = 0;
  private 已销毁 = false;

  constructor(ID: number, 参数: 主动陷阱参数, 特效: any) {
    this.ID = ID;
    this.名称 = 参数.名称 ?? ("主动陷阱#" + String(ID));
    this.参数 = 参数;
    this.特效 = 特效;
    this.X = 参数.X;
    this.Y = 参数.Y;
    this.到期时间 = getServerTime() + 参数.持续秒数 * 1000;
  }

  启动(): void {
    if (this.回调ID !== 0) return;
    this.回调ID = addPeriodicCallback(this.参数.检测间隔毫秒 ?? 100, on主动陷阱Tick, this);
  }

  销毁(原因: 主动陷阱结束原因 = "手动销毁"): void {
    if (this.已销毁) return;
    this.已销毁 = true;
    if (this.回调ID !== 0) {
      removePeriodicCallback(this.回调ID);
      this.回调ID = 0;
    }
    if (this.特效 != null && this.特效 !== 0) DestroyEffect(this.特效);
    if (this.参数.on结束 != null) this.参数.on结束(this, 原因);
  }

  推进(): void {
    if (this.已销毁) return;
    if (getServerTime() >= this.到期时间) {
      this.销毁("过期");
      return;
    }
    const targets = getUnitsInRange(this.X, this.Y, this.参数.触发半径);
    for (let i = 0; i < targets.length; i++) {
      const target = targets[i];
      if (!this.目标可触发(target)) continue;
      this.触发(target);
      return;
    }
  }

  private 目标可触发(target: any): boolean {
    if (!单位有效存活(target)) return false;
    if (this.参数.只触发敌人 !== false && !IsUnitEnemy(target, GetOwningPlayer(this.参数.施法者))) return false;
    if (this.参数.过滤目标 != null && !this.参数.过滤目标(target, this)) return false;
    return true;
  }

  private 触发(target: any): void {
    if (this.参数.触发特效路径 != null && this.参数.触发特效路径 !== "") {
      const effect = AddSpecialEffect(this.参数.触发特效路径, this.X, this.Y);
      if (effect != null && effect !== 0) DestroyEffect(effect);
    }
    if ((this.参数.触发伤害 ?? 0) > 0) {
      const attackType = this.参数.攻击类型 ?? ATTACK_TYPE_NORMAL;
      const damageType = this.参数.伤害类型 ?? DAMAGE_TYPE_MAGIC;
      const weaponType = this.参数.武器类型 ?? WEAPON_TYPE_WHOKNOWS;
      UnitDamageTarget(
        this.参数.施法者,
        target,
        this.参数.触发伤害 ?? 0,
        false,
        false,
        attackType,
        damageType,
        weaponType
      );
    }
    if (this.参数.控制类型 != null && (this.参数.控制持续秒数 ?? 0) > 0) {
      施加扩展控制(this.参数.施法者, target, this.参数.控制类型, { 持续时间: this.参数.控制持续秒数 ?? 0 });
    }
    if (this.参数.on触发 != null) this.参数.on触发(target, this);
    if (this.参数.触发后销毁 !== false) this.销毁("触发");
  }
}

export function 创建主动陷阱(this: void, 参数: 主动陷阱参数): 主动陷阱实例 | null {
  if (参数.施法者 == null || 参数.施法者 === 0) return null;
  if (!(参数.持续秒数 > 0) || !(参数.触发半径 > 0)) return null;
  const effect = AddSpecialEffect(参数.模型路径 ?? 默认主动陷阱模型, 参数.X, 参数.Y);
  if (effect == null || effect === 0) return null;
  if (参数.缩放 != null && typeof EXSetEffectSize === "function") EXSetEffectSize(effect, 参数.缩放);

  const 实例 = new 主动陷阱实现(++下一个主动陷阱ID, 参数, effect);
  实例.启动();
  if (参数.清理 != null) {
    参数.清理.登记清理(实例.名称, function 主动陷阱清理(this: void): void {
      实例.销毁();
    });
  }
  return 实例;
}

export {};
