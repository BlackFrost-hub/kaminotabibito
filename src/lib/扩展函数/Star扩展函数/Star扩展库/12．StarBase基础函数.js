/**
 * Star扩展库 - StarBase基础函数
 *
 * 来源于 StarBase.j，提供基础工具函数。
 *
 * 公开接口：
 *   getStarBaseHT()              - 获取统一回调哈希表
 *   Star_CoordinateX(x)          - 修正X坐标到地图边界内
 *   Star_CoordinateY(y)          - 修正Y坐标到地图边界内
 *   Star_GetLocZ(x, y)           - 获取坐标Z轴高度
 *   GetRectByHandle(i)           - 整数地址转矩形
 */
const jass = require("jass.common");
const jglobals = require("jass.globals");
// 临时位置点（用于获取Z轴高度）
let Star_Location = null;
// 临时哈希表（用于句柄转换）
let tempHT = null;
/**
 * 获取StarBaseHT（统一回调哈希表）
 */
export function getStarBaseHT() {
    return jglobals && jglobals.StarBaseHT ? jglobals.StarBaseHT : null;
}
/**
 * 修正X坐标到地图边界内
 * @param x X坐标
 * @returns 修正后的X坐标
 */
export function Star_CoordinateX(x) {
    let value = x;
    if ((value == null || value === "" || value === false) && typeof this === "number") {
        value = this;
    }
    if (value == null || value === "" || value === false) {
        value = 0;
    }
    let minX = -10000;
    let maxX = 10000;
    const mapRect = jass.GetWorldBounds();
    if (mapRect) {
        minX = jass.GetRectMinX(mapRect);
        maxX = jass.GetRectMaxX(mapRect);
    }
    if (value < minX)
        return minX;
    if (value > maxX)
        return maxX;
    return value;
}
/**
 * 修正Y坐标到地图边界内
 * @param y Y坐标
 * @returns 修正后的Y坐标
 */
export function Star_CoordinateY(y) {
    let value = y;
    if ((value == null || value === "" || value === false) && typeof this === "number") {
        value = this;
    }
    if (value == null || value === "" || value === false) {
        value = 0;
    }
    let minY = -10000;
    let maxY = 10000;
    const mapRect = jass.GetWorldBounds();
    if (mapRect) {
        minY = jass.GetRectMinY(mapRect);
        maxY = jass.GetRectMaxY(mapRect);
    }
    if (value < minY)
        return minY;
    if (value > maxY)
        return maxY;
    return value;
}
/**
 * 获取坐标Z轴高度
 * @param x X坐标
 * @param y Y坐标
 * @returns Z轴高度
 */
export function Star_GetLocZ(x, y) {
    if (Star_Location == null) {
        Star_Location = jass.Location(0, 0);
    }
    if (Star_Location == null)
        return 0;
    jass.MoveLocation(Star_Location, x, y);
    return jass.GetLocationZ(Star_Location);
}
/**
 * 整数地址转矩形
 * @param i 整数地址
 * @returns 矩形句柄
 */
export function GetRectByHandle(i) {
    const StarBaseHT = getStarBaseHT();
    if (StarBaseHT == null)
        return null;
    if (tempHT == null) {
        tempHT = StarBaseHT;
    }
    jass.FlushChildHashtable(tempHT, 2);
    jass.SaveFogStateHandle(tempHT, 2, 1, jass.ConvertFogState(i));
    return jass.LoadRectHandle(tempHT, 2, 1);
}
