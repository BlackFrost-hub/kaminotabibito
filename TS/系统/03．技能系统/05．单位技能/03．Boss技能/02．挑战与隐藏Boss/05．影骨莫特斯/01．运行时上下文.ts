/** @noSelfInFile */

import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 创建阶段上下文, type 阶段上下文 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/01．阶段上下文";
import type { 召唤物组状态 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/03．召唤物组状态管理";
import { 影骨莫特斯单位技能配置 } from "./00．配置";
import { 影骨莫特斯数值与表现配置 } from "./02．数值与表现配置";
import { 播放影骨莫特斯台词 } from "./08．台词播放";
import { 单位有效, 取单位ID, stringToFourCC } from "./11．公共工具";
import type { 固定组合技能执行器 } from "../../../../00．技能模板+函数/00．技能模板/14．固定组合技能模板/01．固定组合技能执行器";
import { 读取单位攻击力 } from "../../../../00．技能模板+函数/02．通用函数/19．战斗公共工具";

const jass = require("jass.common") as any;
const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (unit: any, abilityId: number) => number;
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { 技能_设置技能冷却时间 } = require("平台扩展API动作") as {
  技能_设置技能冷却时间: (this: void, unit: any, abilityId: number, cooldown: number, maxCooldown: number) => boolean;
};
const { 技能_获取技能当前冷却时间, 技能_获取技能最大冷却时间 } = require("平台扩展API取值") as {
  技能_获取技能当前冷却时间: (this: void, unit: any, abilityId: number) => number;
  技能_获取技能最大冷却时间: (this: void, unit: any, abilityId: number) => number;
};

const 幽影爆发技能ID = stringToFourCC(影骨莫特斯单位技能配置.技能壳.幽影爆发);
const 攻击力属性ID = 1;

const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 影骨莫特斯BuffID } = require("系统.05．Buff系统.03．Buff表.01．Boss.02．挑战与隐藏Boss.04．影骨莫特斯") as {
  影骨莫特斯BuffID: {
    背刺准备: string;
    幽灵形态: string;
    盗贼遗产: string;
    P3强化: string;
  };
};

export type 影骨莫特斯阶段 = 1 | 2 | 3;

export type 影骨召唤组 = 召唤物组状态;

export interface 影骨盗贼遗产宝箱点 {
  X: number;
  Y: number;
  朝向: number;
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
  P3强化已应用: boolean;
  P3攻击力增量: number;
  P3幽影爆发原始最大冷却: number;
  当前召唤组?: 影骨召唤组;
  遗产宝箱已生成: boolean;
  遗产宝箱点?: 影骨盗贼遗产宝箱点[];
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
    P3强化已应用: false,
    P3攻击力增量: 0,
    P3幽影爆发原始最大冷却: 0,
    遗产宝箱已生成: false,
    遗产宝箱点: undefined,
  };
  context.阶段上下文 = 创建阶段上下文({
    清理,
    名称: "影骨莫特斯",
    单位: boss,
    初始阶段ID: "P1",
    阶段列表: [{ ID: "P1" }, {
      ID: "P2",
      血量百分比: 影骨莫特斯数值与表现配置.阶段阈值.P2生命比例,
      on进入: 影骨莫特斯阶段进入P2,
    }, {
      ID: "P3",
      血量百分比: 影骨莫特斯数值与表现配置.阶段阈值.P3生命比例,
      on进入: 影骨莫特斯阶段进入P3,
    }],
  });
  return context;
}

function 影骨莫特斯阶段进入P2(this: void, 阶段: 阶段上下文): void {
  const context = 获取影骨莫特斯上下文(阶段.单位);
  if (context != null) context.阶段 = 2;
}

