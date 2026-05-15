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

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { safeEnumItemsInRect } = require("系统.00．核心系统.07．联机安全工具") as {
  safeEnumItemsInRect: (rect: any, filter: any, action: () => void) => void;
};

const BJ_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;

const MAX_RANGE = 10;
const DUMMY_ITEM_ID = (function () {
  const b1 = (string as any).byte("wolg", 1) as number;
  const b2 = (string as any).byte("wolg", 2) as number;
  const b3 = (string as any).byte("wolg", 3) as number;
  const b4 = (string as any).byte("wolg", 4) as number;
  return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
})();

const PATHING_TYPE_WALKABILITY = jass.ConvertPathingType(0);
const PATHING_TYPE_FLOATABILITY = jass.ConvertPathingType(1);
const PATHING_TYPE_BUILDABILITY = jass.ConvertPathingType(2);

let dummyItem: any = null;
let searchRect: any = null;
let lastAbleX = 0;
let lastAbleY = 0;

const hiddenItems: any[] = [];

function initXLib(): void {
  if (dummyItem !== null) return;

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
function hideItemsInRect(): void {
  if (!searchRect) return;
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
function restoreHiddenItems(): void {
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
export function X_IsTerrainWalkable(x: number, y: number): boolean {
  initXLib();

  if (!dummyItem || !searchRect) {
    return !jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY);
  }

  jass.MoveRectTo(searchRect, x, y);

  hideItemsInRect();

  jass.SetItemPosition(dummyItem, x, y);

  const itemX = jass.GetItemX(dummyItem) as number;
  const itemY = jass.GetItemY(dummyItem) as number;

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
export function X_IsUnitTerrainWalkable(this: void, unit: any, x: number, y: number): boolean {
  return X_IsTerrainWalkable(x, y);
}

/**
 * 获取最近可通行X坐标（需先调用X_IsTerrainWalkable）
 */
export function X_GetAbleX(): number {
  return lastAbleX;
}

/**
 * 获取最近可通行Y坐标（需先调用X_IsTerrainWalkable）
 */
export function X_GetAbleY(): number {
  return lastAbleY;
}

/**
 * 深水检测
 */
export function X_IsTerrainDeepWater(x: number, y: number): boolean {
  return !jass.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
    && jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY);
}

/**
 * 浅水检测
 */
export function X_IsTerrainShallowWater(x: number, y: number): boolean {
  return !jass.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY)
    && !jass.IsTerrainPathable(x, y, PATHING_TYPE_WALKABILITY)
    && jass.IsTerrainPathable(x, y, PATHING_TYPE_BUILDABILITY);
}

/**
 * 陆地检测
 */
export function X_IsTerrainLand(x: number, y: number): boolean {
  return jass.IsTerrainPathable(x, y, PATHING_TYPE_FLOATABILITY);
}

/**
 * 平台检测
 */
export function X_IsTerrainPlatform(x: number, y: number): boolean {
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
export function X_SetUnitMovable(u: any, b: boolean): void {
  if (!u) return;

  if (b) {
    const defaultWindow = jass.GetUnitDefaultPropWindow(u);
    jass.SetUnitPropWindow(u, defaultWindow);
  } else {
    jass.SetUnitPropWindow(u, 0);
  }
}

/**
 * 坐标间距离
 */
export function X_GDBC(x1: number, y1: number, x2: number, y2: number): number {
  const dx = x2 - x1;
  const dy = y2 - y1;
  return jass.SquareRoot(dx * dx + dy * dy);
}

/**
 * 坐标间角度（度数）
 */
export function X_GAFC(x1: number, y1: number, x2: number, y2: number): number {
  return jass.Atan2(y2 - y1, x2 - x1) * BJ_RADTODEG;
}

/**
 * 实数转整数（四舍五入）
 */
export function X_R2I2(r: number): number {
  return jass.R2I(r + 0.5);
}

export {};
