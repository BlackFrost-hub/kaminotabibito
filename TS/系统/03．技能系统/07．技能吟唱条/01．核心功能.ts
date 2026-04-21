/**
 * 技能吟唱条系统 - 生命周期入口
 *
 * 本文件是吟唱条系统对外的薄壳：
 * - `init()`：幂等启动，触发输入层 STES 注册
 * - `showCastBar()`：手动触发一次吟唱条（不经过 STES，直接调用渲染层）
 *
 * 拆分说明：
 * - 02．渲染.ts ：帧创建/每帧更新、Map 数据存储、中心计时器 tick
 * - 03．输入.ts ：STES「注册吟唱条」子触发读取与重试注册
 */

const { CAST_BAR_ENABLED, DEFAULT_COLOR_ID } = require("系统.03．技能系统.07．技能吟唱条.00．常量定义") as {
  CAST_BAR_ENABLED: boolean;
  DEFAULT_COLOR_ID: number;
};

const { startCastBar } = require("系统.03．技能系统.07．技能吟唱条.02．渲染") as {
  startCastBar: (colorId: number, totalTime: number, customString: string) => void;
};

const { tryRegisterCastBarStes } = require("系统.03．技能系统.07．技能吟唱条.03．输入") as {
  tryRegisterCastBarStes: () => void;
};

let _initialized = false;

/** 初始化技能吟唱条系统（幂等） */
export function init(this: void): void {
  if (_initialized) return;
  if (!CAST_BAR_ENABLED) return;

  _initialized = true;
  tryRegisterCastBarStes();
}

/**
 * 手动触发吟唱条（供 Lua / TS 直接调用）
 * @param colorId 颜色ID (1-7)
 * @param totalTime 吟唱总时间（秒）
 * @param customString 自定义提示文本（可选）
 */
export function showCastBar(this: void, colorId: number, totalTime: number, customString?: string): void {
  if (!CAST_BAR_ENABLED) return;

  startCastBar(colorId || DEFAULT_COLOR_ID, totalTime, customString || "");
}

export {};
