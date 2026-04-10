/**
 * 装备移速（movespeed2）：不叠加，取当前装备中 movespeed2 最大值，通过 ExecuteFunc("movespeed2") 调用
 * SGSS_SetState(unit, 9, value)；减速需传负数，故先减掉旧值再加新值。
 */
const jass = require("jass.common");
const itemsData = require("系统.02．物品系统.01．装备数据").default;
const { fourCCToString } = require("系统.00．核心系统.01．封装函数");
/** 单位已应用的 movespeed2 值（仅用于 SGSS 先减后加） */
const applied = {};
function getUnitKey(unit) {
    // Lua 环境 tostring(handle) 是稳定且唯一的（如 "unit:0x..."）
    return tostring(unit);
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
    if (typeof jass.UnitItemInSlot !== "function")
        return { value: 0, name: "", count: 0 };
    if (typeof jass.GetItemTypeId !== "function")
        return { value: 0, name: "", count: 0 };
    for (let slot = 0; slot <= 5; slot++) {
        const item = jass.UnitItemInSlot(unit, slot);
        if (!item)
            continue;
        if (ignoreItem && item === ignoreItem)
            continue;
        const tid = jass.GetItemTypeId(item);
        const idStr = fourCCToString(tid);
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
    jass.udg_TempUnit[1] = unit;
    if (oldSpeed !== 0) {
        jass.udg_TempReal[1] = -oldSpeed;
        jass.ExecuteFunc("movespeed2");
    }
    if (newSpeed !== 0) {
        jass.udg_TempReal[1] = newSpeed;
        jass.ExecuteFunc("movespeed2");
    }
    applied[key] = newSpeed;
}
function onItemChange() {
    const unit = jass.GetManipulatingUnit();
    if (!unit)
        return;
    if (typeof jass.IsUnitType === "function" && jass.IsUnitType(unit, jass.UNIT_TYPE_SUMMONED))
        return;
    if (typeof jass.IsUnitIllusionBJ === "function" && jass.IsUnitIllusionBJ(unit))
        return;
    const eventId = jass.GetTriggerEventId();
    const isPickup = eventId === (jass.EVENT_PLAYER_UNIT_PICKUP_ITEM ?? 38);
    const isDrop = eventId === (jass.EVENT_PLAYER_UNIT_DROP_ITEM ?? 39);
    const manipulated = typeof jass.GetManipulatedItem === "function" ? jass.GetManipulatedItem() : undefined;
    const newSpeed = isDrop ? getMaxMovespeed2(unit, manipulated) : getMaxMovespeed2(unit);
    const key = getUnitKey(unit);
    const cur = applied[key] != null ? applied[key] : 0;
    if (isPickup && newSpeed <= cur)
        return;
    applyMovespeed2(unit, newSpeed);
}
function init() {
    const trig = jass.CreateTrigger();
    const pickup = jass.EVENT_PLAYER_UNIT_PICKUP_ITEM ?? 38;
    const drop = jass.EVENT_PLAYER_UNIT_DROP_ITEM ?? 39;
    for (let i = 0; i <= 7; i++) {
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), pickup, undefined);
        jass.TriggerRegisterPlayerUnitEvent(trig, jass.Player(i), drop, undefined);
    }
    const p13 = jass.Player?.(13);
    if (p13 != null) {
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, pickup, undefined);
        jass.TriggerRegisterPlayerUnitEvent(trig, p13, drop, undefined);
    }
    jass.TriggerAddAction(trig, onItemChange);
}
init();
/** 供装备系统在「当前装备加成」里显示移速：返回当前生效的移速值及提供该移速的装备名 */
export { getMaxMovespeed2Info };
