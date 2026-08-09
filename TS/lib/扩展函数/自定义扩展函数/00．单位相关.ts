/**
 * 单位相关扩展函数
 */

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;
const { 登记单位排泄 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
    登记单位排泄: (this: void, unit: any) => any;
};

import { YDUserDataGet } from "../YDWE函数/01．YDUserData兼容";
import { forEachUnitInGroup } from "../封装函数/01．通用工具/04．单位工具";

const BJ_RADTODEG = jglobals.bj_RADTODEG ?? 57.29577951308232;
const Player = jass.Player as (this: void, playerId: number) => any;
const CreateUnit = jass.CreateUnit as (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
const SetUnitFacing = jass.SetUnitFacing as (this: void, whichUnit: any, facing: number) => void;
const SetUnitScale = jass.SetUnitScale as (this: void, whichUnit: any, scaleX: number, scaleY: number, scaleZ: number) => void;

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

    const unit = CreateUnit(Player(playerId), unitTypeId, x, y, 0);

    if (!unit) {
        return null;
    }

    if (facing !== undefined) {
        SetUnitFacing(unit, facing * BJ_RADTODEG);
    }

    const scaleX = scale ?? 1.0;
    const scaleY2 = scaleY ?? 1.0;
    const scaleZ2 = scaleZ ?? 1.0;

    SetUnitScale(unit, scaleX, scaleY2, scaleZ2);

    return 登记单位排泄(unit);
}

export function 创建单位并登记排泄(owner: any, unitTypeId: number, x: number, y: number, facing: number): any {
    const unit = CreateUnit(owner, unitTypeId, x, y, facing);
    return 登记单位排泄(unit);
}

export function createUnitWithOptionsAndRegisterDeathCleanup(
    playerId: number,
    unitId: string | number,
    x: number,
    y: number,
    facing?: number,
    scale?: number,
    scaleY?: number,
    scaleZ?: number
): any {
    return createUnitWithOptions(playerId, unitId, x, y, facing, scale, scaleY, scaleZ);
}

/**
 * 获取玩家的第一个英雄
 * @param player 玩家对象
 * @returns 玩家的第一个英雄单位，如果没有则返回null
 */
export function getPlayerFirstHero(player: any): any {
    if (!player) return null;

    // 当前英雄注册桥接按玩家保存正式英雄；优先读取这一权威来源。
    const registeredHero = YDUserDataGet("player", player, "英雄", "unit") as any;
    if (
        registeredHero != null &&
        registeredHero !== 0 &&
        jass.GetOwningPlayer(registeredHero) === player &&
        jass.IsUnitType(registeredHero, jass.UNIT_TYPE_HERO)
    ) {
        return registeredHero;
    }

    // 兼容旧流程：通过"玩家英雄-单位组"查找，不进行整图枚举。
    const heroGroup = YDUserDataGet("string", "玩家英雄", "单位组", "group") as any;
    if (!heroGroup) return null;

    let hero: any = null;
    forEachUnitInGroup(heroGroup, (u: any) => {
        if (hero != null) return; // 已找到第一个则不再覆写

        // 对齐你给的 JASS：if GetOwningPlayer(GetEnumUnit()) == Player(x)
        if (jass.GetOwningPlayer(u) === player) {
            // 保险起见仍检查英雄类型（按存表语义理论上应全是英雄）
            if (jass.IsUnitType(u, jass.UNIT_TYPE_HERO)) {
                hero = u;
            }
        }
    });

    return hero;
}

export {};
