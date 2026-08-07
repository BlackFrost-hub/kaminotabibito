/** @noSelfInFile */

const japi = require("jass.japi") as any;

import { 世界地图地点配置表, 世界地图默认未知图标 } from "./01．世界地图地点配置";
import type { 世界地图地点帧组, 世界地图帧组 } from "./00．类型定义";

const DzGetGameUI = japi.DzGetGameUI as (this: void) => number;
const DzCreateFrameByTagName = japi.DzCreateFrameByTagName as (
  this: void,
  类型: string,
  名称: string,
  父级: number,
  模板: string,
  ID: number,
) => number;
const DzFrameSetTexture = japi.DzFrameSetTexture as (this: void, 帧: number, 路径: string, flag: number) => void;
const DzFrameSetAbsolutePoint = japi.DzFrameSetAbsolutePoint as (
  this: void,
  帧: number,
  锚点: number,
  x: number,
  y: number,
) => void;
const DzFrameSetPoint = japi.DzFrameSetPoint as (
  this: void,
  帧: number,
  锚点: number,
  相对帧: number,
  相对锚点: number,
  x: number,
  y: number,
) => void;
const DzFrameSetSize = japi.DzFrameSetSize as (this: void, 帧: number, 宽: number, 高: number) => void;
const DzFrameShow = japi.DzFrameShow as (this: void, 帧: number, 显示: boolean) => void;
const DzFrameSetText = japi.DzFrameSetText as (this: void, 帧: number, 文本: string) => void;
const DzFrameSetPriority = japi.DzFrameSetPriority as (this: void, 帧: number, 优先级: number) => void;
const DzFrameSetFont = japi.DzFrameSetFont as (
  this: void,
  帧: number,
  字体路径: string,
  字号: number,
  flag: number,
) => void;

const 中心锚点 = 4;

export const 世界地图帧: 世界地图帧组 = {
  入口图标: 0,
  入口提示: 0,
  放大图标: 0,
  地图根帧: 0,
  地点帧组表: [],
};

let 世界地图界面已初始化 = false;

function 创建入口图标(this: void, 游戏界面: number): void {
  const 入口图标 = DzCreateFrameByTagName("BACKDROP", "name", 游戏界面, "template", 0);
  DzFrameSetTexture(入口图标, "war3mapImported\\worldmap.tga", 0);
  DzFrameSetAbsolutePoint(入口图标, 中心锚点, 0.562708, 0.1552308);
  DzFrameSetSize(入口图标, 0.04, 0.025);
  DzFrameShow(入口图标, true);
  世界地图帧.入口图标 = 入口图标;

  const 入口提示 = DzCreateFrameByTagName("TEXT", "主线任务提示文本", 入口图标, "template", 0);
  DzFrameSetAbsolutePoint(入口提示, 中心锚点, 0.5463336, 0.1555134);
  DzFrameSetText(入口提示, "M");
  世界地图帧.入口提示 = 入口提示;

  const 放大图标 = DzCreateFrameByTagName("BACKDROP", "name", 游戏界面, "template", 0);
  DzFrameSetTexture(放大图标, "war3mapImported\\worldmap.tga", 0);
  DzFrameSetAbsolutePoint(放大图标, 中心锚点, 0.562708, 0.1552308);
  DzFrameSetSize(放大图标, 0.05, 0.03125);
  DzFrameShow(放大图标, false);
  世界地图帧.放大图标 = 放大图标;
}

function 创建地图底图(this: void, 地图根帧: number): void {
  for (let 序号 = 1; 序号 <= 8; 序号++) {
    const 底图 = DzCreateFrameByTagName("BACKDROP", "name", 地图根帧, "template", 0);
    DzFrameSetTexture(底图, "war3mapImported\\map0" + tostring(序号) + ".blp", 0);
    if (序号 <= 4) {
      DzFrameSetAbsolutePoint(底图, 中心锚点, -0.1 + 0.2 * 序号, 0.4249764);
    } else {
      DzFrameSetAbsolutePoint(底图, 中心锚点, -0.9 + 0.2 * 序号, 0.1422246);
    }
    DzFrameSetSize(底图, 0.2, 0.2844486);
  }
}

