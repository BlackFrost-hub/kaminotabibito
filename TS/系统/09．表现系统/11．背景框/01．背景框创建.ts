/** @noSelfInFile */
const japi = require("jass.japi") as any;

import { createFrame } from "../01．UI工具/01．帧创建";
import { setFramePosition, setFrameSize } from "../01．UI工具/02．位置尺寸";
import { setFrameTexture } from "../01．UI工具/03．内容设置";
import { hideFrame, showFrame, destroyFrame } from "../01．UI工具/05．帧控制";
import { FrameType, FramePoint, PositionConfig } from "../01．UI工具/00．类型定义";

const DzGetGameUI = japi.DzGetGameUI as () => number;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: number, level: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (frame: number, font: string, scale: number, flag: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: number, text: string) => void;
const DzFrameSetAlpha = japi.DzFrameSetAlpha as (frame: number, alpha: number) => void;

export interface 背景框实例 {
  主背景: number;
  贴图组: number[];
  段落组: number[];
}

export interface 背景框配置 {
  /** 段落数量，默认 4 */
  段落数量?: number;
  /** 段落初始文字，默认空字符串 */
  段落文字?: string[];
  /** 字体文件路径，默认 "war3mapImported\\uizt.ttf" */
  字体文件?: string;
  /** 字体大小，默认 1.00 */
  字体大小?: number;
  /** 是否初始可见，默认 false */
  初始可见?: boolean;
  /** 优先级，默认 3 */
  优先级?: number;
}

const 贴图数量 = 8;
const 每张贴图宽度 = 0.20;
const 每张贴图高度 = 0.3053724;
const 上排Y = 0.4473138;
const 下排Y = 0.1526862;
const 段落X = 0.309792;
const 段落间距 = 0.0882192;
const 段落宽度 = 0.3741664;
const 段落高度 = 0.0882186;
const 默认字体文件 = "war3mapImported\\uizt.ttf";
const 默认字体大小 = 1.00;

function 计算贴图X(索引: number): number {
  if (索引 >= 1 && 索引 <= 4) {
    return -0.10 + 0.20 * 索引;
  }
  return -0.90 + 0.20 * 索引;
}

function 计算贴图Y(索引: number): number {
  if (索引 >= 1 && 索引 <= 4) {
    return 上排Y;
  }
  return 下排Y;
}

export function 创建背景框(config?: 背景框配置): 背景框实例 | null {
  const 段落数 = config?.段落数量 ?? 4;
  const 字体 = config?.字体文件 ?? 默认字体文件;
  const 字号 = config?.字体大小 ?? 默认字体大小;
  const 可见 = config?.初始可见 ?? false;
  const 优先级 = config?.优先级 ?? 3;
  const 文字列表 = config?.段落文字;

  const 主背景 = createFrame({
    type: FrameType.BACKDROP,
    name: "BJtietu",
    parent: DzGetGameUI(),
    template: "template",
    visible: 可见,
  });
  if (主背景 === null) return null;
  DzFrameSetPriority(主背景, 优先级);

  const 贴图组: number[] = [];
  for (let i = 0; i < 贴图数量; i++) {
    const 索引 = i + 1;
    const 贴图 = createFrame({
      type: FrameType.BACKDROP,
      name: `BJtietu_map${索引}`,
      parent: 主背景,
      template: "template",
      visible: true,
    });
    if (贴图 !== null) {
      const 路径 = `war3mapImported\\BJtietu0${索引}.tga`;
      setFrameTexture(贴图, 路径);
      const pos: PositionConfig = { point: FramePoint.CENTER, x: 计算贴图X(索引), y: 计算贴图Y(索引) };
      setFramePosition(贴图, pos);
      setFrameSize(贴图, { width: 每张贴图宽度, height: 每张贴图高度 });
    }
    贴图组[i] = 贴图 ?? 0;
  }

  const 段落组: number[] = [];
  for (let i = 0; i < 段落数; i++) {
    const 索引 = i + 1;
    const 段落 = createFrame({
      type: FrameType.TEXT,
      name: `BJtietu_text${索引}`,
      parent: 主背景,
      template: "template",
      visible: true,
    });
    if (段落 !== null) {
      const y = 0.5293128 - 段落间距 * 索引;
      const pos: PositionConfig = { point: FramePoint.CENTER, x: 段落X, y };
      setFramePosition(段落, pos);
      setFrameSize(段落, { width: 段落宽度, height: 段落高度 });
      DzFrameSetFont(段落, 字体, 字号, 0);
      const 初始文字 = 文字列表 != null ? 文字列表[i] ?? "" : "";
      DzFrameSetText(段落, 初始文字);
    }
    段落组[i] = 段落 ?? 0;
  }

  return { 主背景, 贴图组, 段落组 };
}

export function 设置段落文字(实例: 背景框实例, 段落索引: number, 文字: string): void {
  const 段落帧 = 实例.段落组[段落索引];
  if (段落帧 !== 0 && 段落帧 != null) {
    DzFrameSetText(段落帧, 文字);
  }
}

export function 设置背景框透明度(实例: 背景框实例, alpha: number): void {
  DzFrameSetAlpha(实例.主背景, alpha);
}

export function 显示背景框(实例: 背景框实例): void {
  showFrame(实例.主背景);
}

export function 隐藏背景框(实例: 背景框实例): void {
  hideFrame(实例.主背景);
}

export function 销毁背景框(实例: 背景框实例): void {
  for (let i = 0; i < 实例.段落组.length; i++) {
    const 段落帧 = 实例.段落组[i];
    if (段落帧 !== 0 && 段落帧 != null) {
      destroyFrame(段落帧);
    }
  }
  for (let i = 0; i < 实例.贴图组.length; i++) {
    const 贴图帧 = 实例.贴图组[i];
    if (贴图帧 !== 0 && 贴图帧 != null) {
      destroyFrame(贴图帧);
    }
  }
  destroyFrame(实例.主背景);
}
