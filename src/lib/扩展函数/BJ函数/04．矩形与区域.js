const jass = require("jass.common");
/**
 * 获取整个地图区域
 * 对应JASS: GetEntireMapRect
 * 实现: return GetWorldBounds()
 */
export function GetEntireMapRect() {
    return jass.GetWorldBounds();
}
export function RectContainsCoords(r, x, y) {
    if (!r)
        return false;
    return (jass.GetRectMinX(r) <= x &&
        x <= jass.GetRectMaxX(r) &&
        jass.GetRectMinY(r) <= y &&
        y <= jass.GetRectMaxY(r));
}
export function RectContainsLoc(r, loc) {
    if (!r || !loc)
        return false;
    return RectContainsCoords(r, jass.GetLocationX(loc), jass.GetLocationY(loc));
}
export function RectContainsUnit(r, whichUnit) {
    if (!r || !whichUnit)
        return false;
    return RectContainsCoords(r, jass.GetUnitX(whichUnit), jass.GetUnitY(whichUnit));
}
export function SetStackedSoundBJ(add, soundHandle, r) {
    if (!soundHandle || !r)
        return;
    const width = jass.GetRectMaxX(r) - jass.GetRectMinX(r);
    const height = jass.GetRectMaxY(r) - jass.GetRectMinY(r);
    jass.SetSoundPosition(soundHandle, jass.GetRectCenterX(r), jass.GetRectCenterY(r), 0);
    if (add) {
        jass.RegisterStackedSound(soundHandle, true, width, height);
    }
    else {
        jass.UnregisterStackedSound(soundHandle, true, width, height);
    }
}
