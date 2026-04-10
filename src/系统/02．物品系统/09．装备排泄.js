/**
 * 装备排泄：物品被破坏时 RemoveItem 并销毁对应触发器。
 * 一物一触发 + 闭包保存 item，回调里不依赖"从事件取句柄"。
 */
const jass = require("jass.common");
let _lastCreatedItem = undefined;
/** 模拟 JASS GetLastCreatedItem —— 返回最近一次通过 setLastCreatedItem 登记的物品。 */
export function GetLastCreatedItem() {
    return _lastCreatedItem;
}
/**
 * 在 CreateItemLoc/CreateItem 后立刻调用，自动：
 *   1. 记录为 lastCreatedItem
 *   2. 注册死亡清理（RemoveItem + DestroyTrigger）
 */
export function setLastCreatedItem(item) {
    _lastCreatedItem = item;
    registerItemForCleanup(item);
}
function registerItemForCleanup(item) {
    if (item == null)
        return;
    if (typeof jass.CreateTrigger !== "function")
        return;
    const trig = jass.CreateTrigger();
    if (!trig)
        return;
    if (typeof jass.TriggerRegisterDeathEvent !== "function")
        return;
    jass.TriggerRegisterDeathEvent(trig, item);
    const capturedItem = item;
    let taHandle = undefined;
    const onDeath = () => {
        if (typeof jass.RemoveItem === "function")
            jass.RemoveItem(capturedItem);
        if (taHandle != null && typeof jass.TriggerRemoveAction === "function") {
            jass.TriggerRemoveAction(trig, taHandle);
        }
        if (typeof jass.DestroyTrigger === "function")
            jass.DestroyTrigger(trig);
    };
    if (typeof jass.TriggerAddAction === "function") {
        taHandle = jass.TriggerAddAction(trig, onDeath);
    }
}
