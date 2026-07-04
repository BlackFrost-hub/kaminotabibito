/** @noSelfInFile */

const { resolveItemIdByName } = require("系统.02．物品系统.13．物品名反查") as {
  resolveItemIdByName: (this: void, name: string) => string | undefined;
};
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 注册持有型范围光环 } = require("系统.03．技能系统.00．技能模板+函数.01．技能函数.23．光环.01．范围光环") as {
  注册持有型范围光环: (this: void, params: {
    物品类型ID: number;
    间隔毫秒: number;
    半径: number;
    目标类型: "友军含自己" | "友军不含自己" | "敌人";
    排除无敌?: boolean;
    应用目标效果: (this: void, target: any, holder: any, currentCount: number) => void;
    同步目标效果?: (this: void, target: any, holder: any, currentCount: number) => void;
    移除目标效果: (this: void, target: any, holder: any, currentCount: number) => void;
  }) => void;
};
const { SGSS_SetState } = require("lib.扩展函数.Star扩展函数.00．SGSS") as {
  SGSS_SetState: (this: void, unit: any, id: number, value: number) => void;
};
const { registerManualBuff, 移除单位指定Buff } = require("系统.05．Buff系统.00．Buff系统") as {
  registerManualBuff: (this: void, target: any, buffID: string, durationSec: number, effectValue: number, extras?: any) => void;
  移除单位指定Buff: (this: void, unit: any, buffID: string) => boolean;
};
const { 常规BuffID } = require("系统.05．Buff系统.03．Buff表.00．Buff登记") as {
  常规BuffID: { 精灵执法披风_秩序领域: string };
};
import { 创建句柄上下文托管器 } from "../../../03．技能系统/00．技能模板+函数/04．机制组件/09．装备通用机制/24．句柄上下文托管";

const jass = require("jass.common") as any;
const GetUnitName = jass.GetUnitName as (unit: any) => string;

const 精灵执法披风配置 = {
  物品名: "精灵执法披风",
  范围: 300,
  周期毫秒: 500,
  攻速降低: -0.15,
  攻速属性ID: 10,
  BuffID: 常规BuffID.精灵执法披风_秩序领域,
  Buff持续时间: 1,
} as const;

const 精灵执法披风物品ID = stringToFourCCSafe(resolveItemIdByName(精灵执法披风配置.物品名));

type 精灵执法披风影响上下文 = {
  层数: number;
  单位: any;
  来源名称?: string;
};

const 精灵执法披风影响托管器 = 创建句柄上下文托管器<精灵执法披风影响上下文>("精灵执法披风影响");

let 已初始化精灵执法披风 = false;

function 记录精灵执法披风来源(this: void, source: any, unit: any): void {
  const 上下文 = 精灵执法披风影响托管器.读取(unit);
  if (上下文 == null) return;
  上下文.单位 = unit;
  if (source != null && source !== 0) {
    上下文.来源名称 = "『精灵执法披风』「" + GetUnitName(source) + "」";
  }
}

function 调整精灵执法披风影响层数(this: void, unit: any, delta: number): void {
  if (delta === 0 || unit == null || unit === 0) return;
  SGSS_SetState(unit, 精灵执法披风配置.攻速属性ID, 精灵执法披风配置.攻速降低 * delta);
}

function 刷新精灵执法披风Buff(this: void, unit: any): void {
  const 上下文 = 精灵执法披风影响托管器.读取(unit);
  if (上下文 == null || 上下文.层数 <= 0) return;
  registerManualBuff(unit, 精灵执法披风配置.BuffID, 精灵执法披风配置.Buff持续时间, 15, {
    sourceName: 上下文.来源名称,
  });
}

function 应用精灵执法披风光环(this: void, target: any, holder: any, currentCount: number): void {
  const count = currentCount <= 0 ? 1 : currentCount;
  const 当前上下文 = 精灵执法披风影响托管器.读取(target);
  const nextCount = (当前上下文?.层数 ?? 0) + count;
  精灵执法披风影响托管器.写入(target, {
    层数: nextCount,
    单位: target,
    来源名称: 当前上下文?.来源名称,
  });
  记录精灵执法披风来源(holder, target);
  调整精灵执法披风影响层数(target, count);
  刷新精灵执法披风Buff(target);
}

function 同步精灵执法披风光环(this: void, target: any, holder: any, _currentCount: number): void {
  记录精灵执法披风来源(holder, target);
  刷新精灵执法披风Buff(target);
}

function 移除精灵执法披风光环(this: void, target: any, _holder: any, currentCount: number): void {
  const count = currentCount <= 0 ? 1 : currentCount;
  const 当前上下文 = 精灵执法披风影响托管器.读取(target);
  const nextCount = (当前上下文?.层数 ?? 0) - count;
  调整精灵执法披风影响层数(target, -count);
  if (nextCount > 0) {
    精灵执法披风影响托管器.写入(target, {
      层数: nextCount,
      单位: target,
      来源名称: 当前上下文?.来源名称,
    });
    刷新精灵执法披风Buff(target);
    return;
  }
  移除单位指定Buff(target, 精灵执法披风配置.BuffID);
  精灵执法披风影响托管器.清空(target);
}

export function 初始化精灵执法披风效果(this: void): void {
  if (已初始化精灵执法披风) return;
  已初始化精灵执法披风 = true;
  if (精灵执法披风物品ID === 0) return;
  注册持有型范围光环({
    物品类型ID: 精灵执法披风物品ID,
    间隔毫秒: 精灵执法披风配置.周期毫秒,
    半径: 精灵执法披风配置.范围,
    目标类型: "敌人",
    应用目标效果: 应用精灵执法披风光环,
    同步目标效果: 同步精灵执法披风光环,
    移除目标效果: 移除精灵执法披风光环,
  });
}

初始化精灵执法披风效果();

export {};
