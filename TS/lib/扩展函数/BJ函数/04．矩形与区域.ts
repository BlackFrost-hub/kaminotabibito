const jass = require("jass.common") as any;

export function RectContainsCoords(r: any, x: number, y: number): boolean {
    if (!r) return false;
    if (
        typeof jass.GetRectMinX !== "function" ||
        typeof jass.GetRectMaxX !== "function" ||
        typeof jass.GetRectMinY !== "function" ||
        typeof jass.GetRectMaxY !== "function"
    ) {
        return false;
    }
    return (
        jass.GetRectMinX(r) <= x &&
        x <= jass.GetRectMaxX(r) &&
        jass.GetRectMinY(r) <= y &&
        y <= jass.GetRectMaxY(r)
    );
}

export function RectContainsLoc(r: any, loc: any): boolean {
    if (!r || !loc) return false;
    if (typeof jass.GetLocationX !== "function" || typeof jass.GetLocationY !== "function") return false;
    return RectContainsCoords(r, jass.GetLocationX(loc), jass.GetLocationY(loc));
}

export function RectContainsUnit(r: any, whichUnit: any): boolean {
    if (!r || !whichUnit) return false;
    if (typeof jass.GetUnitX !== "function" || typeof jass.GetUnitY !== "function") return false;
    return RectContainsCoords(r, jass.GetUnitX(whichUnit), jass.GetUnitY(whichUnit));
}

export function SetStackedSoundBJ(add: boolean, soundHandle: any, r: any): void {
    if (!soundHandle || !r) return;
    if (
        typeof jass.GetRectMaxX !== "function" ||
        typeof jass.GetRectMinX !== "function" ||
        typeof jass.GetRectMaxY !== "function" ||
        typeof jass.GetRectMinY !== "function" ||
        typeof jass.GetRectCenterX !== "function" ||
        typeof jass.GetRectCenterY !== "function" ||
        typeof jass.SetSoundPosition !== "function"
    ) return;

    const width = jass.GetRectMaxX(r) - jass.GetRectMinX(r);
    const height = jass.GetRectMaxY(r) - jass.GetRectMinY(r);
    jass.SetSoundPosition(soundHandle, jass.GetRectCenterX(r), jass.GetRectCenterY(r), 0);

    if (add) {
        if (typeof jass.RegisterStackedSound === "function") {
            jass.RegisterStackedSound(soundHandle, true, width, height);
        }
    } else if (typeof jass.UnregisterStackedSound === "function") {
        jass.UnregisterStackedSound(soundHandle, true, width, height);
    }
}

export {};
