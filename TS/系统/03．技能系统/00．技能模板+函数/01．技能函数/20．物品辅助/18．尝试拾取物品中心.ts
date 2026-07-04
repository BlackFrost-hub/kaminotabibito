/** @noSelfInFile */

const jass = require("jass.common") as any;
const itemStack = require("lib.扩展函数.物品相关函数.物品叠加函数") as any;

const CreateTrigger = jass.CreateTrigger as () => any;
const TriggerAddAction = jass.TriggerAddAction as (trigger: any, action: () => void) => any;
const StarItem_GetTriggerUnit = itemStack.StarItem_GetTriggerUnit as () => any;
const StarItem_GetTriggerItem = itemStack.StarItem_GetTriggerItem as () => any;
const StarItem_TryPickUpItem = itemStack.StarItem_TryPickUpItem as (trigger: any) => void;

export type 尝试拾取物品回调 = (this: void, unit: any, item: any) => void;

const 尝试拾取物品回调列表: Array<尝试拾取物品回调 | undefined> = [];
let 已初始化尝试拾取物品中心 = false;

function 分发尝试拾取物品(this: void): void {
  const unit = StarItem_GetTriggerUnit();
  const item = StarItem_GetTriggerItem();
  if (unit == null || unit === 0 || item == null || item === 0) return;

  for (let i = 0; i < 尝试拾取物品回调列表.length; i++) {
    const callback = 尝试拾取物品回调列表[i];
    if (callback == null) continue;
    callback(unit, item);
  }
}

function 初始化尝试拾取物品中心(this: void): void {
  if (已初始化尝试拾取物品中心) return;
  已初始化尝试拾取物品中心 = true;

  const trigger = CreateTrigger();
  TriggerAddAction(trigger, 分发尝试拾取物品);
  StarItem_TryPickUpItem(trigger);
}

export function onTryPickupItem(this: void, callback: 尝试拾取物品回调): number {
  初始化尝试拾取物品中心();
  尝试拾取物品回调列表.push(callback);
  return 尝试拾取物品回调列表.length - 1;
}

export function offTryPickupItem(this: void, id: number): void {
  if (id < 0 || id >= 尝试拾取物品回调列表.length) return;
  尝试拾取物品回调列表[id] = undefined;
}
