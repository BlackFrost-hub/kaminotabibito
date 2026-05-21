// ========== 虚拟分区：Buff 表数据源 ==========
const debuffMod = require("系统.05．Buff系统.01．Buff表");
const debuffBuffs = debuffMod.buffs;
const DOT_BUFF_ROWS = {
    antiHeal: "D001",
    burn: "D002",
    poison: "D003",
    trollCurse: "D004",
};
// ========== 虚拟分区：效果/ID 映射 ==========
/** DOT 每跳 `AddSpecialEffectTarget` 的模型路径，与同 ID 行的 `effect` 一致 */
export function dotEffectModelFromBuffRow(rowId) {
    const row = debuffBuffs[rowId];
    return row != null && typeof row.effect === "string" && row.effect !== "" ? row.effect : "";
}
/** 与 Buff表 buffID 对齐，供 UI/其它系统引用 */
export const DOT_DEBUFF_IDS = {
    antiHeal: debuffBuffs[DOT_BUFF_ROWS.antiHeal]?.buffID ?? DOT_BUFF_ROWS.antiHeal,
    burn: debuffBuffs[DOT_BUFF_ROWS.burn]?.buffID ?? DOT_BUFF_ROWS.burn,
    poison: debuffBuffs[DOT_BUFF_ROWS.poison]?.buffID ?? DOT_BUFF_ROWS.poison,
    trollCurse: debuffBuffs[DOT_BUFF_ROWS.trollCurse]?.buffID ?? DOT_BUFF_ROWS.trollCurse,
};
export function getDotBuffRow(typeId) {
    return DOT_BUFF_ROWS[typeId];
}