function 应用影骨莫特斯P3强化(this: void, context: 影骨莫特斯运行时上下文): void {
  if (context.P3强化已应用 || !单位有效(context.Boss单位)) return;
  const cfg = 影骨莫特斯数值与表现配置.P3强化;
  const 攻击力增量 = 读取单位攻击力(context.Boss单位) * cfg.攻击力提高比例;
  if (攻击力增量 !== 0) SGSS_SetState(context.Boss单位, 攻击力属性ID, 攻击力增量);
  context.P3攻击力增量 = 攻击力增量;

  if (GetUnitAbilityLevel(context.Boss单位, 幽影爆发技能ID) > 0) {
    let 原始最大冷却 = 技能_获取技能最大冷却时间(context.Boss单位, 幽影爆发技能ID) || 0;
    if (原始最大冷却 <= 0) 原始最大冷却 = 影骨莫特斯数值与表现配置.幽影爆发.冷却秒;
    context.P3幽影爆发原始最大冷却 = 原始最大冷却;
    const 当前冷却 = 技能_获取技能当前冷却时间(context.Boss单位, 幽影爆发技能ID) || 0;
    const P3最大冷却 = 原始最大冷却 * cfg.幽影爆发冷却比例;
    const P3当前冷却 = 当前冷却 * cfg.幽影爆发冷却比例;
    技能_设置技能冷却时间(context.Boss单位, 幽影爆发技能ID, P3当前冷却, P3最大冷却);
  }

  registerManualBuff(context.Boss单位, 影骨莫特斯BuffID.P3强化, 9999, cfg.攻击力提高比例, {
    sourceName: "影骨-P3强化",
  });
  context.P3强化已应用 = true;
}

function 清除影骨莫特斯P3强化(this: void, context: 影骨莫特斯运行时上下文): void {
  if (context.P3攻击力增量 !== 0 && 单位有效(context.Boss单位)) {
    SGSS_SetState(context.Boss单位, 攻击力属性ID, -context.P3攻击力增量);
  }
  if (context.P3幽影爆发原始最大冷却 > 0 && 单位有效(context.Boss单位) && GetUnitAbilityLevel(context.Boss单位, 幽影爆发技能ID) > 0) {
    const 当前冷却 = 技能_获取技能当前冷却时间(context.Boss单位, 幽影爆发技能ID) || 0;
    技能_设置技能冷却时间(context.Boss单位, 幽影爆发技能ID, 当前冷却, context.P3幽影爆发原始最大冷却);
  }
  if (context.Boss单位 != null && context.Boss单位 !== 0) 移除单位指定Buff(context.Boss单位, 影骨莫特斯BuffID.P3强化);
  context.P3强化已应用 = false;
  context.P3攻击力增量 = 0;
  context.P3幽影爆发原始最大冷却 = 0;
}

function 影骨莫特斯阶段进入P3(this: void, 阶段: 阶段上下文): void {
  const context = 获取影骨莫特斯上下文(阶段.单位);
  if (context == null) return;
  context.阶段 = 3;
  应用影骨莫特斯P3强化(context);
}

function 清理影骨莫特斯上下文机制(this: void, context: 影骨莫特斯运行时上下文): void {
  清除影骨莫特斯P3强化(context);
  context.幽影召唤物 = [];
  context.当前召唤组 = undefined;
}

function on影骨莫特斯单位死亡(this: void, _context: 影骨莫特斯运行时上下文, dyingUnit: any, _killingUnit: any): void {
  播放影骨莫特斯台词(dyingUnit, "死亡", 0);
}

const 影骨莫特斯上下文工厂 = 创建单位运行时上下文工厂<影骨莫特斯运行时上下文>({
  名称: "影骨莫特斯",
  主动技能提示: 影骨莫特斯单位技能配置.主动技能提示,
  创建上下文: 创建影骨莫特斯上下文,
  on清理: 清理影骨莫特斯上下文机制,
  死亡时自动清理: true,
  on单位死亡: on影骨莫特斯单位死亡,
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

export function 设置影骨莫特斯测试阶段(this: void, context: 影骨莫特斯运行时上下文, 阶段: 影骨莫特斯阶段): void {
  if (阶段 !== 3 && context.P3强化已应用) 清除影骨莫特斯P3强化(context);
  context.阶段 = 阶段;
  if (阶段 === 3) 应用影骨莫特斯P3强化(context);
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

export function 注册影骨莫特斯运行时(this: void): void {}
