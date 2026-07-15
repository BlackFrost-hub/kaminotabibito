/** @noSelfInFile */

import { 瑟兰迪尔单位技能配置 } from "./00．配置";
import { 瑟兰迪尔阶段阈值, 瑟兰迪尔运行时配置 } from "./02．数值与表现配置";
import { 尝试触发瑟兰迪尔执法印记 } from "./04．执法印记";
import { 刷新瑟兰迪尔秩序领域, 清理瑟兰迪尔秩序领域 } from "./07．秩序领域";
import { 尝试触发瑟兰迪尔审判之环 } from "./08．审判之环";
import { 尝试触发瑟兰迪尔月光灌注, 清理瑟兰迪尔月光灌注 } from "./11．月光灌注";
import { 尝试触发瑟兰迪尔终末审判 } from "./12．终末审判";
import type { 机制清理篮子 } from "../../../../00．技能模板+函数/04．机制组件/06．机制清理/01．机制清理篮子";
import { 创建单位运行时上下文工厂 } from "../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/15．单位运行时上下文工厂";
import { 创建周期机制调度器 } from '../../../../00．技能模板+函数/04．机制组件/10．复杂战斗通用机制/17．周期机制调度器';
export { 播放瑟兰迪尔台词 } from "./15．台词播放";
import { 播放瑟兰迪尔台词 } from "./15．台词播放";

const jass = require("jass.common") as any;
const { getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  getServerTime: (this: void) => number;
};

const IsUnitType = jass.IsUnitType as (whichUnit: any, whichUnitType: any) => boolean;
const GetUnitState = jass.GetUnitState as (whichUnit: any, whichUnitState: any) => number;
const UNIT_TYPE_DEAD = jass.UNIT_TYPE_DEAD as any;
const UNIT_STATE_LIFE = jass.UNIT_STATE_LIFE as any;
const UNIT_STATE_MAX_LIFE = jass.UNIT_STATE_MAX_LIFE as any;

export type 瑟兰迪尔阶段 = 1 | 2 | 3;

export interface 瑟兰迪尔运行时上下文 {
  Boss单位: any;
  阶段: 瑟兰迪尔阶段;
  开战时间Ms: number;
  清理: 机制清理篮子;
  上次执法印记Ms: number;
  上次审判之环Ms: number;
  审判之环进行中: boolean;
  上次终末审判Ms: number;
  已触发月光灌注: boolean;
}

let 瑟兰迪尔运行时已注册 = false;

function 创建瑟兰迪尔上下文(this: void, boss: any, 清理: 机制清理篮子): 瑟兰迪尔运行时上下文 {
  return {
    Boss单位: boss,
    阶段: 1,
    开战时间Ms: getServerTime(),
    清理,
    上次执法印记Ms: 0,
    上次审判之环Ms: 0,
    审判之环进行中: false,
    上次终末审判Ms: 0,
    已触发月光灌注: false,
  };
}

function 清理瑟兰迪尔上下文机制(this: void, context: 瑟兰迪尔运行时上下文): void {
  清理瑟兰迪尔秩序领域(context.Boss单位);
  清理瑟兰迪尔月光灌注();
}

const 瑟兰迪尔上下文工厂 = 创建单位运行时上下文工厂<瑟兰迪尔运行时上下文>({
  名称: "瑟兰迪尔",
  主动技能提示: 瑟兰迪尔单位技能配置.主动技能提示,
  创建上下文: 创建瑟兰迪尔上下文,
  on清理: 清理瑟兰迪尔上下文机制,
});

export function 获取瑟兰迪尔上下文(this: void, boss: any): 瑟兰迪尔运行时上下文 | undefined {
  return 瑟兰迪尔上下文工厂.获取(boss);
}

export function 获取或创建瑟兰迪尔上下文(this: void, boss: any): 瑟兰迪尔运行时上下文 | undefined {
  return 瑟兰迪尔上下文工厂.获取或创建(boss);
}

export function 清理瑟兰迪尔上下文(this: void, boss: any): void {
  瑟兰迪尔上下文工厂.清理上下文(boss);
}

function 单位有效(this: void, unit: any): boolean {
  return unit != null && unit !== 0 && IsUnitType(unit, UNIT_TYPE_DEAD) !== true;
}

function 刷新瑟兰迪尔阶段(this: void, context: 瑟兰迪尔运行时上下文): void {
  const boss = context.Boss单位;
  const maxLife = GetUnitState(boss, UNIT_STATE_MAX_LIFE);
  if (maxLife <= 0) return;
  const ratio = GetUnitState(boss, UNIT_STATE_LIFE) / maxLife;
  if (context.阶段 === 1 && ratio <= 瑟兰迪尔阶段阈值.第二阶段生命比例) {
    context.阶段 = 2;
    播放瑟兰迪尔台词(boss, "转阶段70");
  }
  if (context.阶段 === 2 && ratio <= 瑟兰迪尔阶段阈值.第三阶段生命比例) {
    context.阶段 = 3;
    播放瑟兰迪尔台词(boss, "转阶段40");
  }
}

function 推进瑟兰迪尔运行时(this: void, context: 瑟兰迪尔运行时上下文): void {
  if (!单位有效(context.Boss单位)) {
    清理瑟兰迪尔上下文(context.Boss单位);
    return;
  }
  刷新瑟兰迪尔阶段(context);
  尝试触发瑟兰迪尔执法印记(context);
  刷新瑟兰迪尔秩序领域(context);
  尝试触发瑟兰迪尔月光灌注(context);
  if (context.阶段 >= 2) 尝试触发瑟兰迪尔审判之环(context);
  if (context.阶段 >= 3) 尝试触发瑟兰迪尔终末审判(context);
}

export function 注册瑟兰迪尔运行时(this: void): void {
  if (瑟兰迪尔运行时已注册) return;
  瑟兰迪尔运行时已注册 = true;
  创建周期机制调度器({
    名称: '瑟兰迪尔-运行时推进',
    间隔毫秒: 瑟兰迪尔运行时配置.推进间隔毫秒,
    取上下文列表: 瑟兰迪尔上下文工厂.获取全部,
    执行: 推进瑟兰迪尔运行时,
  });
}
