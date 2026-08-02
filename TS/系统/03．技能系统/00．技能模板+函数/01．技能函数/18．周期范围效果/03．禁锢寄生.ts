/** @noSelfInFile */

import type { 每跳伤害计算器, 持续伤害组件, 持续原生效果参数 } from "./01．类型";
import type { 自适应共享周期驱动 } from "../../04．机制组件/10．复杂战斗通用机制/17．周期机制调度器";

const jass = require("jass.common") as any;

const GetUnitAbilityLevel = jass.GetUnitAbilityLevel as (whichUnit: any, abilityId: number) => number;
const IsUnitPaused = jass.IsUnitPaused as (whichUnit: any) => boolean;
const ATTACK_TYPE_NORMAL = jass.ATTACK_TYPE_NORMAL;
const DAMAGE_TYPE_PLANT = jass.DAMAGE_TYPE_PLANT;
const WEAPON_TYPE_WHOKNOWS = jass.WEAPON_TYPE_WHOKNOWS;

const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};
const { 创建自适应共享周期驱动 } = require("系统.03．技能系统.00．技能模板+函数.04．机制组件.10．复杂战斗通用机制.17．周期机制调度器") as {
  创建自适应共享周期驱动: (this: void, 参数: any) => 自适应共享周期驱动;
};
const { SFB_setEntanglingRoots, SFB_setParasite } = require("lib.扩展函数.Star扩展函数.Star扩展库.04．快速Buff系统") as {
  SFB_setEntanglingRoots: (this: void, sourceUnit: any, u: any, time: number) => void;
  SFB_setParasite: (this: void, sourceUnit: any, u: any, time: number) => void;
};
const { 造成持续伤害 } = require("系统.04．伤害系统.07．持续伤害系统") as {
  造成持续伤害: (this: void, source: any, target: any, amount: number, damageType: any, ranged?: boolean, attackType?: any, weaponType?: any, 选项?: any) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};

const BUFF_纠缠根须 = 0x42456572;
const BUFF_寄生 = 0x424E7061;
const 默认伤害间隔 = 1;
const 持续时间补偿 = 0.05;

interface 持续伤害实例 {
  ID: number;
  来源单位: any;
  目标单位: any;
  伤害: number;
  伤害类型: any;
  每跳伤害计算器?: 每跳伤害计算器;
  伤害间隔毫秒: number;
  下次伤害时间: number;
  BuffID: number;
  调试标签?: string;
  调试跳数: number;
  调试上次暂停日志时间: number;
}

const 持续伤害实例表: Record<number, 持续伤害实例 | undefined> = {};
const 持续伤害ID列表: number[] = [];
let 下一个持续伤害ID = 0;
let 持续伤害驱动: 自适应共享周期驱动 | undefined;

function 转数字(this: void, value: any): number {
  if (value == null || value === false || value === "") return 0;
  const n = typeof value === "number" ? value : Number(value);
  return n !== n ? 0 : n;
}

function 读取来源单位(this: void, 参数: 持续原生效果参数): any {
  return 参数.来源单位 ?? 参数.BuffSource;
}

function 读取目标单位(this: void, 参数: 持续原生效果参数): any {
  return 参数.目标单位 ?? 参数.BuffTarget;
}

function 读取持续时间(this: void, 参数: 持续原生效果参数): number {
  const time = 转数字(参数.持续时间 ?? 参数.time);
  return time > 0 ? time + 持续时间补偿 : 0;
}

function 读取伤害间隔(this: void, 参数: 持续原生效果参数): number {
  const interval = 转数字(参数.伤害间隔 ?? 参数.DamageInterval);
  return interval > 0 ? interval : 默认伤害间隔;
}

function 读取伤害类型(this: void, 参数: 持续原生效果参数): any {
  return 参数.伤害类型 ?? 参数.DamageType ?? DAMAGE_TYPE_PLANT;
}

