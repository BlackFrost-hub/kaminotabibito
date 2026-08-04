/** @noSelfInFile */

const jass = require("jass.common") as any;
const { addPeriodicCallback, removePeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: () => void) => number;
  removePeriodicCallback: (this: void, id: number) => void;
};

const R2I = jass.R2I as (this: void, r: number) => number;

import type { 世界地图单位缓步创建状态, 世界地图单位缓步创建选项 } from "./00．开关与类型";
import { 世界地图杂鱼出生配置表, 世界地图杂鱼默认缓步创建选项 } from "./01．杂鱼出生配置";
import { 世界地图精英出生配置表, 世界地图精英默认缓步创建选项 } from "./02．精英出生配置";
import { 路人NPC出生配置表, 路人NPC默认缓步创建选项 } from "./03．路人NPC出生配置";
import { 世界地图商人出生配置表, 世界地图商人默认缓步创建选项 } from "./04．商人出生配置";
import {
  获取世界地图单位缓步创建任务状态,
  启动世界地图单位缓步创建任务,
  停止世界地图单位缓步创建任务,
} from "./20．世界地图单位缓步创建";

export interface 世界地图单位总调度选项 {
  杂鱼选项?: 世界地图单位缓步创建选项;
  精英选项?: 世界地图单位缓步创建选项;
  路人NPC选项?: 世界地图单位缓步创建选项;
  商人选项?: 世界地图单位缓步创建选项;
  监视间隔秒?: number;
  完成回调?: (this: void) => void;
}

export interface 世界地图单位总调度状态 {
  当前阶段: "未启动" | "杂鱼" | "杂鱼+精英" | "NPC" | "商人" | "完成";
  是否运行中: boolean;
  杂鱼总数: number;
  杂鱼已创建数: number;
  精英总数: number;
  精英已创建数: number;
  NPC总数: number;
  NPC已创建数: number;
  商人总数: number;
  商人已创建数: number;
}

const 空状态: 世界地图单位总调度状态 = {
  当前阶段: "未启动",
  是否运行中: false,
  杂鱼总数: 世界地图杂鱼出生配置表.length,
  杂鱼已创建数: 0,
  精英总数: 世界地图精英出生配置表.length,
  精英已创建数: 0,
  NPC总数: 路人NPC出生配置表.length,
  NPC已创建数: 0,
  商人总数: 世界地图商人出生配置表.length,
  商人已创建数: 0,
};

export const 世界地图单位总调度默认选项: 世界地图单位总调度选项 = {
  杂鱼选项: 世界地图杂鱼默认缓步创建选项,
  精英选项: 世界地图精英默认缓步创建选项,
  路人NPC选项: 路人NPC默认缓步创建选项,
  监视间隔秒: 0.1,
};

let 当前状态: 世界地图单位总调度状态 = { ...空状态 };
let 当前杂鱼任务ID: number | undefined;
let 当前精英任务ID: number | undefined;
let 当前路人NPC任务ID: number | undefined;
let 当前商人任务ID: number | undefined;
let 监视回调ID: number | undefined;
let 精英已启动 = false;
let 路人NPC已启动 = false;
let 商人已启动 = false;
let 杂鱼已完成 = false;
let 精英已完成 = false;
let 路人NPC已完成 = false;
let 商人已完成 = false;
let 全部创建完成回调: ((this: void) => void) | undefined;
let 全部创建完成回调已触发 = false;
let 当前精英选项: 世界地图单位缓步创建选项 | undefined;
let 当前路人NPC选项: 世界地图单位缓步创建选项 | undefined;
let 当前商人选项: 世界地图单位缓步创建选项 | undefined;

function 创建状态副本(this: void): 世界地图单位总调度状态 {
  return { ...当前状态 };
}

