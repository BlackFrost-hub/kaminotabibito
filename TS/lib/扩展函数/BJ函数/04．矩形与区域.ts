const jass = require("jass.common") as any;

/**
 * 获取整个地图区域
 * 对应JASS: GetEntireMapRect
 * 实现: return GetWorldBounds()
 */
export function GetEntireMapRect(): any {
  return jass.GetWorldBounds();
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
