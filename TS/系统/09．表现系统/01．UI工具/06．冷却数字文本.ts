/** @noSelfInFile */

const japi = require("jass.japi") as any;

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (type: string, name: string, parent: number, template: string, id: number) => number;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: number, point: number, relativeFrame: number, relativePoint: number, x: number, y: number) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (frame: number, width: number, height: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetTextAlignment = japi.DzFrameSetTextAlignment as (frame: number, align: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, fontFile: string, height: number, flag: number) => void;
const DzFrameSetTextColor = japi.DzFrameSetTextColor as (frame: number, r: number, g: number, b: number, a: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, priority: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: number, visible: boolean) => void;

export interface 冷却数字文本层配置 {
  后缀: string;
  偏移X: number;
  偏移Y: number;
  颜色码: string;
  r: number;
  g: number;
  b: number;
  a: number;
  优先级偏移: number;
}

export interface 冷却数字文本组配置 {
  名称前缀: string;
  父级?: number;
  宽度?: number;
  高度?: number;
  字体大小?: number;
  优先级?: number;
  对齐?: number;
  层?: 冷却数字文本层配置[];
}

export interface 冷却数字文本组 {
  框体列表: number[];
  层列表: 冷却数字文本层配置[];
  主文本框体: number;
  宽度: number;
  高度: number;
  字体大小: number;
  优先级: number;
  对齐: number;
}

export const 冷却数字字体 = "UI\\uizt.ttf";
export const 冷却数字白金颜色码 = "fffff2d8";
export const 冷却数字阴影颜色码 = "ff101010";

export const 技能冷却数字层: 冷却数字文本层配置[] = [
  { 后缀: "Shadow", 偏移X: -0.0012, 偏移Y: -0.0012, 颜色码: 冷却数字阴影颜色码, r: 16, g: 16, b: 16, a: 255, 优先级偏移: -1 },
  { 后缀: "Text", 偏移X: 0.0, 偏移Y: 0.0, 颜色码: 冷却数字白金颜色码, r: 255, g: 242, b: 216, a: 255, 优先级偏移: 0 },
];

export const 英雄栏冷却数字层: 冷却数字文本层配置[] = [
  { 后缀: "BottomShadow", 偏移X: 0.0014, 偏移Y: -0.0018, 颜色码: "ff080808", r: 8, g: 8, b: 8, a: 255, 优先级偏移: -2 },
  { 后缀: "LeftOutline", 偏移X: -0.0011, 偏移Y: 0.0, 颜色码: "ff3a2a18", r: 58, g: 42, b: 24, a: 255, 优先级偏移: -1 },
  { 后缀: "RightOutline", 偏移X: 0.0011, 偏移Y: 0.0, 颜色码: "ff3a2a18", r: 58, g: 42, b: 24, a: 255, 优先级偏移: -1 },
  { 后缀: "Shadow", 偏移X: -0.0014, 偏移Y: -0.0014, 颜色码: 冷却数字阴影颜色码, r: 16, g: 16, b: 16, a: 255, 优先级偏移: -1 },
  { 后缀: "Text", 偏移X: 0.0, 偏移Y: 0.0, 颜色码: 冷却数字白金颜色码, r: 255, g: 242, b: 216, a: 255, 优先级偏移: 0 },
];

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

export function 包装冷却数字颜色(this: void, text: string, 颜色码: string): string {
  if (text === "") return "";
  if (颜色码 === "") return text;
  return `|c${颜色码}${text}|r`;
}

export function 创建冷却数字文本组(this: void, 配置: 冷却数字文本组配置): 冷却数字文本组 | null {
  const 父级 = 配置.父级 ?? DzGetGameUI();
  if (!句柄有效(父级)) return null;

  const 宽度 = 配置.宽度 ?? 0.042;
  const 高度 = 配置.高度 ?? 0.020;
  const 字体大小 = 配置.字体大小 ?? 0.020;
  const 优先级 = 配置.优先级 ?? 9001;
  const 对齐 = 配置.对齐 ?? 8;
  const 层列表 = 配置.层 ?? 技能冷却数字层;
  const 框体列表: number[] = [];

  for (let i = 0; i < 层列表.length; i++) {
    const 层 = 层列表[i];
    const frame = DzCreateFrameByTagName("TEXT", `${配置.名称前缀}${层.后缀}`, 父级, "template", 0);
    if (!句柄有效(frame)) return null;

    DzFrameSetSize(frame, 宽度, 高度);
    DzFrameSetText(frame, "");
    DzFrameSetFont(frame, 冷却数字字体, 字体大小, 0);
    DzFrameSetTextAlignment(frame, -1);
    DzFrameSetTextAlignment(frame, 对齐);
    DzFrameSetTextColor(frame, 层.r, 层.g, 层.b, 层.a);
    DzFrameSetPriority(frame, 优先级 + 层.优先级偏移);
    DzFrameShow(frame, false);
    框体列表.push(frame);
  }

  return {
    框体列表,
    层列表,
    主文本框体: 框体列表[框体列表.length - 1] ?? 0,
    宽度,
    高度,
    字体大小,
    优先级,
    对齐,
  };
}

export function 设置冷却数字文本锚点(
  this: void,
  文本组: 冷却数字文本组 | null,
  relativeFrame: number,
  point: number,
  relativePoint: number,
  x: number,
  y: number
): void {
  if (文本组 == null || !句柄有效(relativeFrame)) return;
  for (let i = 0; i < 文本组.框体列表.length; i++) {
    const frame = 文本组.框体列表[i];
    const 层 = 文本组.层列表[i];
    if (!句柄有效(frame) || 层 == null) continue;
    DzFrameSetPoint(frame, point, relativeFrame, relativePoint, x + 层.偏移X, y + 层.偏移Y);
  }
}

export function 设置冷却数字文本(this: void, 文本组: 冷却数字文本组 | null, text: string): void {
  if (文本组 == null) return;
  for (let i = 0; i < 文本组.框体列表.length; i++) {
    const frame = 文本组.框体列表[i];
    const 层 = 文本组.层列表[i];
    if (!句柄有效(frame) || 层 == null) continue;
    DzFrameSetText(frame, 包装冷却数字颜色(text, 层.颜色码));
  }
}

export function 显示冷却数字文本(this: void, 文本组: 冷却数字文本组 | null, visible: boolean): void {
  if (文本组 == null) return;
  for (let i = 0; i < 文本组.框体列表.length; i++) {
    const frame = 文本组.框体列表[i];
    if (句柄有效(frame)) DzFrameShow(frame, visible);
  }
}
