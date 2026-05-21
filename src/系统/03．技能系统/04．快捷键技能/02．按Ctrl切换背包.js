/**
 * 背包切换功能
 *
 * 按Ctrl键切换英雄背包与辅助背包
 */
const jass = require("jass.common");
const japi = require("jass.japi");
const g = require("jass.globals");
const { YDUserDataGet } = require("lib.扩展函数.YDWE函数.index");
const { UnitItemInSlotBJ } = require("lib.扩展函数.BJ函数.index");
const { UnitRemoveItemSwapped } = require("lib.扩展函数.BJ函数.index");
const { DzTriggerRegisterKeyEventTrg } = require("lib.扩展函数.KK扩展API.index");
/** 触发器 */
let switchBagTrigger = null;
/**
 * 交换两个单位的物品
 *
 * @param unit1 单位1
 * @param unit2 单位2
 * @param slot 物品栏位置（1-6）
 */
function swapItems(unit1, unit2, slot) {
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
        jass.UnitAddItem(unit2, item1);
    }
    if (item2 != null) {
        jass.UnitAddItem(unit1, item2);
    }
}
/**
 * 按Ctrl切换背包事件处理
 */
function onCtrlSwitchBag() {
    const player = japi.DzGetTriggerKeyPlayer();
    // 获取玩家的英雄
    const hero = YDUserDataGet("player", player, "英雄", "unit");
    if (hero == null)
        return;
    // 检查英雄是否被当前玩家选中
    if (!jass.IsUnitSelected(hero, player))
        return;
    // 获取切换背包辅助单位
    const helperUnit = YDUserDataGet("player", jass.GetOwningPlayer(hero), "切换背包辅助", "unit");
    if (helperUnit == null)
        return;
    // 设置装备限制开关为true（禁止触发装备效果）
    if (g.udg_Itmeboolean != null) {
        g.udg_Itmeboolean = true;
    }
    // 遍历6个物品栏，交换物品
    for (let slot = 1; slot <= 6; slot++) {
        swapItems(hero, helperUnit, slot);
    }
    // 设置装备限制开关为false（恢复装备效果）
    if (g.udg_Itmeboolean != null) {
        g.udg_Itmeboolean = false;
    }
}
/**
 * 初始化背包切换功能
 */
export function initSwitchBag() {
    if (switchBagTrigger != null)
        return;
    switchBagTrigger = jass.CreateTrigger();
    DzTriggerRegisterKeyEventTrg(switchBagTrigger, 0, 17);
    jass.TriggerAddAction(switchBagTrigger, onCtrlSwitchBag);
}
