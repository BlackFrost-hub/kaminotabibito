/**
 * GS扩展库 - 极坐标投影函数
 * 对齐 JASS BJ: PolarProjectionBJ
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

/**
 * 角度转弧度常量
 */
const bj_DEGTORAD = jglobals.bj_DEGTORAD ?? (Math.PI / 180);

/**
 * 极坐标投影 - 从源位置按指定角度和距离计算目标位置
 * @param source 源位置（location），计算后会被移除
 * @param dist 距离
 * @param angle 角度（度）
 * @returns 新的位置（location）
 */
export function GS_PolarProjectionBJ(source: any, dist: number, angle: number): any {
    if (!source) return null;
    if (typeof jass.GetLocationX !== "function" || typeof jass.GetLocationY !== "function") return null;

    const x = jass.GetLocationX(source) + dist * Math.cos(angle * bj_DEGTORAD);
    const y = jass.GetLocationY(source) + dist * Math.sin(angle * bj_DEGTORAD);

    // 移除源位置（与原版 JASS 行为一致）
    if (typeof jass.RemoveLocation === "function") {
        jass.RemoveLocation(source);
    }

    // 创建并返回新位置
    if (typeof jass.Location === "function") {
        return jass.Location(x, y);
    }
    return null;
}

export {};
