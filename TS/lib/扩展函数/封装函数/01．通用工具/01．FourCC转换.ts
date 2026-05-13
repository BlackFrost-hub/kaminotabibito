/**
 * FourCC 转换函数
 * 用于物品/单位 ID 的字符串与数字转换
 */

const jass = require("jass.common") as any;

/**
 * 将 4 字符字符串转换为 FourCC 数字（用于物品/单位 ID）
 */
export function stringToFourCC(s: string | undefined | null): number {
  if (!s || s.length < 4) return 0;
  const b1 = (string as any).byte(s, 1) as number;
  const b2 = (string as any).byte(s, 2) as number;
  const b3 = (string as any).byte(s, 3) as number;
  const b4 = (string as any).byte(s, 4) as number;
  return b1 * 16777216 + b2 * 65536 + b3 * 256 + b4;
}

/**
 * 将 FourCC 数字转换为 4 字符字符串
 */
export function fourCCToString(fourcc: number): string {
  const c1 = string.char(fourcc % 256);
  const c2 = string.char(jass.R2I(fourcc / 256) % 256);
  const c3 = string.char(jass.R2I(fourcc / 65536) % 256);
  const c4 = string.char(jass.R2I(fourcc / 16777216) % 256);
  return c4 + c3 + c2 + c1;
}
