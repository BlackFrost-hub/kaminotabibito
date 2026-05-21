/** @noSelfInFile */
/**
 * 装备移速（movespeed2）：不叠加，取当前装备中 movespeed2 最大值
 * 直接调用 TS 端 SGSS_SetState(unit, 9, value)；减速需传负数，故先减掉旧值再加新值。
 */
const jass = require("jass.common");
const GetItemTypeId = jass.GetItemTypeId;
const { onItemPickup, onItemDrop } = require("系统.00．核心系统.01．事件中心.04．物品事件中心");
const itemsData = require("系统.02．物品系统.01．装备数据").default;
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS");
const { IsUnitIllusionBJ } = require("lib.扩展函数.BJ函数.08．单位BJ扩展");
const R2I = jass.R2I;
const stringChar = string.char;
/** 单位已应用的 movespeed2 值（仅用于 SGSS 先减后加） */
const applied = {};
const EQUIP_SPEED_EVENT_PLAYER_IDS = [0, 1, 2, 3, 4, 5, 6, 7, 13];
function getUnitKey(unit) {
    // Lua 环境 tostring(handle) 是稳定且唯一的（如 "unit:0x..."）
    return tostring(unit);
}
function fourCCToStringCompat(four) {
    const c1 = stringChar(four % 256);
    const c2 = stringChar(R2I(four / 256) % 256);
    const c3 = stringChar(R2I(four / 65536) % 256);
    const c4 = stringChar(R2I(four / 16777216) % 256);
    return `${String(c4)}${String(c3)}${String(c2)}${String(c1)}`;
}
function getMaxMovespeed2(unit, ignoreItem) {
    const info = getMaxMovespeed2Info(unit, ignoreItem);
    return info.value;
}
/** 返回当前生效的移速值、提供该移速的装备名、以及带移速的装备件数（≥2 时才提示“只生效某装备”） */
function getMaxMovespeed2Info(unit, ignoreItem) {
    let max = 0;
    let name = "";
    let count = 0;
    for (let slot = 0; slot <= 5; slot++) {
        const item = jass.UnitItemInSlot(unit, slot);
        if (!item)
            continue;
        if (ignoreItem && item === ignoreItem)
            continue;
        const tid = GetItemTypeId(item);
        const idStr = fourCCToStringCompat(tid);
        const entry = itemsData[idStr];
        const typ = entry?.type;
        if (typ === "任务" || typ === "药剂" || typ === "食品")
            continue;
        const v = entry?.movespeed2;
        if (typeof v === "number" && v > 0)
            count++;
        if (typeof v === "number" && v > max) {
            max = v;
            name = (entry?.name != null ? String(entry.name).trim() : "") || "未知";
        }
    }
    return { value: max, name, count };
}
function applyMovespeed2(unit, newSpeed) {
    const key = getUnitKey(unit);
    const oldSpeed = applied[key] != null ? applied[key] : 0;
    if (newSpeed === oldSpeed)
        return;
    if (oldSpeed !== 0) {
        SGSS_SetState(unit, 9, -oldSpeed);
    }
    if (newSpeed !== 0) {
        SGSS_SetState(unit, 9, newSpeed);
    }
    applied[key] = newSpeed;
}
function onItemChange(unit, item, isPickup) {
    if (unit === null || unit === 0)
        return;
    if (jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED))
        return;
    if (IsUnitIllusionBJ(unit))
        return;
    const isDrop = !isPickup;
    const newSpeed = isDrop ? getMaxMovespeed2(unit, item) : getMaxMovespeed2(unit);
    const key = getUnitKey(unit);
    const cur = applied[key] != null ? applied[key] : 0;
    if (isPickup && newSpeed <= cur)
        return;
    applyMovespeed2(unit, newSpeed);
}
function init() {
    // 使用物品事件中心注册，减少触发器数量
    onItemPickup((unit, item) => {
        onItemChange(unit, item, true);
    });
    onItemDrop((unit, item) => {
        onItemChange(unit, item, false);
    });
}
init();
/** 供装备系统在「当前装备加成」里显示移速：返回当前生效的移速值及提供该移速的装备名 */
export { getMaxMovespeed2Info };
