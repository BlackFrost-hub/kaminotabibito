/** @noSelfInFile */
/**
 * 吟唱条系统 - UI创建（单壳复用）
 */

const japi = require("jass.japi") as any;

const 常量 = require("./00．常量定义") as {
  锚点CENTER: number;
  UI坐标X: number;
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
  吟唱条通道_常规技能: string;
  吟唱条通道_大招: string;
  吟唱条通道_场地常驻AOE: string;
  吟唱条通道_致命惩罚: string;
  吟唱条通道_场地AOE: string;
};

const { 获取前景模型, 获取背景模型, 获取通道Y坐标, 获取通道框架名 } = require("./00．常量定义") as {
  获取前景模型: (this: void, 颜色ID: number) => string;
  获取背景模型: (this: void, 颜色ID: number) => string;
  获取通道Y坐标: (this: void, 通道: string) => number;
  获取通道框架名: (this: void, 基础名: string, 通道: string) => string;
};

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

let 常规技能吟唱条UI实例: 吟唱条UI | null = null;
let 大招吟唱条UI实例: 吟唱条UI | null = null;
let 场地常驻AOE吟唱条UI实例: 吟唱条UI | null = null;
let 致命惩罚吟唱条UI实例: 吟唱条UI | null = null;

const 锚点TOPLEFT = 0;
const 背景层级 = 0;
const 文字层级 = 2;
function 初始化文本框(this: void, frame: any): void {
  DzFrameSetPriority(frame, 文字层级);
}

function 获取吟唱条UI实例(this: void, 通道: string): 吟唱条UI | null {
  if (通道 === 常量.吟唱条通道_致命惩罚) return 致命惩罚吟唱条UI实例;
  if (通道 === 常量.吟唱条通道_场地常驻AOE) return 场地常驻AOE吟唱条UI实例;
  if (通道 === 常量.吟唱条通道_大招 || 通道 === 常量.吟唱条通道_场地AOE) return 大招吟唱条UI实例;
  return 常规技能吟唱条UI实例;
}

function 保存吟唱条UI实例(this: void, 通道: string, UI实例: 吟唱条UI): void {
  if (通道 === 常量.吟唱条通道_致命惩罚) {
    致命惩罚吟唱条UI实例 = UI实例;
  } else if (通道 === 常量.吟唱条通道_场地常驻AOE) {
    场地常驻AOE吟唱条UI实例 = UI实例;
  } else if (通道 === 常量.吟唱条通道_大招 || 通道 === 常量.吟唱条通道_场地AOE) {
    大招吟唱条UI实例 = UI实例;
  } else {
    常规技能吟唱条UI实例 = UI实例;
  }
}

export function 创建吟唱条UI(this: void, 通道 = 常量.吟唱条通道_常规技能): 吟唱条UI {
  const 已有UI = 获取吟唱条UI实例(通道);
  if (已有UI != null) return 已有UI;

  const 父级 = DzGetGameUI();
  const y = 获取通道Y坐标(通道);

  const 前景 = DzCreateFrameByTagName("SPRITE", 获取通道框架名(常量.框架名_前景, 通道), 父级, "template", 0);
  DzFrameSetAbsolutePoint(前景, 常量.锚点CENTER, 常量.UI坐标X, y);
  DzFrameSetAnimate(前景, 0, false);
  DzFrameSetAnimateOffset(前景, 1.0);

  const 背景 = DzCreateFrameByTagName("SPRITE", 获取通道框架名(常量.框架名_背景, 通道), 前景, "template", 0);
  DzFrameSetAbsolutePoint(背景, 常量.锚点CENTER, 常量.UI坐标X, y);
  DzFrameSetPriority(背景, 背景层级);

  const 标题 = DzCreateFrameByTagName("TEXT", 获取通道框架名(常量.框架名_标题, 通道), 前景, "template", 0);
  DzFrameSetPoint(标题, 常量.锚点CENTER, 前景, 常量.锚点CENTER, -0.148, 0.020);
  DzFrameSetText(标题, 常量.默认标题文本);
  初始化文本框(标题);

  const 进度 = DzCreateFrameByTagName("TEXT", 获取通道框架名(常量.框架名_进度, 通道), 前景, "template", 0);
  DzFrameSetPoint(进度, 常量.锚点CENTER, 前景, 常量.锚点CENTER, -0.162, 0.005);
  初始化文本框(进度);

  const 分隔符 = DzCreateFrameByTagName("TEXT", 获取通道框架名(常量.框架名_分隔符, 通道), 前景, "template", 0);
  DzFrameSetPoint(分隔符, 常量.锚点CENTER, 前景, 常量.锚点CENTER, -0.150, 0.005);
  DzFrameSetText(分隔符, 常量.分隔符文本);
  初始化文本框(分隔符);

  const 时间 = DzCreateFrameByTagName("TEXT", 获取通道框架名(常量.框架名_时间, 通道), 前景, "template", 0);
  DzFrameSetPoint(时间, 常量.锚点CENTER, 前景, 常量.锚点CENTER, -0.138, 0.005);
  初始化文本框(时间);

  const 提示 = DzCreateFrameByTagName("TEXT", 获取通道框架名(常量.框架名_提示, 通道), 前景, "template", 0);
  DzFrameSetPoint(提示, 常量.锚点CENTER, 前景, 锚点TOPLEFT, -0.120, 0.005);
  DzFrameSetText(提示, 常量.默认提示文本);
  初始化文本框(提示);

  const UI实例 = {
    前景,
    背景,
    标题,
    进度,
    分隔符,
    时间,
    提示,
  };
  保存吟唱条UI实例(通道, UI实例);

  隐藏吟唱条UI(通道);
  return UI实例;
}

