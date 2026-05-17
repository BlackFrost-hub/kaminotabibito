/** @noSelfInFile */
/**
 * 吟唱条系统 - 常量定义
 */

const jass = require("jass.common") as any;
const japi = require("jass.japi") as any;

const DzCreateFrame = japi.DzCreateFrame as (template: string, parent: any, priority: number, id: number) => any;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: any, point: number, x: number, y: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: any, point: number, relativeFrame: any, relativePoint: number, x: number, y: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: any, text: string) => void;
const DzFrameSetTexture = japi.DzFrameSetTexture as (frame: any, texture: string, flag: number) => void;
const DzFrameSetAnimate = japi.DzFrameSetAnimate as (frame: any, animId: number, auto: boolean) => void;
const DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset as (frame: any, offset: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: any, show: boolean) => void;
const DzGetGameUI = japi.DzGetGameUI as () => any;

export const 模块名 = "吟唱条";

export const 吟唱条步进秒 = 0.01;

export const UI坐标X = 0.549;
export const UI坐标Y = 0.2;
export const 锚点CENTER = 4;

export const 框架名_前景 = "吟唱条前景";
export const 框架名_背景 = "吟唱条背景";
export const 框架名_标题 = "吟唱条标题";
export const 框架名_进度 = "吟唱条进度";
export const 框架名_分隔符 = "吟唱条分隔符";
export const 框架名_时间 = "吟唱条时间";
export const 框架名_提示 = "吟唱条提示";

export const 默认标题文本 = "吟唱中";
export const 默认提示文本 = "场地技能：";
export const 分隔符文本 = "/";

export const 默认颜色ID = 5;

export const 颜色ID到前景模型: Record<number, string> = {
  1: "UI\\CastBar\\UI_shengmingzhi_gb2.mdx",
  2: "UI\\CastBar\\UI_shengmingzhi_t1.mdx",
  3: "UI\\CastBar\\UI_shengmingzhi_o2.mdx",
  4: "UI\\CastBar\\UI_shengmingzhi_r2.mdx",
  5: "UI\\CastBar\\UI_shengmingzhi_p2.mdx",
  6: "UI\\CastBar\\UI_shengmingzhi_g2.mdx",
  7: "UI\\CastBar\\UI_shengmingzhi_b2.mdx",
};

export const 颜色ID到背景模型: Record<number, string> = {
  1: "UI\\CastBar\\UI_shengmingzhi-beijing_gb2.mdx",
  2: "UI\\CastBar\\UI_shengmingzhi-beijing_t1.mdx",
  3: "UI\\CastBar\\UI_shengmingzhi-beijing_o2.mdx",
  4: "UI\\CastBar\\UI_shengmingzhi-beijing_r2.mdx",
  5: "UI\\CastBar\\UI_shengmingzhi-beijing_p2.mdx",
  6: "UI\\CastBar\\UI_shengmingzhi-beijing_g2.mdx",
  7: "UI\\CastBar\\UI_shengmingzhi-beijing_b2.mdx",
};

export function 获取前景模型(颜色ID: number): string {
  return 颜色ID到前景模型[颜色ID] || 颜色ID到前景模型[默认颜色ID];
}

export function 获取背景模型(颜色ID: number): string {
  return 颜色ID到背景模型[颜色ID] || 颜色ID到背景模型[默认颜色ID];
}
