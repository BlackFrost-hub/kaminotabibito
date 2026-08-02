/** @noSelfInFile */

import {
  创建世界坐标进度UI,
  更新世界坐标进度UI,
  设置世界坐标进度UI显示,
  销毁世界坐标进度UI,
  type 世界坐标进度UI,
} from "../../../../09．表现系统/15．世界坐标进度UI";

const jass = require("jass.common") as Record<string, any>;

const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: {
    模型路径: string;
    X: number;
    Y: number;
    Z?: number;
    缩放?: number;
  }) => any;
};

const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;
const Player = jass.Player as (this: void, playerId: number) => any;
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
const IssueTargetOrder = jass.IssueTargetOrder as (this: void, unit: any, order: string, target: any) => boolean;

const { 闪电效果代码 } = require("系统.03．技能系统.00．技能模板+函数.02．通用函数.17．闪电效果代码") as {
  闪电效果代码: Record<string, string>;
};

const { addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
  removePeriodicCallback: (this: void, id: number) => void;
  getServerTime: (this: void) => number;
};
const { 创建单位并登记排泄安全 } = require("lib.扩展函数.自定义扩展函数.05．单位相关安全包装") as {
  创建单位并登记排泄安全: (this: void, owner: any, unitTypeId: number, x: number, y: number, facing: number) => any;
};
const { 立即移除单位并取消排泄登记 } = require("系统.00．核心系统.01．事件中心.07A．单位排泄") as {
  立即移除单位并取消排泄登记: (this: void, unit: any) => void;
};
const { X_FixUnitStandingSafe } = require("lib.扩展函数.Star扩展函数.Star扩展库.06A．X库函数安全版") as {
  X_FixUnitStandingSafe: (this: void, unit: any) => void;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, value: string | undefined | null) => number;
};
const { IsUnitAliveBJ } = require("lib.扩展函数.BJ函数.02．单位与英雄") as {
  IsUnitAliveBJ: (this: void, whichUnit: any) => boolean;
};
const { 按名字反查总单位ID } = require("系统.01．单位系统.08．单位配置表.04．总单位配置表") as {
  按名字反查总单位ID: (this: void, name: string) => string | undefined;
};
const { GS_LoadUintProperty, GS_UnitPry } = require("lib.扩展函数.Star扩展函数.02．GS单位属性") as {
  GS_LoadUintProperty: (this: void, unit: any, propertyType: number) => number;
  GS_UnitPry: (this: void, unit: any, change: number, propertyType: number, value: number) => void;
};
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};
const { 设置全体玩家游戏失败 } = require("系统.00．核心系统.09．游戏结算开关") as {
  设置全体玩家游戏失败: (this: void) => boolean;
};
const { 启用封印守卫战区域音乐, 清理封印守卫战区域音乐 } = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐") as {
  启用封印守卫战区域音乐: (this: void) => boolean;
  清理封印守卫战区域音乐: (this: void) => boolean;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { safeForForce } = require("系统.00．核心系统.07．联机安全工具") as {
  safeForForce: (this: void, forceOrSelf: any, action: (this: void) => void) => void;
};
const { CameraSetEQNoiseForPlayer, CameraClearNoiseForPlayer } = require("lib.扩展函数.封装函数.07．镜头函数.01．镜头震动") as {
  CameraSetEQNoiseForPlayer: (this: void, whichPlayer: any, magnitude: number) => void;
  CameraClearNoiseForPlayer: (this: void, whichPlayer: any) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 进入主线节点 } from "../../00．剧情系统核心工具/10．标准剧情动作";