export function 隐藏吟唱条UI(this: void, 通道 = 常量.吟唱条通道_常规技能): void {
  const UI实例 = 获取吟唱条UI实例(通道);
  if (UI实例 == null) return;
  DzFrameShow(UI实例.前景, false);
  DzFrameShow(UI实例.背景, false);
  DzFrameShow(UI实例.标题, false);
  DzFrameShow(UI实例.进度, false);
  DzFrameShow(UI实例.分隔符, false);
  DzFrameShow(UI实例.时间, false);
  DzFrameShow(UI实例.提示, false);
}

export function 显示吟唱条UI(this: void, 通道 = 常量.吟唱条通道_常规技能): void {
  let UI实例 = 获取吟唱条UI实例(通道);
  if (UI实例 == null) {
    UI实例 = 创建吟唱条UI(通道);
  }
  DzFrameShow(UI实例.前景, true);
  DzFrameShow(UI实例.背景, true);
  DzFrameShow(UI实例.标题, true);
  DzFrameShow(UI实例.进度, true);
  DzFrameShow(UI实例.分隔符, true);
  DzFrameShow(UI实例.时间, true);
  DzFrameShow(UI实例.提示, true);
}

export function 更新吟唱条模型(this: void, 通道: string, 颜色ID: number): void {
  const UI实例 = 获取吟唱条UI实例(通道);
  if (UI实例 == null) return;
  const y = 获取通道Y坐标(通道);
  DzFrameSetModel(UI实例.前景, 获取前景模型(颜色ID), 0, 0);
  DzFrameSetModel(UI实例.背景, 获取背景模型(颜色ID), 0, 0);
  DzFrameSetAbsolutePoint(UI实例.前景, 常量.锚点CENTER, 常量.UI坐标X, y);
  DzFrameSetAbsolutePoint(UI实例.背景, 常量.锚点CENTER, 常量.UI坐标X, y);
  DzFrameSetPriority(UI实例.背景, 背景层级);
  DzFrameSetAnimate(UI实例.前景, 0, false);
  DzFrameSetAnimateOffset(UI实例.前景, 0.90);
}

export function 更新吟唱条文本(this: void, 通道: string, 标题文本: string, 提示文本: string): void {
  const UI实例 = 获取吟唱条UI实例(通道);
  if (UI实例 == null) return;
  DzFrameSetText(UI实例.标题, 标题文本);
  DzFrameSetText(UI实例.提示, 提示文本);
}

export function 更新吟唱条数值(this: void, 通道: string, 已过秒: string, 剩余秒: string): void {
  const UI实例 = 获取吟唱条UI实例(通道);
  if (UI实例 == null) return;
  DzFrameSetText(UI实例.进度, 已过秒);
  DzFrameSetText(UI实例.时间, 剩余秒);
}

export function 设置吟唱条动画进度(this: void, 通道: string, 进度: number): void {
  const UI实例 = 获取吟唱条UI实例(通道);
  if (UI实例 == null) return;
  if (进度 < 0) 进度 = 0;
  if (进度 > 1) 进度 = 1;
  DzFrameSetAnimateOffset(UI实例.前景, 1.0 - 进度);
}
