/** @noSelfInFile */

import {
  addPeriodicCallback,
  getServerTime,
  removePeriodicCallback,
} from "../../../../00．核心系统/05．中心计时器";
import {
  Boss战战斗音乐字段,
  Boss战胜利音乐字段,
  Boss战运行Tick毫秒,
  Boss战运行模块名,
} from "./00．常量定义";
import {
  type Boss战运行上下文,
  创建Boss战运行上下文,
  当前是否存在Boss战运行上下文,
  获取全部Boss战运行上下文,
  获取全部矩形当前Boss战上下文,
  清理Boss战运行上下文,
  读取Boss战运行上下文,
  记录Boss战运行上下文,
} from "./01．Boss战运行上下文";
import { 尝试移除过期胜利音频, 结束Boss战区域音频 } from "./02．Boss战区域音频";
import {
  单位是否死亡,
  读取Boss战矩形,
  读取Boss战地点是否动态,
  读取Boss战音频,
  读取Boss战单位布尔,
  执行Boss战转场动画,
  完成Boss战启动,
  完成Boss战转场搬运,
  尝试兜底搜敌并下令,
  当前是否存在待清理BossYD任务,
  获取Boss战胜利提示文本,
  获取Boss战转场后提示文本,
  获取Quest消息完成,
  获取Quest消息秘密,
  处理待清理Boss单位YD数据,
  清理Boss战单位字段,
  清理Boss箭头特效,
  登记Boss死亡延迟清理YD数据,
  纠偏Boss位置,
} from "./04．Boss战运行工具";
import { 纠偏玩家英雄位置到Boss } from "./05．Boss战地形纠偏";
import {
  处理Boss战护卫启动,
  处理Boss战护卫Tick,
  处理Boss战护卫结束,
} from "./06．Boss战护卫";
import {
  启动Boss血条弱点韧性,
  结束Boss血条弱点韧性,
} from "../03．Boss血条弱点韧性/index";
import { 同步全部Boss护卫血条优先级 } from "./09．Boss护卫血条优先级调度";
import { 清理Boss自动技能启动上下文 } from "../01．Boss自动技能注册表";

const { QuestMessageBJ } = require("lib.扩展函数.BJ函数.06．任务消息") as {
  QuestMessageBJ: (this: void, forceHandle: any, messageType: number, message: string) => void;
};
const { GetPlayersAll } = require("lib.扩展函数.BJ函数.07．杂项") as {
  GetPlayersAll: (this: void) => any;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, moduleName: string, ...args: any[]) => void;
};
const jass = require("jass.common") as any;
const jglobals = require("jass.globals") as { udg_Boss?: any; [key: string]: any };
const { stringToFourCCSafe } = require("lib.扩展函数.封装函数.01．通用工具.01．FourCC转换安全版") as {
  stringToFourCCSafe: (this: void, s: string | undefined | null) => number;
};
const { 启动赫萝昼夜被动, 停止赫萝昼夜被动 } = require("../../../05．单位技能/03．Boss技能/03．异界Boss/02．赫萝/index") as {
  启动赫萝昼夜被动: (this: void, unit: any) => void;
  停止赫萝昼夜被动: (this: void, unit: any) => void;
};
const { 瑟兰迪尔单位技能配置 } = require("../../../05．单位技能/03．Boss技能/01．主线Boss/02．瑟兰迪尔/00．配置") as {
  瑟兰迪尔单位技能配置: { 单位ID: string };
};
const {
  获取瑟兰迪尔上下文,
  获取或创建瑟兰迪尔上下文,
  清理瑟兰迪尔上下文,
  播放瑟兰迪尔台词,
} = require("../../../05．单位技能/03．Boss技能/01．主线Boss/02．瑟兰迪尔/03．运行时上下文") as {
  获取瑟兰迪尔上下文: (this: void, boss: any) => any;
  获取或创建瑟兰迪尔上下文: (this: void, boss: any) => any;
  清理瑟兰迪尔上下文: (this: void, boss: any) => void;
  播放瑟兰迪尔台词: (this: void, boss: any, 类型: string, index?: number) => void;
};

