/** @noSelfInFile */

import { 祖地双灵卫副本配置 } from "./01．祖地双灵卫副本配置";
import { 祖地双灵卫副本状态 } from "./02．祖地双灵卫副本状态";

const jass = require("jass.common") as any;

const { 创建并冻结剧情Boss预置, 剧情Boss预置暂停来源 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.03．剧情Boss预置桥接") as {
  创建并冻结剧情Boss预置: (this: void, params: any) => any;
  剧情Boss预置暂停来源: string;
};
const { 启动剧情Boss战 } = require("系统.11．剧情系统.01．主线任务.00．剧情系统核心工具.11．剧情Boss战启动桥接") as {
  启动剧情Boss战: (this: void, bossUnit: any, params?: any) => boolean;
};
const { register祖地双灵卫战斗结束Listener } = require("系统.03．技能系统.05．单位技能.03．Boss技能.02．挑战与隐藏Boss.06．祖地双灵卫.13．战斗结束事件") as {
  register祖地双灵卫战斗结束Listener: (this: void, listener: (this: void, red: any, azure: any) => void) => void;
};
const { registerEnterRegionTrigger } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  registerEnterRegionTrigger: (this: void, trigger: any, region: any, filter?: any) => (this: void) => void;
};
const { safeTriggerAddAction, safeDestroyTrigger } = require("系统.00．核心系统.07．联机安全工具") as {
  safeTriggerAddAction: (this: void, trigger: any, callback: (this: void) => void) => { readonly id: number } | null;
  safeDestroyTrigger: (this: void, trigger: any) => void;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, durationMs?: number) => void;
};
const { 创建点特效, 创建单位脚下点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, params: any) => any;
  创建单位脚下点特效: (this: void, unit: any, params: any) => any;
};
const { addDelayedCallback, addPeriodicCallback, removePeriodicCallback, getServerTime } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void) => void) => number;
  addPeriodicCallback: (this: void, intervalMs: number, callback: (this: void) => void) => number;
  removePeriodicCallback: (this: void, callbackId: number) => void;
  getServerTime: (this: void) => number;
};

const CreateRegion = jass.CreateRegion as (this: void) => any;
const CreateTrigger = jass.CreateTrigger as (this: void) => any;
const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;
const Rect = jass.Rect as (this: void, minX: number, minY: number, maxX: number, maxY: number) => any;
const RegionAddRect = jass.RegionAddRect as (this: void, region: any, rect: any) => void;
const RemoveRect = jass.RemoveRect as (this: void, rect: any) => void;
const RemoveRegion = jass.RemoveRegion as (this: void, region: any) => void;

const Boss预警刷新毫秒 = 100;
let Boss场景模块已初始化 = false;
let Boss入口触发器: any = null;
let Boss预警周期ID = 0;
let Boss预警结束毫秒 = 0;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 读取Boss单位(this: void, index: number): any {
  return 祖地双灵卫副本状态.Boss单位列表[index];
}

function onBoss预警Tick(this: void): void {
  if (Boss预警结束毫秒 <= 0 || getServerTime() >= Boss预警结束毫秒) {
    if (Boss预警周期ID !== 0) removePeriodicCallback(Boss预警周期ID);
    Boss预警周期ID = 0;
    Boss预警结束毫秒 = 0;
    return;
  }
  const cfg = 祖地双灵卫副本配置.Boss预警点;
  创建点特效({
    模型路径: cfg.特效,
    X: cfg.X,
    Y: cfg.Y,
    缩放: cfg.缩放,
    持续秒: 0.45,
  });
}

function 创建双灵卫预置(this: void): boolean {
  祖地双灵卫副本状态.Boss单位列表 = [];
  for (let i = 0; i < 祖地双灵卫副本配置.Boss列表.length; i++) {
    const cfg = 祖地双灵卫副本配置.Boss列表[i];
    const boss = 创建并冻结剧情Boss预置({
      Boss键: cfg.Boss键,
      Boss名: cfg.Boss名,
      允许单位类型: [cfg.单位ID],
      X: cfg.X,
      Y: cfg.Y,
      朝向: cfg.朝向,
      预创建后暂停: true,
      预创建后无敌: true,
    });
    if (!句柄有效(boss)) return false;
    祖地双灵卫副本状态.Boss单位列表.push(boss);
    创建单位脚下点特效(boss, {
      模型路径: 祖地双灵卫副本配置.Boss脚下特效.路径,
      缩放: 祖地双灵卫副本配置.Boss脚下特效.缩放,
      持续秒: 3.2,
    });
  }
  return 祖地双灵卫副本状态.Boss单位列表.length === 祖地双灵卫副本配置.Boss列表.length;
}