import { 清理剧情运行时单位, 注册剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";

const 封印守卫战传送门模型 = "Common\\Effect\\Form\\Portal\\SealGuardWavePortal.mdx";
const 封印守卫战锚点模型 = "Common\\Effect\\Form\\Marker\\SealAnchorCrystalTower.mdx";
const 封印能量核心单位ID = stringToFourCCSafe("n06G");
const 中立被动玩家ID = 15;
const 中立敌对玩家ID = jass.PLAYER_NEUTRAL_AGGRESSIVE as number;
const 封印守卫战倒计时刷新毫秒 = 100;
const 封印守卫战敌人目标重发间隔毫秒 = 1800;
const 封印守卫战波次最大间隔秒 = 45;
const 封印守卫战镜头震荡幅度 = 10;

export const 封印守卫战持续秒 = 300;
export const 封印守卫战锚点修复持续秒 = 40;
export const 封印守卫战锚点修复退回速度 = 0.25;
export const 封印能量核心位置 = { X: 975.9, Y: -9652.2, Z: 250.8, 朝向: 0 } as const;

export const 封印守卫战锚点位置表 = [
  { 编号: 1, X: 959.6, Y: -9016.9, Z: 230.3 },
  { 编号: 2, X: 396.7, Y: -10096.3, Z: 252.5 },
  { 编号: 3, X: 1588.6, Y: -10146.2, Z: 264.4 },
] as const;

export const 封印守卫战锚点闪电连接表 = [
  { 锚点编号: 1, 代码: 闪电效果代码.粉色光束, 能量源X: 1148.2, 能量源Y: -7998.1 },
  { 锚点编号: 2, 代码: 闪电效果代码.绿色光束, 能量源X: -377.1, 能量源Y: -10973.8 },
  { 锚点编号: 3, 代码: 闪电效果代码.青蓝白光束, 能量源X: 2639.2, 能量源Y: -10680.0 },
] as const;

export const 封印守卫战三路传送门位置表 = [
  { 路线: "北侧", X: 1193.2, Y: -8251.9, 初始面向: 253.02 },
  { 路线: "西南", X: -114.6, Y: -10868.3, 初始面向: 56.48 },
  { 路线: "东南", X: 2113.4, Y: -11018.6, 初始面向: 121.03 },
] as const;

interface 封印守卫战波次单位配置 {
  单位名: string;
  数量: number;
}

interface 封印守卫战波次配置 {
  波次: number;
  开始秒: number;
  属性倍率: number;
  单位列表: readonly 封印守卫战波次单位配置[];
}

export const 封印守卫战波次配置表: readonly 封印守卫战波次配置[] = [
  { 波次: 1, 开始秒: 0, 属性倍率: 1.00, 单位列表: [
    { 单位名: "失控英灵", 数量: 8 },
    { 单位名: "断誓猎手", 数量: 4 },
    { 单位名: "黑暗残响", 数量: 1 },
  ] },
  { 波次: 2, 开始秒: 45, 属性倍率: 1.10, 单位列表: [
    { 单位名: "失控英灵", 数量: 10 },
    { 单位名: "夺灵祭司", 数量: 4 },
    { 单位名: "锚蚀兽", 数量: 2 },
    { 单位名: "失律号令者", 数量: 1 },
  ] },
  { 波次: 3, 开始秒: 90, 属性倍率: 1.22, 单位列表: [
    { 单位名: "失控英灵", 数量: 12 },
    { 单位名: "断誓猎手", 数量: 5 },
    { 单位名: "锚蚀兽", 数量: 2 },
    { 单位名: "裂誓重卫", 数量: 1 },
  ] },
  { 波次: 4, 开始秒: 135, 属性倍率: 1.36, 单位列表: [
    { 单位名: "失控英灵", 数量: 14 },
    { 单位名: "断誓猎手", 数量: 6 },
    { 单位名: "夺灵祭司", 数量: 2 },
    { 单位名: "裂誓重卫", 数量: 1 },
    { 单位名: "黑暗残响", 数量: 1 },
  ] },
  { 波次: 5, 开始秒: 180, 属性倍率: 1.52, 单位列表: [
    { 单位名: "失控英灵", 数量: 16 },
    { 单位名: "断誓猎手", 数量: 6 },
    { 单位名: "锚蚀兽", 数量: 3 },
    { 单位名: "夺灵祭司", 数量: 2 },
    { 单位名: "裂誓重卫", 数量: 1 },
    { 单位名: "失律号令者", 数量: 1 },
  ] },
  { 波次: 6, 开始秒: 198, 属性倍率: 1.52, 单位列表: [
    { 单位名: "失控英灵", 数量: 10 },
    { 单位名: "夺灵祭司", 数量: 4 },
    { 单位名: "黑暗残响", 数量: 1 },
    { 单位名: "失律号令者", 数量: 1 },
  ] },
  { 波次: 7, 开始秒: 230, 属性倍率: 1.70, 单位列表: [
    { 单位名: "失控英灵", 数量: 18 },
    { 单位名: "锚蚀兽", 数量: 6 },
    { 单位名: "断誓猎手", 数量: 3 },
    { 单位名: "裂誓重卫", 数量: 2 },
    { 单位名: "失律号令者", 数量: 1 },
  ] },
  { 波次: 8, 开始秒: 248, 属性倍率: 1.70, 单位列表: [
    { 单位名: "断誓猎手", 数量: 8 },
    { 单位名: "失控英灵", 数量: 4 },
    { 单位名: "夺灵祭司", 数量: 3 },
    { 单位名: "黑暗残响", 数量: 2 },
  ] },
  { 波次: 9, 开始秒: 266, 属性倍率: 1.70, 单位列表: [
    { 单位名: "失控英灵", 数量: 12 },
    { 单位名: "锚蚀兽", 数量: 4 },
    { 单位名: "夺灵祭司", 数量: 4 },
    { 单位名: "裂誓重卫", 数量: 2 },
    { 单位名: "失律号令者", 数量: 1 },
  ] },
] as const;

const 封印守卫战波次出生偏移表 = [
  { X: 0, Y: 0 },
  { X: 96, Y: 0 },
  { X: -96, Y: 0 },
  { X: 0, Y: 96 },
  { X: 0, Y: -96 },
  { X: 160, Y: 96 },
  { X: -160, Y: 96 },
  { X: 160, Y: -96 },
  { X: -160, Y: -96 },
] as const;

const 当前封印守卫战传送门特效列表: any[] = [];
const 当前封印守卫战锚点特效列表: any[] = [];
const 当前封印守卫战锚点闪电列表: any[] = [];
const 当前封印守卫战敌人列表: any[] = [];
const 当前封印守卫战锚点修复秒数: number[] = [0, 0, 0];
let 当前封印能量核心: any = null;
let 当前封印守卫战倒计时UI: 世界坐标进度UI | null = null;
let 当前封印守卫战下一波倒计时UI: 世界坐标进度UI | null = null;
const 当前封印守卫战刷新点下一波倒计时UI: (世界坐标进度UI | null)[] = [];
const 当前封印守卫战锚点进度UI: (世界坐标进度UI | null)[] = [null, null, null];
let 当前封印守卫战倒计时周期ID = 0;
let 当前封印守卫战结束时间毫秒 = 0;
let 当前封印守卫战开始时间毫秒 = 0;
let 当前封印守卫战下一波索引 = 0;
let 当前封印守卫战下次目标重发时间毫秒 = 0;
let 当前封印守卫战运行中 = false;
let 已注册封印守卫战死亡监听 = false;

function on启动封印守卫战镜头震荡(this: void): void {
  const 玩家 = jass.GetEnumPlayer();
  CameraSetEQNoiseForPlayer(玩家, 封印守卫战镜头震荡幅度);
}

function on清理封印守卫战镜头震荡(this: void): void {
  const 玩家 = jass.GetEnumPlayer();
  CameraClearNoiseForPlayer(玩家);
}

function 启动封印守卫战镜头震荡(this: void): void {
  safeForForce(GetPlayersAll(), on启动封印守卫战镜头震荡);
}

function 清理封印守卫战镜头震荡(this: void): void {
  safeForForce(GetPlayersAll(), on清理封印守卫战镜头震荡);
}

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 单位存活(this: void, unit: any): boolean {
  return 句柄有效(unit) && IsUnitAliveBJ(unit);
}

function 清理封印守卫战下一波倒计时UI(this: void): void {
  销毁世界坐标进度UI(当前封印守卫战下一波倒计时UI);
  当前封印守卫战下一波倒计时UI = null;
  for (let i = 0; i < 当前封印守卫战刷新点下一波倒计时UI.length; i++) {
    销毁世界坐标进度UI(当前封印守卫战刷新点下一波倒计时UI[i]);
    当前封印守卫战刷新点下一波倒计时UI[i] = null;
  }
  当前封印守卫战刷新点下一波倒计时UI.length = 0;
}

function 停止封印守卫战倒计时(this: void): void {
  if (当前封印守卫战倒计时周期ID !== 0) {
    removePeriodicCallback(当前封印守卫战倒计时周期ID);
    当前封印守卫战倒计时周期ID = 0;
  }
  销毁世界坐标进度UI(当前封印守卫战倒计时UI);
  当前封印守卫战倒计时UI = null;
  清理封印守卫战下一波倒计时UI();
  当前封印守卫战结束时间毫秒 = 0;
  当前封印守卫战开始时间毫秒 = 0;
}

export function 创建封印守卫战下一波倒计时UI(this: void): boolean {
  清理封印守卫战下一波倒计时UI();
  当前封印守卫战下一波倒计时UI = 创建世界坐标进度UI({
    X: 封印能量核心位置.X,
    Y: 封印能量核心位置.Y,
    Z: 650,
    最大值: 封印守卫战波次最大间隔秒,
    当前值: 0,
    标题: "下一波来袭",
    数值后缀: "秒",
    类型: "危险",
    平滑过渡秒: 0.1,
    初始显示: false,
    雾中可见: false,
  });
  if (当前封印守卫战下一波倒计时UI == null) return false;

  for (let i = 0; i < 封印守卫战三路传送门位置表.length; i++) {
    const 位置 = 封印守卫战三路传送门位置表[i];
    const 进度UI = 创建世界坐标进度UI({
      X: 位置.X,
      Y: 位置.Y,
      Z: 520,
      最大值: 封印守卫战波次最大间隔秒,
      当前值: 0,
      标题: "下一波来袭",
      数值后缀: "秒",
      类型: "危险",
      平滑过渡秒: 0.1,
      初始显示: false,
      雾中可见: false,
    });
    if (进度UI == null) {
      清理封印守卫战下一波倒计时UI();
      return false;
    }
    当前封印守卫战刷新点下一波倒计时UI.push(进度UI);
  }
  return 当前封印守卫战刷新点下一波倒计时UI.length === 封印守卫战三路传送门位置表.length;
}

function 更新封印守卫战下一波倒计时UI对象(this: void, ui: 世界坐标进度UI | null, 剩余秒: number, 是否显示: boolean): void {
  更新世界坐标进度UI(ui, 剩余秒, true);
  设置世界坐标进度UI显示(ui, 是否显示);
}

function 更新封印守卫战下一波倒计时UI(this: void, 当前时间毫秒: number): void {
  const 下一波 = 封印守卫战波次配置表[当前封印守卫战下一波索引];
  if (下一波 == null || 当前封印守卫战开始时间毫秒 <= 0) {
    更新封印守卫战下一波倒计时UI对象(当前封印守卫战下一波倒计时UI, 0, false);
    for (let i = 0; i < 当前封印守卫战刷新点下一波倒计时UI.length; i++) {
      更新封印守卫战下一波倒计时UI对象(当前封印守卫战刷新点下一波倒计时UI[i], 0, false);
    }
    return;
  }

  let 剩余秒 = (当前封印守卫战开始时间毫秒 + 下一波.开始秒 * 1000 - 当前时间毫秒) / 1000;
  if (剩余秒 < 0) 剩余秒 = 0;
  if (剩余秒 > 封印守卫战波次最大间隔秒) 剩余秒 = 封印守卫战波次最大间隔秒;
  更新封印守卫战下一波倒计时UI对象(当前封印守卫战下一波倒计时UI, 剩余秒, true);
  for (let i = 0; i < 当前封印守卫战刷新点下一波倒计时UI.length; i++) {
    更新封印守卫战下一波倒计时UI对象(当前封印守卫战刷新点下一波倒计时UI[i], 剩余秒, true);
  }
}

function 更新封印守卫战倒计时(this: void): void {
  if (!单位存活(当前封印能量核心)) {
    if (当前封印守卫战运行中) 处理封印守卫战失败();
    停止封印守卫战倒计时();
    return;
  }
  const 当前时间毫秒 = getServerTime();
  let 剩余秒 = (当前封印守卫战结束时间毫秒 - 当前时间毫秒) / 1000;
  if (剩余秒 < 0) 剩余秒 = 0;
  更新世界坐标进度UI(当前封印守卫战倒计时UI, 剩余秒, true);
  if (当前封印守卫战运行中) {
    推进封印守卫战波次(当前时间毫秒);
    if (剩余秒 <= 0) 处理封印守卫战守护时限();
  }
}

function 清理封印守卫战锚点进度UI(this: void): void {
  for (let i = 0; i < 当前封印守卫战锚点进度UI.length; i++) {
    销毁世界坐标进度UI(当前封印守卫战锚点进度UI[i]);
    当前封印守卫战锚点进度UI[i] = null;
    当前封印守卫战锚点修复秒数[i] = 0;
  }
}

export function 创建封印守卫战锚点进度UI(this: void): boolean {
  清理封印守卫战锚点进度UI();
  for (let i = 0; i < 封印守卫战锚点位置表.length; i++) {
    const 位置 = 封印守卫战锚点位置表[i];
    const 进度UI = 创建世界坐标进度UI({
      X: 位置.X,
      Y: 位置.Y,
      Z: 420,
      最大值: 封印守卫战锚点修复持续秒,
      当前值: 0,
      标题: `修复锚点 ${位置.编号}`,
      数值后缀: "秒",
      类型: "奥术",
      平滑过渡秒: 0.1,
      初始显示: true,
      雾中可见: false,
    });
    if (进度UI == null) {
      清理封印守卫战锚点进度UI();
      return false;
    }
    当前封印守卫战锚点进度UI[i] = 进度UI;
  }
  return true;
}

export function 更新封印守卫战锚点修复进度(this: void, 锚点编号: number, 当前秒: number): void {
  const 索引 = 锚点编号 - 1;
  if (索引 < 0 || 索引 >= 当前封印守卫战锚点进度UI.length) return;
  let 目标秒 = 当前秒;
  if (目标秒 < 0) 目标秒 = 0;
  if (目标秒 > 封印守卫战锚点修复持续秒) 目标秒 = 封印守卫战锚点修复持续秒;
  当前封印守卫战锚点修复秒数[索引] = 目标秒;
  更新世界坐标进度UI(当前封印守卫战锚点进度UI[索引], 目标秒);
}

export function 推进封印守卫战锚点修复进度(
  this: void,
  锚点编号: number,
  经过秒: number,
  正在修复: boolean,
): void {
  if (!(经过秒 > 0)) return;
  const 索引 = 锚点编号 - 1;
  if (索引 < 0 || 索引 >= 当前封印守卫战锚点进度UI.length) return;
  const 变化量 = 正在修复 ? 经过秒 : -经过秒 * 封印守卫战锚点修复退回速度;
  更新封印守卫战锚点修复进度(锚点编号, 当前封印守卫战锚点修复秒数[索引] + 变化量);
}

export function 设置封印守卫战锚点进度显示(this: void, 锚点编号: number, 是否显示: boolean): void {
  const 索引 = 锚点编号 - 1;
  if (索引 < 0 || 索引 >= 当前封印守卫战锚点进度UI.length) return;
  设置世界坐标进度UI显示(当前封印守卫战锚点进度UI[索引], 是否显示);
}

function 读取封印守卫战波次单位类型ID(this: void, 单位名: string): number {
  return stringToFourCCSafe(按名字反查总单位ID(单位名));
}

function 应用封印守卫战波次属性(this: void, unit: any, 属性倍率: number): void {
  if (!单位存活(unit) || !(属性倍率 > 0) || 属性倍率 === 1) return;
  const 最大生命 = GS_LoadUintProperty(unit, 0);
  const 攻击力 = GS_LoadUintProperty(unit, 2);
  const 护甲 = GS_LoadUintProperty(unit, 3);
  if (最大生命 > 0) GS_UnitPry(unit, 0, 0, 最大生命 * (属性倍率 - 1));
  if (攻击力 > 0) GS_UnitPry(unit, 0, 2, 攻击力 * (属性倍率 - 1));
  if (护甲 > 0) GS_UnitPry(unit, 0, 3, 护甲 * (属性倍率 - 1));
}

function 创建封印守卫战波次单位(
  this: void,
  单位名: string,
  出生点索引: number,
  出生序号: number,
  属性倍率: number,
): any {
  const 单位类型ID = 读取封印守卫战波次单位类型ID(单位名);
  const 出生点 = 封印守卫战三路传送门位置表[出生点索引 % 封印守卫战三路传送门位置表.length];
  const 偏移 = 封印守卫战波次出生偏移表[出生序号 % 封印守卫战波次出生偏移表.length];
  if (!(单位类型ID > 0) || 出生点 == null || 偏移 == null) return null;

  const unit = 创建单位并登记排泄安全(
    Player(中立敌对玩家ID),
    单位类型ID,
    出生点.X + 偏移.X,
    出生点.Y + 偏移.Y,
    出生点.初始面向,
  );
  if (!单位存活(unit)) return null;
  应用封印守卫战波次属性(unit, 属性倍率);
  if (单位存活(当前封印能量核心)) IssueTargetOrder(unit, "attack", 当前封印能量核心);
  return unit;
}

function 创建封印守卫战波次(this: void, 配置: 封印守卫战波次配置): void {
  let 出生序号 = 0;
  for (let i = 0; i < 配置.单位列表.length; i++) {
    const 单位配置 = 配置.单位列表[i];
    for (let j = 0; j < 单位配置.数量; j++) {
      const unit = 创建封印守卫战波次单位(
        单位配置.单位名,
        出生序号 % 封印守卫战三路传送门位置表.length,
        出生序号,
        配置.属性倍率,
      );
      if (单位存活(unit)) 当前封印守卫战敌人列表.push(unit);
      出生序号++;
    }
  }
}

function 清理封印守卫战敌人(this: void): void {
  for (let i = 0; i < 当前封印守卫战敌人列表.length; i++) {
    const unit = 当前封印守卫战敌人列表[i];
    if (句柄有效(unit)) 立即移除单位并取消排泄登记(unit);
  }
  当前封印守卫战敌人列表.length = 0;
}

function 移除已死亡封印守卫战敌人(this: void): void {
  for (let i = 当前封印守卫战敌人列表.length - 1; i >= 0; i--) {
    if (!单位存活(当前封印守卫战敌人列表[i])) 当前封印守卫战敌人列表.splice(i, 1);
  }
}

function 刷新封印守卫战敌人目标(this: void, 当前时间毫秒: number): void {
  if (当前时间毫秒 < 当前封印守卫战下次目标重发时间毫秒) return;
  当前封印守卫战下次目标重发时间毫秒 = 当前时间毫秒 + 封印守卫战敌人目标重发间隔毫秒;
  if (!单位存活(当前封印能量核心)) return;

  移除已死亡封印守卫战敌人();
  for (let i = 0; i < 当前封印守卫战敌人列表.length; i++) {
    const unit = 当前封印守卫战敌人列表[i];
    if (单位存活(unit)) IssueTargetOrder(unit, "attack", 当前封印能量核心);
  }
}

function 推进封印守卫战波次(this: void, 当前时间毫秒: number): void {
  while (当前封印守卫战下一波索引 < 封印守卫战波次配置表.length) {
    const 下一波 = 封印守卫战波次配置表[当前封印守卫战下一波索引];
    if (下一波 == null) break;
    const 计划时间毫秒 = 当前封印守卫战开始时间毫秒 + 下一波.开始秒 * 1000;
    if (当前时间毫秒 < 计划时间毫秒) break;
    创建封印守卫战波次(下一波);
    当前封印守卫战下一波索引++;
  }
  更新封印守卫战下一波倒计时UI(当前时间毫秒);
  刷新封印守卫战敌人目标(当前时间毫秒);
}

function 所有封印守卫战锚点已完成(this: void): boolean {
  for (let i = 0; i < 当前封印守卫战锚点修复秒数.length; i++) {
    if (当前封印守卫战锚点修复秒数[i] < 封印守卫战锚点修复持续秒) return false;
  }
  return true;
}

function 处理封印守卫战失败(this: void): void {
  if (!当前封印守卫战运行中) return;
  当前封印守卫战运行中 = false;
  清理封印守卫战镜头震荡();
  清理封印守卫战区域音乐();
  清理封印守卫战敌人();
  清理封印守卫战三路传送门();
  清理封印能量核心与守护倒计时();
  设置全体玩家游戏失败();
}

function 处理封印守卫战守护时限(this: void): void {
  if (!当前封印守卫战运行中) return;
  当前封印守卫战运行中 = false;
  清理封印守卫战镜头震荡();
  清理封印守卫战区域音乐();
  停止封印守卫战倒计时();
  清理封印守卫战敌人();
  清理封印守卫战三路传送门();
  if (!所有封印守卫战锚点已完成()) {
    清理封印能量核心与守护倒计时();
    设置全体玩家游戏失败();
  }
}

function on封印守卫战单位死亡(this: void, dyingUnit: any, _killingUnit: any): void {
  if (!当前封印守卫战运行中) return;
  if (dyingUnit === 当前封印能量核心) {
    处理封印守卫战失败();
    return;
  }
  for (let i = 当前封印守卫战敌人列表.length - 1; i >= 0; i--) {
    if (当前封印守卫战敌人列表[i] === dyingUnit) 当前封印守卫战敌人列表.splice(i, 1);
  }
}

function 确保封印守卫战死亡监听(this: void): void {
  if (已注册封印守卫战死亡监听) return;
  已注册封印守卫战死亡监听 = true;
  registerDeathListener(on封印守卫战单位死亡);
}

function 清理封印守卫战锚点闪电(this: void): void {
  for (let i = 0; i < 当前封印守卫战锚点闪电列表.length; i++) {
    const 闪电 = 当前封印守卫战锚点闪电列表[i];
    if (句柄有效(闪电)) DestroyLightning(闪电);
  }
  当前封印守卫战锚点闪电列表.length = 0;
}

export function 创建封印守卫战锚点闪电(this: void): void {
  清理封印守卫战锚点闪电();
  for (let i = 0; i < 封印守卫战锚点闪电连接表.length; i++) {
    const 配置 = 封印守卫战锚点闪电连接表[i];
    const 目标 = 封印守卫战锚点位置表[配置.锚点编号 - 1];
    if (目标 == null) continue;
    const 闪电 = AddLightningEx(
      配置.代码,
      false,
      配置.能量源X,
      配置.能量源Y,
      1700,
      目标.X,
      目标.Y,
      目标.Z,
    );
    if (句柄有效(闪电)) 当前封印守卫战锚点闪电列表.push(闪电);
  }
}

export function 清理封印守卫战锚点特效(this: void): void {
  for (let i = 0; i < 当前封印守卫战锚点特效列表.length; i++) {
    const 特效 = 当前封印守卫战锚点特效列表[i];
    if (句柄有效(特效)) DestroyEffect(特效);
  }
  当前封印守卫战锚点特效列表.length = 0;
}

export function 创建封印守卫战锚点特效(this: void): boolean {
  清理封印守卫战锚点特效();
  for (let i = 0; i < 封印守卫战锚点位置表.length; i++) {
    const 位置 = 封印守卫战锚点位置表[i];
    const 特效 = 创建点特效({
      模型路径: 封印守卫战锚点模型,
      X: 位置.X,
      Y: 位置.Y,
      Z: 位置.Z,
      缩放: 1,
    });
    if (!句柄有效(特效)) {
      清理封印守卫战锚点特效();
      return false;
    }
    当前封印守卫战锚点特效列表.push(特效);
  }
  return 当前封印守卫战锚点特效列表.length === 封印守卫战锚点位置表.length;
}

export function 清理封印守卫战三路传送门(this: void): void {
  for (let i = 0; i < 当前封印守卫战传送门特效列表.length; i++) {
    const 特效 = 当前封印守卫战传送门特效列表[i];
    if (句柄有效(特效)) DestroyEffect(特效);
  }
  当前封印守卫战传送门特效列表.length = 0;
}

export function 创建封印守卫战三路传送门(this: void): boolean {
  清理封印守卫战三路传送门();
  for (let i = 0; i < 封印守卫战三路传送门位置表.length; i++) {
    const 位置 = 封印守卫战三路传送门位置表[i];
    const 特效 = 创建点特效({
      模型路径: 封印守卫战传送门模型,
      X: 位置.X,
      Y: 位置.Y,
      Z: 0,
      缩放: 1,
    });
    if (句柄有效(特效)) 当前封印守卫战传送门特效列表.push(特效);
  }
  return 当前封印守卫战传送门特效列表.length === 封印守卫战三路传送门位置表.length;
}

export function 清理封印能量核心与守护倒计时(this: void): void {
  停止封印守卫战倒计时();
  清理封印守卫战锚点进度UI();
  清理封印守卫战锚点特效();
  清理封印守卫战锚点闪电();
  if (句柄有效(当前封印能量核心)) 立即移除单位并取消排泄登记(当前封印能量核心);
  当前封印能量核心 = null;
  清理剧情运行时单位("剧情运行时.封印守卫战能量核心");
}

export function 清理封印守卫战(this: void): void {
  当前封印守卫战运行中 = false;
  清理封印守卫战镜头震荡();
  清理封印守卫战区域音乐();
  清理封印守卫战敌人();
  清理封印守卫战三路传送门();
  清理封印能量核心与守护倒计时();
  当前封印守卫战下一波索引 = 0;
  当前封印守卫战下次目标重发时间毫秒 = 0;
}

export function 创建封印能量核心与守护倒计时(this: void): any {
  清理封印能量核心与守护倒计时();
  if (!(封印能量核心单位ID > 0)) return null;

  const 位置 = 封印能量核心位置;
  const 核心 = 创建单位并登记排泄安全(
    Player(中立被动玩家ID),
    封印能量核心单位ID,
    位置.X,
    位置.Y,
    位置.朝向,
  );
  if (!单位存活(核心)) return null;

  当前封印能量核心 = 核心;
  X_FixUnitStandingSafe(核心);
  注册剧情运行时单位("剧情运行时.封印守卫战能量核心", 核心);
  当前封印守卫战倒计时UI = 创建世界坐标进度UI({
    X: 位置.X,
    Y: 位置.Y,
    Z: 520,
    最大值: 封印守卫战持续秒,
    当前值: 封印守卫战持续秒,
    标题: "守护封印核心",
    数值后缀: "秒",
    类型: "奥术",
    平滑过渡秒: 0.1,
    初始显示: true,
    雾中可见: false,
  });
  if (当前封印守卫战倒计时UI == null) {
    清理封印能量核心与守护倒计时();
    return null;
  }
  if (!创建封印守卫战锚点进度UI()) {
    清理封印能量核心与守护倒计时();
    return null;
  }
  if (!创建封印守卫战锚点特效()) {
    清理封印能量核心与守护倒计时();
    return null;
  }
  if (!创建封印守卫战下一波倒计时UI()) {
    清理封印能量核心与守护倒计时();
    return null;
  }
  创建封印守卫战锚点闪电();

  当前封印守卫战结束时间毫秒 = getServerTime() + 封印守卫战持续秒 * 1000;
  当前封印守卫战倒计时周期ID = addPeriodicCallback(
    封印守卫战倒计时刷新毫秒,
    更新封印守卫战倒计时,
  );
  return 核心;
}

export function 读取封印守卫战能量核心(this: void): any {
  return 当前封印能量核心;
}

export function 启动封印守卫战(this: void): boolean {
  if (当前封印守卫战运行中) return false;
  清理封印守卫战();
  if (!创建封印守卫战三路传送门()) {
    清理封印守卫战三路传送门();
    return false;
  }
  if (!单位存活(创建封印能量核心与守护倒计时())) {
    清理封印守卫战三路传送门();
    return false;
  }

  当前封印守卫战运行中 = true;
  当前封印守卫战开始时间毫秒 = getServerTime();
  当前封印守卫战下一波索引 = 0;
  当前封印守卫战下次目标重发时间毫秒 = 0;
  启用封印守卫战区域音乐();
  启动封印守卫战镜头震荡();
  确保封印守卫战死亡监听();
  return true;
}

export function 执行启动封印守卫战(this: void, _参数: 剧情动作参数表): void {
  const 当前进度 = 读取剧情进度();
  if (当前进度 !== 48 && 当前进度 !== 49) return;
  const 已启动 = 启动封印守卫战();
  if (已启动 && 当前进度 === 48) 进入主线节点(49);
}

export function 执行清理封印守卫战(this: void, _参数: 剧情动作参数表): void {
  清理封印守卫战();
}

export const 封印守卫战剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_启动封印守卫战": 执行启动封印守卫战,
  "第三章_清理封印守卫战": 执行清理封印守卫战,
};
