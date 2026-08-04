/** @noSelfInFile */

/**
 * 背包切换功能
 *
 * 按Ctrl键切换英雄背包与辅助背包
 */

const jass = require("jass.common") as any;
const g = require("jass.globals") as { [key: string]: any };
const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { UnitItemInSlotBJ } = require("lib.扩展函数.BJ函数.index") as {
  UnitItemInSlotBJ: (this: void, whichUnit: any, itemSlot: number) => any;
};
const { UnitRemoveItemSwapped } = require("lib.扩展函数.BJ函数.index") as {
  UnitRemoveItemSwapped: (this: void, whichItem: any, whichHero: any) => void;
};
const { registerSyncHardwareKey } = require("lib.扩展函数.封装函数.04．硬件输入.08．同步硬件输入中心") as {
  registerSyncHardwareKey: (
    this: void,
    key: number | string,
    status: number,
    callback: (this: void, event: { player: any; key: number; status: number }) => void
  ) => any;
};
const { KEY_STATE } = require("lib.扩展函数.封装函数.04．硬件输入.01．常量定义") as {
  KEY_STATE: { UP: number };
};
const DzGetTriggerKeyPlayer = (require("jass.japi") as any).DzGetTriggerKeyPlayer as (this: void) => any;
const { beginEquipItemMessageSilence, endEquipItemMessageSilence } = require("系统.02．物品系统.11．装备系统") as {
  beginEquipItemMessageSilence: (this: void) => void;
  endEquipItemMessageSilence: (this: void) => void;
};
const UnitAddItem = jass.UnitAddItem as (this: void, unit: any, item: any) => boolean;
const IsUnitSelected = jass.IsUnitSelected as (this: void, unit: any, player: any) => boolean;
const GetOwningPlayer = jass.GetOwningPlayer as (this: void, unit: any) => any;

interface 同步键盘事件 {
  player: any;
  key: number;
  status: number;
}

const Ctrl键码 = 17;

/** 触发器 */
let switchBagTrigger: any = null;

/**
 * 交换两个单位的物品
 *
 * @param unit1 单位1
 * @param unit2 单位2
 * @param slot 物品栏位置（1-6）
 */
function swapItems(this: void, unit1: any, unit2: any, slot: number): void {
  // 获取单位1的物品
  const item1 = UnitItemInSlotBJ(unit1, slot);
  // 获取单位2的物品
  const item2 = UnitItemInSlotBJ(unit2, slot);

  // 移除物品
  if (item1 != null) {
    UnitRemoveItemSwapped(item1, unit1);
  }
  if (item2 != null) {
    UnitRemoveItemSwapped(item2, unit2);
  }

  // 交换添加
  if (item1 != null) {
    UnitAddItem(unit2, item1);
  }
  if (item2 != null) {
    UnitAddItem(unit1, item2);
  }
}

/**
 * 按Ctrl切换背包事件处理
 */
function onCtrlSwitchBag(this: void, event: 同步键盘事件): void {
  const player = event.player || DzGetTriggerKeyPlayer();
  if (player == null || player === 0) {
    return;
  }

  // 获取玩家的英雄
  const hero = YDUserDataGetSafe("player", player, "英雄", "unit");
  if (hero == null || hero === 0) {
    return;
  }

  // 检查英雄是否被当前玩家选中
  const isHeroSelected = IsUnitSelected(hero, player);
  if (!isHeroSelected) {
    return;
  }

  // 获取切换背包辅助单位
  const heroOwner = GetOwningPlayer(hero);
  const helperUnit = YDUserDataGetSafe("player", heroOwner, "切换背包辅助", "unit");
  if (helperUnit == null || helperUnit === 0) {
    return;
  }

  // 设置装备限制开关为true（禁止触发装备效果）
  if (g.udg_Itmeboolean != null) {
    g.udg_Itmeboolean = true;
  }

  beginEquipItemMessageSilence();
  // 遍历6个物品栏，交换物品
  for (let slot = 1; slot <= 6; slot++) {
    swapItems(hero, helperUnit, slot);
  }
  endEquipItemMessageSilence();

  // 设置装备限制开关为false（恢复装备效果）
  if (g.udg_Itmeboolean != null) {
    g.udg_Itmeboolean = false;
  }
}

/**
 * 初始化背包切换功能
 */
export function initSwitchBag(this: void): void {
  if (switchBagTrigger != null) return;

  switchBagTrigger = registerSyncHardwareKey(Ctrl键码, KEY_STATE.UP, onCtrlSwitchBag);
}

export {};
