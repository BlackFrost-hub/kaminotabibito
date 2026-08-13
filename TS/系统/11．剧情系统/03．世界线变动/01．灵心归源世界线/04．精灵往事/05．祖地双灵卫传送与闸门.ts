/** @noSelfInFile */

import { 祖地双灵卫副本配置 } from "./01．祖地双灵卫副本配置";
import { 祖地双灵卫副本状态 } from "./02．祖地双灵卫副本状态";
import { register祖地双灵卫试炼全部完成Listener } from "./03．祖地双灵卫试炼";

const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as any;

const { 创建矩形进入监听 } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  创建矩形进入监听: (this: void, rect: any, callback: (this: void) => void, filter?: any) => { 区域: any; 触发器: any; 取消: (this: void) => void } | null;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
};
const { ModifyGateBJ } = require("lib.扩展函数.BJ函数.07．杂项") as {
  ModifyGateBJ: (this: void, operation: number, gate: any) => void;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs?: number) => void;
};

const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const IssueImmediateOrder = jass.IssueImmediateOrder as (this: void, unit: any, order: string) => boolean;
const Rect = jass.Rect as (this: void, minX: number, minY: number, maxX: number, maxY: number) => any;
const RemoveRect = jass.RemoveRect as (this: void, rect: any) => void;
const SetUnitFacing = jass.SetUnitFacing as (this: void, unit: any, facing: number) => void;
const SetUnitPosition = jass.SetUnitPosition as (this: void, unit: any, x: number, y: number) => void;

let 传送模块已初始化 = false;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 打开祖地内门(this: void): void {
  const names = 祖地双灵卫副本配置.入口闸门变量名列表;
  for (let i = 0; i < names.length; i++) {
    const gate = jglobals[names[i]];
    if (句柄有效(gate)) ModifyGateBJ(jglobals.bj_GATEOPERATION_OPEN, gate);
  }
}

function on进入祖地双灵卫传送点(this: void): void {
  const unit = GetTriggerUnit();
  if (!句柄有效(unit) || !是玩家英雄组单位(unit)) return;
  const cfg = 祖地双灵卫副本配置.永久传送点;
  SetUnitPosition(unit, cfg.目标X, cfg.目标Y);
  SetUnitFacing(unit, cfg.目标朝向);
  IssueImmediateOrder(unit, "stop");
}

export function 创建祖地双灵卫永久传送点(this: void): boolean {
  if (祖地双灵卫副本状态.传送点已创建) return true;
  const cfg = 祖地双灵卫副本配置.永久传送点;
  const rect = Rect(cfg.X - cfg.半径, cfg.Y - cfg.半径, cfg.X + cfg.半径, cfg.Y + cfg.半径);
  if (!句柄有效(rect)) return false;
  const 监听 = 创建矩形进入监听(rect, on进入祖地双灵卫传送点, null);
  RemoveRect(rect);
  if (监听 == null) return false;
  const effect = 创建点特效({
    模型路径: cfg.特效,
    X: cfg.X,
    Y: cfg.Y,
    Z轴角度: cfg.朝向,
    缩放: 0.75,
  });
  祖地双灵卫副本状态.传送点触发器 = 监听.触发器;
  祖地双灵卫副本状态.传送点区域 = 监听.区域;
  祖地双灵卫副本状态.传送点特效 = effect;
  祖地双灵卫副本状态.传送点已创建 = true;
  打开祖地内门();
  if (句柄有效(祖地双灵卫副本状态.埃德里安单位)) {
    广播单位提示(
      祖地双灵卫副本状态.埃德里安单位,
      "三项考验都已完成。祖地内门已经开启，传送灵阵会送你们前往双灵沉眠之处。",
      5600,
    );
  }
  return true;
}

function on祖地双灵卫试炼全部完成(this: void): void {
  创建祖地双灵卫永久传送点();
}

export function init祖地双灵卫传送与闸门(this: void): void {
  if (传送模块已初始化) return;
  传送模块已初始化 = true;
  register祖地双灵卫试炼全部完成Listener(on祖地双灵卫试炼全部完成);
}