function 重置总调度(this: void): void {
  当前状态 = { ...空状态 };
  当前杂鱼任务ID = undefined;
  当前精英任务ID = undefined;
  当前路人NPC任务ID = undefined;
  当前商人任务ID = undefined;
  精英已启动 = false;
  路人NPC已启动 = false;
  商人已启动 = false;
  杂鱼已完成 = false;
  精英已完成 = false;
  路人NPC已完成 = false;
  商人已完成 = false;
  全部创建完成回调 = undefined;
  全部创建完成回调已触发 = false;
  当前精英选项 = undefined;
  当前路人NPC选项 = undefined;
  当前商人选项 = undefined;
}

function 停止总调度监视(this: void): void {
  if (监视回调ID == null) return;
  removePeriodicCallback(监视回调ID);
  监视回调ID = undefined;
}

function 停止任务(this: void, 任务ID: number | undefined): void {
  if (任务ID == null) return;
  停止世界地图单位缓步创建任务(任务ID);
}

function 读取任务状态(this: void, 任务ID: number | undefined): 世界地图单位缓步创建状态 | undefined {
  if (任务ID == null) return undefined;
  return 获取世界地图单位缓步创建任务状态(任务ID);
}

function 刷新单个任务进度(
  this: void,
  任务ID: number | undefined,
  总数: number,
  写入函数: (this: void, value: number) => void,
): void {
  const 状态 = 读取任务状态(任务ID);
  if (状态 == null) return;
  if (状态.总数 <= 0 && 状态.运行中 !== true) return;
  写入函数(状态.已创建数量 > 总数 ? 总数 : 状态.已创建数量);
}

function 写入杂鱼已创建数(this: void, value: number): void {
  当前状态.杂鱼已创建数 = value;
}

function 写入精英已创建数(this: void, value: number): void {
  当前状态.精英已创建数 = value;
}

function 写入路人NPC已创建数(this: void, value: number): void {
  当前状态.NPC已创建数 = value;
}

function 写入商人已创建数(this: void, value: number): void {
  当前状态.商人已创建数 = value;
}

function 杂鱼完成回调(this: void, 已创建数量: number): void {
  杂鱼已完成 = true;
  当前杂鱼任务ID = undefined;
  当前状态.杂鱼已创建数 = 已创建数量;
}

function 精英完成回调(this: void, 已创建数量: number): void {
  精英已完成 = true;
  当前精英任务ID = undefined;
  当前状态.精英已创建数 = 已创建数量;
}

function 路人NPC完成回调(this: void, 已创建数量: number): void {
  路人NPC已完成 = true;
  当前路人NPC任务ID = undefined;
  当前状态.NPC已创建数 = 已创建数量;
}

function 商人完成回调(this: void, 已创建数量: number): void {
  商人已完成 = true;
  当前商人任务ID = undefined;
  当前状态.商人已创建数 = 已创建数量;
}

function 启动精英阶段(this: void): void {
  if (精英已启动) return;
  精英已启动 = true;
  当前状态.当前阶段 = "杂鱼+精英";
  当前精英任务ID = 启动世界地图单位缓步创建任务(世界地图精英出生配置表, {
    ...世界地图精英默认缓步创建选项,
    ...当前精英选项,
    完成回调: 精英完成回调,
  });
}

function 启动路人NPC阶段(this: void): void {
  if (路人NPC已启动) return;
  路人NPC已启动 = true;
  当前状态.当前阶段 = "NPC";
  当前路人NPC任务ID = 启动世界地图单位缓步创建任务(路人NPC出生配置表, {
    ...路人NPC默认缓步创建选项,
    ...当前路人NPC选项,
    完成回调: 路人NPC完成回调,
  });
}

function 启动商人阶段(this: void): void {
  if (商人已启动) return;
  商人已启动 = true;
  当前状态.当前阶段 = "商人";
  当前商人任务ID = 启动世界地图单位缓步创建任务(世界地图商人出生配置表, {
    ...世界地图商人默认缓步创建选项,
    ...当前商人选项,
    完成回调: 商人完成回调,
  });
}

