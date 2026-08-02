/** @noSelfInFile */

const jass = require("jass.common") as any;

const { YDUserDataGetSafe } = require("lib.扩展函数.YDWE函数.09．YDUserData安全版") as {
  YDUserDataGetSafe: (this: void, tableType: string, tableKey: any, attr: string, valueType: string) => any;
};
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: any) => any;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 注册剧情玩家组传送 } = require("系统.07．地形系统.03．区域传送") as {
  注册剧情玩家组传送: (this: void, 配置: {
    入口中心X: number;
    入口中心Y: number;
    入口半径: number;
    目标X: number;
    目标Y: number;
    目标面向?: number;
    条件: (this: void) => boolean;
    读取玩家英雄组: (this: void) => any;
    允许进入单位?: (this: void, unit: any) => boolean;
    完成?: (this: void) => void;
  }) => (this: void) => void;
};

import type { 剧情动作参数表, 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文, 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 清理剧情运行时单位, 注册剧情运行时单位, 读取剧情运行时单位 } from "../../00．剧情系统核心工具/08．剧情运行时单位";

const DestroyEffect = jass.DestroyEffect as (this: void, effect: any) => void;

const 传送门X = 16184.4;
const 传送门Y = -3983.5;
const 英灵墓地X = 11001.9;
const 英灵墓地Y = -14942.2;
const 英灵墓地面向 = 270;
const 传送门半径 = 420;
const 传送门模型 = "Common\\Effect\\Form\\Portal\\7sr_suramarcity_pylonfx.mdx";
const 英灵墓地铭文模型 = "Common\\Effect\\Form\\MagicCircle\\SpiritGuardSoulSeal.mdx";

interface 英灵墓地铭文位置 {
  X: number;
  Y: number;
}

const 英灵墓地铭文位置表: 英灵墓地铭文位置[] = [
  // 里科特死亡术式
  { X: 8371.6, Y: -12888.4 },
  // 王家公开“叛军墓志”
  { X: 8213.8, Y: -14068.0 },
  // 被覆盖的古代军誓铭文
  { X: 8764.1, Y: -14102.3 },
];

interface 菲尼克斯尔战后状态 {
  传送门特效?: any;
  取消剧情传送注册?: (this: void) => void;
  已传送: boolean;
}

let 当前战后状态: 菲尼克斯尔战后状态 | undefined;
const 英灵墓地铭文特效列表: any[] = [];

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 清理传送门(this: void, 状态: 菲尼克斯尔战后状态): void {
  if (状态.取消剧情传送注册 != null) 状态.取消剧情传送注册();
  if (状态.传送门特效 != null && 状态.传送门特效 !== 0) DestroyEffect(状态.传送门特效);
  状态.取消剧情传送注册 = undefined;
  状态.传送门特效 = undefined;
}

function 创建英灵墓地铭文特效(this: void): void {
  if (英灵墓地铭文特效列表.length > 0) return;
  for (let i = 0; i < 英灵墓地铭文位置表.length; i++) {
    const 位置 = 英灵墓地铭文位置表[i];
    const 特效 = 创建点特效({
      模型路径: 英灵墓地铭文模型,
      X: 位置.X,
      Y: 位置.Y,
      Z: 0,
      缩放: 1,
    });
    if (句柄有效(特效)) 英灵墓地铭文特效列表.push(特效);
  }
}

function 清理英灵墓地铭文特效(this: void): void {
  for (let i = 0; i < 英灵墓地铭文特效列表.length; i++) {
    const 特效 = 英灵墓地铭文特效列表[i];
    if (句柄有效(特效)) DestroyEffect(特效);
  }
  英灵墓地铭文特效列表.length = 0;
}

function 清理菲尼克斯尔战后运行时(this: void): void {
  清理剧情运行时单位("主线NPC.菲尼克斯尔残响");
  清理剧情运行时单位("剧情运行时.菲尼克斯尔战后玩家");
}

function 读取菲尼克斯尔战后玩家英雄组(this: void): any {
  return YDUserDataGetSafe("string", "玩家英雄", "单位组", "group");
}

function 剧情进度为45(this: void): boolean {
  return 读取剧情进度() === 45;
}

function 菲尼克斯尔战后允许进入(this: void, unit: any): boolean {
  return 是玩家英雄组单位(unit);
}

function 完成菲尼克斯尔战后传送(this: void): void {
  const 状态 = 当前战后状态;
  if (状态 == null || 状态.已传送) return;
  状态.已传送 = true;
  清理传送门(状态);
  清理菲尼克斯尔战后运行时();
  创建英灵墓地铭文特效();
  当前战后状态 = undefined;
}

function 创建菲尼克斯尔战后入口(this: void): void {
  const 状态 = 当前战后状态 ?? { 已传送: false };
  当前战后状态 = 状态;
  if (状态.已传送) return;
  if (!句柄有效(状态.传送门特效)) {
    状态.传送门特效 = 创建点特效({
      模型路径: 传送门模型,
      X: 传送门X,
      Y: 传送门Y,
      缩放: 2.2,
    });
  }
  if (状态.取消剧情传送注册 != null) return;
  状态.取消剧情传送注册 = 注册剧情玩家组传送({
    入口中心X: 传送门X,
    入口中心Y: 传送门Y,
    入口半径: 传送门半径,
    目标X: 英灵墓地X,
    目标Y: 英灵墓地Y,
    目标面向: 英灵墓地面向,
    条件: 剧情进度为45,
    读取玩家英雄组: 读取菲尼克斯尔战后玩家英雄组,
    允许进入单位: 菲尼克斯尔战后允许进入,
    完成: 完成菲尼克斯尔战后传送,
  });
}

export function 执行准备菲尼克斯尔战后(this: void, _参数: 剧情动作参数表): void {
  const 上下文 = 读取当前剧情动作上下文();
  if (!句柄有效(读取剧情运行时单位("主线NPC.菲尼克斯尔残响")) && 句柄有效(上下文.触发单位)) {
    注册剧情运行时单位("主线NPC.菲尼克斯尔残响", 上下文.触发单位);
  }
  当前战后状态 = 当前战后状态 ?? { 已传送: false };
}

export function 执行开启菲尼克斯尔战后传送门(this: void, _参数: 剧情动作参数表): void {
  创建菲尼克斯尔战后入口();
}

export function 执行清理菲尼克斯尔战后(this: void, _参数: 剧情动作参数表): void {
  if (当前战后状态 != null) 清理传送门(当前战后状态);
  当前战后状态 = undefined;
  清理菲尼克斯尔战后运行时();
}

export function 执行创建英灵墓地铭文特效(this: void, _参数: 剧情动作参数表): void {
  创建英灵墓地铭文特效();
}

export function 执行清理英灵墓地铭文特效(this: void, _参数: 剧情动作参数表): void {
  清理英灵墓地铭文特效();
}

export const 菲尼克斯尔战后承接剧情动作注册表: Record<string, 剧情动作处理器> = {
  "第三章_准备菲尼克斯尔战后": 执行准备菲尼克斯尔战后,
  "第三章_开启菲尼克斯尔战后传送门": 执行开启菲尼克斯尔战后传送门,
  "第三章_清理菲尼克斯尔战后": 执行清理菲尼克斯尔战后,
  "第三章_创建英灵墓地铭文特效": 执行创建英灵墓地铭文特效,
  "第三章_清理英灵墓地铭文特效": 执行清理英灵墓地铭文特效,
};
