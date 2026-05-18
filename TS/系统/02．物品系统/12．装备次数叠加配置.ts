/** @noSelfInFile */

const { 去除颜色代码 } = require("系统.00．核心系统.01．颜色常量") as {
  去除颜色代码: (this: void, text: string) => string;
};

const 可叠加次数装备名称 = new Set<string>([
  // 仅把需要“按次数放大属性”的装备放进来。
  // 当前默认留空：装备即使有次数，也不会自动按次数乘属性。
]);

export function 是否允许装备次数叠加(this: void, 装备名: string): boolean {
  const 规范名 = 去除颜色代码(装备名 ?? "").trim();
  if (规范名 === "") return false;
  return 可叠加次数装备名称.has(规范名);
}

export {};
