/**
 * Star扩展库 - 物品技能事件系统
 *
 * 来源于 StarUnit.j，提供物品技能事件监听功能。
 * 当单位使用物品时，触发注册的物品技能事件。
 *
 * 公开接口：
 *   SU_AddItemAbilityEvent(trg)     - 注册物品技能事件
 *   SU_InititemAbilityListener()    - 初始化物品技能监听
 *   SU_GetLastSpellItemAbility()    - 获取最后使用的物品技能ID
 *   SU_GetLastSpellItemAbilityTargetX() - 获取目标X坐标
 *   SU_GetLastSpellItemAbilityTargetY() - 获取目标Y坐标
 *   SU_GetLastSpellItemAbilityTargetUnit() - 获取目标单位
 *   SU_GetLastSpellItemAbilityTargetPoint() - 获取目标点
 *
 * 依赖：
 *   - StarBaseHT (jass.globals.StarBaseHT) - 统一回调哈希表
 *   - YDHT (jass.globals.YDHT) - 逆天哈希表
 *   - StrHEX(s) = StringHash(s) - 字符串转哈希码
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件") as {
  registerPlayerUnitEventForPlayerIds: (this: void, trig: any, playerIds: readonly number[], eventId: any, filter?: any) => void;
};
const { registerSpellEffectListener } = require("系统.00．核心系统.01．事件中心.08．技能事件中心") as {
  registerSpellEffectListener: (callback: (castingUnit: any, spellAbilityId: number) => void) => void;
};

const lastItemAbilityContext = {
  abilityId: 0,
  targetX: 0,
  targetY: 0,
  targetUnit: null as any,
  targetPoint: null as any,
};

const su_iatList: any[] = [];
let su_iatIndex: number = 0;

let su_ItemAbilityTrig2: any = null;
let su_ItemAbilityInited: boolean = false;
const STAR_ITEM_ABILITY_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15] as const;

const HASH_LAST_SPELL = jass.StringHash("最后使用的技能");
const HASH_LAST_SPELL_X = jass.StringHash("最后使用的技能X");
const HASH_LAST_SPELL_Y = jass.StringHash("最后使用的技能Y");
const HASH_LAST_SPELL_TARGET_UNIT = jass.StringHash("最后使用的技能目标单位");
const HASH_ITEM_ABILITY_INDEX = jass.StringHash("物品技能事件索引");

// 读取统一回调哈希表。
function getStarBaseHT(): any {
  return jglobals && jglobals.StarBaseHT ? jglobals.StarBaseHT : null;
}

// 读取触发器注册索引哈希表。
function getYDHT(): any {
  return jglobals && jglobals.YDHT ? jglobals.YDHT : null;
}

// 读取当前施法单位。
function getTriggerUnitOrNull(): any {
  return jass.GetTriggerUnit();
}

// 按施法单位保存本次技能上下文，目标单位取技能真实目标。
//key = caster
// value = spell target unit
function saveLastSpellContext(caster: any): void {
  const StarBaseHT = getStarBaseHT();
  if (caster == null || StarBaseHT == null) return;

  const hd = jass.GetHandleId(caster);
  const spellId = jass.GetSpellAbilityId();
  const x = jass.GetSpellTargetX();
  const y = jass.GetSpellTargetY();
  const targetUnit = jass.GetSpellTargetUnit();

  jass.SaveInteger(StarBaseHT, hd, HASH_LAST_SPELL, spellId);
  jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_X, x);
  jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_Y, y);
  jass.SaveUnitHandle(StarBaseHT, hd, HASH_LAST_SPELL_TARGET_UNIT, targetUnit);
}

// 按施法单位读取最近一次技能上下文。
function loadLastSpellContext(caster: any): void {
  const StarBaseHT = getStarBaseHT();
  if (caster == null || StarBaseHT == null) {
    resetLastSpellContext();
    return;
  }

  const hd = jass.GetHandleId(caster);
  lastItemAbilityContext.abilityId = jass.LoadInteger(StarBaseHT, hd, HASH_LAST_SPELL);
  lastItemAbilityContext.targetX = jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_X);
  lastItemAbilityContext.targetY = jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_Y);
  lastItemAbilityContext.targetUnit = jass.LoadUnitHandle(StarBaseHT, hd, HASH_LAST_SPELL_TARGET_UNIT);
  if (lastItemAbilityContext.targetUnit === 0) {
    lastItemAbilityContext.targetUnit = null;
  }
}

// 清空最近一次物品技能上下文。
function resetLastSpellContext(): void {
  lastItemAbilityContext.abilityId = 0;
  lastItemAbilityContext.targetX = 0;
  lastItemAbilityContext.targetY = 0;
  lastItemAbilityContext.targetUnit = null;
  lastItemAbilityContext.targetPoint = null;
}

// 为当前上下文构建点对象。
function createLastSpellTargetPoint(): void {
  lastItemAbilityContext.targetPoint = null;
  lastItemAbilityContext.targetPoint = jass.Location(
    lastItemAbilityContext.targetX,
    lastItemAbilityContext.targetY
  );
}

// 销毁当前上下文里的点对象。
function destroyLastSpellTargetPoint(): void {
  if (lastItemAbilityContext.targetPoint == null) return;
  jass.RemoveLocation(lastItemAbilityContext.targetPoint);
  lastItemAbilityContext.targetPoint = null;
}

// 执行已注册的物品技能事件。
function fireItemAbilityEvents(): void {
  if (su_iatList.length <= 0) return;

  createLastSpellTargetPoint();

  for (let i = 0; i < su_iatList.length; i++) {
    const trig = su_iatList[i];
    if (trig == null) continue;
    if (!jass.IsTriggerEnabled(trig)) continue;
    if (!jass.TriggerEvaluate(trig)) continue;
    jass.TriggerExecute(trig);
  }

  destroyLastSpellTargetPoint();
}

/**
 * 注册物品技能事件
 * @param trg 触发器
 */