function 注册持续伤害(this: void, 来源单位: any, 目标单位: any, 伤害: number, 伤害类型: any, 伤害间隔: number, BuffID: number, 每跳伤害计算器?: 每跳伤害计算器, 调试标签?: string): number {
  if (目标单位 == null || 目标单位 === 0) return 0;
  if (!(伤害 > 0) && 每跳伤害计算器 == null) return 0;

  const id = ++下一个持续伤害ID;
  const now = getServerTime();
  持续伤害实例表[id] = {
    ID: id,
    来源单位,
    目标单位,
    伤害,
    伤害类型,
    每跳伤害计算器,
    伤害间隔毫秒: 伤害间隔 * 1000,
    下次伤害时间: now + 伤害间隔 * 1000,
    BuffID,
    调试标签,
    调试跳数: 0,
    调试上次暂停日志时间: 0,
  };
  持续伤害ID列表.push(id);
  确保持续伤害系统启动();
  return id;
}

function 移除持续伤害(this: void, id: number): void {
  const 实例 = 持续伤害实例表[id];
  if (实例 == null) return;
  if (实例.调试标签 != null) debugLogForce(实例.调试标签, "持续伤害实例移除", "实例ID=", id, "目标=", 实例.目标单位, "已执行跳数=", 实例.调试跳数);
  delete 持续伤害实例表[id];
  const index = 持续伤害ID列表.indexOf(id);
  if (index >= 0) 持续伤害ID列表.splice(index, 1);
}

function 确保持续伤害系统启动(this: void): void {
  if (持续伤害驱动 == null) {
    持续伤害驱动 = 创建自适应共享周期驱动({
      名称: "禁锢寄生持续伤害驱动",
      最大检查间隔毫秒: 100,
      取建议检查间隔毫秒: 取持续伤害建议检查间隔,
      onTick: 持续伤害系统Tick,
    });
  }
  持续伤害驱动.刷新();
}

function 取持续伤害建议检查间隔(this: void, _nowMs: number): number {
  let 最短间隔 = 0;
  for (let i = 0; i < 持续伤害ID列表.length; i++) {
    const 实例 = 持续伤害实例表[持续伤害ID列表[i]];
    if (实例 == null) continue;
    const 间隔 = 实例.伤害间隔毫秒;
    if (间隔 > 0 && (最短间隔 === 0 || 间隔 < 最短间隔)) 最短间隔 = 间隔;
  }
  return 最短间隔;
}

