/** @noSelfInFile */

import type { 祖地双灵卫名称 } from './00．配置';
import type { 赤誓灵卫形态 } from './01．赤誓灵卫/00．状态';
import type { 苍影灵卫形态 } from './02．苍影灵卫/00．状态';
import { 祖地双灵卫单位技能配置 } from './00．配置';
import { 祖地双灵卫数值与表现配置 } from './02．数值与表现配置';
import { 创建机制清理篮子, type 机制清理篮子 } from '../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子';
import { 创建联合战斗成员生命周期, type 联合战斗成员生命周期 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/20．联合战斗成员生命周期';
import { stringToFourCC, 取单位ID, 单位未标记死亡 as 单位有效 } from '../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具';
import type { 伤害生命下限保护控制器 } from '../../../../00．技能模板+函数/04．机制组件/08．机制触发/09．伤害生命下限保护';
import type { 持续单位连线实例 } from '../../../../00．技能模板+函数/04．机制组件/07．机制连线/01．持续单位连线';
import type { 友军范围承伤转移控制器 } from '../../../../00．技能模板+函数/04．机制组件/09．装备通用机制/20．友军范围承伤转移';
import { 播放赤誓灵卫台词, 播放苍影灵卫台词 } from './12．台词播放';

const { 读取Boss战运行上下文 } = require('系统.03．技能系统.06．AI自动使用技能.03．Boss战启动桥接.01．Boss战运行.01．Boss战运行上下文') as {
  读取Boss战运行上下文: (this: void, boss: any) => any;
};
const { getServerTime, addDelayedCallback } = require('系统.00．核心系统.05．中心计时器') as {
  getServerTime: (this: void) => number;
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
};
const { 开始硬直 } = require('系统.03．技能系统.00．技能模板+函数.02．通用函数.01．控制与Buff') as {
  开始硬直: (this: void, unit: any, durationSec: number) => void;
};
const { 显示常规技能吟唱条, 显示大招吟唱条 } = require('系统.09．表现系统.08．吟唱条.06．对外接口') as {
  显示常规技能吟唱条: (this: void, 参数: any) => void;
  显示大招吟唱条: (this: void, 参数: any) => void;
};
const { CosBJ, SinBJ } = require('lib.扩展函数.BJ函数.12．数学函数') as {
  CosBJ: (this: void, degrees: number) => number;
  SinBJ: (this: void, degrees: number) => number;
};
const jass = require('jass.common') as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitX = jass.GetUnitX as (unit: any) => number;
const GetUnitY = jass.GetUnitY as (unit: any) => number;
const GetRectCenterX = jass.GetRectCenterX as (rect: any) => number;
const GetRectCenterY = jass.GetRectCenterY as (rect: any) => number;
const GetRectMinX = jass.GetRectMinX as (rect: any) => number;
const GetRectMaxX = jass.GetRectMaxX as (rect: any) => number;
const GetRectMinY = jass.GetRectMinY as (rect: any) => number;
const GetRectMaxY = jass.GetRectMaxY as (rect: any) => number;
const CreateGroup = jass.CreateGroup as () => any;
const DestroyGroup = jass.DestroyGroup as (group: any) => boolean;
const GroupEnumUnitsInRange = jass.GroupEnumUnitsInRange as (group: any, x: number, y: number, radius: number, filter: any) => void;
const FirstOfGroup = jass.FirstOfGroup as (group: any) => any;
const GroupRemoveUnit = jass.GroupRemoveUnit as (group: any, unit: any) => boolean;

const 赤誓正常ID = stringToFourCC(祖地双灵卫单位技能配置.单位.赤誓灵卫.单位ID);
const 赤誓变异ID = stringToFourCC(祖地双灵卫单位技能配置.单位.赤誓灵卫.变异单位ID);
const 苍影正常ID = stringToFourCC(祖地双灵卫单位技能配置.单位.苍影灵卫.单位ID);
const 苍影变异ID = stringToFourCC(祖地双灵卫单位技能配置.单位.苍影灵卫.变异单位ID);

export type 祖地双灵卫阶段 = '未启动' | 'P1双灵守门' | 'P2侵蚀失衡' | 'P3双蚀共鸣' | '净化收束' | '已结束';

/**
 * 联合 Boss 的共享运行时骨架。
 * 当前不创建计时器、事件或单位；导入本模块不会启动战斗。
 */
export interface 祖地双灵卫净化节点状态 {
  序号: number;
  X: number;
  Y: number;
  阶段: '未激活' | '破壳' | '校准' | '已净化';
  校准截止Ms: number;
  重试允许Ms: number;
  特效?: any;
  表现阶段?: string;
}

export interface 祖地双灵卫区域状态 {
  X: number;
  Y: number;
  半径: number;
  到期Ms: number;
  特效?: any;
}

export interface 祖地双灵卫运行时上下文 {
  赤誓灵卫单位?: any;
  苍影灵卫单位?: any;
  阶段: 祖地双灵卫阶段;
  赤誓灵卫形态: 赤誓灵卫形态;
  苍影灵卫形态: 苍影灵卫形态;
  首次变异守卫?: 祖地双灵卫名称;
  大型技能占用者?: 祖地双灵卫名称 | '联合机制';
  当前净化节点序号: number;
  已净化节点数量: number;
  崩解中的守卫?: 祖地双灵卫名称;
  崩解截止时间Ms: number;
  同誓保护已启用: boolean;
  低血保护守卫?: 祖地双灵卫名称;
  同誓保护特效?: any;
  同誓暗金连线?: 持续单位连线实例;
  同誓冷蓝连线?: 持续单位连线实例;
  同誓承伤转移?: 友军范围承伤转移控制器;
  P2开始时间Ms: number;
  大型机制忙碌到Ms: number;
  下次联合机制Ms: number;
  下次赤誓普通技能Ms: number;
  下次苍影普通技能Ms: number;
  誓盾?: { X: number; Y: number; 朝向: number; 到期Ms: number; 特效?: any };
  镇魂印?: 祖地双灵卫区域状态;
  空白灵域列表: 祖地双灵卫区域状态[];
  净化节点列表: 祖地双灵卫净化节点状态[];
  P3共鸣层数: number;
  净化易伤到Ms: number;
  最终结算待处理: boolean;
  封门误判待触发: boolean;
  净化节点清理已登记: boolean;
  侵蚀生命下限保护列表: 伤害生命下限保护控制器[];
  同息生命下限保护列表: 伤害生命下限保护控制器[];
  战斗已结束: boolean;
  场地矩形?: any;
  场地中心X: number;
  场地中心Y: number;
  场地半宽: number;
  场地半高: number;
  联合生命周期: 联合战斗成员生命周期;
  清理: 机制清理篮子;
  已初始化: boolean;
}

export function 开始祖地双灵卫常规施法(this: void, unit: any, 吟唱秒: number, 标题文本: string, 提示文本: string, 硬直秒?: number): void {
  if (!单位有效(unit)) return;
  开始硬直(unit, 硬直秒 ?? 吟唱秒);
  显示常规技能吟唱条({ 总时长: 吟唱秒, 颜色ID: 5, 标题文本, 提示文本 });
}

export function 开始祖地双灵卫联合施法(this: void, context: 祖地双灵卫运行时上下文, 吟唱秒: number, 标题文本: string, 提示文本: string, 硬直秒?: number): void {
  const duration = 硬直秒 ?? 吟唱秒;
  if (单位有效(context.赤誓灵卫单位)) 开始硬直(context.赤誓灵卫单位, duration);
  if (单位有效(context.苍影灵卫单位)) 开始硬直(context.苍影灵卫单位, duration);
  显示大招吟唱条({ 通道: '大招', 总时长: 吟唱秒, 颜色ID: 5, 标题文本, 提示文本 });
}

const 上下文列表: 祖地双灵卫运行时上下文[] = [];
const 单位上下文表: Record<number, 祖地双灵卫运行时上下文 | undefined> = {};

function 是赤誓单位(this: void, unit: any): boolean {
  const id = unit != null && unit !== 0 ? GetUnitTypeId(unit) : 0;
  return id === 赤誓正常ID || id === 赤誓变异ID;
}

function 是苍影单位(this: void, unit: any): boolean {
  const id = unit != null && unit !== 0 ? GetUnitTypeId(unit) : 0;
  return id === 苍影正常ID || id === 苍影变异ID;
}

function 查找附近搭档(this: void, unit: any, 寻找赤誓: boolean): any {
  const group = CreateGroup();
  GroupEnumUnitsInRange(group, GetUnitX(unit), GetUnitY(unit), 3600, null);
  let result: any = undefined;
  while (true) {
    const candidate = FirstOfGroup(group);
    if (candidate == null || candidate === 0) break;
    GroupRemoveUnit(group, candidate);
    if (candidate !== unit && (寻找赤誓 ? 是赤誓单位(candidate) : 是苍影单位(candidate))) {
      result = candidate;
      break;
    }
  }
  DestroyGroup(group);
  return result;
}

function 创建节点列表(this: void, centerX: number, centerY: number): 祖地双灵卫净化节点状态[] {
  const radius = 祖地双灵卫数值与表现配置.P3.节点中心偏移半径;
  const angles = [30, 150, 270];
  const result: 祖地双灵卫净化节点状态[] = [];
  for (let i = 0; i < angles.length; i++) {
    result.push({ 序号: i + 1, X: centerX + CosBJ(angles[i]) * radius, Y: centerY + SinBJ(angles[i]) * radius, 阶段: '未激活', 校准截止Ms: 0, 重试允许Ms: 0 });
  }
  return result;
}

export function 创建祖地双灵卫运行时上下文(this: void, 赤誓灵卫单位?: any, 苍影灵卫单位?: any, 场地矩形?: any): 祖地双灵卫运行时上下文 {
  const 清理 = 创建机制清理篮子('祖地双灵卫');
  const rect = 场地矩形;
  const fallbackX = 赤誓灵卫单位 != null && 苍影灵卫单位 != null ? (GetUnitX(赤誓灵卫单位) + GetUnitX(苍影灵卫单位)) * 0.5 : 0;
  const fallbackY = 赤誓灵卫单位 != null && 苍影灵卫单位 != null ? (GetUnitY(赤誓灵卫单位) + GetUnitY(苍影灵卫单位)) * 0.5 : 0;
  const centerX = rect != null && rect !== 0 ? GetRectCenterX(rect) : fallbackX;
  const centerY = rect != null && rect !== 0 ? GetRectCenterY(rect) : fallbackY;
  const halfWidth = rect != null && rect !== 0 ? (GetRectMaxX(rect) - GetRectMinX(rect)) * 0.5 : 1000;
  const halfHeight = rect != null && rect !== 0 ? (GetRectMaxY(rect) - GetRectMinY(rect)) * 0.5 : 850;
  let context!: 祖地双灵卫运行时上下文;
  const 联合生命周期 = 创建联合战斗成员生命周期({
    名称: '祖地双灵卫联合生命周期',
    清理,
    默认最终状态列表: ['崩解'],
    成员列表: [
      { key: '赤誓灵卫', 单位: 赤誓灵卫单位, 角色: '搭档', 初始状态: '活跃', 参与最终结算: true, 最终状态列表: ['崩解'] },
      { key: '苍影灵卫', 单位: 苍影灵卫单位, 角色: '搭档', 初始状态: '活跃', 参与最终结算: true, 最终状态列表: ['崩解'] },
    ],
    on满足最终结算: function 双灵卫满足最终结算(this: void): void {
      if (context != null) context.最终结算待处理 = true;
    },
  });
  context = {
    赤誓灵卫单位,
    苍影灵卫单位,
    阶段: 赤誓灵卫单位 != null && 苍影灵卫单位 != null ? 'P1双灵守门' : '未启动',
    赤誓灵卫形态: '正常',
    苍影灵卫形态: '正常',
    当前净化节点序号: 0,
    已净化节点数量: 0,
    崩解截止时间Ms: 0,
    同誓保护已启用: false,
    P2开始时间Ms: 0,
    大型机制忙碌到Ms: getServerTime() + 1800,
    下次联合机制Ms: getServerTime() + 22000,
    下次赤誓普通技能Ms: getServerTime() + 3200,
    下次苍影普通技能Ms: getServerTime() + 4700,
    空白灵域列表: [],
    净化节点列表: 创建节点列表(centerX, centerY),
    P3共鸣层数: 3,
    净化易伤到Ms: 0,
    最终结算待处理: false,
    封门误判待触发: false,
    净化节点清理已登记: false,
    侵蚀生命下限保护列表: [],
    同息生命下限保护列表: [],
    战斗已结束: false,
    场地矩形: rect,
    场地中心X: centerX,
    场地中心Y: centerY,
    场地半宽: halfWidth,
    场地半高: halfHeight,
    联合生命周期,
    清理,
    已初始化: 赤誓灵卫单位 != null && 苍影灵卫单位 != null,
  };
  return context;
}

export function 获取祖地双灵卫运行时上下文(this: void, unit: any): 祖地双灵卫运行时上下文 | undefined {
  return 单位上下文表[取单位ID(unit)];
}

export function 获取全部祖地双灵卫运行时上下文(this: void): 祖地双灵卫运行时上下文[] {
  const result: 祖地双灵卫运行时上下文[] = [];
  for (let i = 0; i < 上下文列表.length; i++) if (!上下文列表[i].战斗已结束) result.push(上下文列表[i]);
  return result;
}

export function 获取或创建祖地双灵卫运行时上下文(this: void, 启动单位: any): 祖地双灵卫运行时上下文 | undefined {
  const existing = 获取祖地双灵卫运行时上下文(启动单位);
  if (existing != null) return existing;
  const red = 是赤誓单位(启动单位) ? 启动单位 : 查找附近搭档(启动单位, true);
  const azure = 是苍影单位(启动单位) ? 启动单位 : 查找附近搭档(启动单位, false);
  if (red == null || red === 0 || azure == null || azure === 0) return undefined;
  const battle = 读取Boss战运行上下文(启动单位) ?? 读取Boss战运行上下文(red) ?? 读取Boss战运行上下文(azure);
  const context = 创建祖地双灵卫运行时上下文(red, azure, battle?.地点矩形);
  上下文列表.push(context);
  单位上下文表[取单位ID(red)] = context;
  单位上下文表[取单位ID(azure)] = context;
  播放赤誓灵卫台词(red, '开场');
  const azureOpeningId = addDelayedCallback(7200, function 苍影灵卫开场接话(this: void): void {
    if (!context.战斗已结束) 播放苍影灵卫台词(azure, '开场');
  });
  context.清理.登记延迟回调('祖地双灵卫-苍影开场台词', azureOpeningId);
  return context;
}

export function 清理祖地双灵卫运行时上下文(this: void, context: 祖地双灵卫运行时上下文): void {
  if (context.战斗已结束) return;
  context.战斗已结束 = true;
  context.阶段 = '已结束';
  单位上下文表[取单位ID(context.赤誓灵卫单位)] = undefined;
  单位上下文表[取单位ID(context.苍影灵卫单位)] = undefined;
  context.清理.清理全部();
}
