/** @noSelfInFile */

const jass = require("jass.common") as any;
const { 创建点特效 } = require("lib.扩展函数.封装函数.01．通用工具.03．特效") as {
  创建点特效: (this: void, 参数: { 模型路径: string; X: number; Y: number; 面向角度?: number; 缩放?: number; 动画速度?: number; 持续秒?: number }) => any;
};
const {
  启用第二章精灵城背景音乐,
  启用第二章精灵城王宫背景音乐,
} = require("系统.07．地形系统.07．区域背景音乐.03．动态区域背景音乐") as {
  启用第二章精灵城背景音乐: (this: void) => boolean;
  启用第二章精灵城王宫背景音乐: (this: void) => boolean;
};
const { debugLogForce } = require("lib.扩展函数.自定义扩展函数.03．调试输出") as {
  debugLogForce: (this: void, module: string, ...args: any[]) => void;
};
const { 创建矩形进入监听 } = require("系统.00．核心系统.01．事件中心.02．区域事件中心") as {
  创建矩形进入监听: (this: void, rect: any, callback: (this: void) => void, filter?: any) => { 取消: (this: void) => void } | null;
};
const { 是玩家英雄组单位 } = require("系统.00．核心系统.00．玩家系统.00．英雄注册联动.00．玩家英雄获取桥接") as {
  是玩家英雄组单位: (this: void, unit: any) => boolean;
};
const { 动态矩形区域配置表, 注册动态矩形区域, 注销动态矩形区域 } = require("系统.07．地形系统.09．动态矩形区域注册表.index") as {
  动态矩形区域配置表: Record<string, { 键: string; 左: number; 右: number; 下: number; 上: number; 说明?: string }>;
  注册动态矩形区域: (this: void, 配置: { 键: string; 左: number; 右: number; 下: number; 上: number; 说明?: string }) => any;
  注销动态矩形区域: (this: void, 键: string) => boolean;
};

import type { 剧情动作处理器 } from "../../00．剧情系统核心工具/00．剧情动作类型";
import {
  读取语义单位引用,
  停止触发单位,
  给玩家组添加多个区域视野,
} from "../../00．剧情系统核心工具/06．剧情通用执行工具";
import { 读取剧情进度 } from "../../00．剧情系统核心工具/01．剧情动作上下文";
export { 阿尔文接引剧情片段 } from "../02．第二章/20．阿尔文引导";

const GetTriggerUnit = jass.GetTriggerUnit as (this: void) => any;

const GetUnitX = jass.GetUnitX as (this: void, whichUnit: any) => number;
const GetUnitY = jass.GetUnitY as (this: void, whichUnit: any) => number;
const 王城门禁矩形键 = "剧情.王城门禁入口";

interface 王城门禁监听状态 {
  取消: (this: void) => void;
  已触发: boolean;
}

let 王城门禁监听: 王城门禁监听状态 | undefined;

function 句柄有效(this: void, handle: any): boolean {
  return handle != null && handle !== 0;
}

function 清理王城门禁矩形监听(this: void): void {
  const 状态 = 王城门禁监听;
  if (状态 == null) return;
  状态.取消();
  注销动态矩形区域(王城门禁矩形键);
  王城门禁监听 = undefined;
}

function 播放王城门禁剧情(this: void, 触发单位: any): void {
  const { 播放主线剧情片段 } = require("系统.11．剧情系统.01．主线任务.02．剧情步骤.02．剧情步骤播放器") as {
    播放主线剧情片段: (this: void, 片段ID: string, 上下文?: any) => boolean;
  };
  const 已播放 = 播放主线剧情片段("elven_city_gate_open", {
    片段ID: "elven_city_gate_open",
    触发配置名: "精灵城门禁矩形入口",
    触发单位,
  });
  if (!已播放) 清理王城门禁矩形监听();
}

function on王城门禁矩形进入(this: void): void {
  const 状态 = 王城门禁监听;
  if (状态 == null || 状态.已触发 || 读取剧情进度() !== 21) return;
  const 触发单位 = GetTriggerUnit();
  if (!句柄有效(触发单位) || !是玩家英雄组单位(触发单位)) return;
  状态.已触发 = true;
  播放王城门禁剧情(触发单位);
}

function 注册王城门禁矩形监听(this: void): void {
  if (读取剧情进度() !== 21 || 王城门禁监听 != null) return;
  const 矩形 = 注册动态矩形区域(动态矩形区域配置表[王城门禁矩形键]);
  if (!句柄有效(矩形)) {
    注销动态矩形区域(王城门禁矩形键);
    return;
  }
  const 监听 = 创建矩形进入监听(矩形, on王城门禁矩形进入, null);
  if (监听 == null) {
    注销动态矩形区域(王城门禁矩形键);
    return;
  }
  王城门禁监听 = {
    取消: 监听.取消,
    已触发: false,
  };
}

export function 执行阿尔文接引(this: void): void {
  停止触发单位();
  const 阿尔文 = 读取语义单位引用("主线NPC.阿尔文");
  if (阿尔文 == null || 阿尔文 === 0) return;
  创建点特效({
    模型路径: "Abilities\\Spells\\Human\\Resurrect\\ResurrectTarget.mdl",
    X: GetUnitX(阿尔文),
    Y: GetUnitY(阿尔文),
    面向角度: 270,
    缩放: 2,
    动画速度: 1,
    持续秒: 1.5,
  });
}

export function 执行启用第二章精灵城背景音乐(this: void): void {
  const 调试模块 = "剧情20-21-BGM";
  debugLogForce(调试模块, "进入 20→21 BGM 动作");
  const 精灵城结果 = 启用第二章精灵城背景音乐();
  debugLogForce(调试模块, "精灵城背景音乐挂载结果", 精灵城结果);
  const 王宫结果 = 启用第二章精灵城王宫背景音乐();
  debugLogForce(调试模块, "王宫背景音乐挂载结果", 王宫结果);
  注册王城门禁矩形监听();
  debugLogForce(调试模块, "王城门禁矩形监听已注册");
}

export function 执行清理王城门禁矩形监听(this: void): void {
  清理王城门禁矩形监听();
}

export function 执行阿尔文对话开启视野(this: void): void {
  给玩家组添加多个区域视野("精灵传送阵");
}

export const 阿尔文引导剧情动作注册表: Record<string, 剧情动作处理器> = {
  "JLC精灵城_阿尔文接引": 执行阿尔文接引,
  "第二章_启用精灵城背景音乐": 执行启用第二章精灵城背景音乐,
  "第二章_阿尔文对话开启视野": 执行阿尔文对话开启视野,
  "第二章_清理王城门禁矩形监听": 执行清理王城门禁矩形监听,
};
