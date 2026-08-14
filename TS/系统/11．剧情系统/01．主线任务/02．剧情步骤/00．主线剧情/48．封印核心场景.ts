/** @noSelfInFile */

const jass = require("jass.common") as any;

const { 创建矩形进入监听 } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  创建矩形进入监听: (this: void, rect: any, callback: (this: void) => void, filter?: any) => { 取消: (this: void) => void } | null;
};
const { 获取玩家英雄单位组, 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  获取玩家英雄单位组: (this: void) => any;
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { 暂停并设置无敌安全, 解除暂停并取消无敌安全 } = require("lib.扩展函数.自定义扩展函数.06．单位状态安全包装") as {
  暂停并设置无敌安全: (this: void, unit: any, 来源: string) => boolean;
  解除暂停并取消无敌安全: (this: void, unit: any, 来源: string) => boolean;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { 闪电效果代码 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码") as {
  闪电效果代码: Record<string, string>;
};
const { 注册封印守卫战区域音乐 } = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐") as {
  注册封印守卫战区域音乐: (this: void) => boolean;
};
const { 动态矩形区域配置表, 注册动态矩形区域, 注销动态矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  动态矩形区域配置表: Record<string, { 键: string; 左: number; 右: number; 下: number; 上: number; 说明?: string }>;
  注册动态矩形区域: (this: void, 配置: { 键: string; 左: number; 右: number; 下: number; 上: number; 说明?: string }) => any;
  注销动态矩形区域: (this: void, 键: string) => boolean;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 应用第三章电影镜头 } from "./40-50．第三章电影镜头";
import { 读取语义单位引用, 设置玩家英雄组控制状态 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 清理剧情运行时单位, 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";
import { 发布主线节点目标 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 创建剧情场景单位, 定位剧情单位 } from "../../../00．公共/02．剧情NPC创建";

const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const ForGroup = jass.ForGroup as (this: void, whichGroup: any, callback: (this: void) => void) => void;
const GetEnumUnit = jass.GetEnumUnit as (this: void) => any;
const AddLightningEx = jass.AddLightningEx as (
  this: void,
  codeName: string,
  checkVisibility: boolean,
  x1: number,
  y1: number,
  z1: number,
  x2: number,
  y2: number,
  z2: number,
) => any;
const DestroyLightning = jass.DestroyLightning as (this: void, whichLightning: any) => boolean;

const 中立被动玩家ID = 15;
const 封印核心纯对白来源 = "剧情系统:封印核心纯对白";
const 封印核心入口矩形键 = "剧情.封印核心入口";

export const 封印核心场景站位表 = {
  A入口: { X: 2480.1, Y: -9696.2, 朝向: 178.32 },
  B玩家: { X: 1635.4, Y: -10330.4, 朝向: 134.20 },
  C里科特: { X: 443.5, Y: -9340.2, 朝向: 320.28 },
  D教皇: { X: 1314.7, Y: -9198.5, 朝向: 285.82 },
  E奥斯特利一世: { X: 975.9, Y: -9652.2, 朝向: 314.20 },
} as const;

export const 封印核心七色闪电配置表 = [
  { 代码: 闪电效果代码.红色光束, X: 2630.6, Y: -8719.3 },
  { 代码: 闪电效果代码.粉色光束, X: 1148.2, Y: -7998.1 },
  { 代码: 闪电效果代码.黄色光束, X: -337.3, Y: -8510.6 },
  { 代码: 闪电效果代码.黑色光束, X: -838.9, Y: -9768.8 },
  { 代码: 闪电效果代码.绿色光束, X: -377.1, Y: -10973.8 },
  { 代码: 闪电效果代码.金色光束, X: 1141.3, Y: -11431.3 },
  { 代码: 闪电效果代码.青蓝白光束, X: 2639.2, Y: -10680.0 },
] as const;

interface 封印核心场景单位记录 {
  运行时键: string;
  单位: any;
  临时创建: boolean;
}

interface 封印核心场景状态 {
  单位列表: 封印核心场景单位记录[];
  闪电列表: any[];
  已清理: boolean;
}

interface 封印核心入口监听状态 {
  取消: (this: void) => void;
  已触发: boolean;
}

let 当前封印核心场景状态: 封印核心场景状态 | undefined;
let 当前封印核心入口监听: 封印核心入口监听状态 | undefined;
let 当前玩家对白站位: typeof 封印核心场景站位表.B玩家 | undefined;
let 当前封印核心奥斯特利一世记录: 封印核心场景单位记录 | undefined;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 单位存活(this: void, unit: any): boolean {
  return 句柄有效(unit) && IsUnitAliveBJ(unit);
}

function 定位并停止单位(this: void, unit: any, 站位: { X: number; Y: number; 朝向: number }): void {
  定位剧情单位(unit, 站位);
}

function on移动玩家到对白站位(this: void): void {
  if (当前玩家对白站位 == null) return;
  定位并停止单位(GetEnumUnit(), 当前玩家对白站位);
}

function 移动玩家队伍到对白站位(this: void): void {
  const 玩家英雄组 = 获取玩家英雄单位组();
  if (!句柄有效(玩家英雄组)) return;
  当前玩家对白站位 = 封印核心场景站位表.B玩家;
  ForGroup(玩家英雄组, on移动玩家到对白站位);
  当前玩家对白站位 = undefined;
}

function 创建占位单位(this: void, 单位名: string, 站位: { X: number; Y: number; 朝向: number }): any {
  const 单位ID = 按名字反查总单位ID(单位名);
  const 单位类型ID = stringToFourCCSafe(单位ID);
  if (!(单位类型ID > 0)) return null;
  return 创建剧情场景单位({
    单位ID: 单位ID!,
    X: 站位.X,
    Y: 站位.Y,
    朝向: 站位.朝向,
    玩家ID: 中立被动玩家ID,
    登记死亡排泄: true,
  });
}

function 读取或创建场景单位(
  this: void,
  读取引用: string,
  运行时键: string,
  占位单位名: string,
  站位: { X: number; Y: number; 朝向: number },
): 封印核心场景单位记录 | undefined {
  let unit = 读取语义单位引用(读取引用);
  let 临时创建 = false;
  if (!单位存活(unit)) {
    unit = 创建占位单位(占位单位名, 站位);
    临时创建 = true;
  }
  if (!单位存活(unit)) return undefined;

  定位并停止单位(unit, 站位);
  暂停并设置无敌安全(unit, `${封印核心纯对白来源}:${运行时键}`);
  注册剧情运行时单位(运行时键, unit);
  return { 运行时键, 单位: unit, 临时创建 };
}

function 创建封印核心场景单位(this: void, 状态: 封印核心场景状态): boolean {
  const 里科特 = 读取或创建场景单位(
    "Boss.里科特",
    "剧情运行时.封印核心里科特",
    "里科特",
    封印核心场景站位表.C里科特,
  );
  if (里科特 == null) return false;
  状态.单位列表.push(里科特);

  const 教皇 = 读取或创建场景单位(
    "主线NPC.封印核心教皇",
    "剧情运行时.封印核心教皇",
    "精灵审判官",
    封印核心场景站位表.D教皇,
  );
  if (教皇 == null) return false;
  状态.单位列表.push(教皇);

  const 奥斯特利一世 = 读取或创建场景单位(
    "主线NPC.封印核心奥斯特利一世",
    "剧情运行时.封印核心奥斯特利一世",
    "血精灵守护者",
    封印核心场景站位表.E奥斯特利一世,
  );
  if (奥斯特利一世 == null) return false;
  状态.单位列表.push(奥斯特利一世);
  当前封印核心奥斯特利一世记录 = 奥斯特利一世;
  return true;
}

function 创建七色闪电(this: void, 状态: 封印核心场景状态): void {
  if (状态.闪电列表.length > 0) return;
  const 目标 = 封印核心场景站位表.E奥斯特利一世;
  for (let i = 0; i < 封印核心七色闪电配置表.length; i++) {
    const 配置 = 封印核心七色闪电配置表[i];
    const 闪电 = AddLightningEx(配置.代码, false, 配置.X, 配置.Y, 1700.0, 目标.X, 目标.Y, 250.8);
    if (句柄有效(闪电)) 状态.闪电列表.push(闪电);
  }
}

function 清理封印核心闪电(this: void, 状态: 封印核心场景状态): void {
  for (let i = 0; i < 状态.闪电列表.length; i++) {
    const 闪电 = 状态.闪电列表[i];
    if (句柄有效(闪电)) DestroyLightning(闪电);
  }
  状态.闪电列表.length = 0;
}

function 清理封印核心场景单位(this: void, 状态: 封印核心场景状态): void {
  for (let i = 0; i < 状态.单位列表.length; i++) {
    const 记录 = 状态.单位列表[i];
    if (记录 === 当前封印核心奥斯特利一世记录) continue;
    解除暂停并取消无敌安全(记录.单位, `${封印核心纯对白来源}:${记录.运行时键}`);
    if (记录.临时创建 && 句柄有效(记录.单位)) 立即移除单位并取消排泄登记(记录.单位);
    清理剧情运行时单位(记录.运行时键);
  }
  状态.单位列表.length = 0;
  清理剧情运行时单位("剧情运行时.封印核心玩家");
}

export function 清理封印核心收束说话者(this: void): void {
  const 记录 = 当前封印核心奥斯特利一世记录;
  if (记录 == null) return;
  解除暂停并取消无敌安全(记录.单位, `${封印核心纯对白来源}:${记录.运行时键}`);
  if (记录.临时创建 && 句柄有效(记录.单位)) 立即移除单位并取消排泄登记(记录.单位);
  清理剧情运行时单位(记录.运行时键);
  当前封印核心奥斯特利一世记录 = undefined;
}

export function 清理封印核心场景(this: void): void {
  const 状态 = 当前封印核心场景状态;
  if (状态 != null && !状态.已清理) {
    状态.已清理 = true;
    清理封印核心闪电(状态);
    清理封印核心场景单位(状态);
  }
  当前封印核心场景状态 = undefined;
  设置玩家英雄组控制状态(false, false);
}

export function 布置封印核心纯对白(this: void): boolean {
  if (读取剧情进度() !== 48) return false;
  if (当前封印核心场景状态 != null && !当前封印核心场景状态.已清理) return true;

  const 状态: 封印核心场景状态 = { 单位列表: [], 闪电列表: [], 已清理: false };
  当前封印核心场景状态 = 状态;
  移动玩家队伍到对白站位();
  应用第三章电影镜头(48);
  设置玩家英雄组控制状态(true, false);
  if (!创建封印核心场景单位(状态)) {
    清理封印核心场景();
    return false;
  }
  发布主线节点目标(48);
  return true;
}

export function 创建封印核心七色光束(this: void): void {
  const 状态 = 当前封印核心场景状态;
  if (状态 == null || 状态.已清理) return;
  创建七色闪电(状态);
}

function 清理封印核心入口监听(this: void): void {
  const 状态 = 当前封印核心入口监听;
  if (状态 == null) return;
  状态.取消();
  注销动态矩形区域(封印核心入口矩形键);
  当前封印核心入口监听 = undefined;
}

function 播放封印核心纯对白(this: void, 触发单位: any): void {
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  const 已播放 = 播放主线剧情片段("molten_realm_seal_core_dialogue", {
    片段ID: "molten_realm_seal_core_dialogue",
    触发配置名: "封印核心入口",
    触发单位,
  });
  if (!已播放) 清理封印核心场景();
}

function on封印核心入口触发(this: void): void {
  const 状态 = 当前封印核心入口监听;
  if (状态 == null || 状态.已触发) return;
  if (读取剧情进度() !== 48) return;
  const 触发单位 = GetTriggerUnit();
  if (!单位存活(触发单位) || !是玩家英雄组单位(触发单位)) return;

  状态.已触发 = true;
  清理封印核心入口监听();
  注册剧情运行时单位("剧情运行时.封印核心玩家", 触发单位);
  播放封印核心纯对白(触发单位);
}

export function 开始监听封印核心入口(this: void): void {
  if (读取剧情进度() !== 48 || 当前封印核心入口监听 != null) return;
  注册封印守卫战区域音乐();

  const 矩形 = 注册动态矩形区域(动态矩形区域配置表[封印核心入口矩形键]);
  if (!句柄有效(矩形)) {
    注销动态矩形区域(封印核心入口矩形键);
    return;
  }
  const 监听 = 创建矩形进入监听(矩形, on封印核心入口触发, null);
  if (监听 == null) {
    注销动态矩形区域(封印核心入口矩形键);
    return;
  }
  当前封印核心入口监听 = {
    取消: 监听.取消,
    已触发: false,
  };
}

export function 执行布置封印核心纯对白(this: void, _参数: 剧情动作参数表): void {
  布置封印核心纯对白();
}

export function 执行创建封印核心七色光束(this: void, _参数: 剧情动作参数表): void {
  创建封印核心七色光束();
}

export function 执行结束封印核心纯对白(this: void, _参数: 剧情动作参数表): void {
  清理封印核心场景();
}

export function 执行清理封印核心入口(this: void, _参数: 剧情动作参数表): void {
  清理封印核心入口监听();
  清理封印核心场景();
}

export function 执行清理封印核心收束(this: void, _参数: 剧情动作参数表): void {
  清理封印核心收束说话者();
}

export const 封印核心场景剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_布置封印核心纯对白": 执行布置封印核心纯对白,
  "第三章_创建封印核心七色光束": 执行创建封印核心七色光束,
  "第三章_结束封印核心纯对白": 执行结束封印核心纯对白,
  "第三章_清理封印核心入口": 执行清理封印核心入口,
  "第三章_清理封印核心收束": 执行清理封印核心收束,
};
