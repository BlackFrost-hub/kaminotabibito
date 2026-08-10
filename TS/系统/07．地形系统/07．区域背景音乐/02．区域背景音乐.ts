/** @noSelfInFile */

const jass = require("jass.common") as Record<string, any>;
const 统一矩形区域读取 = require("系统.07．地形系统.09．动态矩形区域注册表.04．统一矩形区域读取") as {
  获取矩形区域列表: (this: void, 名称列表: string[]) => any[];
};
import 区域背景音乐配置表 from "./01．区域背景音乐配置表";
import type { 区域背景音乐配置项 } from "./00．区域背景音乐类型";
import {
  挂载区域背景音乐句柄,
  卸载区域背景音乐句柄,
} from "./04．区域背景音乐运行时";

const jglobals = require("jass.globals") as Record<string, any>;
const GetRandomInt = jass.GetRandomInt as (lowBound: number, highBound: number) => number;
const 获取矩形区域列表 = 统一矩形区域读取.获取矩形区域列表;

const 随机环境音乐结果 = new Map<string, string>();

function 读取音频句柄(this: void, 音乐变量名: string | undefined): any {
  if (音乐变量名 == null || 音乐变量名 === "") return null;
  return jglobals[音乐变量名] || null;
}

function 卸载区域音频(this: void, rectHandle: any, soundVarName: string | undefined): boolean {
  const soundHandle = 读取音频句柄(soundVarName);
  if (rectHandle == null || rectHandle === 0 || soundHandle == null || soundHandle === 0) return false;
  return 卸载区域背景音乐句柄(soundHandle, rectHandle);
}

function 挂载区域音频(this: void, rectHandle: any, soundVarName: string | undefined): boolean {
  const soundHandle = 读取音频句柄(soundVarName);
  if (rectHandle == null || rectHandle === 0 || soundHandle == null || soundHandle === 0) return false;
  return 挂载区域背景音乐句柄(true, soundHandle, rectHandle);
}

function 获取环境音乐变量名(this: void, 配置: 区域背景音乐配置项): string | undefined {
  const 随机列表 = 配置.随机环境音乐变量名列表;
  if (随机列表 != null && 随机列表.length > 0) {
    const 组名 = 配置.随机音乐组 || 配置.场景定义;
    const 已记录结果 = 随机环境音乐结果.get(组名);
    if (已记录结果 != null && 已记录结果 !== "") return 已记录结果;

    const 索引 = GetRandomInt(1, 随机列表.length) - 1;
    const 变量名 = 随机列表[索引];
    if (变量名 != null && 变量名 !== "") {
      随机环境音乐结果.set(组名, 变量名);
      return 变量名;
    }
  }
  return 配置.默认环境音乐变量名;
}

export function 初始化区域环境背景音乐(this: void): number {
  let count = 0;
  随机环境音乐结果.clear();
  for (let i = 0; i < 区域背景音乐配置表.length; i++) {
    const 配置 = 区域背景音乐配置表[i];
    const 环境音乐变量名 = 获取环境音乐变量名(配置);
    const 矩形列表 = 获取矩形区域列表(配置.矩形区域名称列表);
    for (let 矩形索引 = 0; 矩形索引 < 矩形列表.length; 矩形索引++) {
      if (挂载区域音频(矩形列表[矩形索引], 环境音乐变量名)) count++;
    }
  }
  return count;
}

function 清空矩形区域背景音乐(this: void, rectHandle: any, 配置: 区域背景音乐配置项): number {
  let count = 0;
  if (卸载区域音频(rectHandle, 配置.默认环境音乐变量名)) count++;
  const 随机列表 = 配置.随机环境音乐变量名列表;
  if (随机列表 != null) {
    for (let i = 0; i < 随机列表.length; i++) {
      if (卸载区域音频(rectHandle, 随机列表[i])) count++;
    }
  }
  if (卸载区域音频(rectHandle, 配置.战斗音乐变量名)) count++;
  if (卸载区域音频(rectHandle, 配置.胜利音乐变量名)) count++;
  return count;
}

export function 清空单个区域背景音乐(this: void, 配置: 区域背景音乐配置项): number {
  let count = 0;
  const 矩形列表 = 获取矩形区域列表(配置.矩形区域名称列表);
  for (let 矩形索引 = 0; 矩形索引 < 矩形列表.length; 矩形索引++) {
    count += 清空矩形区域背景音乐(矩形列表[矩形索引], 配置);
  }
  return count;
}

export function 清空指定场景区域背景音乐(this: void, 场景定义: string): number {
  if (场景定义 == null || 场景定义 === "") return 0;

  let count = 0;
  for (let i = 0; i < 区域背景音乐配置表.length; i++) {
    const 配置 = 区域背景音乐配置表[i];
    if (配置.场景定义 !== 场景定义) continue;
    count += 清空单个区域背景音乐(配置);
  }
  return count;
}

export function 清空全部区域背景音乐(this: void): number {
  let count = 0;
  for (let i = 0; i < 区域背景音乐配置表.length; i++) {
    count += 清空单个区域背景音乐(区域背景音乐配置表[i]);
  }
  return count;
}

export function init区域背景音乐(this: void): void {
  初始化区域环境背景音乐();
}
