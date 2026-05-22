/** @noSelfInFile */
/**
 * 物品相关BJ函数
 *
 * 对应 Blizzard.j 中的物品操作函数
 */

const jass = require("jass.common") as any;

//=============================================================================
// 全局变量
//=============================================================================

/**
 * 最后移除的物品句柄
 * 对应JASS: item bj_lastRemovedItem = null
 */
export let bj_lastRemovedItem: any = null;

//=============================================================================
// 物品操作函数
//=============================================================================

/**
 * 移除单位物品并记录到 bj_lastRemovedItem
 * 对应JASS: UnitRemoveItemSwapped
 *
 * @param whichItem 要移除的物品
 * @param whichHero 物品所属单位
 */
export function UnitRemoveItemSwapped(whichItem: any, whichHero: any): void {
  if (whichItem == null || whichHero == null) return;

  bj_lastRemovedItem = whichItem;
  jass.UnitRemoveItem(whichHero, whichItem);
}

export {};
