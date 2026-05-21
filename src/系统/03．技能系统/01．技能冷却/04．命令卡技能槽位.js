/** @noSelfInFile */
const japi = require("jass.japi");
const ydweAbility = require("lib.扩展函数.YDWE函数.00．YDWE函数");
const { YDWEGetUnitAbilityDataString } = require("lib.扩展函数.YDWE函数.00．YDWE函数");
const DzFrameGetCommandBarButton = japi.DzFrameGetCommandBarButton;
const KKCommandButtonGetAbilityId = japi.KKCommandButtonGetAbilityId;
export const 命令卡热键槽位表 = [
    [0, 2, "Q"],
    [1, 2, "W"],
    [2, 2, "E"],
    [3, 2, "R"],
    [0, 1, "D"],
];
export const D技能候选槽位表 = [
    [0, 1],
    [2, 1],
];
export function 解析脚本返回整数(raw) {
    if (raw == null || raw === "")
        return 0;
    if (typeof raw === "number" && raw === raw && isFinite(raw))
        return raw;
    const value = parseInt(tostring(raw), 10);
    return isFinite(value) ? value : 0;
}
export function 读取命令卡按钮能力Id(x, y) {
    const 按钮框体 = DzFrameGetCommandBarButton(y, x);
    if (按钮框体 === 0)
        return 0;
    return KKCommandButtonGetAbilityId(按钮框体) || 0;
}
export function 按命令卡推断热键(abilityId) {
    if (abilityId === 0)
        return null;
    for (let i = 0; i < 命令卡热键槽位表.length; i++) {
        const [x, y, hotkey] = 命令卡热键槽位表[i];
        if (读取命令卡按钮能力Id(x, y) === abilityId)
            return hotkey;
    }
    return null;
}
function 归一化热键(rawHotkey) {
    const hotkey = tostring(rawHotkey);
    if (hotkey === "Q" || hotkey === "q")
        return "Q";
    if (hotkey === "W" || hotkey === "w")
        return "W";
    if (hotkey === "E" || hotkey === "e")
        return "E";
    if (hotkey === "R" || hotkey === "r")
        return "R";
    if (hotkey === "D" || hotkey === "d")
        return "D";
    return null;
}
function 读取按钮技能热键(whichHero, x, y) {
    if (whichHero == null || whichHero === 0)
        return null;
    const abilityId = 读取命令卡按钮能力Id(x, y);
    if (abilityId === 0)
        return null;
    const rawHotkey = YDWEGetUnitAbilityDataString(whichHero, abilityId, 1, ydweAbility.ABILITY_DATA_HOTKEY);
    if (rawHotkey == null || rawHotkey === "")
        return null;
    return 归一化热键(rawHotkey);
}
export function 获取D技能槽位(whichHero) {
    const 默认槽位 = D技能候选槽位表[0];
    const 主槽位热键 = 读取按钮技能热键(whichHero, D技能候选槽位表[0][0], D技能候选槽位表[0][1]);
    if (主槽位热键 === "D")
        return 默认槽位;
    const 备用槽位热键 = 读取按钮技能热键(whichHero, D技能候选槽位表[1][0], D技能候选槽位表[1][1]);
    if (备用槽位热键 === "D")
        return D技能候选槽位表[1];
    return 默认槽位;
}
