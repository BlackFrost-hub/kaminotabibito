/** @noSelfInFile */
const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const CreateDestructable = jass.CreateDestructable as (
    this: void,
    objectid: number,
    x: number,
    y: number,
    facing: number,
    scale: number,
    variation: number,
) => any;
const GetLocationX = jass.GetLocationX as (this: void, whichLocation: any) => number;
const GetLocationY = jass.GetLocationY as (this: void, whichLocation: any) => number;

/**
 * 获取整个地图区域
 * 对应JASS: GetEntireMapRect
 * 实现: return GetWorldBounds()
 */
export function GetEntireMapRect(): any {
    return jass.GetWorldBounds();
}

/**
 * 对应 Blizzard.j 的 CreateDestructableLoc。
 * 位置句柄由调用方管理；本函数只读取坐标并创建可破坏物。
 */
export function CreateDestructableLoc(
    this: void,
    objectid: number,
    loc: any,
    facing: number,
    scale: number,
    variation: number,
): any {
    if (loc == null || loc === 0) return null;
    const destructable = CreateDestructable(
        objectid,
        GetLocationX(loc),
        GetLocationY(loc),
        facing,
        scale,
        variation,
    );
    jglobals.bj_lastCreatedDestructable = destructable;
    return destructable;
}

export function RectContainsCoords(r: any, x: number, y: number): boolean {
    if (!r) return false;
    return (
        jass.GetRectMinX(r) <= x &&
        x <= jass.GetRectMaxX(r) &&
        jass.GetRectMinY(r) <= y &&
        y <= jass.GetRectMaxY(r)
    );
}

export function RectContainsLoc(r: any, loc: any): boolean {
    if (!r || !loc) return false;
    return RectContainsCoords(r, jass.GetLocationX(loc), jass.GetLocationY(loc));
}

export function RectContainsUnit(r: any, whichUnit: any): boolean {
    if (!r || !whichUnit) return false;
    return RectContainsCoords(r, jass.GetUnitX(whichUnit), jass.GetUnitY(whichUnit));
}

export function SetStackedSoundBJ(add: boolean, soundHandle: any, r: any): void {
    if (!soundHandle || !r) return;

    const width = jass.GetRectMaxX(r) - jass.GetRectMinX(r);
    const height = jass.GetRectMaxY(r) - jass.GetRectMinY(r);
    jass.SetSoundPosition(soundHandle, jass.GetRectCenterX(r), jass.GetRectCenterY(r), 0);

    if (add) {
        jass.RegisterStackedSound(soundHandle, true, width, height);
    } else {
        jass.UnregisterStackedSound(soundHandle, true, width, height);
    }
}

export {};
