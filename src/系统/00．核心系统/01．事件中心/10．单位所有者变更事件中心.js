/** @noSelfInFile */
/**
 * 单位所有者变更事件中心
 */
const jass = require("jass.common");
const playerUnitEvent = require("系统.00．核心系统.01．事件中心.01．玩家单位事件");
export const CHANGE_OWNER_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];
const changeOwnerListeners = [];
let initialized = false;
function hasListener(list, callback) {
    for (let i = 0; i < list.length; i++) {
        if (list[i] === callback)
            return true;
    }
    return false;
}
function dispatchChangeOwnerListeners(list, changingUnit) {
    for (let i = 0; i < list.length; i++) {
        const callback = list[i];
        if (callback != null)
            callback(changingUnit);
    }
}
function onChangeOwner() {
    const changingUnit = jass.GetTriggerUnit();
    if (changingUnit == null)
        return;
    dispatchChangeOwnerListeners(changeOwnerListeners, changingUnit);
}
/**
 * 注册单位所有者变更监听。
 * 第一次使用时会自动初始化事件；同一回调不会重复注册。
 */
export function registerChangeOwnerListener(callback) {
    if (typeof callback !== "function")
        return;
    initChangeOwnerEvent();
    if (!hasListener(changeOwnerListeners, callback))
        changeOwnerListeners.push(callback);
}
/**
 * 取消单位所有者变更监听。
 */
export function unregisterChangeOwnerListener(callback) {
    const index = changeOwnerListeners.indexOf(callback);
    if (index >= 0)
        changeOwnerListeners.splice(index, 1);
}
/**
 * 初始化单位所有者变更事件。
 */
export function initChangeOwnerEvent() {
    if (initialized)
        return;
    initialized = true;
    const trig = jass.CreateTrigger();
    playerUnitEvent.registerPlayerUnitEventForPlayerIds(trig, CHANGE_OWNER_PLAYER_IDS, jass.EVENT_PLAYER_UNIT_CHANGE_OWNER);
    jass.TriggerAddAction(trig, onChangeOwner);
}
