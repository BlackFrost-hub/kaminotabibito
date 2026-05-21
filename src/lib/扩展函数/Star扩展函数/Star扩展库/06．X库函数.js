/**
 * Star扩展库 - X库函数
 *
 * 来源于 X.j，提供地形检测、坐标工具、单位移动控制等功能。
 *
 * 公开接口：
 *   X_IsTerrainWalkable(x, y)     - 检测坐标是否可通行
 *   X_GetAbleX()                  - 获取最近可通行X坐标（需先调用IsTerrainWalkable）
 *   X_GetAbleY()                  - 获取最近可通行Y坐标（需先调用IsTerrainWalkable）
 *   X_IsTerrainDeepWater(x, y)    - 深水检测
 *   X_IsTerrainShallowWater(x, y) - 浅水检测
 *   X_IsTerrainLand(x, y)         - 陆地检测
 *   X_IsTerrainPlatform(x, y)     - 平台检测
 *   X_SetUnitMovable(u, b)        - 设置单位是否可移动
 *   X_GDBC(x1, y1, x2, y2)       - 坐标间距离
 *   X_GAFC(x1, y1, x2, y2)       - 坐标间角度
 *   X_R2I2(r)                     - 实数转整数（四舍五入）
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
const { safeEnumItemsInRect } = require("系统.00．核心系统.07．联机安全工具");
const BJ_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;
const MAX_RANGE = 10;
const DUMMY_ITEM_ID = (function () {
    const b1 = string.byte("wolg", 1);
    const b2 = string.byte("wolg", 2);
    const b3 = string.byte("wolg", 3);
    const b4 = string.byte("wolg", 4);
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
})();
const PATHING_TYPE_WALKABILITY = jass["PATHING_TYPE_WALKABILITY"];
const PATHING_TYPE_FLOATABILITY = jass["PATHING_TYPE_FLOATABILITY"];
const PATHING_TYPE_BUILDABILITY = jass["PATHING_TYPE_BUILDABILITY"];
let dummyItem = null;
let searchRect = null;
let lastAbleX = 0;
let lastAbleY = 0;
const hiddenItems = [];
function initXLib() {
    if (dummyItem !== null)
        return;
    searchRect = jass.Rect(0, 0, 128, 128);
    if (DUMMY_ITEM_ID !== 0) {
        dummyItem = jass.CreateItem(DUMMY_ITEM_ID, 0, 0);
        if (dummyItem) {
            jass.SetItemVisible(dummyItem, false);
        }
    }
}
/**
 * 隐藏区域内的可见物品，防止物品间碰撞导致检测bug
 */
function hideItemsInRect() {
    if (!searchRect)
        return;
    hiddenItems.length = 0;
    safeEnumItemsInRect(searchRect, null, () => {
        const it = jass.GetEnumItem();
        if (it && jass.IsItemVisible(it)) {
            hiddenItems.push(it);
            jass.SetItemVisible(it, false);
        }
    });
}
/**
 * 恢复之前隐藏的物品
 */
function restoreHiddenItems() {
    for (let i = hiddenItems.length - 1; i >= 0; i--) {
        const it = hiddenItems[i];
        if (it) {
            jass.SetItemVisible(it, true);
        }
        hiddenItems[i] = null;
    }
    hiddenItems.length = 0;
}
/**
 * 检测坐标是否可通行（物品法 + IsTerrainPathable双重检测）
 * 调用后可通过 X_GetAbleX/Y 获取最近可通行坐标
 * @param x X坐标
 * @param y Y坐标
 * @returns 是否可通行
 */
export function X_IsTerrainWalkable(xOrSelf, xOrY, yMaybe) {
    let x = xOrSelf;
    let y = xOrY;
    // 兼容两种 Lua 调用形态：
    // 1. X_IsTerrainWalkable(x, y)
    // 2. X_IsTerrainWalkable(nil, x, y)
    if (y == null && yMaybe == null && typeof xOrSelf === "number" && typeof xOrY === "number") {
        x = xOrSelf;
        y = xOrY;
    }
    if (yMaybe != null) {
        x = xOrY;
        y = yMaybe;
    }
    initXLib();
    if (!dummyItem || !searchRect) {
        return !jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY);
    }
    jass.MoveRectTo(searchRect, x, y);
    hideItemsInRect();
    jass.SetItemPosition(dummyItem, x, y);
    const itemX = jass.GetItemX(dummyItem);
    const itemY = jass.GetItemY(dummyItem);
    lastAbleX = itemX;
    lastAbleY = itemY;
    jass.SetItemVisible(dummyItem, false);
    restoreHiddenItems();
    const dx = itemX - x;
    const dy = itemY - y;
    const distOk = dx * dx + dy * dy <= MAX_RANGE * MAX_RANGE;
    return distOk && !jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY);
}
/**
 * 兼容当前仓库调用面：单位地形判定先退化为坐标地形判定。
 */