function 持续伤害系统Tick(this: void, now: number): void {
  let index = 0;
  while (index < 持续伤害ID列表.length) {
    const id = 持续伤害ID列表[index];
    const 实例 = 持续伤害实例表[id];
    if (实例 == null || 实例.目标单位 == null || 实例.目标单位 === 0) {
      if (实例 != null && 实例.调试标签 != null) debugLogForce(实例.调试标签, "持续伤害跳过并移除：目标句柄无效", "实例ID=", id);
      移除持续伤害(id);
      continue;
    }

    if (GetUnitAbilityLevel(实例.目标单位, 实例.BuffID) <= 0) {
      if (实例.调试标签 != null) debugLogForce(实例.调试标签, "持续伤害跳过并移除：原生Buff不存在", "实例ID=", id, "BuffID=", 实例.BuffID);
      移除持续伤害(id);
      continue;
    }

    if (now >= 实例.下次伤害时间) {
      if (IsUnitPaused(实例.目标单位)) {
        if (实例.调试标签 != null && now - 实例.调试上次暂停日志时间 >= 1000) {
          实例.调试上次暂停日志时间 = now;
          debugLogForce(实例.调试标签, "持续伤害跳过：目标当前被暂停", "实例ID=", id, "目标=", 实例.目标单位, "时间Ms=", now, "下次伤害时间=", 实例.下次伤害时间);
        }
      } else {
        实例.调试跳数 += 1;
        if (实例.调试标签 != null) debugLogForce(实例.调试标签, "持续伤害Tick开始", "实例ID=", id, "跳数=", 实例.调试跳数, "时间Ms=", now, "目标=", 实例.目标单位);
        const 每跳伤害计算器 = 实例.每跳伤害计算器;
        if (每跳伤害计算器 != null) {
          const 伤害组件列表: 持续伤害组件[] = 每跳伤害计算器(实例.来源单位, 实例.目标单位);
          if (实例.调试标签 != null) debugLogForce(实例.调试标签, "动态伤害计算器返回", "实例ID=", id, "组件数=", 伤害组件列表.length);
          for (let componentIndex = 0; componentIndex < 伤害组件列表.length; componentIndex++) {
            const 伤害组件 = 伤害组件列表[componentIndex];
            if (伤害组件 == null || !(伤害组件.伤害 > 0)) {
              if (实例.调试标签 != null) debugLogForce(实例.调试标签, "伤害组件跳过", "实例ID=", id, "组件索引=", componentIndex, "组件有效=", 伤害组件 != null, "伤害=", 伤害组件 != null ? 伤害组件.伤害 : 0);
              continue;
            }
            const applied = 造成持续伤害(实例.来源单位, 实例.目标单位, 伤害组件.伤害, 伤害组件.伤害类型, false, ATTACK_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
            if (实例.调试标签 != null) debugLogForce(实例.调试标签, "伤害组件已结算", "实例ID=", id, "组件索引=", componentIndex, "伤害=", 伤害组件.伤害, "伤害类型句柄=", 伤害组件.伤害类型, "结算返回=", applied);
          }
        } else {
          const applied = 造成持续伤害(实例.来源单位, 实例.目标单位, 实例.伤害, 实例.伤害类型, false, ATTACK_TYPE_NORMAL, WEAPON_TYPE_WHOKNOWS);
          if (实例.调试标签 != null) debugLogForce(实例.调试标签, "固定伤害已结算", "实例ID=", id, "伤害=", 实例.伤害, "伤害类型句柄=", 实例.伤害类型, "结算返回=", applied);
        }
        实例.下次伤害时间 = now + 实例.伤害间隔毫秒;
        if (实例.调试标签 != null) debugLogForce(实例.调试标签, "持续伤害Tick结束", "实例ID=", id, "下一次伤害时间=", 实例.下次伤害时间);
      }
    }

    if (index < 持续伤害ID列表.length && 持续伤害ID列表[index] === id) index++;
  }
}

export function 施加禁锢(this: void, 参数: 持续原生效果参数): void {
  const 来源单位 = 读取来源单位(参数);
  const 目标单位 = 读取目标单位(参数);
  const 持续时间 = 读取持续时间(参数);
  const 调试标签 = (参数 as any).调试标签 as string | undefined;
  if (调试标签 != null) debugLogForce(调试标签, "施加禁锢入口", "来源=", 来源单位, "目标=", 目标单位, "持续秒=", 持续时间, "伤害=", 转数字(参数.伤害 ?? 参数.HitDamage), "伤害间隔秒=", 读取伤害间隔(参数), "有动态计算器=", 参数.每跳伤害计算器 != null);
  if (目标单位 == null || 目标单位 === 0 || 持续时间 <= 0) {
    if (调试标签 != null) debugLogForce(调试标签, "施加禁锢拒绝", "目标句柄有效=", 目标单位 != null && 目标单位 !== 0, "持续时间有效=", 持续时间 > 0);
    return;
  }

  SFB_setEntanglingRoots(来源单位, 目标单位, 持续时间);
  if (调试标签 != null) debugLogForce(调试标签, "原生纠缠根须已调用", "来源=", 来源单位, "目标=", 目标单位, "持续秒=", 持续时间);
  const 实例ID = 注册持续伤害(来源单位, 目标单位, 转数字(参数.伤害 ?? 参数.HitDamage), 读取伤害类型(参数), 读取伤害间隔(参数), BUFF_纠缠根须, 参数.每跳伤害计算器, 调试标签);
  if (调试标签 != null) debugLogForce(调试标签, "持续伤害实例已注册", "实例ID=", 实例ID, "来源=", 来源单位, "目标=", 目标单位);
}

export function 施加寄生(this: void, 参数: 持续原生效果参数): void {
  const 来源单位 = 读取来源单位(参数);
  const 目标单位 = 读取目标单位(参数);
  const 持续时间 = 读取持续时间(参数);
  if (目标单位 == null || 目标单位 === 0 || 持续时间 <= 0) return;

  SFB_setParasite(来源单位, 目标单位, 持续时间);
  注册持续伤害(来源单位, 目标单位, 转数字(参数.伤害 ?? 参数.HitDamage), 读取伤害类型(参数), 读取伤害间隔(参数), BUFF_寄生, 参数.每跳伤害计算器);
}

export {};
