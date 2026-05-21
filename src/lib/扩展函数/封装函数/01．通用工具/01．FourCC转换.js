/**
 * FourCC 转换函数
 * 统一转发到安全版，避免不同调用形态下出现 self/nil 错位。
 */
const 安全版模块 = require("./01．FourCC转换安全版");
export const stringToFourCC = 安全版模块.stringToFourCCSafe;
export const fourCCToString = 安全版模块.fourCCToStringSafe;