const GetUnitTypeId = jass.GetUnitTypeId as (whichUnit: any) => number;
const { 尝试播放Boss死亡音效 } = require("./08．Boss死亡音效") as {
  尝试播放Boss死亡音效: (this: void, bossUnit: any) => void;
};
const { 重建亚伦柯斯安兹封锁墙, 清理亚伦柯斯安兹封锁墙 } = require("系统.07．地形系统.06．可破坏物数据.02．亚伦柯斯与安兹乌尔恭封锁墙") as {
  重建亚伦柯斯安兹封锁墙: (this: void, bossUnit: any) => void;
  清理亚伦柯斯安兹封锁墙: (this: void, bossUnit: any) => void;
};

let Boss战运行周期回调ID = 0;
const 瑟兰迪尔单位类型ID = stringToFourCCSafe(瑟兰迪尔单位技能配置.单位ID);

function 是瑟兰迪尔Boss(this: void, bossUnit: any): boolean {
  return bossUnit != null && bossUnit !== 0 && GetUnitTypeId(bossUnit) === 瑟兰迪尔单位类型ID;
}

function 启动瑟兰迪尔Boss运行时(this: void, bossUnit: any): void {
  if (!是瑟兰迪尔Boss(bossUnit)) return;
  const existed = 获取瑟兰迪尔上下文(bossUnit);
  const context = 获取或创建瑟兰迪尔上下文(bossUnit);
  if (context != null && existed == null) {
    播放瑟兰迪尔台词(bossUnit, "开战");
  }
}

function 停止瑟兰迪尔Boss运行时(this: void, bossUnit: any): void {
  if (!是瑟兰迪尔Boss(bossUnit)) return;
  清理瑟兰迪尔上下文(bossUnit);
}

function 写入当前Boss全局(this: void, bossUnit: any): void {
  if (bossUnit == null || bossUnit === 0) return;
  jglobals.udg_Boss = bossUnit;
}

function 清理当前Boss全局(this: void, bossUnit: any): void {
  if (bossUnit == null || bossUnit === 0) return;
  if (jglobals.udg_Boss === bossUnit) jglobals.udg_Boss = null;
}

export interface 主动结束Boss战选项 {
  跳过死亡音效?: boolean;
  跳过死亡剧情?: boolean;
}

function 结束Boss战运行上下文(this: void, context: Boss战运行上下文, nowMs: number, 选项?: 主动结束Boss战选项): void {
  if (context.是否已结束) return;

  context.是否已结束 = true;
  清理亚伦柯斯安兹封锁墙(context.Boss单位);
  if (选项?.跳过死亡音效 !== true) 尝试播放Boss死亡音效(context.Boss单位);
  结束Boss血条弱点韧性(context);
  处理Boss战护卫结束(context);
  停止赫萝昼夜被动(context.Boss单位);
  停止瑟兰迪尔Boss运行时(context.Boss单位);
  清理Boss自动技能启动上下文(context.Boss单位);
  清理当前Boss全局(context.Boss单位);
  清理Boss战运行上下文(context.Boss单位);
  清理Boss战单位字段(context.Boss单位);
  清理Boss箭头特效(context.Boss单位);
  登记Boss死亡延迟清理YD数据(context, nowMs);
  结束Boss战区域音频(context, nowMs);
  const { 发放异界Boss死亡奖励 } = require("./07．异界Boss死亡奖励") as {
    发放异界Boss死亡奖励: (this: void, bossUnit: any) => boolean;
  };
  发放异界Boss死亡奖励(context.Boss单位);
  const { 尝试播放Boss死亡主线剧情 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.06．Boss死亡剧情索引") as {
    尝试播放Boss死亡主线剧情: (this: void, bossUnit: any) => boolean;
  };
  if (选项?.跳过死亡剧情 !== true) 尝试播放Boss死亡主线剧情(context.Boss单位);

  QuestMessageBJ(GetPlayersAll(), 获取Quest消息完成(), 获取Boss战胜利提示文本());
  debugLogForce(Boss战运行模块名, "Boss战结束", "boss=", context.Boss句柄ID, "generation=", context.运行代次);
}

function 推进Boss战启动状态(this: void, context: Boss战运行上下文, nowMs: number): void {
  const 激活前状态 = context.是否已激活;
  if (context.转场提示时间 > 0 && nowMs >= context.转场提示时间) {
QuestMessageBJ(GetPlayersAll(), 获取Quest消息秘密(), 获取Boss战转场后提示文本());
    context.转场提示时间 = 0;
  }

  if (context.是否已激活) return;
  if (context.等待激活截止时间 > 0 && nowMs < context.等待激活截止时间) return;

  if (context.等待激活截止时间 > 0) {
    完成Boss战转场搬运(context);
    context.等待激活截止时间 = 0;
  }

  完成Boss战启动(context);
  if (!激活前状态 && context.是否已激活) {
    启动Boss血条弱点韧性(context);
    启动赫萝昼夜被动(context.Boss单位);
    启动瑟兰迪尔Boss运行时(context.Boss单位);
    处理Boss战护卫启动(context);
  }
}

