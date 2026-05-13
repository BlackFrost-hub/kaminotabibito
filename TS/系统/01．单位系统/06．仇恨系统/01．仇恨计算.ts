/** @noSelfInFile */
/**
 * 01．仇恨计算
 *
 * 注册到伤害系统最终伤害通知，敌人（target）对攻击者（attacker）产生仇恨。
 * 公式：仇恨值 = (实际伤害 / 目标最大生命值) * 1000
 *
 * 攻击者会经过 伤害映射 处理：玩家 0-4 的非英雄单位被映射为对应玩家英雄。
 * 玩家判定范围 0-4（含未来扩展的玩家4）。
 */

const jass = require("jass.common") as any;

const { registerAppliedFinalDamageListener } = require("系统.04．伤害系统.00．伤害计算.04．主计算流程") as {
  registerAppliedFinalDamageListener: (this: void, cb: (target: any, attacker: any, applied: number) => void) => void;
};

const { isUnitEnemy } = require("lib.扩展函数.自定义扩展函数.02．条件判断函数") as {
  isUnitEnemy: (this: void, targetUnit: any, sourceUnit: any) => boolean;
};

const { 获取映射攻击者 } = require("系统.04．伤害系统.04．伤害映射") as {
  获取映射攻击者: (this: void, attacker: any, target: any) => any;
};

const { addThreat } = require("系统.01．单位系统.06．仇恨系统.00．仇恨存储") as {
  addThreat: (this: void, 敌人: any, 仇恨目标: any, 数值: number) => void;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const GetOwningPlayer = jass.GetOwningPlayer as (u: any) => any;
const GetPlayerId = jass.GetPlayerId as (p: any) => number;
const GetUnitState = jass.GetUnitState as (u: any, state: any) => number;
const GetHandleId = jass.GetHandleId as (h: any) => number;
const R2I = jass.R2I as (value: number) => number;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE;
const 模块名 = "仇恨计算";

/** 仇恨系统自己的玩家判定：玩家 0-4 为玩家单位，其余为 NPC/电脑 */
function 是玩家单位(unit: any): boolean {
  if (unit == null || unit === 0) return false;
  const owner = GetOwningPlayer(unit);
  if (owner == null || owner === 0) return false;
  const pid = GetPlayerId(owner);
  return pid >= 0 && pid <= 4;
}

let 已注册 = false;
let _nowMs: (() => number) | null = null;
let 上次事件毫秒 = -1;
let 上次目标ID = 0;
let 上次攻击者ID = 0;
let 上次伤害毫数 = 0;

function nowMs(): number {
  if (_nowMs == null) {
    _nowMs = require("系统.00．核心系统.05．中心计时器").getServerTime as () => number;
  }
  return _nowMs();
}

function onDamage(this: void, target: any, attacker: any, applied: number): void {
  if (attacker == null || attacker === 0) return;
  if (target == null || target === 0) return;
  if (target === attacker) return;
  if (applied <= 0) return;

  // 将非英雄的玩家单位映射为玩家英雄
  attacker = 获取映射攻击者(attacker, target);

  const 敌对结果 = isUnitEnemy(attacker, target);
  const attacker是玩家单位 = 是玩家单位(attacker);
  const target是玩家单位 = 是玩家单位(target);

  // 只给敌方怪物建玩家仇恨
  if (!敌对结果) return;
  if (target是玩家单位) return;
  if (!attacker是玩家单位) return;

  const maxHp = GetUnitState(target, UNIT_STATE_MAX_LIFE);
  if (maxHp <= 0) return;

  const 当前目标ID = GetHandleId(target);
  const 当前攻击者ID = GetHandleId(attacker);
  const 当前伤害毫数 = R2I(applied * 1000 + 0.5);
  const 当前毫秒 = nowMs();
  if (
    当前毫秒 === 上次事件毫秒 &&
    当前目标ID === 上次目标ID &&
    当前攻击者ID === 上次攻击者ID &&
    当前伤害毫数 === 上次伤害毫数
  ) {
    debugLogForce(
      模块名,
      "忽略重复最终伤害回调 targetID=",
      当前目标ID,
      "attackerID=",
      当前攻击者ID,
      "applied=",
      applied
    );
    return;
  }
  上次事件毫秒 = 当前毫秒;
  上次目标ID = 当前目标ID;
  上次攻击者ID = 当前攻击者ID;
  上次伤害毫数 = 当前伤害毫数;

  const threat = (applied / maxHp) * 1000;
  debugLogForce(
    模块名,
    "最终伤害回调 targetID=",
    当前目标ID,
    "attackerID=",
    当前攻击者ID,
    "applied=",
    applied,
    "maxHp=",
    maxHp,
    "threat=",
    threat
  );
  addThreat(target, attacker, threat);
}

export function 注册伤害仇恨回调(): void {
  if (已注册) return;
  已注册 = true;
  registerAppliedFinalDamageListener(onDamage);
}

export {};
