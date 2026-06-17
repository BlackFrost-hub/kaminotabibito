/** @noSelfInFile */

import { 创建可配置层数状态, 可配置层数状态控制器 } from "../../../00．技能模板+函数/04．机制组件/01．层数状态";
import { 米亚安全域运行时矩形组, 创建米亚安全域矩形组, 清理米亚安全域矩形组, 取米亚单位所在安全域 } from "./01．场地配置";
import { 米亚单位技能配置 } from "./00．配置";
import { 米亚腐化感染配置, 米亚阶段阈值 } from "./02．数值与表现配置";
import { 尝试触发米亚灵猫分身 } from "./07．灵猫分身";
import { 刷新米亚污染标记 } from "./08．污染标记";
import { 尝试触发米亚污染脉冲 } from "./09．污染脉冲";
import { 尝试触发米亚污水柱爆发 } from "./10．污水柱爆发";
import { 尝试触发米亚腐化转移 } from "./11．腐化转移";
import { 刷新米亚平台超载惩罚 } from "./12．平台超载惩罚";
import { 刷新米亚腐化黏液涂层 } from "./13．腐化黏液涂层";
import { 尝试触发米亚终极污染, 清理米亚终极污染 } from "./14．终极污染";
import { 播放米亚台词 } from "./15．台词播放";
import { 设置单位技能壳普通提示 } from "../../../00．技能模板+函数/02．通用函数/15．单位技能壳提示";

const jass = require("jass.common") as any;
const { getServerTime, addPeriodicCallback } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
};

const GetHandleId = jass.GetHandleId as (whichHandle: any) => number;
const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

export type 米亚阶段 = 1 | 2 | 3;

export interface 米亚运行时上下文 {
  Boss单位: any;
  阶段: 米亚阶段;
  开战时间Ms: number;
  安全域区域组: 米亚安全域运行时矩形组;
  腐化层数控制器: 可配置层数状态控制器;
  已触发分身80: boolean;
  已触发分身50: boolean;
  污染标记目标?: any;
  上次污染标记低频台词Ms: number;
  已触发终极污染30: boolean;
  已触发终极污染15: boolean;
  上次腐化爪击Ms: number;
  上次污水喷吐Ms: number;
  上次污染标记Ms: number;
  上次污染脉冲Ms: number;
  上次污水柱爆发Ms: number;
  上次腐化转移Ms: number;
  上次平台超载检测Ms: number;
  上次全场甩黏液Ms: number;
  腐化转移污染平台ID?: string;
  腐化转移污染结束Ms: number;
  腐化转移下次叠层Ms: number;
  超载平台ID表: Record<string, boolean | undefined>;
  超载平台下次叠层Ms表: Record<string, number | undefined>;
  上次平台超载台词Ms: number;
  终极污染引导中: boolean;
  终极污染开始Ms: number;
  终极污染结束Ms: number;
  终极污染核心列表: any[];
  终极污染本次叠层表: Record<number, number | undefined>;
}

const 米亚上下文表: Record<number, 米亚运行时上下文 | undefined> = {};
let 米亚运行时已注册 = false;