function 启动祖地双灵卫Boss战(this: void): void {
  if (祖地双灵卫副本状态.Boss战已启动) return;
  const red = 读取Boss单位(0);
  const azure = 读取Boss单位(1);
  if (!句柄有效(red) || !句柄有效(azure)) return;
  const triggerHero = 祖地双灵卫副本状态.Boss场景触发英雄;
  const redStarted = 启动剧情Boss战(red, { 触发单位: triggerHero, 暂停来源: 剧情Boss预置暂停来源 });
  const azureStarted = 启动剧情Boss战(azure, { 触发单位: triggerHero, 暂停来源: 剧情Boss预置暂停来源 });
  祖地双灵卫副本状态.Boss战已启动 = redStarted && azureStarted;
}

function 播放Boss开战最后一段(this: void): void {
  const red = 读取Boss单位(0);
  if (句柄有效(red)) 广播单位提示(red, "刀剑之后，再谈你们有没有资格知道。", 3600);
  addDelayedCallback(5000, 启动祖地双灵卫Boss战);
}

function 播放Boss开战第三段(this: void): void {
  const hero = 祖地双灵卫副本状态.Boss场景触发英雄;
  if (句柄有效(hero)) 广播单位提示(hero, "我们不是来夺取祖地。先停手，告诉我这里发生了什么。", 4600);
  addDelayedCallback(6000, 播放Boss开战最后一段);
}

function 播放Boss开战第二段(this: void): void {
  const azure = 读取Boss单位(1);
  if (句柄有效(azure)) 广播单位提示(azure, "来者身上没有旧印。按祖地之律，止步于此。", 4200);
  addDelayedCallback(5600, 播放Boss开战第三段);
}

function 完成Boss预警并创建(this: void): void {
  if (Boss预警周期ID !== 0) {
    removePeriodicCallback(Boss预警周期ID);
    Boss预警周期ID = 0;
  }
  Boss预警结束毫秒 = 0;
  if (!创建双灵卫预置()) {
    祖地双灵卫副本状态.Boss场景已触发 = false;
    return;
  }
  const red = 读取Boss单位(0);
  if (句柄有效(red)) 广播单位提示(red, "长老把祖地的门交给外人，连最后的誓约也要一并抛下吗？", 4800);
  addDelayedCallback(6200, 播放Boss开战第二段);
}

function 开始Boss预警(this: void): void {
  Boss预警结束毫秒 = getServerTime() + 祖地双灵卫副本配置.Boss前导毫秒;
  onBoss预警Tick();
  Boss预警周期ID = addPeriodicCallback(Boss预警刷新毫秒, onBoss预警Tick);
  addDelayedCallback(祖地双灵卫副本配置.Boss前导毫秒, 完成Boss预警并创建);
}

function on进入祖地双灵卫Boss入口(this: void): void {
  if (!祖地双灵卫副本状态.传送点已创建 || 祖地双灵卫副本状态.Boss场景已触发) return;
  const hero = GetTriggerUnit();
  if (!句柄有效(hero) || !是玩家英雄组单位(hero)) return;
  祖地双灵卫副本状态.Boss场景已触发 = true;
  祖地双灵卫副本状态.Boss场景触发英雄 = hero;
  广播单位提示(hero, "怎么什么都没有？这里明明残留着很强的气息。", 4200);
  addDelayedCallback(5600, 开始Boss预警);
}

function 注册Boss入口(this: void): void {
  if (句柄有效(Boss入口触发器)) return;
  const cfg = 祖地双灵卫副本配置.Boss入口;
  const region = CreateRegion();
  const rect = Rect(cfg.X - cfg.半径, cfg.Y - cfg.半径, cfg.X + cfg.半径, cfg.Y + cfg.半径);
  const trigger = CreateTrigger();
  if (!句柄有效(region) || !句柄有效(rect) || !句柄有效(trigger)) {
    if (句柄有效(trigger)) safeDestroyTrigger(trigger);
    if (句柄有效(region)) RemoveRegion(region);
    if (句柄有效(rect)) RemoveRect(rect);
    return;
  }
  RegionAddRect(region, rect);
  RemoveRect(rect);
  if (safeTriggerAddAction(trigger, on进入祖地双灵卫Boss入口) == null) {
    safeDestroyTrigger(trigger);
    RemoveRegion(region);
    return;
  }
  registerEnterRegionTrigger(trigger, region, null);
  Boss入口触发器 = trigger;
}

function on祖地双灵卫战斗结束(this: void, _red: any, _azure: any): void {
  if (祖地双灵卫副本状态.Boss战已完成) return;
  祖地双灵卫副本状态.Boss战已完成 = true;
  if (句柄有效(祖地双灵卫副本状态.埃德里安单位)) {
    广播单位提示(
      祖地双灵卫副本状态.埃德里安单位,
      "祖地深处的躁动停下来了。回来吧，这段延续太久的旧誓该有一个交代了。",
      5600,
    );
  }
}

export function init祖地双灵卫Boss场景(this: void): void {
  if (Boss场景模块已初始化) return;
  Boss场景模块已初始化 = true;
  注册Boss入口();
  register祖地双灵卫战斗结束Listener(on祖地双灵卫战斗结束);
}

