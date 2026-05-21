/**
 * 颜色工具函数
 * 只保留动态生成颜色文本的函数
 */
/** 重置代码 */
export const COLOR = {
    RESET: "|r",
};
/** 装备等级颜色映射 */
const 装备等级颜色映射 = {
    "E-": "|cffC0C0C0",
    E: "|cffFFFFFF",
    "D-": "|cff3399FF",
    D: "|cff0070DD",
    "D+": "|cff0070DD",
    "D++": "|cff800080",
    "C-": "|cffA335EE",
    C: "|cffA335EE",
    "C+": "|cffA335EE",
    "C++": "|cffFF8000",
    "B-": "|cffFF8000",
    B: "|cffFF8000",
    "B+": "|cffFFD700",
    "B++": "|cffFF0000",
    A: "|cffFF0000",
    "A+": "|cffFF66CC",
    "A++": "|cff66FFFF",
    S: "|cff00FFFF",
    SS: "|cff00FFCC",
    SSS: "|cffFF66FF",
};
const 彩虹颜色序列 = ["|cffFF0000", "|cffFF8000", "|cffFFD700", "|cff00FF00", "|cff00FFFF", "|cff3399FF", "|cffCC66FF"];
/** 品质颜色映射 */
const QUALITY_COLORS = {
    common: "|cffffffff", // 普通 - 白色
    uncommon: "|cff1eff00", // 优秀 - 绿色
    rare: "|cff0070dd", // 稀有 - 蓝色
    epic: "|cffa335ee", // 史诗 - 紫色
    legendary: "|cffff8000", // 传说 - 橙色
    mythic: "|cffe6cc80", // 神话 - 金色
};
/** 元素颜色映射 */
const ELEMENT_COLORS = {
    fire: "|cffff4444", // 火元素 - 火红
    ice: "|cff44ffff", // 冰元素 - 冰蓝
    lightning: "|cffffd700", // 雷元素 - 金黄
    poison: "|cff44ff44", // 毒元素 - 毒绿
    dark: "|cff8800ff", // 暗元素 - 暗紫
    light: "|cfffff8dc", // 光元素 - 米白
    earth: "|cff8b4513", // 土元素 - 土褐
    wind: "|cff40e0d0", // 风元素 - 青绿
};
/** 品质颜色快捷函数 */
export function qualityColor(text, quality) {
    return QUALITY_COLORS[quality] + text + COLOR.RESET;
}
/** 元素颜色快捷函数 */
export function elementColor(text, element) {
    return ELEMENT_COLORS[element] + text + COLOR.RESET;
}
/** 装备等级取颜色代码 */
export const 装备等级颜色代码 = (level) => {
    return 装备等级颜色映射[level] ?? "|cffFFFFFF";
};
/** 装备等级文本着色 */
export const 装备等级颜色文本 = (text, level) => {
    return 装备等级颜色代码(level) + text + COLOR.RESET;
};
/** 去掉文本中的颜色代码，保留纯文字与换行控制 */
export const 去除颜色代码 = (text) => {
    if (text == null || text === "")
        return "";
    let result = "";
    let i = 0;
    while (i < text.length) {
        if (text.substring(i, i + 2) === "|r") {
            i = i + 2;
            continue;
        }
        if (text.substring(i, i + 2) === "|c" && i + 10 <= text.length) {
            i = i + 10;
            continue;
        }
        result += text.substring(i, i + 1);
        i++;
    }
    return result;
};
/** 是否为彩色显示的高阶等级 */
export const 是否彩虹装备等级 = (level) => {
    return level === "S" || level === "SS" || level === "SSS";
};
/** 逐字彩色文本 */
export const 彩虹颜色文本 = (text) => {
    const plainText = 去除颜色代码(text);
    if (plainText === "")
        return "";
    let result = "";
    let colorIndex = 0;
    let i = 0;
    while (i < plainText.length) {
        const char = plainText.substring(i, i + 1);
        if (char !== " " && char !== "『" && char !== "』" && char !== "《" && char !== "》" && char !== "（" && char !== "）" && char !== "[" && char !== "]") {
            result += 彩虹颜色序列[colorIndex % 彩虹颜色序列.length] + char + COLOR.RESET;
            colorIndex++;
        }
        else {
            result += char;
        }
        i++;
    }
    return result;
};
/** 装备等级显示文本 */
export const 装备等级显示文本 = (text, level) => {
    if (是否彩虹装备等级(level))
        return 彩虹颜色文本(text);
    return 装备等级颜色文本(text, level);
};
/** 按装备等级给物品名着色 */
export const 装备名字颜色文本 = (text, level) => {
    const plainText = 去除颜色代码(text);
    if (是否彩虹装备等级(level))
        return 彩虹颜色文本(plainText);
    return 装备等级颜色文本(plainText, level);
};
