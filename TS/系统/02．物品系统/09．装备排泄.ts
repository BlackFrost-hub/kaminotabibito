/**
 * 装备排泄：物品被破坏时 RemoveItem 并销毁对应触发器。
 * 一物一触发 + 闭包保存 item，回调里不依赖"从事件取句柄"。
 */
const jass = require("jass.common") as Record<string, unknown>;

let _lastCreatedItem: any = undefined;

/** 模拟 JASS GetLastCreatedItem —— 返回最近一次通过 setLastCreatedItem 登记的物品。 */
export function GetLastCreatedItem(): any {
  return _lastCreatedItem;
}

/**
 * 在 CreateItemLoc/CreateItem 后立刻调用，自动：
 *   1. 记录为 lastCreatedItem
 *   2. 注册死亡清理（RemoveItem + DestroyTrigger）
 */
export function setLastCreatedItem(item: any): void {
  _lastCreatedItem = item;
  registerItemForCleanup(item);
}

function registerItemForCleanup(item: any): void {
  if (item == null) return;
  const trig = (jass as any).CreateTrigger();
  if (!trig) return;
  (jass as any).TriggerRegisterDeathEvent(trig, item);
  const capturedItem = item;
  let taHandle: any = undefined;
  const onDeath = (): void => {
    (jass as any).RemoveItem(capturedItem);
    if (taHandle != null) {
      (jass as any).TriggerRemoveAction(trig, taHandle);
    }
    (jass as any).DestroyTrigger(trig);
  };
  taHandle = (jass as any).TriggerAddAction(trig, onDeath);
}

export {};
