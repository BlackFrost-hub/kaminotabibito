// 装备限制.ts - 玩家1-4英雄：按 type 仅一件、onlyone、双手与主/副互斥；多出的 UnitRemoveItem 丢脚下
const jass = require("jass.common");
const GetItemTypeId = jass.GetItemTypeId;
const UnitItemInSlot = jass.UnitItemInSlot;
const Player = jass.Player;
const GetOwningPlayer = jass.GetOwningPlayer;
const UnitRemoveItem = jass.UnitRemoveItem;
const DisplayTimedTextToPlayer = jass.DisplayTimedTextToPlayer;
const { onItemPickup } = require("系统.00．核心系统.01．事件中心.04．物品事件中心");
const { isHeroUnit, isSpecialUnit } = require("lib.扩展函数.封装函数.01．通用工具.index");
const { getItemDataEntryByTypeId } = require("lib.扩展函数.物品相关函数.index");
/** 与 `11．装备系统.ts` 相同：`require("jass.globals")` 得到 `g`，GUI 变量一律 `g.udg_Xxx`（如 `g.udg_TempIsAdd`、`g.udg_TempHp`） */
const g = require("jass.globals");
/** 地图 Jass：`set udg_Itmeboolean = true` → 此处 `g.udg_Itmeboolean`；为 true/1 时不做装备限制 */
function isEquipLimitDisabledByJass() {
    const v = g.udg_Itmeboolean;
    return v === true || v === 1;
}
/** 与装备系统共用：装备限制 UnitRemoveItem 前设为 true，装备系统 DROP 时跳过扣属性 */
export const equipShared = { skipNextDrop: false };
const EQUIP_LIMIT_EVENT_PLAYER_IDS = [0, 1, 2, 3];
const ONE_PER_SLOT = ["主武器", "副武器", "衣服", "鞋子", "裤子", "头盔", "灵魂"];
const TWO_HANDED = "双手武器";
const CONFLICT_WITH_TWO_HANDED = ["主武器", "副武器"];
const PREFIX = "|cffffff00『系统提示』：|r";
const COLOR_TYPE = "|cff00ff00"; // 类型名 绿
const COLOR_NAME = "|cff00bfff"; // 物品名 蓝
const COLOR_ERR = "|cffff0000"; // 错误/强调 红
function getEntry(itemTypeId) {
    return getItemDataEntryByTypeId(itemTypeId);
}
function safeGetItemTypeId(it) {
    const a = GetItemTypeId(it);
    if (typeof a === "number")
        return a;
    return undefined;
}
function safeUnitItemInSlot(unit, slot) {
    const a = UnitItemInSlot(unit, slot);
    if (a)
        return a;
    return undefined;
}
/** 仅判断：该拾取是否会被装备限制拒绝（true=允许保留，false=会被丢出）。供装备系统在加属性前调用。
 * 事件触发时物品可能尚未入背包，故把“当前拾取的这件”也计入数量。 */
