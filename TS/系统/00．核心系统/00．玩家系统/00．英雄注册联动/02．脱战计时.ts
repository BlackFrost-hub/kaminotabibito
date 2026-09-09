/** @noSelfInFile */

import { 读取Boss当前阶段阈值 } from "../../03．脱战系统/01．Boss阶段状态";
import { 计算Boss脱战目标生命比例 } from "../../03．脱战系统/02．Boss脱战回血规则";

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const SetUnitState = jass.SetUnitState as (this: void, unit: any, state: any, value: number) => void;
const GetUnitTypeId = jass.GetUnitTypeId as (this: void, unit: any) => number;
const IsUnitType = jass.IsUnitType as (this: void, unit: any, type: any) => boolean;
const GetUnitName = jass.GetUnitName as (this: void, unit: any) => string;
const R2SW = jass.R2SW as (this: void, value: number, width: number, precision: number) => string;
const GetUnitStateJapi = japi.GetUnitState as (this: void, unit: any, state: any) => number;
const g = require("jass.globals") as { udg_Boss?: any; [key: string]: any };
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, whichForce: any, messageType: number, message: string) => void;
};

function 设置生命百分比(this: void, unit: any, pct: number): void {
  const maxLife = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE);
  SetUnitState(unit, jass.UNIT_STATE_LIFE, maxLife * (pct > 0 ? pct : 0) * 0.01);
}
function 设置魔法百分比(this: void, unit: any, pct: number): void {
  const maxMana = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_MANA);
  SetUnitState(unit, jass.UNIT_STATE_MANA, maxMana * (pct > 0 ? pct : 0) * 0.01);
}
function 拥有Buff(this: void, unit: any, buffId: number): boolean {
  if (unit == null || unit === 0) return false;
  return jass.GetUnitAbilityLevel(unit, buffId) > 0;
}

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (target: any, attacker: any, applied: number, snapshot: any) => void) => void;
};
function 注册最终伤害回调(this: void, cb: (target: any, attacker: any, applied: number, snapshot: any) => void): void {
  registerAppliedFinalDamageListener(cb);
}
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const {
  脱战开关,
  玩家英雄脱战时间秒,
  Boss脱战时间秒,
  脱战移速技能ID,
  脱战BuffID,
  脱战伤害阈值比例,
} = require("系统.00．核心系统.03．脱战系统.00．脱战规则") as {
  脱战开关: boolean;
  玩家英雄脱战时间秒: number;
  Boss脱战时间秒: number;
  脱战移速技能ID: number;
  脱战BuffID: number;
  脱战伤害阈值比例: number;
};
const centerTimer = globalThis as unknown as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

const 英雄脱战计时器ID: number[] = [0, 0, 0, 0, 0];
let Boss脱战计时器ID = 0;
let Boss脱战计时暂停深度 = 0;
let 当前计时Boss: any = null;

function Boss仍有效(this: void, boss: any): boolean {
  return boss != null && boss !== 0 && GetUnitTypeId(boss) !== 0 && !IsUnitType(boss, jass.UNIT_TYPE_DEAD);
}

function 是玩家英雄(this: void, unit: any): boolean {
  if (unit == null) return false;
  return getRegisteredPlayerHero(jass.GetOwningPlayer(unit)) === unit;
}

function 取玩家编号(this: void, unit: any): number {
  if (unit == null) return -1;
  const owner = jass.GetOwningPlayer(unit);
  if (owner == null) return -1;
  return jass.GetPlayerId(owner);
}

function 启动英雄脱战计时(this: void, 玩家编号: number): void {
  if (玩家编号 < 0 || 玩家编号 > 3) return;

  const 索引 = 玩家编号 + 1;
  const 旧任务ID = 英雄脱战计时器ID[索引];
  if (旧任务ID !== 0) {
    centerTimer.removeDelayedCallback(旧任务ID);
  }

  英雄脱战计时器ID[索引] = centerTimer.addDelayedCallback(玩家英雄脱战时间秒 * 1000, () => {
    if (英雄脱战计时器ID[索引] === 0) return;
    英雄脱战计时器ID[索引] = 0;
    英雄脱战完成(玩家编号);
  });
}

function 英雄脱战完成(this: void, 玩家编号: number): void {
  const owner = jass.Player(玩家编号);
  if (owner == null || owner === 0) return;

  const unit = getRegisteredPlayerHero(owner);
  if (unit == null || unit === 0) return;

  jass.DisplayTimedTextToPlayer(owner, 0, 0, 30, "|cffffff00『系统提示』：|r『进入脱战状态』！生命和魔法已恢复。");
  jass.UnitAddAbility(unit, 脱战移速技能ID);
  设置生命百分比(unit, 100);
  设置魔法百分比(unit, 100);
  jass.SetUnitPathing(unit, true);
}

