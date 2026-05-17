/** @noSelfInFile */
/**
 * 吟唱条系统 - UI创建（单壳复用）
 */

const japi = require("jass.japi") as any;

const 常量 = require("./00．常量定义") as {
  锚点CENTER: number;
  UI坐标X: number;
  UI坐标Y: number;
  框架名_前景: string;
  框架名_背景: string;
  框架名_标题: string;
  框架名_进度: string;
  框架名_分隔符: string;
  框架名_时间: string;
  框架名_提示: string;
  默认标题文本: string;
  默认提示文本: string;
  分隔符文本: string;
  获取前景模型: (颜色ID: number) => string;
  获取背景模型: (颜色ID: number) => string;
};

const 获取前景模型 = (颜色ID: number): string => 常量.获取前景模型(颜色ID);
const 获取背景模型 = (颜色ID: number): string => 常量.获取背景模型(颜色ID);

const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (frame: any, point: number, x: number, y: number) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (frame: any, point: number, relativeFrame: any, relativePoint: number, x: number, y: number) => void;
const DzFrameSetText = japi.DzFrameSetText as (frame: any, text: string) => void;
const DzFrameSetModel = japi.DzFrameSetModel as (frame: any, model: string, modelType: number, flag: number) => void;
const DzFrameSetAnimate = japi.DzFrameSetAnimate as (frame: any, animId: number, auto: boolean) => void;
const DzFrameSetAnimateOffset = japi.DzFrameSetAnimateOffset as (frame: any, offset: number) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (frame: any, priority: number) => void;
const DzFrameShow = japi.DzFrameShow as (frame: any, show: boolean) => void;
const DzGetGameUI = japi.DzGetGameUI as () => any;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (type: string, name: string, parent: any, own: string, id: number) => any;

interface 吟唱条UI {
  前景: any;
  背景: any;
  标题: any;
  进度: any;
  分隔符: any;
  时间: any;
  提示: any;
}

let 吟唱条UI实例: 吟唱条UI | null = null;

const 锚点TOPLEFT = 0;
const 背景层级 = 0;
const 文字层级 = 2;
function 初始化文本框(this: void, frame: any): void {
  DzFrameSetPriority(frame, 文字层级);
}

export function 创建吟唱条UI(this: void): 吟唱条UI {
  if (吟唱条UI实例 != null) {
    return 吟唱条UI实例;
  }

  const 父级 = DzGetGameUI();

  const 前景 = DzCreateFrameByTagName("SPRITE", 常量.框架名_前景, 父级, "template", 0);
  DzFrameSetAbsolutePoint(前景, 常量.锚点CENTER, 常量.UI坐标X, 常量.UI坐标Y);
  DzFrameSetAnimate(前景, 0, false);
  DzFrameSetAnimateOffset(前景, 1.0);

  const 背景 = DzCreateFrameByTagName("SPRITE", 常量.框架名_背景, 前景, "template", 0);
  DzFrameSetAbsolutePoint(背景, 常量.锚点CENTER, 常量.UI坐标X, 常量.UI坐标Y);
  DzFrameSetPriority(背景, 背景层级);

  const 标题 = DzCreateFrameByTagName("TEXT", 常量.框架名_标题, 前景, "template", 0);
  DzFrameSetPoint(标题, 常量.锚点CENTER, 前景, 常量.锚点CENTER, -0.148, 0.020);
  DzFrameSetText(标题, 常量.默认标题文本);
  初始化文本框(标题);

  const 进度 = DzCreateFrameByTagName("TEXT", 常量.框架名_进度, 前景, "template", 0);
  DzFrameSetPoint(进度, 常量.锚点CENTER, 前景, 常量.锚点CENTER, -0.162, 0.005);
  初始化文本框(进度);

  const 分隔符 = DzCreateFrameByTagName("TEXT", 常量.框架名_分隔符, 前景, "template", 0);
  DzFrameSetPoint(分隔符, 常量.锚点CENTER, 前景, 常量.锚点CENTER, -0.150, 0.005);
  DzFrameSetText(分隔符, 常量.分隔符文本);
  初始化文本框(分隔符);

  const 时间 = DzCreateFrameByTagName("TEXT", 常量.框架名_时间, 前景, "template", 0);
  DzFrameSetPoint(时间, 常量.锚点CENTER, 前景, 常量.锚点CENTER, -0.138, 0.005);
  初始化文本框(时间);

  const 提示 = DzCreateFrameByTagName("TEXT", 常量.框架名_提示, 前景, "template", 0);
  DzFrameSetPoint(提示, 常量.锚点CENTER, 前景, 锚点TOPLEFT, -0.120, 0.005);
  DzFrameSetText(提示, 常量.默认提示文本);
  初始化文本框(提示);

  吟唱条UI实例 = {
    前景,
    背景,
    标题,
    进度,
    分隔符,
    时间,
    提示,
  };

  隐藏吟唱条UI();
  return 吟唱条UI实例;
}

