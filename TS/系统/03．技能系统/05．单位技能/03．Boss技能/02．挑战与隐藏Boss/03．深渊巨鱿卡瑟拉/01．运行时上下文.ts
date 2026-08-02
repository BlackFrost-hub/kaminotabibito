/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 创建阶段上下文, type 阶段上下文 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/01．阶段上下文";
import type { 动态装饰物安全区组 } from "../../../../00．技能模板+函数/04．机制组件/02．战斗区域/06．动态装饰物安全区组";
import { 卡瑟拉单位技能配置 } from "./00．配置";
import { 卡瑟拉数值与表现配置 } from "./02．数值与表现配置";
import { 触发卡瑟拉触手解放 } from "./08．触手解放";

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 卡瑟拉BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.02．卡瑟拉") as {
  卡瑟拉BuffID: { 触手残片: string };
};

export type 卡瑟拉阶段 = 1 | 2 | 3;

export interface 卡瑟拉地面触手残片 {
  X: number;
  Y: number;
  特效?: any;
  已吸收?: boolean;
}

export interface 卡瑟拉绝缘珊瑚点 {
  X: number;
  Y: number;
  半径: number;
  装饰单位?: any;
}

export interface 卡瑟拉运行时上下文 {
  Boss单位: any;
  阶段: 卡瑟拉阶段;
  阶段上下文: 阶段上下文;
  已初始化: boolean;
  清理: 机制清理篮子;
  触手残片数量: number;
  玩家触手残片表: Record<number, number | undefined>;
  玩家触手残片单位表: Record<number, any>;
  场上触手残片列表: 卡瑟拉地面触手残片[];
  绝缘珊瑚列表: 卡瑟拉绝缘珊瑚点[];
  绝缘珊瑚安全区组?: 动态装饰物安全区组;
  触手解放已触发: boolean;
  触手再生节点已注册: boolean;
  Boss潜入中: boolean;
  触手精华层数: number;
}

function 创建卡瑟拉上下文(this: void, boss: any, 清理: 机制清理篮子): 卡瑟拉运行时上下文 {
  const context: 卡瑟拉运行时上下文 = {
    Boss单位: boss,
    阶段: 1,
    阶段上下文: undefined as any,
    已初始化: false,
    清理,
    触手残片数量: 0,
    玩家触手残片表: {},
    玩家触手残片单位表: {},
    场上触手残片列表: [],
    绝缘珊瑚列表: [],
    触手解放已触发: false,
    触手再生节点已注册: false,
    Boss潜入中: false,
    触手精华层数: 0,
  };
  context.阶段上下文 = 创建阶段上下文({
    清理,
    名称: "卡瑟拉",
    单位: boss,
    初始阶段ID: "P1",
    Tick间隔毫秒: 卡瑟拉数值与表现配置.运行时.推进间隔毫秒,
    阶段列表: [{
      ID: "P1",
    }, {
      ID: "P2",
      血量百分比: 卡瑟拉数值与表现配置.阶段阈值.P2生命比例,
      on进入: function 卡瑟拉进入P2(this: void): void {
        context.阶段 = 2;
      },
    }, {
      ID: "P3",
      血量百分比: 卡瑟拉数值与表现配置.阶段阈值.P3生命比例,
      on进入: function 卡瑟拉进入P3(this: void): void {
        context.阶段 = 3;
        触发卡瑟拉触手解放(context);
      },
    }],
  });
  return context;
}

const 卡瑟拉上下文工厂 = 创建单位运行时上下文工厂<卡瑟拉运行时上下文>({
  名称: "卡瑟拉",
  主动技能提示: 卡瑟拉单位技能配置.主动技能提示,
  创建上下文: 创建卡瑟拉上下文,
  死亡时自动清理: true,
});

export function 获取卡瑟拉上下文(this: void, boss: any): 卡瑟拉运行时上下文 | undefined {
  return 卡瑟拉上下文工厂.获取(boss);
}

export function 获取或创建卡瑟拉上下文(this: void, boss: any): 卡瑟拉运行时上下文 | undefined {
  return 卡瑟拉上下文工厂.获取或创建(boss);
}

export function 获取全部卡瑟拉上下文(this: void): 卡瑟拉运行时上下文[] {
  return 卡瑟拉上下文工厂.获取全部();
}

export function 清理卡瑟拉上下文(this: void, boss: any): void {
  卡瑟拉上下文工厂.清理上下文(boss);
}

export function 增加玩家触手残片(this: void, context: 卡瑟拉运行时上下文, unit: any, amount: number = 1): number {
  const id = 卡瑟拉上下文工厂.取单位ID(unit);
  if (id === 0) return 0;
  const max = 卡瑟拉数值与表现配置.触手残片.玩家持有上限;
  let next = (context.玩家触手残片表[id] ?? 0) + amount;
  if (next > max) next = max;
  if (next < 0) next = 0;
  context.玩家触手残片表[id] = next;
  context.玩家触手残片单位表[id] = unit;
  刷新玩家触手残片Buff(context, unit, next);
  return next;
}

export function 设置玩家触手残片(this: void, context: 卡瑟拉运行时上下文, unit: any, amount: number): number {
  const id = 卡瑟拉上下文工厂.取单位ID(unit);
  if (id === 0) return 0;
  const max = 卡瑟拉数值与表现配置.触手残片.玩家持有上限;
  let next = amount;
  if (next > max) next = max;
  if (next < 0) next = 0;
  context.玩家触手残片表[id] = next;
  context.玩家触手残片单位表[id] = unit;
  刷新玩家触手残片Buff(context, unit, next);
  return next;
}

export function 刷新玩家触手残片Buff(this: void, _context: 卡瑟拉运行时上下文, unit: any, stack?: number): void {
  const current = stack != null ? stack : 0;
  if (current <= 0) {
    移除单位指定Buff(unit, 卡瑟拉BuffID.触手残片);
    return;
  }
  registerManualBuff(unit, 卡瑟拉BuffID.触手残片, 120, current, {
    stack: current,
    sourceName: "卡瑟拉-触手残片",
  });
}

export function 取玩家触手残片(this: void, context: 卡瑟拉运行时上下文, unit: any): number {
  const id = 卡瑟拉上下文工厂.取单位ID(unit);
  return id === 0 ? 0 : (context.玩家触手残片表[id] ?? 0);
}

export function 消耗玩家触手残片(this: void, context: 卡瑟拉运行时上下文, unit: any, amount: number): boolean {
  const id = 卡瑟拉上下文工厂.取单位ID(unit);
  if (id === 0) return false;
  const current = context.玩家触手残片表[id] ?? 0;
  if (current < amount) return false;
  context.玩家触手残片表[id] = current - amount;
  context.玩家触手残片单位表[id] = unit;
  刷新玩家触手残片Buff(context, unit, current - amount);
  return true;
}
