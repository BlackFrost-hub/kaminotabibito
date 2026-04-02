/**
 * 颜色工具函数
 * 只保留动态生成颜色文本的函数
 */

/** 重置代码 */
export const COLOR = {
  RESET: "|r",
} as const;

/** 品质颜色映射 */
const QUALITY_COLORS: Record<string, string> = {
  common: "|cffffffff",     // 普通 - 白色
  uncommon: "|cff1eff00",   // 优秀 - 绿色
  rare: "|cff0070dd",       // 稀有 - 蓝色
  epic: "|cffa335ee",       // 史诗 - 紫色
  legendary: "|cffff8000",  // 传说 - 橙色
  mythic: "|cffe6cc80",     // 神话 - 金色
};

/** 元素颜色映射 */
const ELEMENT_COLORS: Record<string, string> = {
  fire: "|cffff4444",       // 火元素 - 火红
  ice: "|cff44ffff",        // 冰元素 - 冰蓝
  lightning: "|cffffd700",  // 雷元素 - 金黄
  poison: "|cff44ff44",     // 毒元素 - 毒绿
  dark: "|cff8800ff",       // 暗元素 - 暗紫
  light: "|cfffff8dc",      // 光元素 - 米白
  earth: "|cff8b4513",      // 土元素 - 土褐
  wind: "|cff40e0d0",       // 风元素 - 青绿
};

/** 品质颜色快捷函数 */
export function qualityColor(text: string, quality: "common" | "uncommon" | "rare" | "epic" | "legendary" | "mythic"): string {
  return QUALITY_COLORS[quality] + text + COLOR.RESET;
}

/** 元素颜色快捷函数 */
export function elementColor(text: string, element: "fire" | "ice" | "lightning" | "poison" | "dark" | "light" | "earth" | "wind"): string {
  return ELEMENT_COLORS[element] + text + COLOR.RESET;
}
