/**
 * 脱战计时系统
 *
 * 功能：
 * 1. 玩家英雄受到伤害时启动18秒计时器
 * 2. 计时器到期后恢复生命/魔法到100%，添加脱战移速技能
 * 3. 若有脱战buff且受到超过1%最大生命伤害，移除脱战移速技能
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;
const jglobals = require("jass.globals") as any;

const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index") as {
  YDUserDataGet: (tableType: string, tableKey: any, attr: string, valueType: string) => any;
};

const { SetUnitLifePercentBJ, SetUnitManaPercentBJ } = require("lib.扩展函数.BJ函数.index") as {
  SetUnitLifePercentBJ: (whichUnit: any, percent: number) => void;
  SetUnitManaPercentBJ: (whichUnit: any, percent: number) => void;
};

/** 从japi获取事件伤害 */
function getEventDamage(): number {
  return japi.GetEventDamage();
}

//=============================================================================
// 一、常量配置
//=============================================================================

/** 脱战计时时间（秒） */
const OUT_OF_COMBAT_TIME = 18.0;

/** 脱战移速技能ID */
const OUT_OF_COMBAT_SPEED_ABILITY = 0x41303142; // A01B

/** 脱战buff ID */
const OUT_OF_COMBAT_BUFF = 0x42303031; // B001

/** 伤害阈值比例（1%） */
const DAMAGE_THRESHOLD_RATIO = 0.01;

//=============================================================================
// 二、计时器存储
//=============================================================================

/** 玩家脱战计时器（玩家0-3对应索引1-4） */
const outOfCombatTimers: any[] = [null, null, null, null, null];

//=============================================================================
// 三、触发器
//=============================================================================

let damageTrigger: any = null;
let timerTrigger: any = null;

//=============================================================================
// 四、核心功能
//=============================================================================

/**
 * 检查单位是否为玩家英雄
 */
function isPlayerHero(unit: any): boolean {
  if (unit == null) return false;
  if (!jass.IsUnitType(unit, jass.UNIT_TYPE_HERO)) return false;

  const heroGroup = YDUserDataGet("string", "玩家英雄", "单位组", "group");
  if (heroGroup == null) return false;

  let found = false;
  jass.ForGroup(heroGroup, () => {
    if (jass.GetEnumUnit() === unit) found = true;
  });
  return found;
}

/**
 * 获取玩家ID（0-3）
 */
function getPlayerId(unit: any): number {
  if (unit == null) return -1;
  const owner = jass.GetOwningPlayer(unit);
  if (owner == null) return -1;
  return jass.GetPlayerId(owner);
}

/**
 * 启动脱战计时器
 */
function startOutOfCombatTimer(playerId: number): void {
  if (playerId < 0 || playerId > 3) return;

  const timerIndex = playerId + 1;
  let timer = outOfCombatTimers[timerIndex];

  if (timer == null) {
    timer = jass.CreateTimer();
    outOfCombatTimers[timerIndex] = timer;
  }

  jass.TimerStart(timer, OUT_OF_COMBAT_TIME, false, () => {});
}

/**
 * 处理脱战完成
 */
function onOutOfCombat(playerId: number): void {
  const heroGroup = YDUserDataGet("string", "玩家英雄", "单位组", "group");
  if (heroGroup == null) return;

  jass.ForGroup(heroGroup, () => {
    const unit = jass.GetEnumUnit();
    if (unit == null) return;

    const owner = jass.GetOwningPlayer(unit);
    if (jass.GetPlayerId(owner) !== playerId) return;

    // 显示脱战提示
    jass.DisplayTimedTextToPlayer(owner, 0, 0, 30, "脱战成功！生命和魔法已恢复。");

    // 添加脱战移速技能
    jass.UnitAddAbility(unit, OUT_OF_COMBAT_SPEED_ABILITY);

    // 恢复生命和魔法到100%
    SetUnitLifePercentBJ(unit, 100);
    SetUnitManaPercentBJ(unit, 100);

    // 恢复碰撞
    jass.SetUnitPathing(unit, true);
  });
}

/**
 * 检查并移除脱战buff（受到大伤害时）
 */
function checkRemoveOutOfCombatBuff(unit: any, damage: number): void {
  if (!jass.UnitHasBuffBJ(unit, OUT_OF_COMBAT_BUFF)) return;

  const maxLife = jass.GetUnitState(unit, jass.UNIT_STATE_MAX_LIFE);
  const threshold = maxLife * DAMAGE_THRESHOLD_RATIO;

  if (damage >= threshold) {
    // 移除脱战移速技能和buff
    jass.UnitRemoveAbility(unit, OUT_OF_COMBAT_SPEED_ABILITY);
    jass.UnitRemoveAbility(unit, OUT_OF_COMBAT_BUFF);

    const owner = jass.GetOwningPlayer(unit);
    jass.DisplayTimedTextToPlayer(owner, 0, 0, 30, "|cffff0000『进入战斗状态』|r");
  }
}

//=============================================================================
// 五、事件处理
//=============================================================================

/**
 * 单位受伤事件处理
 */
function onUnitDamaged(): void {
  const unit = jass.GetTriggerUnit();
  const damage = getEventDamage();

  // 检查是否为幻象
  if (jass.IsUnitIllusion(unit)) return;

  // 检查伤害是否>=1
  if (damage < 1.0) return;

  // 检查是否为玩家英雄
  if (!isPlayerHero(unit)) return;

  // 检查并移除脱战buff
  checkRemoveOutOfCombatBuff(unit, damage);

  // 启动脱战计时器
  const playerId = getPlayerId(unit);
  startOutOfCombatTimer(playerId);
}

/**
 * 计时器到期事件处理
 */
function onTimerExpire(): void {
  const expiredTimer = jass.GetExpiredTimer();

  for (let i = 1; i <= 4; i++) {
    if (outOfCombatTimers[i] === expiredTimer) {
      onOutOfCombat(i - 1);
      return;
    }
  }
}

//=============================================================================
// 六、英雄注册
//=============================================================================

/** 已注册受伤事件的单位 */
const registeredUnits = new Set<any>();

/**
 * 为英雄注册受伤事件
 */
export function registerOutOfCombatHero(hero: any): void {
  if (hero == null) return;

  // 避免重复注册
  const handleId = jass.GetHandleId(hero);
  if (registeredUnits.has(handleId)) return;
  registeredUnits.add(handleId);

  // 注册单位受伤事件
  jass.TriggerRegisterUnitEvent(damageTrigger, hero, jass.EVENT_UNIT_DAMAGED);
}

//=============================================================================
// 七、初始化
//=============================================================================

/**
 * 初始化脱战计时系统
 */
export function initOutOfCombat(): void {
  if (damageTrigger != null) return;

  // 创建受伤触发器
  damageTrigger = jass.CreateTrigger();
  jass.TriggerAddAction(damageTrigger, onUnitDamaged);

  // 创建计时器触发器
  timerTrigger = jass.CreateTrigger();

  // 为4个计时器注册到期事件
  for (let i = 1; i <= 4; i++) {
    const timer = jass.CreateTimer();
    outOfCombatTimers[i] = timer;
    jass.TriggerRegisterTimerExpireEvent(timerTrigger, timer);
  }

  jass.TriggerAddAction(timerTrigger, onTimerExpire);
}

export {};
