"use strict";
/** @noSelfInFile */
/**
 * 装备重伤（wound）：不叠加，取当前装备中 wound 最大值
 * - 英雄单位：存储到玩家级 YDUserData
 * - 非英雄单位：存储到单位级 YDUserData
 */
const jass = require("jass.common");
const GetItemTypeId = jass.GetItemTypeId;
const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心");
const itemsData = require("系统.02．物品系统.01．装备数据").default;
const { fourCCToString } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { YDUserDataSetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版");
const { IsUnitIllusionBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展");
const ATTR_重伤 = "重伤";
function 写入YD用户数据(tableType, tableKey, attr, valueType, value) {
    YDUserDataSetSafe(tableType, tableKey, attr, valueType, value);
}
function getMaxWound(unit, ignoreItem) {
    let max = 0;
    for (let slot = 0; slot <= 5; slot++) {
        const item = jass.UnitItemInSlot(unit, slot);
        if (!item)
            continue;
        if (ignoreItem && item === ignoreItem)
            continue;
        const tid = GetItemTypeId(item);
        const idStr = fourCCToString(tid);
        const entry = itemsData[idStr];
        const typ = entry?.type;
        if (typ === "任务" || typ === "药剂" || typ === "食品")
            continue;
        const v = entry?.wound;
        if (typeof v === "number" && v > max) {
            max = v;
        }
    }
    return max;
}
function applyWound(unit, newValue) {
    const owner = jass.GetOwningPlayer(unit);
    const playerId = jass.GetPlayerId(owner);
    if (playerId < 0 || playerId > 3)
        return;
    // 英雄：存储到玩家；非英雄：存储到单位
    if (jass.IsUnitType(unit, jass.UNIT_TYPE_HERO)) {
        写入YD用户数据("player", owner, ATTR_重伤, "real", newValue);
    }
    else {
        写入YD用户数据("unit", unit, ATTR_重伤, "real", newValue);
    }
}
function onItemChange(unit, item, isPickup) {
    if (unit === null || unit === 0)
        return;
    if (jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED))
        return;
    if (IsUnitIllusionBJ(unit))
        return;
    const isDrop = !isPickup;
    const newWound = isDrop ? getMaxWound(unit, item) : getMaxWound(unit);
    applyWound(unit, newWound);
}
function init() {
    onItemPickup((unit, item) => {
        onItemChange(unit, item, true);
    });
    onItemDrop((unit, item) => {
        onItemChange(unit, item, false);
    });
}
init();
