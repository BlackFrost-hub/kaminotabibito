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
 *   SU_GetLastSpellItemAbilityTargetPoint() - 获取目标点
 *
 * 依赖：
 *   - StarBaseHT (jass.globals.StarBaseHT) - 统一回调哈希表
 *   - YDHT (jass.globals.YDHT) - 逆天哈希表
 *   - StrHEX(s) = StringHash(s) - 字符串转哈希码
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

// 全局变量
let Star_LastSpellItemAbility: number = 0;
let Star_LastSpellItemAbilityTargetX: number = 0;
let Star_LastSpellItemAbilityTargetY: number = 0;
let Star_LastSpellItemAbilityTargetPoint: any = null;

// 事件触发器列表
const su_iatList: any[] = [];
let su_iatIndex: number = 0;

// 触发器引用
let su_ItemAbilityTrig: any = null;
let su_ItemAbilityTrig2: any = null;

// 哈希码常量 (StrHEX(s) = StringHash(s))
const HASH_LAST_SPELL = jass.StringHash("最后使用的技能");
const HASH_LAST_SPELL_X = jass.StringHash("最后使用的技能X");
const HASH_LAST_SPELL_Y = jass.StringHash("最后使用的技能Y");
const HASH_ITEM_ABILITY_INDEX = jass.StringHash("物品技能事件索引");

/**
 * 注册物品技能事件
 * @param trg 触发器
 */
export function SU_AddItemAbilityEvent(trg: any): void {
  if (trg == null || trg === 0) return;

  const YDHT = jglobals && jglobals.YDHT ? jglobals.YDHT : null;
  if (YDHT == null) return;

  const hd = jass.GetHandleId(trg);

  // 检查是否已注册
  const hasIndex = typeof jass.HaveSavedInteger === "function"
    && jass.HaveSavedInteger(YDHT, hd, HASH_ITEM_ABILITY_INDEX);

  if (!hasIndex) {
    if (typeof jass.SaveInteger === "function") {
      jass.SaveInteger(YDHT, hd, HASH_ITEM_ABILITY_INDEX, su_iatIndex);
    }
    su_iatList[su_iatIndex] = trg;
    su_iatIndex++;
  }
}

/**
 * 技能施放回调（内部使用）
 */
function SU_InititemAbilityListener_1(): void {
  const u = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : null;
  if (u == null) return;

  const hd = jass.GetHandleId(u);
  const StarBaseHT = jglobals && jglobals.StarBaseHT ? jglobals.StarBaseHT : null;

  if (StarBaseHT != null && typeof jass.SaveInteger === "function") {
    const spellId = typeof jass.GetSpellAbilityId === "function" ? jass.GetSpellAbilityId() : 0;
    jass.SaveInteger(StarBaseHT, hd, HASH_LAST_SPELL, spellId);
  }
  if (StarBaseHT != null && typeof jass.SaveReal === "function") {
    const x = typeof jass.GetSpellTargetX === "function" ? jass.GetSpellTargetX() : 0;
    const y = typeof jass.GetSpellTargetY === "function" ? jass.GetSpellTargetY() : 0;
    jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_X, x);
    jass.SaveReal(StarBaseHT, hd, HASH_LAST_SPELL_Y, y);
  }
}

/**
 * 物品使用回调（内部使用）
 */
function SU_InititemAbilityListener_2(): void {
  const u = typeof jass.GetTriggerUnit === "function" ? jass.GetTriggerUnit() : null;
  if (u == null) return;

  const hd = jass.GetHandleId(u);
  const StarBaseHT = jglobals && jglobals.StarBaseHT ? jglobals.StarBaseHT : null;

  // 读取最后使用的技能信息
  if (StarBaseHT != null) {
    Star_LastSpellItemAbility = typeof jass.LoadInteger === "function"
      ? jass.LoadInteger(StarBaseHT, hd, HASH_LAST_SPELL)
      : 0;
    Star_LastSpellItemAbilityTargetX = typeof jass.LoadReal === "function"
      ? jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_X)
      : 0;
    Star_LastSpellItemAbilityTargetY = typeof jass.LoadReal === "function"
      ? jass.LoadReal(StarBaseHT, hd, HASH_LAST_SPELL_Y)
      : 0;
  }

  // 触发注册的事件
  if (su_iatIndex > 0) {
    if (typeof jass.Location === "function") {
      Star_LastSpellItemAbilityTargetPoint = jass.Location(
        Star_LastSpellItemAbilityTargetX,
        Star_LastSpellItemAbilityTargetY
      );
    }

    for (let i = 0; i < su_iatIndex; i++) {
      const trig = su_iatList[i];
      if (trig != null && typeof jass.IsTriggerEnabled === "function" && jass.IsTriggerEnabled(trig)) {
        if (typeof jass.TriggerEvaluate === "function" && jass.TriggerEvaluate(trig)) {
          jass.TriggerExecute(trig);
        }
      }
    }

    // 清理
    if (Star_LastSpellItemAbilityTargetPoint != null) {
      if (typeof jass.RemoveLocation === "function") {
        jass.RemoveLocation(Star_LastSpellItemAbilityTargetPoint);
      }
      Star_LastSpellItemAbilityTargetPoint = null;
    }
  }
}

/**
 * 初始化物品技能监听
 * 需要在地图初始化时调用
 */
export function SU_InititemAbilityListener(): void {
  // 创建触发器
  su_ItemAbilityTrig = typeof jass.CreateTrigger === "function" ? jass.CreateTrigger() : null;
  su_ItemAbilityTrig2 = typeof jass.CreateTrigger === "function" ? jass.CreateTrigger() : null;

  if (su_ItemAbilityTrig == null || su_ItemAbilityTrig2 == null) return;

  // 注册技能施放事件
  if (typeof jass.TriggerRegisterAnyUnitEventBJ === "function") {
    jass.TriggerRegisterAnyUnitEventBJ(su_ItemAbilityTrig, jass.EVENT_PLAYER_UNIT_SPELL_EFFECT);
  }
  // 注册物品使用事件
  if (typeof jass.TriggerRegisterAnyUnitEventBJ === "function") {
    jass.TriggerRegisterAnyUnitEventBJ(su_ItemAbilityTrig2, jass.EVENT_PLAYER_UNIT_USE_ITEM);
  }

  // 添加动作
  if (typeof jass.TriggerAddAction === "function") {
    jass.TriggerAddAction(su_ItemAbilityTrig, SU_InititemAbilityListener_1);
    jass.TriggerAddAction(su_ItemAbilityTrig2, SU_InititemAbilityListener_2);
  }
}

/**
 * 获取最后使用的物品技能ID
 */
export function SU_GetLastSpellItemAbility(): number {
  return Star_LastSpellItemAbility;
}

/**
 * 获取最后使用的物品技能目标X坐标
 */
export function SU_GetLastSpellItemAbilityTargetX(): number {
  return Star_LastSpellItemAbilityTargetX;
}

/**
 * 获取最后使用的物品技能目标Y坐标
 */
export function SU_GetLastSpellItemAbilityTargetY(): number {
  return Star_LastSpellItemAbilityTargetY;
}

/**
 * 获取最后使用的物品技能目标点
 */
export function SU_GetLastSpellItemAbilityTargetPoint(): any {
  return Star_LastSpellItemAbilityTargetPoint;
}

export {};
