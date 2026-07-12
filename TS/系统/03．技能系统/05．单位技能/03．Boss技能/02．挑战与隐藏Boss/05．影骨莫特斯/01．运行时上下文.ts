/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 影骨莫特斯数值与表现配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, 取单位ID, stringToFourCC } from "./11．公共工具";

const jass = require("jass.common") as any;
const GetUnitTypeId = jass.GetUnitTypeId as (unit: any) => number;
const GetUnitState = jass.GetUnitState as (unit: any, state: any) => number;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;
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
  已初始化: boolean;
  清理: 机制清理篮子;
  已开启遗产宝箱数: number;
  背刺准备: boolean;
  幽影爆发中: boolean;
  幽影召唤物: any[];
  上次暗影禁锢Ms: number;
  下次暗影禁锢间隔Ms: number;
  当前召唤组?: 影骨召唤组;
  下一个召唤组ID: number;
  遗产宝箱已生成: boolean;
}

function 创建影骨莫特斯上下文(this: void, boss: any, 清理: 机制清理篮子): 影骨莫特斯运行时上下文 {
  播放影骨莫特斯台词(boss, "开场", 0);
  return {
    Boss单位: boss,
    阶段: 取影骨莫特斯当前阶段(boss),
    已初始化: false,
    清理,
    已开启遗产宝箱数: 0,
    背刺准备: false,
    幽影爆发中: false,
    幽影召唤物: [],
    上次暗影禁锢Ms: 0,
    下次暗影禁锢间隔Ms: 0,
    下一个召唤组ID: 0,
    遗产宝箱已生成: false,
  };
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

export function 取影骨莫特斯当前阶段(this: void, boss: any): 影骨莫特斯阶段 {
  if (!单位有效(boss)) return 1;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (!(maxLife > 0)) return 1;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  if (ratio <= 影骨莫特斯数值与表现配置.阶段阈值.P3生命比例) return 3;
  if (ratio <= 影骨莫特斯数值与表现配置.阶段阈值.P2生命比例) return 2;
  return 1;
}

export function 刷新影骨莫特斯阶段(this: void, context: 影骨莫特斯运行时上下文): 影骨莫特斯阶段 {
  context.阶段 = 取影骨莫特斯当前阶段(context.Boss单位);
  return context.阶段;
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