function 取单位ID(this: void, unit: any): number {
  if (unit == null || unit === 0) return 0;
  return GetHandleId(unit) || 0;
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 创建米亚腐化层数控制器(this: void, context: 米亚运行时上下文): 可配置层数状态控制器 {
  return 创建可配置层数状态({
    状态ID: "mia-corruption",
    最大层数: 米亚腐化感染配置.最大层数,
    衰减: {
      等待秒: 米亚腐化感染配置.普通衰减等待秒,
      间隔秒: 米亚腐化感染配置.普通衰减间隔秒,
      每次减少层数: 1,
      加速条件: function 米亚腐化安全平台加速条件(this: void, 单位: any): boolean {
        const 区域 = 取米亚单位所在安全域(单位, context.安全域区域组);
        if (区域 == null) return false;
        const id = 区域.配置.ID ?? 区域.配置.名称 ?? "";
        if (id !== "" && context.腐化转移污染平台ID === id) return false;
        if (id !== "" && context.超载平台ID表[id] === true) return false;
        return true;
      },
      加速等待秒: 米亚腐化感染配置.安全平台衰减等待秒,
      加速间隔秒: 米亚腐化感染配置.安全平台衰减间隔秒,
    },
    表现档位: [
      { 键: "低层", 最小层数: 1, 最大层数: 6 },
      { 键: "中层", 最小层数: 7, 最大层数: 11 },
      { 键: "高层", 最小层数: 12, 最大层数: 15 },
    ],
  });
}

export function 获取米亚上下文(this: void, boss: any): 米亚运行时上下文 | undefined {
  const id = 取单位ID(boss);
  if (id === 0) return undefined;
  return 米亚上下文表[id];
}

export function 获取或创建米亚上下文(this: void, boss: any): 米亚运行时上下文 | undefined {
  const id = 取单位ID(boss);
  if (id === 0) return undefined;
  let context = 米亚上下文表[id];
  if (context != null) return context;

  context = {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    安全域区域组: 创建米亚安全域矩形组(),
    腐化层数控制器: undefined as any,
    已触发分身80: false,
    已触发分身50: false,
    污染标记目标: null,
    上次污染标记低频台词Ms: 0,
    已触发终极污染30: false,
    已触发终极污染15: false,
    上次腐化爪击Ms: 0,
    上次污水喷吐Ms: 0,
    上次污染标记Ms: 0,
    上次污染脉冲Ms: 0,
    上次污水柱爆发Ms: 0,
    上次腐化转移Ms: 0,
    上次平台超载检测Ms: 0,
    上次全场甩黏液Ms: 0,
    腐化转移污染平台ID: "",
    腐化转移污染结束Ms: 0,
    腐化转移下次叠层Ms: 0,
    超载平台ID表: {},
    超载平台下次叠层Ms表: {},
    上次平台超载台词Ms: 0,
    终极污染引导中: false,
    终极污染开始Ms: 0,
    终极污染结束Ms: 0,
    终极污染核心列表: [],
    终极污染本次叠层表: {},
  };
  context.腐化层数控制器 = 创建米亚腐化层数控制器(context);
  米亚上下文表[id] = context;
  设置单位技能壳普通提示(boss, 米亚单位技能配置.主动技能提示);
  播放米亚台词(boss, "开场", 0);
  return context;
}

export function 清理米亚上下文(this: void, boss: any): void {
  const id = 取单位ID(boss);
  if (id === 0) return;
  const context = 米亚上下文表[id];
  if (context == null) return;
  清理米亚终极污染(context);
  context.腐化层数控制器.销毁();
  清理米亚安全域矩形组(context.安全域区域组);
  delete 米亚上下文表[id];
}

function 刷新米亚阶段(this: void, context: 米亚运行时上下文): void {
  const boss = context.Boss单位;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (maxLife <= 0) return;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  if (context.阶段 === 1 && ratio <= 米亚阶段阈值.第二阶段生命比例) {
    context.阶段 = 2;
    播放米亚台词(boss, "转阶段2", 0);
  }
  if (context.阶段 === 2 && ratio <= 米亚阶段阈值.第三阶段生命比例) {
    context.阶段 = 3;
    播放米亚台词(boss, "转阶段3", 0);
  }
}

function 推进米亚运行时(this: void): void {
  const nowMs = getServerTime();
  for (const id in 米亚上下文表) {
    const context = 米亚上下文表[id as any];
    if (context == null) continue;
    if (!单位有效(context.Boss单位)) {
      清理米亚上下文(context.Boss单位);
      continue;
    }
    刷新米亚阶段(context);
    尝试触发米亚灵猫分身(context);
    刷新米亚污染标记(context, nowMs);
    尝试触发米亚污染脉冲(context, nowMs);
    尝试触发米亚污水柱爆发(context, nowMs);
    尝试触发米亚腐化转移(context, nowMs);
    刷新米亚平台超载惩罚(context, nowMs);
    刷新米亚腐化黏液涂层(context, nowMs);
    尝试触发米亚终极污染(context);
  }
}

export function 注册米亚运行时(this: void): void {
  if (米亚运行时已注册) return;
  米亚运行时已注册 = true;
  addPeriodicCallback(250, 推进米亚运行时);
}

export function 给单位添加米亚腐化层数(this: void, context: 米亚运行时上下文, 单位: any, 层数: number, 原因: string): number {
  return context.腐化层数控制器.增加(单位, 层数, 原因);
}