export function 隐藏吟唱条UI(this: void): void {
  if (吟唱条UI实例 == null) return;
  DzFrameShow(吟唱条UI实例.前景, false);
  DzFrameShow(吟唱条UI实例.标题, false);
  DzFrameShow(吟唱条UI实例.进度, false);
  DzFrameShow(吟唱条UI实例.分隔符, false);
  DzFrameShow(吟唱条UI实例.时间, false);
  DzFrameShow(吟唱条UI实例.提示, false);
}

export function 显示吟唱条UI(this: void): void {
  if (吟唱条UI实例 == null) {
    创建吟唱条UI();
  }
  if (吟唱条UI实例 != null) {
    DzFrameShow(吟唱条UI实例.前景, true);
    DzFrameShow(吟唱条UI实例.背景, true);
    DzFrameShow(吟唱条UI实例.标题, true);
    DzFrameShow(吟唱条UI实例.进度, true);
    DzFrameShow(吟唱条UI实例.分隔符, true);
    DzFrameShow(吟唱条UI实例.时间, true);
    DzFrameShow(吟唱条UI实例.提示, true);
  }
}

export function 更新吟唱条模型(this: void, 颜色ID: number): void {
  if (吟唱条UI实例 == null) return;
  DzFrameSetModel(吟唱条UI实例.前景, 获取前景模型(颜色ID), 0, 0);
  DzFrameSetModel(吟唱条UI实例.背景, 获取背景模型(颜色ID), 0, 0);
  DzFrameSetAbsolutePoint(吟唱条UI实例.前景, 常量.锚点CENTER, 常量.UI坐标X, 常量.UI坐标Y);
  DzFrameSetAbsolutePoint(吟唱条UI实例.背景, 常量.锚点CENTER, 常量.UI坐标X, 常量.UI坐标Y);
  DzFrameSetPriority(吟唱条UI实例.背景, 背景层级);
  DzFrameSetAnimate(吟唱条UI实例.前景, 0, false);
  DzFrameSetAnimateOffset(吟唱条UI实例.前景, 0.90);
}

export function 更新吟唱条文本(this: void, 标题文本: string, 提示文本: string): void {
  if (吟唱条UI实例 == null) return;
  DzFrameSetText(吟唱条UI实例.标题, 标题文本);
  DzFrameSetText(吟唱条UI实例.提示, 提示文本);
}

export function 更新吟唱条数值(this: void, 已过秒: string, 剩余秒: string): void {
  if (吟唱条UI实例 == null) return;
  DzFrameSetText(吟唱条UI实例.进度, 已过秒);
  DzFrameSetText(吟唱条UI实例.时间, 剩余秒);
}

export function 设置吟唱条动画进度(this: void, 进度: number): void {
  if (吟唱条UI实例 == null) return;
  if (进度 < 0) 进度 = 0;
  if (进度 > 1) 进度 = 1;
  DzFrameSetAnimateOffset(吟唱条UI实例.前景, 1.0 - 进度);
}
