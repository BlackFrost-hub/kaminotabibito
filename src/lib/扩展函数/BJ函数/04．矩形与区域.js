const jass = require("jass.common");
export function RectContainsCoords(r, x, y) {
    if (!r)
        return false;
    if (typeof jass.GetRectMinX !== "function" ||
        typeof jass.GetRectMaxX !== "function" ||
        typeof jass.GetRectMinY !== "function" ||
        typeof jass.GetRectMaxY !== "function") {
        return false;
    }
    return (jass.GetRectMinX(r) <= x &&
        x <= jass.GetRectMaxX(r) &&
        jass.GetRectMinY(r) <= y &&
        y <= jass.GetRectMaxY(r));
}
export function RectContainsLoc(r, loc) {
    if (!r || !loc)
        return false;
    if (typeof jass.GetLocationX !== "function" || typeof jass.GetLocationY !== "function")
        return false;
    return RectContainsCoords(r, jass.GetLocationX(loc), jass.GetLocationY(loc));
}
export function RectContainsUnit(r, whichUnit) {
    if (!r || !whichUnit)
        return false;
    if (typeof jass.GetUnitX !== "function" || typeof jass.GetUnitY !== "function")
        return false;
    return RectContainsCoords(r, jass.GetUnitX(whichUnit), jass.GetUnitY(whichUnit));
}
export function SetStackedSoundBJ(add, soundHandle, r) {
    if (!soundHandle || !r)
        return;
    if (typeof jass.GetRectMaxX !== "function" ||
        typeof jass.GetRectMinX !== "function" ||
        typeof jass.GetRectMaxY !== "function" ||
        typeof jass.GetRectMinY !== "function" ||
        typeof jass.GetRectCenterX !== "function" ||
        typeof jass.GetRectCenterY !== "function" ||
        typeof jass.SetSoundPosition !== "function")
        return;
    const width = jass.GetRectMaxX(r) - jass.GetRectMinX(r);
    const height = jass.GetRectMaxY(r) - jass.GetRectMinY(r);
    jass.SetSoundPosition(soundHandle, jass.GetRectCenterX(r), jass.GetRectCenterY(r), 0);
    if (add) {
        if (typeof jass.RegisterStackedSound === "function") {
            jass.RegisterStackedSound(soundHandle, true, width, height);
        }
    }
    else if (typeof jass.UnregisterStackedSound === "function") {
        jass.UnregisterStackedSound(soundHandle, true, width, height);
    }
}