function 启动Boss脱战计时(this: void): void {
  const boss = g.udg_Boss;
  if (!Boss仍有效(boss)) return;
  if (当前计时Boss !== boss) {
    当前计时Boss = boss;
    Boss脱战计时暂停深度 = 0;
  }
  if (Boss脱战计时暂停深度 > 0) return;
  if (Boss脱战计时器ID !== 0) {
    centerTimer.removeDelayedCallback(Boss脱战计时器ID);
  }
  Boss脱战计时器ID = centerTimer.addDelayedCallback(Boss脱战时间秒 * 1000, onBoss脱战计时完成, boss);
}

/** 长时间 Boss 机制期间暂停脱战回血计时；支持嵌套调用。 */
export function 暂停Boss脱战计时(this: void): void {
  if (!Boss仍有效(g.udg_Boss)) return;
  if (当前计时Boss !== g.udg_Boss) {
    当前计时Boss = g.udg_Boss;
    Boss脱战计时暂停深度 = 0;
  }
  Boss脱战计时暂停深度 = Boss脱战计时暂停深度 + 1;
  if (Boss脱战计时器ID !== 0) {
    centerTimer.removeDelayedCallback(Boss脱战计时器ID);
    Boss脱战计时器ID = 0;
  }
}

/** Boss 机制完成或 Boss 死亡后恢复脱战计时。恢复从 0 秒重新计时。 */
export function 恢复Boss脱战计时(this: void): void {
  if (Boss脱战计时暂停深度 <= 0) return;
  Boss脱战计时暂停深度 = Boss脱战计时暂停深度 - 1;
  if (Boss脱战计时暂停深度 === 0) 启动Boss脱战计时();
}

function onBoss脱战计时完成(this: void, variable?: any): void {
  const boss = variable;
  if (Boss脱战计时器ID === 0 || 当前计时Boss !== boss) return;
  Boss脱战计时器ID = 0;
  if (boss !== g.udg_Boss || !Boss仍有效(boss) || Boss脱战计时暂停深度 > 0) return;

  const 最大生命 = GetUnitStateJapi(boss, jass.UNIT_STATE_MAX_LIFE);
  if (!(最大生命 > 0)) return;
  const 当前生命 = GetUnitStateJapi(boss, jass.UNIT_STATE_LIFE);
  const 当前比例 = 当前生命 / 最大生命;
  const 阶段阈值 = 读取Boss当前阶段阈值(boss);
  const 目标比例 = 计算Boss脱战目标生命比例(当前比例, 阶段阈值);
  if (目标比例 > 当前比例) SetUnitState(boss, jass.UNIT_STATE_LIFE, 最大生命 * 目标比例);
  设置魔法百分比(boss, 100);
  启动Boss脱战计时();

  if (目标比例 <= 当前比例) return;
  QuestMessageBJ(
    GetPlayersAll(),
    jass.bj_QUESTMESSAGE_WARNING,
    "|cffffff00『脱战恢复』|r |cffff6600" + GetUnitName(boss) + "|r\n"
    + "|cffcccccc生命：|r |cff66ccff" + R2SW(当前比例 * 100, 1, 2) + "%|r"
    + " |cffcccccc→|r |cff99ff99" + R2SW(目标比例 * 100, 1, 2) + "%|r"
    + " |cff99ff99（+" + R2SW((目标比例 - 当前比例) * 100, 1, 2) + "%）|r\n"
    + "|cffcccccc若持续未受伤，|r|cffffff00" + Boss脱战时间秒 + "秒|r|cffcccccc后再次恢复。|r"
  );
}

function 检查移除脱战Buff(this: void, unit: any, damage: number): void {
  if (!拥有Buff(unit, 脱战BuffID)) return;

  const 最大生命 = GetUnitStateJapi(unit, jass.UNIT_STATE_MAX_LIFE);
  const 阈值 = 最大生命 * 脱战伤害阈值比例;

  if (damage >= 阈值) {
    jass.UnitRemoveAbility(unit, 脱战移速技能ID);
    jass.UnitRemoveAbility(unit, 脱战BuffID);
    const owner = jass.GetOwningPlayer(unit);
    jass.DisplayTimedTextToPlayer(owner, 0, 0, 30, "|cffff0000『进入战斗状态』|r");
  }
}

function 单位受伤事件(
  this: void,
  unit: any,
  _attacker: any,
  damage: number,
  _snapshot: any
): void {
  if (jass.IsUnitIllusion(unit)) return;
  if (damage < 1.0) return;

  const boss = g.udg_Boss;
  if (unit === boss) {
    启动Boss脱战计时();
    return;
  }

  if (!是玩家英雄(unit)) return;

  检查移除脱战Buff(unit, damage);

  const 玩家编号 = 取玩家编号(unit);
  启动英雄脱战计时(玩家编号);
}

let 已初始化 = false;

export function 初始化脱战系统(this: void): void {
  if (已初始化) return;
  已初始化 = true;
  if (!脱战开关) return;
  注册最终伤害回调(单位受伤事件);
}

export {};