export function equipLimitWouldAllowPickup(unit, item) {
    if (isEquipLimitDisabledByJass())
        return true;
    if (!unit || !item)
        return true;
    const pickedTypeId = safeGetItemTypeId(item);
    if (pickedTypeId == null)
        return true;
    const entry = getEntry(pickedTypeId);
    if (!entry)
        return true;
    const pickedSlotType = entry.type;
    const onlyOne = entry.onlyone === true || entry.onlyone === "TRUE";
    let sameIdCount = 0;
    let sameSlotTypeCount = 0;
    let hasTwoHanded = false;
    let hasMain = false;
    let hasSub = false;
    for (let i = 0; i <= 5; i++) {
        const it = safeUnitItemInSlot(unit, i);
        if (!it || it === item)
            continue;
        const itTypeId = safeGetItemTypeId(it);
        if (itTypeId == null)
            continue;
        const e = getEntry(itTypeId);
        if (!e)
            continue;
        if (itTypeId === pickedTypeId)
            sameIdCount++;
        if (pickedSlotType != null && e.type === pickedSlotType)
            sameSlotTypeCount++;
        if (e.type === TWO_HANDED)
            hasTwoHanded = true;
        if (e.type === "主武器")
            hasMain = true;
        if (e.type === "副武器")
            hasSub = true;
    }
    sameIdCount += 1;
    sameSlotTypeCount += 1;
    if (pickedSlotType === "主武器")
        hasMain = true;
    if (pickedSlotType === "副武器")
        hasSub = true;
    if (pickedSlotType === TWO_HANDED)
        hasTwoHanded = true;
    let msg = "";
    if (pickedSlotType === TWO_HANDED) {
        if (hasMain || hasSub)
            msg = "x";
    }
    else if (pickedSlotType && CONFLICT_WITH_TWO_HANDED.indexOf(pickedSlotType) >= 0) {
        if (hasTwoHanded)
            msg = "x";
    }
    if (msg === "" && onlyOne && sameIdCount > 1)
        msg = "x";
    if (msg === "" && pickedSlotType && ONE_PER_SLOT.indexOf(pickedSlotType) >= 0 && sameSlotTypeCount > 1)
        msg = "x";
    return msg === "";
}
function onPickup(unit, item) {
    if (isEquipLimitDisabledByJass())
        return;
    if (unit === null || unit === 0 || item === null || item === 0)
        return;
    if (!isHeroUnit(unit))
        return;
    if (isSpecialUnit(unit))
        return;
    const pickedTypeId = safeGetItemTypeId(item);
    if (pickedTypeId == null)
        return;
    const entry = getEntry(pickedTypeId);
    if (!entry)
        return;
    const pickedSlotType = entry.type;
    const onlyOne = entry.onlyone === true || entry.onlyone === "TRUE";
    let name = entry.name != null ? String(entry.name) : "";
    const stripColor = (s) => {
        let out = "";
        let i = 0;
        while (i < s.length) {
            if (s.substring(i, i + 2) === "|r") {
                i += 2;
                continue;
            }
            if (s.substring(i, i + 2) === "|c" && i + 10 <= s.length) {
                let hex = true;
                for (let j = i + 2; j < i + 10 && hex; j++)
                    hex = "0123456789aAbBcCdDeEfF".indexOf(s[j]) >= 0;
                if (hex) {
                    i += 10;
                    continue;
                }
            }
            out += s[i];
            i++;
        }
        return out;
    };
    name = stripColor(name).trim();
    const nameColored = COLOR_NAME + "『" + name + "』|r";
    let msg = "";
    let player = Player(0);
    const p = GetOwningPlayer(unit);
    if (p)
        player = p;
    let sameIdCount = 0;
    let sameSlotTypeCount = 0;
    let hasTwoHanded = false;
    let hasMain = false;
    let hasSub = false;
    for (let i = 0; i <= 5; i++) {
        const it = safeUnitItemInSlot(unit, i);
        if (!it)
            continue;
        const itTypeId = safeGetItemTypeId(it);
        if (itTypeId == null)
            continue;
        const e = getEntry(itTypeId);
        if (!e)
            continue;
        if (itTypeId === pickedTypeId)
            sameIdCount++;
        if (pickedSlotType != null && e.type === pickedSlotType)
            sameSlotTypeCount++;
        if (e.type === TWO_HANDED)
            hasTwoHanded = true;
        if (e.type === "主武器")
            hasMain = true;
        if (e.type === "副武器")
            hasSub = true;
    }
    if (pickedSlotType === TWO_HANDED) {
        if (hasMain || hasSub)
            msg = PREFIX + COLOR_ERR + "双手武器与主武器/副武器不能同时装备！|r";
    }
    else if (pickedSlotType && CONFLICT_WITH_TWO_HANDED.indexOf(pickedSlotType) >= 0) {
        if (hasTwoHanded)
            msg = PREFIX + COLOR_ERR + "双手武器与主武器/副武器不能同时装备！|r";
    }
    if (msg === "" && onlyOne && sameIdCount > 1) {
        msg = PREFIX + COLOR_ERR + "该物品" + nameColored + "只能装备一件！|r";
    }
    if (msg === "" && pickedSlotType && ONE_PER_SLOT.indexOf(pickedSlotType) >= 0 && sameSlotTypeCount > 1) {
        msg = PREFIX + COLOR_TYPE + pickedSlotType + "|r物品：" + nameColored + COLOR_ERR + "只能装备一件！|r";
    }
    if (msg === "")
        return;
    equipShared.skipNextDrop = true;
    UnitRemoveItem(unit, item);
    DisplayTimedTextToPlayer(player, 0, 0, 6, msg);
}
function init() {
    // 使用物品事件中心注册，减少触发器数量
    onItemPickup((unit, item) => {
        // 只处理英雄单位
        if (unit !== null && unit !== 0 && isHeroUnit(unit)) {
            onPickup(unit, item);
        }
    });
}
init();
