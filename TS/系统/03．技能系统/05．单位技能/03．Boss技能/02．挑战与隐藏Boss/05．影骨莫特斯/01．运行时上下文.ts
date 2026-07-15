/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 创建阶段上下文, type 阶段上下文 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/01．阶段上下文";
import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 影骨莫特斯数值与表现配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, 取单位ID, stringToFourCC } from "./11．公共工具";
import type { 固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const { registerDeathListener } = require("系统.00．核心系统.01．事件中心.07．单位死亡事件中心") as {
  registerDeathListener: (this: void, callback: (this: void, dyingUnit: any, killingUnit: any) => void) => void;
};

const 影骨莫特斯单位类型ID = stringToFourCC(影骨莫特斯单位技能配置.单位ID);
let 影骨莫特斯死亡监听已注册 = false;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 影骨莫特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.04．影骨莫特斯") as {
  影骨莫特斯BuffID: {
    背刺准备: string;
    幽灵形态: string;
    盗贼遗产: string;
  };
};

export type 影骨莫特斯阶段 = 1 | 2 | 3;

export interface 影骨召唤组 {
  ID: number;
  阶段: 影骨莫特斯阶段;
  总数: number;
  死亡数: number;
  已重组: boolean;
}

export interface 影骨莫特斯运行时上下文 {
  Boss单位: any;
  阶段: 影骨莫特斯阶段;
  阶段上下文: 阶段上下文;
  已初始化: boolean;
  清理: 机制清理篮子;
  已开启遗产宝箱数: number;
  背刺准备: boolean;
  幽影爆发中: boolean;
  幽影召唤物: any[];
  当前召唤组?: 影骨召唤组;
  下一个召唤组ID: number;
  遗产宝箱已生成: boolean;
  骸骨召唤组合执行器?: 固定组合技能执行器<影骨莫特斯运行时上下文>;
  盗贼遗产组合执行器?: 固定组合技能执行器<影骨莫特斯运行时上下文>;
}

function 创建影骨莫特斯上下文(this: void, boss: any, 清理: 机制清理篮子): 影骨莫特斯运行时上下文 {
  播放影骨莫特斯台词(boss, "开场", 0);
  const context: 影骨莫特斯运行时上下文 = {
    Boss单位: boss,
    阶段: 1,
    阶段上下文: undefined as any,
    已初始化: false,
    清理,
    已开启遗产宝箱数: 0,
    背刺准备: false,
    幽影爆发中: false,
    幽影召唤物: [],
    下一个召唤组ID: 0,
    遗产宝箱已生成: false,
  };
  context.阶段上下文 = 创建阶段上下文({
    清理,
    名称: "影骨莫特斯",
    单位: boss,
    初始阶段ID: "P1",
    阶段列表: [{ ID: "P1" }, {
      ID: "P2",
      血量百分比: 影骨莫特斯数值与表现配置.阶段阈值.P2生命比例,
      on进入: function 影骨莫特斯进入P2(this: void): void { context.阶段 = 2; },
    }, {
      ID: "P3",
      血量百分比: 影骨莫特斯数值与表现配置.阶段阈值.P3生命比例,
      on进入: function 影骨莫特斯进入P3(this: void): void { context.阶段 = 3; },
    }],
  });
  return context;
}

const 影骨莫特斯上下文工厂 = 创建单位运行时上下文工厂<影骨莫特斯运行时上下文>({
  名称: "影骨莫特斯",
  主动技能提示: 影骨莫特斯单位技能配置.主动技能提示,
  创建上下文: 创建影骨莫特斯上下文,
});

export function 获取影骨莫特斯上下文(this: void, boss: any): 影骨莫特斯运行时上下文 | undefined {
  return 影骨莫特斯上下文工厂.获取(boss);
}

export function 获取或创建影骨莫特斯上下文(this: void, boss: any): 影骨莫特斯运行时上下文 | undefined {
  return 影骨莫特斯上下文工厂.获取或创建(boss);
}

export function 清理影骨莫特斯上下文(this: void, boss: any): void {
  影骨莫特斯上下文工厂.清理上下文(boss);
}

export function 获取全部影骨莫特斯上下文(this: void): 影骨莫特斯运行时上下文[] {
  return 影骨莫特斯上下文工厂.获取全部();
}

export function 设置影骨背刺准备(this: void, context: 影骨莫特斯运行时上下文, enabled: boolean): void {
  context.背刺准备 = enabled;
  if (!单位有效(context.Boss单位)) return;
  if (enabled) {
    registerManualBuff(context.Boss单位, 影骨莫特斯BuffID.背刺准备, 12, 1, { sourceName: "影骨-背刺准备" });
  } else {
    移除单位指定Buff(context.Boss单位, 影骨莫特斯BuffID.背刺准备);
  }
}

export function 刷新影骨幽灵形态Buff(this: void, context: 影骨莫特斯运行时上下文): void {
  if (!单位有效(context.Boss单位)) return;
  if (context.幽影爆发中) {
    registerManualBuff(context.Boss单位, 影骨莫特斯BuffID.幽灵形态, 影骨莫特斯数值与表现配置.幽影爆发.持续秒, 1, { sourceName: "影骨-幽灵形态" });
  } else {
    移除单位指定Buff(context.Boss单位, 影骨莫特斯BuffID.幽灵形态);
  }
}

export function 刷新影骨盗贼遗产Buff(this: void, context: 影骨莫特斯运行时上下文): void {
  if (!单位有效(context.Boss单位) || context.已开启遗产宝箱数 <= 0) return;
  registerManualBuff(context.Boss单位, 影骨莫特斯BuffID.盗贼遗产, 9999, context.已开启遗产宝箱数, {
    stack: context.已开启遗产宝箱数,
    sourceName: "影骨-盗贼遗产",
  });
}

export function 注册影骨莫特斯运行时(this: void): void {
  if (影骨莫特斯死亡监听已注册) return;
  影骨莫特斯死亡监听已注册 = true;
  registerDeathListener(on影骨莫特斯死亡);
}

function on影骨莫特斯死亡(this: void, dyingUnit: any): void {
  if (GetUnitTypeId(dyingUnit) !== 影骨莫特斯单位类型ID) return;
  播放影骨莫特斯台词(dyingUnit, "死亡", 0);
  清理影骨莫特斯上下文(dyingUnit);
}
