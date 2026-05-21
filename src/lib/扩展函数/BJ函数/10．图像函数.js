const jass = require("jass.common");
const jglobals = require("jass.globals");
const { PercentTo255 } = require("lib.扩展函数.BJ函数.12．数学函数");
// ===========================================================================
// 最后创建的图像（Blizzard.j）
// ===========================================================================
export let bj_lastCreatedImage = jglobals.bj_lastCreatedImage ?? null;
export function CreateImageBJ(file, size, where, zOffset, imageType) {
    if (where == null || where === 0)
        return null;
    const x = jass.GetLocationX(where);
    const y = jass.GetLocationY(where);
    bj_lastCreatedImage = jass.CreateImage(file, size, size, size, x, y, zOffset, 0, 0, 0, imageType);
    return bj_lastCreatedImage;
}
export function ShowImageBJ(flag, whichImage) {
    if (whichImage == null || whichImage === 0)
        return;
    jass.ShowImage(whichImage, flag);
}
export function SetImagePositionBJ(whichImage, where, zOffset) {
    if (whichImage == null || whichImage === 0)
        return;
    if (where == null || where === 0)
        return;
    const x = jass.GetLocationX(where);
    const y = jass.GetLocationY(where);
    jass.SetImagePosition(whichImage, x, y, zOffset);
}
export function SetImageColorBJ(whichImage, red, green, blue, alpha) {
    if (whichImage == null || whichImage === 0)
        return;
    jass.SetImageColor(whichImage, PercentTo255(red), PercentTo255(green), PercentTo255(blue), PercentTo255(100.0 - alpha));
}
export function GetLastCreatedImage() {
    return bj_lastCreatedImage;
}
