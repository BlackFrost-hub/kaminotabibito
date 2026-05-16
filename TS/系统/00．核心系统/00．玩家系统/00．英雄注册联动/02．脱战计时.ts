/** @noSelfInFile */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { udg_Boss?: any; [key: string]: any };

function 设置生命百分比(this: void, unit: any, pct: number): void {
  const maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE);
  jass.SetUnitState(unit, jass.UNIT_STATE_LIFE, maxLife * (pct > 0 ? pct : 0) * 0.01);
}
function 设置魔法百分比(this: void, unit: any, pct: number): void {
  const maxMana = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_MANA);
  jass.SetUnitState(unit, jass.UNIT_STATE_MANA, maxMana * (pct > 0 ? pct : 0) * 0.01);
}
function 拥有Buff(this: void, unit: any, buffId: number): boolean {
  if (unit == null || unit === 0) return false;
  return jass.GetUnitAbilityLevel(unit, buffId) > 0;
}

const 伤害事件模块 = require("系统.04．伤害系统.01．伤害事件") as {
  registerDamageCallback: (cb: (target: any, damage: number, damageType: number, fromDotTickBatch: boolean, source: any, isNormalAttack: boolean) => void) => void;
};
function 注册伤害回调(this: void, cb: (target: any, damage: number, damageType: number, fromDotTickBatch: boolean, source: any, isNormalAttack: boolean) => void): void {
  伤害事件模块.registerDamageCallback(cb);
}
const { getRegisteredPlayerHero } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  getRegisteredPlayerHero: (this: void, whichPlayer: any) => any;
};
const centerTimer = globalThis as unknown as {
  addDelayedCallback: (this: void, delayMs: number, callback: () => void) => number;
  removeDelayedCallback: (this: void, id: number) => void;
};

const 脱战开关 = true;
const 英雄脱战时间秒 = 18.0;
const Boss脱战时间秒 = 10.0;
const 脱战移速技能ID = 0x41303142; // A01B
const 脱战BuffID = 0x42303031; // B001
const 伤害阈值比例 = 0.012;

const 英雄脱战计时器ID: number[] = [0, 0, 0, 0, 0];
let Boss脱战计时器ID = 0;

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

  英雄脱战计时器ID[索引] = centerTimer.addDelayedCallback(英雄脱战时间秒 * 1000, () => {
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
  if (Boss脱战计时器ID !== 0) {
    centerTimer.removeDelayedCallback(Boss脱战计时器ID);
  }
  Boss脱战计时器ID = centerTimer.addDelayedCallback(Boss脱战时间秒 * 1000, () => {
    if (Boss脱战计时器ID === 0) return;
    Boss脱战计时器ID = 0;
    Boss脱战完成();
  });
}

function Boss脱战完成(this: void): void {
  const boss = g.udg_Boss;
  if (boss == null || boss === 0) return;
  if (jass.IsUnitType(boss, jass.UNIT_TYPE_DEAD)) return;

  设置生命百分比(boss, 100);
  设置魔法百分比(boss, 100);

  const bossName = jass.GetUnitName(boss);
  jass.QuestMessageBJ(
    jass.GetPlayersAll(),
    jass.bj_QUESTMESSAGE_WARNING,
    "|cffffff00『系统消息』|r：|cffff0000Boss|r|cffff6600『" + bossName + "』|r由于太久没受到玩家伤害脱战回血了。"
  );
}

function 检查移除脱战Buff(this: void, unit: any, damage: number): void {
  if (!拥有Buff(unit, 脱战BuffID)) return;

  const 最大生命 = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE);
  const 阈值 = 最大生命 * 伤害阈值比例;

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
  damage: number,
  伤害类型: number,
  来自DOT批: boolean,
  来源: any,
  是否普攻: boolean
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
  注册伤害回调(单位受伤事件);
}

export {};
