import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import { 读取当前剧情动作上下文 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
import { 读取语义单位引用, 设置触发单位控制状态, 停止触发单位 } from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 树魔首领战斗中对白列表 } from "../02．第二章/26．树魔首领战前";

export { 树魔首领战前剧情片段 } from "../02．第二章/26．树魔首领战前";

const { addDelayedCallback } = require("系统.00．核心系统.05．中心计时器") as {
  addDelayedCallback: (this: void, delayMs: number, callback: (this: void, variable?: any) => void, variable?: any) => number;
};
const { 广播单位提示 } = require("系统.09．表现系统.06．广播提示消息.index") as {
  广播单位提示: (this: void, sourceUnit: any, text: string, duration?: number) => void;
};
const { SUC_IsUnitAlive } = require("lib.扩展函数.Star扩展函数.Star扩展库.08．单位判定与筛选函数") as {
  SUC_IsUnitAlive: (this: void, unit: any) => boolean;
};

interface 树魔首领战斗对白状态 {
  世代: number;
  Boss单位: any;
  玩家单位: any;
  下一句索引: number;
}

let 树魔首领战斗对白世代 = 0;
let 当前树魔首领战斗对白状态: 树魔首领战斗对白状态 | undefined;

function on播放下一句树魔首领战斗对白(this: void, 预期世代?: any): void {
  const 状态 = 当前树魔首领战斗对白状态;
  if (状态 == null || 状态.世代 !== 预期世代) return;
  if (!SUC_IsUnitAlive(状态.Boss单位)) {
    当前树魔首领战斗对白状态 = undefined;
    return;
  }

  const 对白 = 树魔首领战斗中对白列表[状态.下一句索引];
  if (对白 == null) {
    当前树魔首领战斗对白状态 = undefined;
    return;
  }

  const 来源单位 = 对白.说话者 === "树魔首领" ? 状态.Boss单位 : 状态.玩家单位;
  if (来源单位 != null && 来源单位 !== 0) {
    广播单位提示(来源单位, 对白.文本, 对白.持续时间 * 1000);
  }

  状态.下一句索引++;
  if (状态.下一句索引 >= 树魔首领战斗中对白列表.length) {
    当前树魔首领战斗对白状态 = undefined;
    return;
  }
  addDelayedCallback(对白.持续时间 * 1000, on播放下一句树魔首领战斗对白, 状态.世代);
}

export function 执行树魔首领战前(this: void): void {
  停止触发单位();
  设置触发单位控制状态(true, false);
}

export function 启动树魔首领战斗对白(this: void): void {
  const Boss单位 = 读取语义单位引用("Boss.树魔首领");
  if (!SUC_IsUnitAlive(Boss单位)) return;

  树魔首领战斗对白世代++;
  当前树魔首领战斗对白状态 = {
    世代: 树魔首领战斗对白世代,
    Boss单位,
    玩家单位: 读取当前剧情动作上下文().触发单位,
    下一句索引: 0,
  };
  addDelayedCallback(3400, on播放下一句树魔首领战斗对白, 树魔首领战斗对白世代);
}

export const 树魔首领战前剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_树魔首领战前": 执行树魔首领战前,
  "JLC精灵城_启动树魔首领战斗对白": 启动树魔首领战斗对白,
};
