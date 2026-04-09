/**
 * 单位相关扩展函数
 */

const jass = require("jass.common") as any;

/**
 * 创建单位并设置尺寸和角度
 * @param playerId 玩家ID (0-15)
 * @param unitId 单位ID (FourCC字符串如 "hfoo")
 * @param x X坐标
 * @param y Y坐标
 * @param facing 面向角度（弧度），不传则使用单位默认面向
 * @param scale X轴缩放，不传则使用1.0
 * @param scaleY Y轴缩放，不传则使用1.0
 * @param scaleZ Z轴缩放，不传则使用1.0
 * @returns 创建的单位，失败返回null
 */
export function createUnitWithOptions(
    playerId: number,
    unitId: string | number,
    x: number,
    y: number,
    facing?: number,
    scale?: number,
    scaleY?: number,
    scaleZ?: number
): any {
    if (typeof jass.CreateUnit !== "function") {
        return null;
    }

    let unitTypeId: number | null = null;
    if (typeof unitId === "number") {
        unitTypeId = unitId;
    } else if (typeof unitId === "string" && unitId.length === 4) {
        const bytes = [
            unitId.charCodeAt(0),
            unitId.charCodeAt(1),
            unitId.charCodeAt(2),
            unitId.charCodeAt(3),
        ];
        unitTypeId = bytes[0] * 16777216 + bytes[1] * 65536 + bytes[2] * 256 + bytes[3];
    }
    if (unitTypeId == null) return null;

    const unit = jass.CreateUnit(jass.Player(playerId), unitTypeId, x, y, 0);

    if (!unit) {
        return null;
    }

    if (facing !== undefined && typeof jass.SetUnitFacing === "function") {
        jass.SetUnitFacing(unit, facing * 180 / Math.PI);
    }

    const scaleX = scale ?? 1.0;
    const scaleY2 = scaleY ?? 1.0;
    const scaleZ2 = scaleZ ?? 1.0;

    if (typeof jass.SetUnitScale === "function") {
        jass.SetUnitScale(unit, scaleX, scaleY2, scaleZ2);
    }

    return unit;
}

export {};