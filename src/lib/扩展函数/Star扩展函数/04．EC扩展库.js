const jass = require("jass.common");
const japi = require("jass.japi");
const { YDWETimerDestroyEffect } = require("lib.扩展函数.YDWE函数.00．YDWE函数");
let starLocation = null;
/**
 * 获取坐标点地形高度（对齐 EC_GetPointZ）
 */
export function EC_GetPointZ(x, y) {
    let px = x;
    let py = y;
    // 兼容被当作普通函数调用时的 self 参数错位：EC_GetPointZ(x, y)
    if (typeof this === "number" && typeof x === "number" && y == null) {
        px = this;
        py = x;
    }
    if (starLocation == null) {
        starLocation = jass.Location(px, py);
    }
    else {
        jass.MoveLocation(starLocation, px, py);
    }
    return jass.GetLocationZ(starLocation) || 0;
}
/**
 * 创建特效（对齐 EC_CreateEffect）
 * time:
 * - >= 0: 到时销毁
 * - == -1: 不自动处理
 * - 其它负数: 立即销毁
 */
export function EC_CreateEffect(pathOrX, xOrY, yOrZ, zOrFac, facOrSize, sizeOrS, sOrTime, timeMaybe) {
    let path = pathOrX;
    let x = xOrY;
    let y = yOrZ;
    let z = zOrFac;
    let fac = facOrSize;
    let size = sizeOrS;
    let s = sOrTime;
    let time = timeMaybe;
    // 兼容被当作普通函数调用时的 self 参数错位：EC_CreateEffect(path, x, y, z, fac, size, s, time)
    if (typeof this === "string" && typeof pathOrX === "number" && timeMaybe == null) {
        path = this;
        x = pathOrX;
        y = xOrY;
        z = yOrZ;
        fac = zOrFac;
        size = facOrSize;
        s = sizeOrS;
        time = sOrTime;
    }
    if (path == null || path === "")
        return null;
    if (x == null || x === false || x === "")
        x = 0;
    if (y == null || y === false || y === "")
        y = 0;
    if (z == null || z === false || z === "")
        z = 0;
    if (fac == null || fac === false || fac === "")
        fac = 0;
    if (size == null || size === false || size === "")
        size = 1;
    if (s == null || s === false || s === "")
        s = 1;
    if (time == null || time === false || time === "")
        time = -1;
    const g = globalThis;
    const eff = jass.AddSpecialEffect(path, x, y);
    g.bj_lastCreatedEffect = eff;
    if (!eff)
        return null;
    japi.EXSetEffectSize(eff, size);
    japi.EXSetEffectZ(eff, EC_GetPointZ(x, y) + z);
    japi.EXEffectMatRotateZ(eff, fac);
    japi.EXSetEffectSpeed(eff, s);
    if (time >= 0) {
        YDWETimerDestroyEffect(time, eff);
    }
    else if (time !== -1) {
        jass.DestroyEffect(eff);
    }
    return eff;
}