function 创建地点帧(this: void, 地图根帧: number, 配置索引: number): 世界地图地点帧组 {
  const 配置 = 世界地图地点配置表[配置索引];
  const 按钮 = DzCreateFrameByTagName("GLUETEXTBUTTON", "主线按钮", 地图根帧, "template", 0);
  DzFrameSetSize(按钮, 0.03, 0.03);
  DzFrameSetAbsolutePoint(按钮, 中心锚点, 配置.按钮X, 配置.按钮Y);

  const 文本框 = DzCreateFrameByTagName("BACKDROP", "主线任务文本框", 按钮, "template", 0);
  DzFrameSetTexture(文本框, "war3mapImported\\wenbenkuang2.blp", 0);
  DzFrameSetSize(文本框, 0.12, 0.2);
  DzFrameSetPoint(文本框, 中心锚点, 按钮, 中心锚点, 0.05, 0.05);
  DzFrameShow(文本框, false);
  DzFrameSetPriority(文本框, 1);

  const 提示文本 = DzCreateFrameByTagName("TEXT", "主线任务提示文本", 文本框, "template", 0);
  DzFrameSetPoint(提示文本, 中心锚点, 文本框, 中心锚点, 0, 0.02);
  DzFrameSetText(提示文本, 配置.初始提示);

  const 图标 = DzCreateFrameByTagName("BACKDROP", "name", 文本框, "template", 0);
  DzFrameSetTexture(图标, 配置.初始图标 ?? 世界地图默认未知图标, 0);
  DzFrameSetPoint(图标, 中心锚点, 按钮, 中心锚点, 0.015, 0.12);
  DzFrameSetSize(图标, 0.02, 0.02);

  const 当前位置箭头 = DzCreateFrameByTagName("BACKDROP", "name", 按钮, "template", 0);
  DzFrameSetTexture(当前位置箭头, "war3mapImported\\TB-jiantouweizhi.tga", 0);
  DzFrameSetSize(当前位置箭头, 0.0135, 0.0191);
  DzFrameShow(当前位置箭头, false);
  DzFrameSetPriority(当前位置箭头, 0);
  if (配置.箭头X != null && 配置.箭头Y != null) {
    DzFrameSetAbsolutePoint(当前位置箭头, 中心锚点, 配置.箭头X, 配置.箭头Y);
  }

  return { 按钮, 文本框, 提示文本, 图标, 当前位置箭头 };
}

export function 获取世界地图地点帧(this: void, 地点ID: number): 世界地图地点帧组 | undefined {
  if (地点ID <= 0) return undefined;
  return 世界地图帧.地点帧组表[地点ID - 1];
}

export function 更新世界地图地点显示(this: void, 地点ID: number, 提示: string, 图标路径: string): void {
  const 地点帧 = 获取世界地图地点帧(地点ID);
  if (地点帧 == null) return;
  DzFrameSetText(地点帧.提示文本, 提示);
  DzFrameSetTexture(地点帧.图标, 图标路径, 0);
}

export function 初始化世界地图界面(this: void): void {
  if (世界地图界面已初始化) return;
  世界地图界面已初始化 = true;

  const 游戏界面 = DzGetGameUI();
  创建入口图标(游戏界面);

  const 地图根帧 = DzCreateFrameByTagName("BACKDROP", "name", 游戏界面, "template", 0);
  世界地图帧.地图根帧 = 地图根帧;
  DzFrameShow(地图根帧, true);
  DzFrameShow(地图根帧, false);

  const 地图提示 = DzCreateFrameByTagName("TEXT", "文本A", 地图根帧, "template", 0);
  DzFrameSetAbsolutePoint(地图提示, 中心锚点, 0.4, 0.5);
  DzFrameSetText(地图提示, "|cffff0000地图提示|r|cff000000：脱战状态下，『双击已激活的城镇』可以快速传送！|r");
  DzFrameSetPriority(地图提示, 1);
  DzFrameSetFont(地图提示, "war3mapImported\\uizt.ttf", 20, 0);

  创建地图底图(地图根帧);
  for (let 配置索引 = 0; 配置索引 < 世界地图地点配置表.length; 配置索引++) {
    世界地图帧.地点帧组表.push(创建地点帧(地图根帧, 配置索引));
  }
}