function 刷新全部进度(this: void): void {
  刷新单个任务进度(当前杂鱼任务ID, 当前状态.杂鱼总数, 写入杂鱼已创建数);
  刷新单个任务进度(当前精英任务ID, 当前状态.精英总数, 写入精英已创建数);
  刷新单个任务进度(当前路人NPC任务ID, 当前状态.NPC总数, 写入路人NPC已创建数);
  刷新单个任务进度(当前商人任务ID, 当前状态.商人总数, 写入商人已创建数);
}

function 杂鱼已进入最后二成(this: void): boolean {
  if (当前状态.杂鱼总数 <= 0) return true;
  if (杂鱼已完成) return true;

  const 状态 = 读取任务状态(当前杂鱼任务ID);
  if (状态 == null || 状态.总数 <= 0) return false;

  return 状态.当前索引 * 5 >= 状态.总数 * 4;
}

function 全部完成(this: void): boolean {
  return 杂鱼已完成 && 精英已完成 && 路人NPC已完成 && 商人已完成;
}

function 总调度监视回调(this: void): void {
  if (当前状态.是否运行中 !== true) {
    停止总调度监视();
    return;
  }

  刷新全部进度();

  if (!精英已启动 && 杂鱼已进入最后二成()) {
    启动精英阶段();
  }

  if (!路人NPC已启动 && 精英已完成) {
    启动路人NPC阶段();
  }

  if (!商人已启动 && 路人NPC已完成) {
    启动商人阶段();
  }

  if (全部完成()) {
    当前状态.当前阶段 = "完成";
    当前状态.是否运行中 = false;
    停止总调度监视();
    if (!全部创建完成回调已触发) {
      全部创建完成回调已触发 = true;
      const 完成回调 = 全部创建完成回调;
      全部创建完成回调 = undefined;
      if (typeof 完成回调 === "function") {
        完成回调();
      }
    }
  }
}

function 启动总调度监视(this: void, 间隔秒: number): void {
  停止总调度监视();
  const 间隔毫秒 = 间隔秒 <= 0 ? 100 : R2I(间隔秒 * 1000);
  监视回调ID = addPeriodicCallback(间隔毫秒, 总调度监视回调);
}

export function 获取世界地图全部单位创建状态(this: void): 世界地图单位总调度状态 {
  return 创建状态副本();
}

export function 停止世界地图全部单位缓步创建(this: void): void {
  停止总调度监视();
  停止任务(当前杂鱼任务ID);
  停止任务(当前精英任务ID);
  停止任务(当前路人NPC任务ID);
  停止任务(当前商人任务ID);
  当前状态.是否运行中 = false;
}

export function 启动世界地图全部单位缓步创建(this: void, 选项?: 世界地图单位总调度选项): 世界地图单位总调度状态 {
  const 已合并选项: 世界地图单位总调度选项 = {
    ...世界地图单位总调度默认选项,
    ...选项,
  };

  停止世界地图全部单位缓步创建();
  重置总调度();
  当前状态.是否运行中 = true;
  当前状态.当前阶段 = "杂鱼";
  全部创建完成回调 = 已合并选项.完成回调;
  当前精英选项 = 已合并选项.精英选项;
  当前路人NPC选项 = 已合并选项.路人NPC选项;
  当前商人选项 = 已合并选项.商人选项;

  当前杂鱼任务ID = 启动世界地图单位缓步创建任务(世界地图杂鱼出生配置表, {
    ...世界地图杂鱼默认缓步创建选项,
    ...已合并选项.杂鱼选项,
    完成回调: 杂鱼完成回调,
  });

  if (当前状态.精英总数 <= 0) {
    精英已完成 = true;
  }
  if (当前状态.NPC总数 <= 0) {
    路人NPC已完成 = true;
  }
  if (当前状态.商人总数 <= 0) {
    商人已完成 = true;
  }

  启动总调度监视(已合并选项.监视间隔秒 ?? 0.1);
  return 创建状态副本();
}