export function 主动结束Boss战运行(this: void, bossUnit: any, 选项?: 主动结束Boss战选项): boolean {
  const context = 读取Boss战运行上下文(bossUnit);
  if (context == null || context.是否已结束) return false;
  结束Boss战运行上下文(context, getServerTime(), 选项);
  return true;
}

function 当前是否仍需驱动Boss战运行(this: void): boolean {
  if (当前是否存在Boss战运行上下文()) return true;
  if (当前是否存在待清理BossYD任务()) return true;

  const rectContexts = 获取全部矩形当前Boss战上下文();
  for (let i = 0; i < rectContexts.length; i++) {
    const context = rectContexts[i];
    if (!context.是否已结束) return true;
    if (context.胜利音乐移除时间 > 0) return true;
  }
  return false;
}

function onBoss战运行Tick(this: void): void {
  const nowMs = getServerTime();
  const activeContexts = 获取全部Boss战运行上下文();

  for (let i = 0; i < activeContexts.length; i++) {
    const context = activeContexts[i];
    if (context == null || context.是否已结束) continue;

    推进Boss战启动状态(context, nowMs);
    if (!context.是否已激活) continue;

    if (单位是否死亡(context.Boss单位)) {
      结束Boss战运行上下文(context, nowMs);
      continue;
    }

    纠偏Boss位置(context);
    纠偏玩家英雄位置到Boss(context);
    处理Boss战护卫Tick(context, nowMs);
    尝试兜底搜敌并下令(context, nowMs);
  }

  同步全部Boss护卫血条优先级(activeContexts);

  const rectContexts = 获取全部矩形当前Boss战上下文();
  for (let i = 0; i < rectContexts.length; i++) {
    const context = rectContexts[i];
    if (context != null) {
      尝试移除过期胜利音频(context, nowMs);
    }
  }

  处理待清理Boss单位YD数据(nowMs);
  if (!当前是否仍需驱动Boss战运行()) {
    停止Boss战运行驱动();
  }
}

function 确保Boss战运行驱动(this: void): void {
  if (Boss战运行周期回调ID !== 0) return;
  Boss战运行周期回调ID = addPeriodicCallback(Boss战运行Tick毫秒, onBoss战运行Tick);
}

export function 停止Boss战运行驱动(this: void): void {
  if (Boss战运行周期回调ID === 0) return;
  removePeriodicCallback(Boss战运行周期回调ID);
  Boss战运行周期回调ID = 0;
}

export function 启动Boss战运行(this: void, bossUnit: any): void {
  if (bossUnit == null || bossUnit === 0) return;

  写入当前Boss全局(bossUnit);

  const oldContext = 读取Boss战运行上下文(bossUnit);
  if (oldContext != null && !oldContext.是否已结束) return;

  const rectHandle = 读取Boss战矩形();
  const rectIsDynamic = 读取Boss战地点是否动态();
  const battleSound = 读取Boss战音频(Boss战战斗音乐字段);
  const victorySound = 读取Boss战音频(Boss战胜利音乐字段);
  const context = 创建Boss战运行上下文(bossUnit, rectHandle, battleSound, victorySound, rectIsDynamic);
  if (context == null) return;

  重建亚伦柯斯安兹封锁墙(bossUnit);
  记录Boss战运行上下文(context);
  确保Boss战运行驱动();

  if (读取Boss战单位布尔(bossUnit, "转换场景")) {
    const nowMs = getServerTime();
    context.等待激活截止时间 = nowMs + 2000;
    context.转场提示时间 = nowMs + 3000;
    执行Boss战转场动画();
  } else {
    完成Boss战启动(context);
    if (context.是否已激活) {
      启动Boss血条弱点韧性(context);
      启动瑟兰迪尔Boss运行时(context.Boss单位);
    }
  }

  debugLogForce(Boss战运行模块名, "启动Boss战运行", "boss=", context.Boss句柄ID, "rect=", context.地点句柄ID);
}
