/** @noSelfInFile */
/**
 * FourCC 安全封装版
 *
 * 用于 `@noSelfInFile` 文件，避免直接挂载/调用原始导出时引入 self 形态风险。
 */
const jass = require("jass.common");
const R2I = jass.R2I;
const stringByte = string.byte;
const stringChar = string.char;
/**
 * 将 4 字符字符串转换为 FourCC 数值。
 */
export function stringToFourCCSafe(s) {
    if (!s || s.length < 4)
        return 0;
    const b1 = stringByte(s, 1);
    const b2 = stringByte(s, 2);
    const b3 = stringByte(s, 3);
    const b4 = stringByte(s, 4);
    return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
}
/**
 * 将 FourCC 数值转换为 4 字符字符串。
 */
export function fourCCToStringSafe(fourcc) {
    const c1 = stringChar(fourcc % 256);
    const c2 = stringChar(R2I(fourcc / 256) % 256);
    const c3 = stringChar(R2I(fourcc / 65536) % 256);
    const c4 = stringChar(R2I(fourcc / 16777216) % 256);
    return `${c4}${c3}${c2}${c1}`;
}
export const stringToFourCC = stringToFourCCSafe;
export const fourCCToString = fourCCToStringSafe;
export const 字符串转FourCC安全版 = stringToFourCCSafe;
export const FourCC转字符串安全版 = fourCCToStringSafe;