export function SU_AddItemAbilityEvent(trg: any): void {
  if (trg == null || trg === 0) return;

  const YDHT = getYDHT();
  if (YDHT == null) return;

  const hd = jass.GetHandleId(trg);

  // 检查是否已注册
  const hasIndex = jass.HaveSavedInteger(YDHT, hd, HASH_ITEM_ABILITY_INDEX);

  if (!hasIndex) {
    jass.SaveInteger(YDHT, hd, HASH_ITEM_ABILITY_INDEX, su_iatIndex);
    su_iatList[su_iatIndex] = trg;
    su_iatIndex++;
  }
}

/**
 * 技能施放回调（内部使用）
 */
function SU_InititemAbilityListener_1(): void {
  const u = getTriggerUnitOrNull();
  if (u == null) return;
  saveLastSpellContext(u);
}

/**
 * 物品使用回调（内部使用）
 */
function SU_InititemAbilityListener_2(): void {
  const u = getTriggerUnitOrNull();
  if (u == null) return;

  loadLastSpellContext(u);
  fireItemAbilityEvents();
}

/**
 * 初始化物品技能监听
 * 需要在地图初始化时调用
 */
export function SU_InititemAbilityListener(): void {
  if (su_ItemAbilityInited) return;

  su_ItemAbilityTrig2 = jass.CreateTrigger();

  if (su_ItemAbilityTrig2 == null) return;

  registerSpellEffectListener(SU_InititemAbilityListener_1);
  playerUnitEvent.registerPlayerUnitEventForPlayerIds(su_ItemAbilityTrig2, STAR_ITEM_ABILITY_EVENT_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_USE_ITEM);

  jass.TriggerAddAction(su_ItemAbilityTrig2, SU_InititemAbilityListener_2);

  su_ItemAbilityInited = true;
}

/**
 * 获取最后使用的物品技能ID
 */
export function SU_GetLastSpellItemAbility(): number {
  return lastItemAbilityContext.abilityId;
}

/**
 * 获取最后使用的物品技能目标X坐标
 */
export function SU_GetLastSpellItemAbilityTargetX(): number {
  return lastItemAbilityContext.targetX;
}

/**
 * 获取最后使用的物品技能目标Y坐标
 */
export function SU_GetLastSpellItemAbilityTargetY(): number {
  return lastItemAbilityContext.targetY;
}

/**
 * 获取最后使用的物品技能目标单位
 */
export function SU_GetLastSpellItemAbilityTargetUnit(): any {
  return lastItemAbilityContext.targetUnit;
}

/**
 * 获取最后使用的物品技能目标点
 */
export function SU_GetLastSpellItemAbilityTargetPoint(): any {
  return lastItemAbilityContext.targetPoint;
}

export {};
