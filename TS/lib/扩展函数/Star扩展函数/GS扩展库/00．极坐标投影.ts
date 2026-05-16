/**
 * GS扩展库 - 极坐标投影函数
 * 对齐 JASS BJ: PolarProjectionBJ
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const DEFAULT_BJ_DEGTORAD = 0.017453292519943295;

/**
 * 角度转弧度常量
 */
const bj_DEGTORAD = jglobals.bj_DEGTORAD ?? DEFAULT_BJ_DEGTORAD;

/**
 * 极坐标投影 - 从源位置按指定角度和距离计算目标位置
 * @param source 源位置（location），计算后会被移除
 * @param dist 距离
 * @param angle 角度（度）
 * @returns 新的位置（location）
 */
export function GS_PolarProjectionBJ(this: any, sourceOrDist: any, distOrAngle: any, angleMaybe: any): any {
    let source = sourceOrDist;
    let dist = distOrAngle;
    let angle = angleMaybe;
    // 兼容被全局桥接后由 JASS 直接调用时的 self 参数错位：GS_PolarProjectionBJ(source, dist, angle)
    if (angle == null && typeof distOrAngle === "number" && typeof sourceOrDist === "number") {
        source = this;
        dist = sourceOrDist;
        angle = distOrAngle;
    }
    if (!source) return null;
    if (dist == null || dist === false || dist === "") dist = 0;
    if (angle == null || angle === false || angle === "") angle = 0;

    const rad = angle * bj_DEGTORAD;
    const x = jass.GetLocationX(source) + dist * jass.Cos(rad);
    const y = jass.GetLocationY(source) + dist * jass.Sin(rad);

    // 移除源位置（与原版 JASS 行为一致）
    jass.RemoveLocation(source);

    // 创建并返回新位置
    return jass.Location(x, y);
}

export {};