export function X_IsUnitTerrainWalkable(unit, x, y) {
    return X_IsTerrainWalkable(x, y);
}
/**
 * 获取最近可通行X坐标（需先调用X_IsTerrainWalkable）
 */
export function X_GetAbleX() {
    return lastAbleX;
}
/**
 * 获取最近可通行Y坐标（需先调用X_IsTerrainWalkable）
 */
export function X_GetAbleY() {
    return lastAbleY;
}
/**
 * 深水检测
 */
export function X_IsTerrainDeepWater(x, y) {
    return !jass.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
        && jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY);
}
/**
 * 浅水检测
 */
export function X_IsTerrainShallowWater(x, y) {
    return !jass.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
        && !jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
        && jass.IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY);
}
/**
 * 陆地检测
 */
export function X_IsTerrainLand(x, y) {
    return jass.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY);
}
/**
 * 平台检测
 */
export function X_IsTerrainPlatform(x, y) {
    return !jass.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
        && !jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
        && !jass.IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY);
}
/**
 * 设置单位是否可以移动
 * 通过设置转向窗口(PropWindow)实现：0=不可移动，默认值=可移动
 * @param u 目标单位
 * @param b 是否可移动
 */
export function X_SetUnitMovable(u, b) {
    if (!u)
        return;
    if (b) {
        const defaultWindow = jass.GetUnitDefaultPropWindow(u);
        jass.SetUnitPropWindow(u, defaultWindow);
    }
    else {
        jass.SetUnitPropWindow(u, 0);
    }
}
/**
 * 坐标间距离
 */
function 归位四坐标参数(thisArg, x1OrY1, y1OrX2, x2OrY2, y2Maybe) {
    let x1 = x1OrY1;
    let y1 = y1OrX2;
    let x2 = x2OrY2;
    let y2 = y2Maybe;
    // 兼容被全局桥接后由 JASS 直接调用时的 self 参数错位：X_GDBC(x1, y1, x2, y2) / X_GAFC(x1, y1, x2, y2)
    if (y2 == null && typeof thisArg === "number" && typeof x1OrY1 === "number" && typeof y1OrX2 === "number" && typeof x2OrY2 === "number") {
        x1 = thisArg;
        y1 = x1OrY1;
        x2 = y1OrX2;
        y2 = x2OrY2;
    }
    if (x1 == null || x1 === false || x1 === "")
        x1 = 0;
    if (y1 == null || y1 === false || y1 === "")
        y1 = 0;
    if (x2 == null || x2 === false || x2 === "")
        x2 = 0;
    if (y2 == null || y2 === false || y2 === "")
        y2 = 0;
    return { x1, y1, x2, y2 };
}
export function X_GDBC(x1OrY1, y1OrX2, x2OrY2, y2Maybe) {
    const { x1, y1, x2, y2 } = 归位四坐标参数(this, x1OrY1, y1OrX2, x2OrY2, y2Maybe);
    const dx = x2 - x1;
    const dy = y2 - y1;
    return jass.SquareRoot(dx * dx + dy * dy);
}
/**
 * 坐标间角度（度数）
 */
export function X_GAFC(x1OrY1, y1OrX2, x2OrY2, y2Maybe) {
    const { x1, y1, x2, y2 } = 归位四坐标参数(this, x1OrY1, y1OrX2, x2OrY2, y2Maybe);
    return jass.Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG;
}
/**
 * 实数转整数（四舍五入）
 */
export function X_R2I2(r) {
    let value = r;
    // 兼容被全局桥接后由 JASS 直接调用时的 self 参数错位：X_R2I2(r)
    if ((value == null || value === false || value === "") && typeof this === "number") {
        value = this;
    }
    if (value == null || value === false || value === "") {
        value = 0;
    }
    return jass.R2I(value + 0.5);
}
